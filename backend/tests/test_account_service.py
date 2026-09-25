import asyncio

import httpx

from app.services import account_service as account


def test_delete_account_cancels_billing_then_removes_everything(monkeypatch):
    order = []

    async def fake_cancel(user_id):
        order.append(("cancel", user_id))

    def handler(request):
        order.append((request.method, request.url.path, dict(request.url.params)))
        return httpx.Response(204)

    real_client = httpx.AsyncClient
    monkeypatch.setattr(account, "cancel_subscription_now", fake_cancel)
    monkeypatch.setattr(account, "_service_headers", lambda: {"apikey": "service"})
    monkeypatch.setattr(
        account.httpx, "AsyncClient", lambda **kw: real_client(transport=httpx.MockTransport(handler))
    )

    asyncio.run(account.delete_account(7, "auth-uid"))

    assert order[0] == ("cancel", 7)
    assert order[1] == ("DELETE", "/rest/v1/problem", {"createdBy": "eq.7"})
    assert order[2] == ("PATCH", "/rest/v1/course", {"personId": "eq.7"})
    assert order[3] == ("DELETE", "/rest/v1/users", {"userId": "eq.7"})
    assert order[4] == ("DELETE", "/auth/v1/admin/users/auth-uid", {})


def test_delete_account_tolerates_missing_auth_user(monkeypatch):
    async def fake_cancel(user_id):
        pass

    def handler(request):
        return httpx.Response(404 if "/auth/" in request.url.path else 204)

    real_client = httpx.AsyncClient
    monkeypatch.setattr(account, "cancel_subscription_now", fake_cancel)
    monkeypatch.setattr(account, "_service_headers", lambda: {"apikey": "service"})
    monkeypatch.setattr(
        account.httpx, "AsyncClient", lambda **kw: real_client(transport=httpx.MockTransport(handler))
    )

    asyncio.run(account.delete_account(7, "auth-uid"))
