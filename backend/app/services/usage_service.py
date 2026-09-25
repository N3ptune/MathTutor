"""Plans, AI usage metering, and monthly quotas.

Every request that calls OpenAI runs inside `metered(...)`. The AI service reports each
call's token usage here, and when the request finishes one ai_usage row is written with the
summed tokens and dollar cost. Quotas are checked against those rows before any AI call.
"""
import contextvars
import logging
from contextlib import asynccontextmanager
from dataclasses import dataclass
from datetime import datetime, timezone

import httpx
from fastapi import HTTPException

from app.config import SUPABASE_URL
from app.services.supabase_service import _service_headers

logger = logging.getLogger(__name__)


@dataclass(frozen=True)
class Plan:
    name: str
    label: str
    monthly_actions: int
    # Hard ceiling on OpenAI spend per user per month, so a run of huge PDF uploads
    # can't cost more than the plan brings in even while under the action count
    monthly_cost_limit_usd: float


PLANS = {
    "free": Plan("free", "Free", monthly_actions=15, monthly_cost_limit_usd=0.50),
    "pro": Plan("pro", "Pro", monthly_actions=500, monthly_cost_limit_usd=6.00),
}

# Stripe statuses that still get Pro. past_due keeps access while Stripe retries the card.
PRO_STATUSES = {"active", "trialing", "past_due"}

# USD per 1M tokens: (input, cached input, output). Reasoning tokens are billed as output.
# Check these against https://openai.com/api/pricing whenever models or prices change.
MODEL_PRICES = {
    "gpt-5-mini": (0.25, 0.025, 2.00),
    "gpt-5": (1.25, 0.125, 10.00),
}
# Unknown models are priced like the most expensive known one, so costs are never undercounted
_FALLBACK_PRICE = max(MODEL_PRICES.values(), key=lambda p: p[2])

_meter: contextvars.ContextVar[list | None] = contextvars.ContextVar("ai_usage_meter", default=None)


def cost_usd(model: str, input_tokens: int, cached_tokens: int, output_tokens: int) -> float:
    input_price, cached_price, output_price = MODEL_PRICES.get(model, _FALLBACK_PRICE)
    uncached = max(input_tokens - cached_tokens, 0)
    return (uncached * input_price + cached_tokens * cached_price + output_tokens * output_price) / 1_000_000


def record_model_usage(model: str, usage) -> None:
    """Called by the AI service after each OpenAI call with the response's `usage` object."""
    meter = _meter.get()
    if meter is None or usage is None:
        return

    input_tokens = getattr(usage, "input_tokens", 0) or 0
    output_tokens = getattr(usage, "output_tokens", 0) or 0
    cached_tokens = getattr(getattr(usage, "input_tokens_details", None), "cached_tokens", 0) or 0
    reasoning_tokens = getattr(getattr(usage, "output_tokens_details", None), "reasoning_tokens", 0) or 0

    meter.append({
        "model": model,
        "inputTokens": input_tokens,
        "cachedTokens": cached_tokens,
        "outputTokens": output_tokens,
        "reasoningTokens": reasoning_tokens,
        "costUsd": cost_usd(model, input_tokens, cached_tokens, output_tokens),
    })


def summarize_calls(user_id: int, action: str, calls: list[dict]) -> dict:
    """One ai_usage row for a whole request, however many OpenAI calls it made."""
    return {
        "userId": user_id,
        "action": action,
        "model": ",".join(sorted({c["model"] for c in calls})),
        "calls": len(calls),
        "inputTokens": sum(c["inputTokens"] for c in calls),
        "cachedTokens": sum(c["cachedTokens"] for c in calls),
        "outputTokens": sum(c["outputTokens"] for c in calls),
        "reasoningTokens": sum(c["reasoningTokens"] for c in calls),
        "costUsd": round(sum(c["costUsd"] for c in calls), 6),
    }


async def _insert_usage(row: dict) -> None:
    headers = {**_service_headers(), "Content-Type": "application/json"}
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.post(f"{SUPABASE_URL}/rest/v1/ai_usage", headers=headers, json=row)
    resp.raise_for_status()


@asynccontextmanager
async def metered(user_id: int, action: str):
    """Collects the token usage of every OpenAI call made inside the block and records it,
    even if the request fails partway (the tokens were still spent)."""
    calls: list[dict] = []
    token = _meter.set(calls)
    try:
        yield calls
    finally:
        _meter.reset(token)
        if calls:
            try:
                await _insert_usage(summarize_calls(user_id, action, calls))
            except Exception:
                # Never fail a student's request over bookkeeping, but make it loud
                logger.exception("Failed to record AI usage for user %s", user_id)


def period_start(now: datetime | None = None) -> datetime:
    """Quotas reset at 00:00 UTC on the 1st of each month."""
    now = now or datetime.now(timezone.utc)
    return now.replace(day=1, hour=0, minute=0, second=0, microsecond=0)


def next_period_start(now: datetime | None = None) -> datetime:
    start = period_start(now)
    return start.replace(year=start.year + 1, month=1) if start.month == 12 else start.replace(month=start.month + 1)


async def get_subscription(user_id: int) -> dict | None:
    url = f"{SUPABASE_URL}/rest/v1/subscription?userId=eq.{user_id}&select=*"
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.get(url, headers=_service_headers())
    resp.raise_for_status()
    rows = resp.json()
    return rows[0] if rows else None


def plan_for(subscription: dict | None) -> Plan:
    if subscription and subscription.get("status") in PRO_STATUSES:
        return PLANS["pro"]
    return PLANS["free"]


async def get_period_usage(user_id: int) -> tuple[int, float]:
    """(AI actions used, dollars spent) so far this month."""
    since = period_start().isoformat().replace("+00:00", "Z")
    url = f"{SUPABASE_URL}/rest/v1/ai_usage?userId=eq.{user_id}&createdAt=gte.{since}&select=costUsd"
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.get(url, headers=_service_headers())
    resp.raise_for_status()
    rows = resp.json()
    return len(rows), sum(float(r["costUsd"] or 0) for r in rows)


def quota_error(plan: Plan, actions_used: int, cost_used: float) -> str | None:
    """The message to show when this user is out of AI actions, or None if they can continue."""
    if actions_used < plan.monthly_actions and cost_used < plan.monthly_cost_limit_usd:
        return None
    reset_day = next_period_start()
    resets = f"{reset_day:%B} {reset_day.day}"
    if plan.name == "free":
        return (
            f"You've used your {plan.monthly_actions} free AI checks for this month. "
            f"Upgrade to Pro to keep going, or wait until they reset on {resets}."
        )
    return f"You've reached this month's Pro usage limit. It resets on {resets}."


async def check_quota(user_id: int) -> Plan:
    """Raises 402 if the user is out of AI actions this month; otherwise returns their plan."""
    plan = plan_for(await get_subscription(user_id))
    actions_used, cost_used = await get_period_usage(user_id)
    message = quota_error(plan, actions_used, cost_used)
    if message:
        raise HTTPException(status_code=402, detail=message)
    return plan
