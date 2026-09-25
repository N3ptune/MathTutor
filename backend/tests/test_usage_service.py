import asyncio
from datetime import datetime, timezone
from types import SimpleNamespace

import pytest
from fastapi import HTTPException

from app.services import usage_service as usage
from app.services.usage_service import PLANS


def test_cost_uses_model_prices():
    # 1M uncached input at $0.25 + 1M output at $2.00
    assert usage.cost_usd("gpt-5-mini", 1_000_000, 0, 1_000_000) == pytest.approx(2.25)


def test_cached_input_is_cheaper():
    full = usage.cost_usd("gpt-5-mini", 1_000_000, 0, 0)
    cached = usage.cost_usd("gpt-5-mini", 1_000_000, 1_000_000, 0)
    assert cached == pytest.approx(full / 10)


def test_unknown_models_are_never_undercounted():
    assert usage.cost_usd("some-new-model", 0, 0, 1_000_000) >= usage.cost_usd("gpt-5", 0, 0, 1_000_000)


def test_usage_outside_a_request_is_ignored():
    usage.record_model_usage("gpt-5-mini", SimpleNamespace(input_tokens=5, output_tokens=5))


def test_metered_sums_every_call_into_one_row(monkeypatch):
    rows = []

    async def fake_insert(row):
        rows.append(row)

    monkeypatch.setattr(usage, "_insert_usage", fake_insert)

    async def run():
        async with usage.metered(3, "exam_submit"):
            for _ in range(5):
                usage.record_model_usage("gpt-5-mini", SimpleNamespace(
                    input_tokens=100,
                    output_tokens=300,
                    input_tokens_details=SimpleNamespace(cached_tokens=40),
                    output_tokens_details=SimpleNamespace(reasoning_tokens=250),
                ))

    asyncio.run(run())

    assert len(rows) == 1
    assert rows[0]["calls"] == 5
    assert rows[0]["inputTokens"] == 500
    assert rows[0]["cachedTokens"] == 200
    assert rows[0]["reasoningTokens"] == 1250
    assert rows[0]["action"] == "exam_submit"


def test_metered_skips_requests_with_no_ai_calls(monkeypatch):
    rows = []

    async def fake_insert(row):
        rows.append(row)

    monkeypatch.setattr(usage, "_insert_usage", fake_insert)

    async def run():
        async with usage.metered(3, "exam_start"):
            pass

    asyncio.run(run())
    assert rows == []


def test_metered_records_even_when_the_request_fails(monkeypatch):
    rows = []

    async def fake_insert(row):
        rows.append(row)

    monkeypatch.setattr(usage, "_insert_usage", fake_insert)

    async def run():
        async with usage.metered(3, "evaluate"):
            usage.record_model_usage("gpt-5-mini", SimpleNamespace(input_tokens=1, output_tokens=1))
            raise RuntimeError("bad JSON")

    with pytest.raises(RuntimeError):
        asyncio.run(run())
    assert len(rows) == 1


@pytest.mark.parametrize("status,plan", [
    ("active", "pro"),
    ("trialing", "pro"),
    ("past_due", "pro"),
    ("canceled", "free"),
    ("unpaid", "free"),
    ("incomplete", "free"),
])
def test_plan_for_subscription_status(status, plan):
    assert usage.plan_for({"status": status}).name == plan


def test_no_subscription_is_free():
    assert usage.plan_for(None).name == "free"


def test_period_boundaries():
    mid_month = datetime(2026, 12, 15, 13, 30, tzinfo=timezone.utc)
    assert usage.period_start(mid_month) == datetime(2026, 12, 1, tzinfo=timezone.utc)
    assert usage.next_period_start(mid_month) == datetime(2027, 1, 1, tzinfo=timezone.utc)


def test_quota_allows_under_limit():
    assert usage.quota_error(PLANS["free"], 14, 0.10) is None


def test_quota_blocks_free_at_action_limit_with_upgrade_prompt():
    message = usage.quota_error(PLANS["free"], 15, 0.10)
    assert "15 free AI checks" in message
    assert "Upgrade" in message


def test_quota_blocks_at_cost_ceiling_even_under_action_limit():
    assert usage.quota_error(PLANS["pro"], 10, 6.00) is not None


def test_check_quota_raises_402(monkeypatch):
    async def no_subscription(user_id):
        return None

    async def used_up(user_id):
        return 15, 0.2

    monkeypatch.setattr(usage, "get_subscription", no_subscription)
    monkeypatch.setattr(usage, "get_period_usage", used_up)

    with pytest.raises(HTTPException) as exc:
        asyncio.run(usage.check_quota(1))
    assert exc.value.status_code == 402


def test_check_quota_returns_plan(monkeypatch):
    async def pro(user_id):
        return {"status": "active"}

    async def light_use(user_id):
        return 40, 0.4

    monkeypatch.setattr(usage, "get_subscription", pro)
    monkeypatch.setattr(usage, "get_period_usage", light_use)

    assert asyncio.run(usage.check_quota(1)).name == "pro"
