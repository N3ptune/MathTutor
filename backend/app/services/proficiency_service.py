from app.config import SUPABASE_URL, SUPABASE_ANON_KEY
from app.services.supabase_service import _user_headers
import httpx

# Practice alone can only push proficiency this high; passing the section's exam unlocks 100
PRACTICE_RATING_CAP = 95.0

EXAM_PASS_THRESHOLD = 0.8
EXAM_QUESTION_BANK_SIZE = 8
EXAM_QUESTIONS_PER_ATTEMPT = 5


async def get_app_user_id(access_token: str, auth_uid: str) -> int:
    url = f"{SUPABASE_URL}/rest/v1/users?auth_uid=eq.{auth_uid}&select=userId"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    data = resp.json()
    if not data:
        raise Exception("No app user found for this auth account")
    return data[0]["userId"]


async def get_problem_section_id(problem_id: int, access_token: str) -> int:
    url = f"{SUPABASE_URL}/rest/v1/problem?problemId=eq.{problem_id}&select=sectionId"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    data = resp.json()
    if not data:
        raise Exception("Problem not found")
    return data[0]["sectionId"]


async def record_problem_attempt(
    user_id: int, problem_id: int, is_correct: bool, proficiency_rating: float, ai_feedback: str, access_token: str
) -> None:
    url = f"{SUPABASE_URL}/rest/v1/user_problem_attempt"
    headers = {**_user_headers(access_token), "Content-Type": "application/json"}
    payload = {
        "userId": user_id,
        "problemId": problem_id,
        "isCorrect": is_correct,
        "proficiencyRating": proficiency_rating,
        "aiFeedback": ai_feedback,
    }
    async with httpx.AsyncClient() as client:
        resp = await client.post(url, headers=headers, json=payload)
    resp.raise_for_status()


async def _get_proficiency_row(user_id: int, section_id: int, access_token: str) -> dict | None:
    url = f"{SUPABASE_URL}/rest/v1/proficiency?userId=eq.{user_id}&sectionId=eq.{section_id}&select=*"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    data = resp.json()
    return data[0] if data else None


async def _count_section_course_problems(section_id: int, access_token: str) -> int:
    url = f"{SUPABASE_URL}/rest/v1/problem?sectionId=eq.{section_id}&source=eq.course&select=problemId"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    return len(resp.json())


async def _get_correctly_solved_course_problem_ids(user_id: int, section_id: int, access_token: str) -> set[int]:
    # user_problem_attempt has no sectionId of its own, so filter through the embedded problem
    url = (
        f"{SUPABASE_URL}/rest/v1/user_problem_attempt"
        f"?userId=eq.{user_id}&isCorrect=is.true&select=problemId,problem!inner(sectionId,source)"
        f"&problem.sectionId=eq.{section_id}&problem.source=eq.course"
    )
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    return {row["problemId"] for row in resp.json()}


async def _upsert_proficiency(user_id: int, section_id: int, rating: float, exam_passed: bool, access_token: str) -> dict:
    payload = {"userId": user_id, "sectionId": section_id, "rating": rating, "examPassed": exam_passed}
    headers = {
        **_user_headers(access_token),
        "Content-Type": "application/json",
        "Prefer": "resolution=merge-duplicates,return=representation",
    }
    url = f"{SUPABASE_URL}/rest/v1/proficiency?on_conflict=userId,sectionId"
    async with httpx.AsyncClient() as client:
        resp = await client.post(url, headers=headers, json=payload)
    resp.raise_for_status()
    return resp.json()[0]


async def recompute_section_proficiency(user_id: int, section_id: int, access_token: str) -> dict:
    """Recomputes a user's section proficiency as the share of the section's course problems
    they have answered correctly, scaled so practice alone tops out at PRACTICE_RATING_CAP.
    Once the section's exam has been passed, proficiency stays locked at 100."""
    existing = await _get_proficiency_row(user_id, section_id, access_token)
    exam_passed = bool(existing and existing.get("examPassed"))

    if exam_passed:
        return await _upsert_proficiency(user_id, section_id, 100.0, True, access_token)

    total = await _count_section_course_problems(section_id, access_token)
    solved = await _get_correctly_solved_course_problem_ids(user_id, section_id, access_token)
    rating = (len(solved) / total) * PRACTICE_RATING_CAP if total else 0.0

    return await _upsert_proficiency(user_id, section_id, min(rating, PRACTICE_RATING_CAP), False, access_token)


async def record_and_update_proficiency(user_id: int, problem_id: int, evaluation_result: dict, access_token: str) -> None:
    is_correct = bool(evaluation_result.get("all_correct", False))
    rating = float(evaluation_result.get("proficiency_rating", 0) or 0)
    ai_feedback = " ".join(evaluation_result.get("feedback", []) or [])[:4000]

    await record_problem_attempt(user_id, problem_id, is_correct, rating, ai_feedback, access_token)
    section_id = await get_problem_section_id(problem_id, access_token)
    await recompute_section_proficiency(user_id, section_id, access_token)


async def mark_exam_passed(user_id: int, section_id: int, access_token: str) -> dict:
    return await _upsert_proficiency(user_id, section_id, 100.0, True, access_token)
