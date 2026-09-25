import json

import pytest
from fastapi import HTTPException
from fastapi.testclient import TestClient

from types import SimpleNamespace

from app.auth import require_ai_quota, require_user
from app.main import app
from app.routers import evalutations_router
from app.services import usage_service
from app.services.usage_service import PLANS


@pytest.fixture
def client(monkeypatch):
    calls = {"evaluate": [], "record": [], "usage": []}

    async def fake_user():
        return {"id": "auth-uid", "access_token": "token"}

    async def fake_quota():
        return {"id": "auth-uid", "access_token": "token", "app_user_id": 7, "plan": PLANS["free"]}

    async def fake_evaluate(problem_id, steps, images, document_text, access_token):
        calls["evaluate"].append(steps)
        usage_service.record_model_usage("gpt-5-mini", SimpleNamespace(input_tokens=1000, output_tokens=2000))
        return {
            "feedback": ["Correct."] * len(steps),
            "step_correct": [True] * len(steps),
            "all_correct": True,
            "proficiency_rating": 90.0,
        }

    async def fake_record(user_id, problem_id, result, steps, access_token):
        calls["record"].append((user_id, problem_id, steps))
        return 555

    async def fake_insert_usage(row):
        calls["usage"].append(row)

    monkeypatch.setattr(evalutations_router, "evaluate_steps", fake_evaluate)
    monkeypatch.setattr(evalutations_router, "record_and_update_proficiency", fake_record)
    monkeypatch.setattr(usage_service, "_insert_usage", fake_insert_usage)
    app.dependency_overrides[require_user] = fake_user
    app.dependency_overrides[require_ai_quota] = fake_quota

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
    assert body["attempt_id"] == 555


def test_records_ai_usage_for_the_request(client):
    test_client, calls = client

    post_steps(test_client, ["x = 2"])

    assert len(calls["usage"]) == 1
    row = calls["usage"][0]
    assert row["userId"] == 7
    assert row["action"] == "evaluate"
    assert row["inputTokens"] == 1000
    assert row["outputTokens"] == 2000
    # 1000 * $0.25/M + 2000 * $2.00/M
    assert row["costUsd"] == pytest.approx(0.00425)


def test_blank_submission_spends_nothing(client):
    test_client, calls = client

    post_steps(test_client, [""])

    assert calls["usage"] == []


def test_out_of_quota_is_rejected_before_grading(client):
    test_client, calls = client

    async def exhausted():
        raise HTTPException(status_code=402, detail="You've used your 15 free AI checks for this month.")

    app.dependency_overrides[require_ai_quota] = exhausted

    resp = post_steps(test_client, ["x = 2"])

    assert resp.status_code == 402
    assert "free AI checks" in resp.json()["detail"]
    assert calls["evaluate"] == []


def test_feedback_still_returned_when_recording_fails(client, monkeypatch):
    test_client, _ = client

    async def failing_record(*args):
        raise RuntimeError("database down")

    monkeypatch.setattr(evalutations_router, "record_and_update_proficiency", failing_record)

    resp = post_steps(test_client, ["x = 2"])

    assert resp.status_code == 200
    assert resp.json()["feedback"] == ["Correct."]


def test_ai_failure_returns_friendly_error(client, monkeypatch):
    test_client, calls = client

    async def failing_evaluate(*args):
        # Tokens were spent before the failure; they must still be recorded
        usage_service.record_model_usage("gpt-5-mini", SimpleNamespace(input_tokens=10, output_tokens=10))
        raise ValueError("model returned invalid JSON")

    monkeypatch.setattr(evalutations_router, "evaluate_steps", failing_evaluate)

    resp = post_steps(test_client, ["x = 2"])

    assert resp.status_code == 500
    assert "try again" in resp.json()["detail"]
    assert len(calls["usage"]) == 1


def test_requires_sign_in():
    resp = TestClient(app).post("/api/evaluate/", data={"problemId": "1", "steps": "[]"})

    assert resp.status_code == 401


def test_students_cannot_generate_shared_course_problems(client):
    test_client, _ = client

    resp = test_client.post(
        "/api/problem_generation/generate/", data={"section_id": "1", "course_id": "1", "personal": "false"}
    )

    assert resp.status_code == 403
