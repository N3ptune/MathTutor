from datetime import datetime, timezone
import json
import random

import httpx

from app.config import SUPABASE_URL, GRADING_REASONING_EFFORT
from app.services.ai_service import send_ai_request
from app.services.supabase_service import get_section_name, _user_headers
from app.services.proficiency_service import (
    EXAM_PASS_THRESHOLD,
    EXAM_QUESTION_BANK_SIZE,
    EXAM_QUESTIONS_PER_ATTEMPT,
    mark_exam_passed,
)
from app.workers.evaluation_worker import LATEX_INSTRUCTIONS, UNTRUSTED_NOTICE


async def _get_question_bank(section_id: int, access_token: str) -> list[dict]:
    url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_question?sectionId=eq.{section_id}&select=*"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    return resp.json()


async def _generate_exam_questions(section_id: int, section_name: str, access_token: str, count: int) -> list[dict]:
    prompt = f"""
You are a math professor writing a mastery exam for the section titled "{section_name}".
Write {count} distinct questions that together cover the full breadth of this section's topic,
ranging from foundational to more challenging. Each question should be answerable with a short
written solution.
{LATEX_INSTRUCTIONS}
Return only JSON in this format:
{{
  "questions": ["question 1", "question 2"]
}}
"""
    messages = [{"role": "user", "content": prompt}]
    raw_response = await send_ai_request(messages, effort="low")
    data = json.loads(raw_response)

    url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_question"
    headers = {**_user_headers(access_token), "Content-Type": "application/json", "Prefer": "return=representation"}
    inserted = []
    async with httpx.AsyncClient() as client:
        for question in data["questions"]:
            resp = await client.post(url, headers=headers, json={"sectionId": section_id, "question": question})
            resp.raise_for_status()
            inserted.append(resp.json()[0])

    return inserted


async def start_exam_attempt(user_id: int, section_id: int, access_token: str) -> dict:
    bank = await _get_question_bank(section_id, access_token)
    if len(bank) < EXAM_QUESTIONS_PER_ATTEMPT:
        section_name = await get_section_name(section_id, access_token)
        needed = max(EXAM_QUESTION_BANK_SIZE - len(bank), EXAM_QUESTIONS_PER_ATTEMPT - len(bank))
        bank += await _generate_exam_questions(section_id, section_name, access_token, needed)

    questions = random.sample(bank, min(EXAM_QUESTIONS_PER_ATTEMPT, len(bank)))

    url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_attempt"
    headers = {**_user_headers(access_token), "Content-Type": "application/json", "Prefer": "return=representation"}
    payload = {"userId": user_id, "sectionId": section_id}
    async with httpx.AsyncClient() as client:
        resp = await client.post(url, headers=headers, json=payload)
    resp.raise_for_status()
    attempt = resp.json()[0]

    return {
        "examAttemptId": attempt["examAttemptId"],
        "questions": [{"examQuestionId": q["examQuestionId"], "question": q["question"]} for q in questions],
    }


async def _get_questions_by_ids(question_ids: list[int], access_token: str) -> dict[int, str]:
    ids = ",".join(str(i) for i in question_ids)
    url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_question?examQuestionId=in.({ids})&select=examQuestionId,question"
    async with httpx.AsyncClient() as client:
        resp = await client.get(url, headers=_user_headers(access_token))
    resp.raise_for_status()
    return {row["examQuestionId"]: row["question"] for row in resp.json()}


async def _grade_answer(question: str, answer: str) -> dict:
    prompt = f"""
You are grading one question from a math mastery exam.

Question:
{question}

<student_work>
{answer}
</student_work>

Judge whether the student's final answer and reasoning are correct.
{UNTRUSTED_NOTICE}
Return only JSON in this format:
{{"is_correct": true, "feedback": "one or two sentences"}}
"""
    messages = [{"role": "user", "content": prompt}]
    raw_response = await send_ai_request(messages, effort=GRADING_REASONING_EFFORT)
    return json.loads(raw_response)


async def submit_exam_attempt(user_id: int, exam_attempt_id: int, answers: list[dict], access_token: str) -> dict:
    # answers: [{"examQuestionId": int, "answer": str}]
    question_map = await _get_questions_by_ids([a["examQuestionId"] for a in answers], access_token)

    graded = []
    correct_count = 0
    for answer in answers:
        question_text = question_map.get(answer["examQuestionId"], "")
        result = await _grade_answer(question_text, answer["answer"])
        is_correct = bool(result.get("is_correct"))
        correct_count += int(is_correct)
        graded.append({
            "examAttemptId": exam_attempt_id,
            "userId": user_id,
            "examQuestionId": answer["examQuestionId"],
            "studentAnswer": answer["answer"],
            "isCorrect": is_correct,
            "aiFeedback": result.get("feedback", ""),
        })

    response_url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_response"
    response_headers = {**_user_headers(access_token), "Content-Type": "application/json"}
    async with httpx.AsyncClient() as client:
        for row in graded:
            resp = await client.post(response_url, headers=response_headers, json=row)
            resp.raise_for_status()

    score = correct_count / len(answers) if answers else 0.0
    passed = score >= EXAM_PASS_THRESHOLD

    attempt_url = f"{SUPABASE_URL}/rest/v1/proficiency_exam_attempt?examAttemptId=eq.{exam_attempt_id}&userId=eq.{user_id}"
    attempt_headers = {**_user_headers(access_token), "Content-Type": "application/json", "Prefer": "return=representation"}
    attempt_payload = {
        "score": score,
        "passed": passed,
        "completedAt": datetime.now(timezone.utc).isoformat(),
    }
    async with httpx.AsyncClient() as client:
        resp = await client.patch(attempt_url, headers=attempt_headers, json=attempt_payload)
    resp.raise_for_status()

    updated = resp.json()
    if not updated:
        raise Exception("Exam attempt not found or not owned by this user")

    if passed:
        await mark_exam_passed(user_id, updated[0]["sectionId"], access_token)

    return {
        "passed": passed,
        "score": score,
        "feedback": [
            {"examQuestionId": g["examQuestionId"], "isCorrect": g["isCorrect"], "feedback": g["aiFeedback"]}
            for g in graded
        ],
    }
