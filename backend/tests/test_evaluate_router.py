import json

import pytest
from fastapi.testclient import TestClient

from app.auth import require_user
from app.main import app
from app.routers import evalutations_router


@pytest.fixture
def client(monkeypatch):
    calls = {"evaluate": [], "record": []}

    async def fake_user():
        return {"id": "auth-uid", "access_token": "token"}

    async def fake_evaluate(problem_id, steps, images, document_text, access_token):
        calls["evaluate"].append(steps)
        return {
            "feedback": ["Correct."] * len(steps),
            "step_correct": [True] * len(steps),
            "all_correct": True,
            "proficiency_rating": 90.0,
        }

    async def fake_app_user_id(access_token, auth_uid):
        return 7

    async def fake_record(user_id, problem_id, result, steps, access_token):
        calls["record"].append((user_id, problem_id, steps))

    monkeypatch.setattr(evalutations_router, "evaluate_steps", fake_evaluate)
    monkeypatch.setattr(evalutations_router, "get_app_user_id", fake_app_user_id)
    monkeypatch.setattr(evalutations_router, "record_and_update_proficiency", fake_record)
    app.dependency_overrides[require_user] = fake_user

    yield TestClient(app), calls

    app.dependency_overrides.clear()


def post_steps(test_client, steps):
    return test_client.post("/api/evaluate/", data={"problemId": "1", "steps": json.dumps(steps)})


def test_rejects_blank_steps_without_a_file(client):
    test_client, calls = client

    resp = post_steps(test_client, ["", "   "])

    assert resp.status_code == 400
    assert "at least one step" in resp.json()["detail"]
    assert calls["evaluate"] == []


def test_rejects_malformed_steps(client):
    test_client, calls = client

    resp = test_client.post("/api/evaluate/", data={"problemId": "1", "steps": "not json"})

    assert resp.status_code == 400
    assert calls["evaluate"] == []


def test_rejects_too_many_steps(client):
    test_client, _ = client

    resp = post_steps(test_client, ["x"] * (evalutations_router.MAX_STEPS + 1))

    assert resp.status_code == 400


def test_drops_blank_steps_and_returns_correctness(client):
    test_client, calls = client

    resp = post_steps(test_client, ["x + 1 = 3", "", " x = 2 "])

    assert resp.status_code == 200
    body = resp.json()
    assert body["step_correct"] == [True, True]
    assert body["all_correct"] is True
    assert calls["evaluate"] == [["x + 1 = 3", "x = 2"]]
    assert calls["record"] == [(7, 1, ["x + 1 = 3", "x = 2"])]


def test_feedback_still_returned_when_recording_fails(client, monkeypatch):
    test_client, _ = client

    async def failing_record(*args):
        raise RuntimeError("database down")

    monkeypatch.setattr(evalutations_router, "record_and_update_proficiency", failing_record)

    resp = post_steps(test_client, ["x = 2"])

    assert resp.status_code == 200
    assert resp.json()["feedback"] == ["Correct."]


def test_ai_failure_returns_friendly_error(client, monkeypatch):
    test_client, _ = client

    async def failing_evaluate(*args):
        raise ValueError("model returned invalid JSON")

    monkeypatch.setattr(evalutations_router, "evaluate_steps", failing_evaluate)

    resp = post_steps(test_client, ["x = 2"])

    assert resp.status_code == 500
    assert "try again" in resp.json()["detail"]


def test_requires_sign_in():
    resp = TestClient(app).post("/api/evaluate/", data={"problemId": "1", "steps": "[]"})

    assert resp.status_code == 401
