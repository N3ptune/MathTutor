"""Stripe subscriptions for the Pro plan.

Stripe is the source of truth. The `subscription` table is a cache of it, written only from
webhooks (with the service-role key), and read to decide each user's plan.
"""
import asyncio
import logging
from datetime import datetime, timezone

import httpx
import stripe
from fastapi import HTTPException

from app.config import (
    FRONTEND_URL,
    STRIPE_PRICE_ID,
    STRIPE_SECRET_KEY,
    STRIPE_WEBHOOK_SECRET,
    SUPABASE_URL,
    is_configured,
)
from app.services.supabase_service import _service_headers
from app.services.usage_service import get_subscription

logger = logging.getLogger(__name__)

SUBSCRIPTION_EVENTS = {
    "customer.subscription.created",
    "customer.subscription.updated",
    "customer.subscription.deleted",
    "customer.subscription.paused",
    "customer.subscription.resumed",
}


def billing_enabled() -> bool:
    return all(is_configured(v) for v in (STRIPE_SECRET_KEY, STRIPE_PRICE_ID, STRIPE_WEBHOOK_SECRET))


def _client() -> stripe.StripeClient:
    if not billing_enabled():
        raise HTTPException(status_code=503, detail="Billing isn't available yet. Please try again later.")
    return stripe.StripeClient(STRIPE_SECRET_KEY)


def _period_end(subscription) -> str | None:
    # Newer Stripe API versions moved current_period_end from the subscription to its items
    end = subscription.get("current_period_end")
    if end is None:
        items = (subscription.get("items") or {}).get("data") or []
        end = items[0].get("current_period_end") if items else None
    return datetime.fromtimestamp(end, tz=timezone.utc).isoformat() if end else None


def subscription_row(user_id: int, subscription) -> dict:
    customer = subscription.get("customer")
    return {
        "userId": user_id,
        "stripeCustomerId": customer if isinstance(customer, str) else customer.get("id"),
        "stripeSubscriptionId": subscription.get("id"),
        "status": subscription.get("status"),
        "currentPeriodEnd": _period_end(subscription),
        "cancelAtPeriodEnd": bool(subscription.get("cancel_at_period_end")),
        "updatedAt": datetime.now(timezone.utc).isoformat(),
    }


async def _upsert_subscription_row(row: dict) -> None:
    headers = {
        **_service_headers(),
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates",
    }
    url = f"{SUPABASE_URL}/rest/v1/subscription?on_conflict=userId"
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.post(url, headers=headers, json=row)
    resp.raise_for_status()


async def _user_id_for_customer(customer_id: str) -> int | None:
    url = f"{SUPABASE_URL}/rest/v1/subscription?stripeCustomerId=eq.{customer_id}&select=userId"
    async with httpx.AsyncClient(timeout=10) as client:
        resp = await client.get(url, headers=_service_headers())
    resp.raise_for_status()
    rows = resp.json()
    return rows[0]["userId"] if rows else None


async def create_checkout_url(user_id: int, email: str) -> str:
    client = _client()
    existing = await get_subscription(user_id)

    params = {
        "mode": "subscription",
        "line_items": [{"price": STRIPE_PRICE_ID, "quantity": 1}],
        "client_reference_id": str(user_id),
        # Lets webhooks map every later subscription event back to this user
        "subscription_data": {"metadata": {"userId": str(user_id)}},
        "success_url": f"{FRONTEND_URL}/account?checkout=success",
        "cancel_url": f"{FRONTEND_URL}/account?checkout=cancelled",
        "allow_promotion_codes": True,
    }
    if existing and existing.get("stripeCustomerId"):
        params["customer"] = existing["stripeCustomerId"]
    else:
        params["customer_email"] = email

    session = await asyncio.to_thread(client.v1.checkout.sessions.create, params)
    return session.url


async def create_portal_url(user_id: int) -> str:
    client = _client()
    existing = await get_subscription(user_id)
    if not existing or not existing.get("stripeCustomerId"):
        raise HTTPException(status_code=400, detail="You don't have a billing account yet.")

    session = await asyncio.to_thread(
        client.v1.billing_portal.sessions.create,
        {"customer": existing["stripeCustomerId"], "return_url": f"{FRONTEND_URL}/account"},
    )
    return session.url


async def sync_subscription(subscription_id: str, user_id: int | None = None) -> None:
    """Re-reads the subscription from Stripe and caches it. Always fetching the latest state
    makes webhook handling safe against retries and out-of-order delivery."""
    subscription = await asyncio.to_thread(_client().v1.subscriptions.retrieve, subscription_id)

    if user_id is None:
        metadata_user = (subscription.get("metadata") or {}).get("userId")
        if metadata_user:
            user_id = int(metadata_user)
        else:
            customer = subscription.get("customer")
            user_id = await _user_id_for_customer(customer if isinstance(customer, str) else customer.get("id"))

    if user_id is None:
        logger.error("Subscription %s has no matching user; ignoring", subscription_id)
        return

    await _upsert_subscription_row(subscription_row(user_id, subscription))


def verify_webhook(payload: bytes, signature: str | None):
    if not billing_enabled():
        raise HTTPException(status_code=503, detail="Billing not configured")
    try:
        return stripe.Webhook.construct_event(payload, signature, STRIPE_WEBHOOK_SECRET)
    except (ValueError, stripe.SignatureVerificationError):
        raise HTTPException(status_code=400, detail="Invalid webhook signature")


async def handle_event(event) -> None:
    obj = event["data"]["object"]

    if event["type"] == "checkout.session.completed" and obj.get("mode") == "subscription":
        user_id = obj.get("client_reference_id")
        await sync_subscription(obj["subscription"], int(user_id) if user_id else None)
    elif event["type"] in SUBSCRIPTION_EVENTS:
        await sync_subscription(obj["id"])


async def cancel_subscription_now(user_id: int) -> None:
    """Used when an account is deleted, so a deleted user is never billed again."""
    existing = await get_subscription(user_id)
    if not existing or not existing.get("stripeSubscriptionId") or existing.get("status") == "canceled":
        return
    await asyncio.to_thread(_client().v1.subscriptions.cancel, existing["stripeSubscriptionId"])
