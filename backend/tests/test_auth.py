import pytest
from fastapi import HTTPException

from app import auth


def test_rate_limit_blocks_after_limit(monkeypatch):
    monkeypatch.setattr(auth, "_recent_requests", auth.defaultdict(auth.deque))

    for _ in range(auth.RATE_LIMIT_REQUESTS):
        auth._check_rate_limit("user-a")

    with pytest.raises(HTTPException) as exc:
        auth._check_rate_limit("user-a")
    assert exc.value.status_code == 429

    # Other users have their own window
    auth._check_rate_limit("user-b")
