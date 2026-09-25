import time
from collections import defaultdict, deque

import httpx
from fastapi import Depends, Header, HTTPException

from app.config import SUPABASE_URL, SUPABASE_ANON_KEY

# Per-user request limit for the endpoints that spend OpenAI credits.
# In-memory, so it is per App Runner instance.
RATE_LIMIT_REQUESTS = 20
RATE_LIMIT_WINDOW_SECONDS = 60
_recent_requests: dict[str, deque] = defaultdict(deque)


def _check_rate_limit(user_id: str) -> None:
    now = time.monotonic()
    window = _recent_requests[user_id]
    while window and now - window[0] > RATE_LIMIT_WINDOW_SECONDS:
        window.popleft()
    if len(window) >= RATE_LIMIT_REQUESTS:
        raise HTTPException(status_code=429, detail="Too many requests, please slow down")
    window.append(now)


async def require_user(authorization: str | None = Header(default=None)) -> dict:
    """Validates the caller's Supabase access token and returns the auth user."""
    if not authorization or not authorization.lower().startswith("bearer "):
        raise HTTPException(status_code=401, detail="Missing access token")

    token = authorization[7:].strip()

    try:
        async with httpx.AsyncClient(timeout=10) as client:
            resp = await client.get(
                f"{SUPABASE_URL}/auth/v1/user",
                headers={"apikey": SUPABASE_ANON_KEY, "Authorization": f"Bearer {token}"},
            )
    except httpx.HTTPError:
        raise HTTPException(status_code=503, detail="Could not verify credentials")

    if resp.status_code != 200:
        raise HTTPException(status_code=401, detail="Invalid or expired access token")

    user = resp.json()
    _check_rate_limit(user["id"])
    # Kept so Supabase requests can run as this user and be checked by RLS
    user["access_token"] = token
    return user


async def require_ai_quota(user: dict = Depends(require_user)) -> dict:
    """For endpoints that call OpenAI: the signed-in user, plus their app user id and plan.
    Rejects with 402 once they've used this month's AI actions."""
    # Imported here so this module stays importable without the service layer (and its config)
    from app.services.proficiency_service import get_app_user_id
    from app.services.usage_service import check_quota

    app_user_id = await get_app_user_id(user["access_token"], user["id"])
    plan = await check_quota(app_user_id)
    return {**user, "app_user_id": app_user_id, "plan": plan}
