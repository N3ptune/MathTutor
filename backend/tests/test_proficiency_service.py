import asyncio

import pytest

from app.services import proficiency_service as svc


@pytest.fixture
def section(monkeypatch):
    """A fake section whose state each test fills in; captures what gets upserted."""
    state = {"existing": None, "total": 0, "solved": set(), "upserts": []}

    async def get_row(user_id, section_id, token):
        return state["existing"]

    async def count(section_id, token):
        return state["total"]

    async def solved(user_id, section_id, token):
        return state["solved"]

    async def upsert(user_id, section_id, rating, exam_passed, token):
        state["upserts"].append((rating, exam_passed))
        return {"rating": rating, "examPassed": exam_passed}

    monkeypatch.setattr(svc, "_get_proficiency_row", get_row)
    monkeypatch.setattr(svc, "_count_section_course_problems", count)
    monkeypatch.setattr(svc, "_get_correctly_solved_course_problem_ids", solved)
    monkeypatch.setattr(svc, "_upsert_proficiency", upsert)
    return state


def recompute():
    return asyncio.run(svc.recompute_section_proficiency(1, 1, "token"))


def test_no_correct_answers_is_zero(section):
    section["total"] = 7

    assert recompute()["rating"] == 0.0


def test_one_of_seven_correct(section):
    section["total"] = 7
    section["solved"] = {101}

    assert recompute()["rating"] == pytest.approx(95 / 7)


def test_all_correct_caps_below_100(section):
    section["total"] = 4
    section["solved"] = {1, 2, 3, 4}

    assert recompute()["rating"] == svc.PRACTICE_RATING_CAP


def test_empty_section_is_zero(section):
    section["total"] = 0

    assert recompute()["rating"] == 0.0


def test_exam_passed_locks_at_100(section):
    section["existing"] = {"examPassed": True}
    section["total"] = 7

    assert recompute() == {"rating": 100.0, "examPassed": True}


def test_attempt_record_keeps_full_history():
    record = svc.build_attempt_record(
        {"feedback": ["ok", "wrong sign"], "step_correct": [True, False], "all_correct": False,
         "proficiency_rating": 35},
        ["x + 1 = 3", "x = 4"],
    )

    assert record == {
        "isCorrect": False,
        "proficiencyRating": 35.0,
        "aiFeedback": "ok wrong sign",
        "steps": ["x + 1 = 3", "x = 4"],
        "stepFeedback": ["ok", "wrong sign"],
        "stepCorrect": [True, False],
    }


def test_attempt_record_prefers_extracted_steps():
    record = svc.build_attempt_record({"extracted_steps": ["from photo"], "feedback": ["ok"]}, [])

    assert record["steps"] == ["from photo"]


def test_solved_query_only_counts_correct_course_attempts(monkeypatch):
    seen = {}

    def handler(request):
        seen["params"] = dict(request.url.params)
        # Two correct attempts on the same problem count once
        return svc.httpx.Response(200, json=[{"problemId": 5}, {"problemId": 5}, {"problemId": 9}])

    real_client = svc.httpx.AsyncClient
    monkeypatch.setattr(svc.httpx, "AsyncClient", lambda: real_client(transport=svc.httpx.MockTransport(handler)))

    solved = asyncio.run(svc._get_correctly_solved_course_problem_ids(1, 3, "token"))

    assert solved == {5, 9}
    assert seen["params"]["isCorrect"] == "is.true"
    assert seen["params"]["problem.sectionId"] == "eq.3"
    assert seen["params"]["problem.source"] == "eq.course"
