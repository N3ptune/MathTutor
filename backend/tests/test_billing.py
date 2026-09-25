import asyncio
from types import SimpleNamespace

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from app.main import app
from app.services import billing_service as billing


class FakeSubscriptions:
    def __init__(self, subscription):
        self.subscription = subscription
        self.cancelled = []

    def retrieve(self, subscription_id):
        return self.subscription

    def cancel(self, subscription_id):
        self.cancelled.append(subscription_id)


@pytest.fixture
def stripe_env(monkeypatch):
    subscription = {
        "id": "sub_123",
        "customer": "cus_123",
        "status": "active",
        "cancel_at_period_end": False,
        "metadata": {"userId": "7"},
        # Newer API versions put the period end on the item
        "items": {"data": [{"current_period_end": 1_800_000_000}]},
    }
    subs = FakeSubscriptions(subscription)
    fake_client = SimpleNamespace(v1=SimpleNamespace(subscriptions=subs))
    upserts = []

    async def fake_upsert(row):
        upserts.append(row)

    monkeypatch.setattr(billing, "_client", lambda: fake_client)
    monkeypatch.setattr(billing, "_upsert_subscription_row", fake_upsert)
    return SimpleNamespace(subscription=subscription, subs=subs, upserts=upserts)


def test_subscription_row_reads_period_end_from_items(stripe_env):
    row = billing.subscription_row(7, stripe_env.subscription)
    assert row["currentPeriodEnd"].startswith("2027-01-15")
    assert row["stripeCustomerId"] == "cus_123"
    assert row["status"] == "active"


def test_checkout_completed_links_subscription_to_user(stripe_env):
    event = {"type": "checkout.session.completed",
             "data": {"object": {"mode": "subscription", "client_reference_id": "7", "subscription": "sub_123"}}}

    asyncio.run(billing.handle_event(event))

    assert stripe_env.upserts[0]["userId"] == 7
    assert stripe_env.upserts[0]["stripeSubscriptionId"] == "sub_123"


def test_subscription_update_uses_latest_stripe_state(stripe_env):
    stripe_env.subscription["status"] = "canceled"
    # The event payload is stale; the handler must re-read the subscription instead
    event = {"type": "customer.subscription.updated", "data": {"object": {"id": "sub_123", "status": "active"}}}

    asyncio.run(billing.handle_event(event))

    assert stripe_env.upserts[0]["status"] == "canceled"


def test_subscription_without_metadata_falls_back_to_customer(stripe_env, monkeypatch):
    stripe_env.subscription["metadata"] = {}

    async def lookup(customer_id):
        assert customer_id == "cus_123"
        return 42

    monkeypatch.setattr(billing, "_user_id_for_customer", lookup)

    asyncio.run(billing.handle_event(
        {"type": "customer.subscription.deleted", "data": {"object": {"id": "sub_123"}}}
    ))

    assert stripe_env.upserts[0]["userId"] == 42


def test_unrelated_events_are_ignored(stripe_env):
    asyncio.run(billing.handle_event({"type": "invoice.paid", "data": {"object": {}}}))
    assert stripe_env.upserts == []


def test_cancel_on_delete_only_touches_live_subscriptions(stripe_env, monkeypatch):
    async def cancelled_sub(user_id):
        return {"stripeSubscriptionId": "sub_old", "status": "canceled"}

    monkeypatch.setattr(billing, "get_subscription", cancelled_sub)
    asyncio.run(billing.cancel_subscription_now(7))
    assert stripe_env.subs.cancelled == []

    async def live_sub(user_id):
        return {"stripeSubscriptionId": "sub_123", "status": "active"}

    monkeypatch.setattr(billing, "get_subscription", live_sub)
    asyncio.run(billing.cancel_subscription_now(7))
    assert stripe_env.subs.cancelled == ["sub_123"]


def test_webhook_rejects_bad_signatures(monkeypatch):
    monkeypatch.setattr(billing, "billing_enabled", lambda: True)
    monkeypatch.setattr(billing, "STRIPE_WEBHOOK_SECRET", "whsec_test")

    resp = TestClient(app).post("/billing/webhook", content=b"{}", headers={"stripe-signature": "t=1,v1=bad"})

    assert resp.status_code == 400


def test_webhook_needs_no_sign_in_but_is_off_until_configured(monkeypatch):
    monkeypatch.setattr(billing, "billing_enabled", lambda: False)

    resp = TestClient(app).post("/billing/webhook", content=b"{}")

    assert resp.status_code == 503


def test_checkout_unavailable_until_configured(monkeypatch):
    monkeypatch.setattr(billing, "billing_enabled", lambda: False)

    with pytest.raises(HTTPException) as exc:
        billing._client()
    assert exc.value.status_code == 503


def test_webhook_with_valid_signature_is_handled(monkeypatch):
    import hashlib
    import hmac
    import json
    import time

    secret = "whsec_test"
    handled = []

    async def fake_handle(event):
        handled.append(event["type"])

    monkeypatch.setattr(billing, "billing_enabled", lambda: True)
    monkeypatch.setattr(billing, "STRIPE_WEBHOOK_SECRET", secret)
    monkeypatch.setattr(billing, "handle_event", fake_handle)

    payload = json.dumps({"id": "evt_1", "object": "event", "type": "customer.subscription.updated",
                          "data": {"object": {"id": "sub_123"}}})
    timestamp = int(time.time())
    signature = hmac.new(secret.encode(), f"{timestamp}.{payload}".encode(), hashlib.sha256).hexdigest()

    resp = TestClient(app).post(
        "/billing/webhook", content=payload, headers={"stripe-signature": f"t={timestamp},v1={signature}"}
    )

    assert resp.status_code == 200
    assert handled == ["customer.subscription.updated"]
