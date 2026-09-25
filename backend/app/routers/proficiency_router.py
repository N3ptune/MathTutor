import logging

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel, Field

from app.auth import require_ai_quota
from app.services.proficiency_service import EXAM_QUESTIONS_PER_ATTEMPT
from app.services.usage_service import metered
from app.workers.proficiency_exam_worker import start_exam_attempt, submit_exam_attempt

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/proficiency", tags=["Proficiency"])


class ExamStartRequest(BaseModel):
    sectionId: int


class ExamAnswer(BaseModel):
    examQuestionId: int
    answer: str = Field(max_length=2000)


class ExamSubmitRequest(BaseModel):
    examAttemptId: int
    # Each answer is its own AI grading call, so cap it at the size of a real exam
    answers: list[ExamAnswer] = Field(max_length=EXAM_QUESTIONS_PER_ATTEMPT)


@router.post("/exam/start")
async def exam_start(body: ExamStartRequest, user: dict = Depends(require_ai_quota)):
    try:
        # Only costs an action when the section's question bank has to be generated
        async with metered(user["app_user_id"], "exam_start"):
            return await start_exam_attempt(user["app_user_id"], body.sectionId, user["access_token"])
    except Exception:
        logger.exception("Failed to start proficiency exam")
        raise HTTPException(status_code=500, detail="Couldn't start the exam right now. Please try again.")


@router.post("/exam/submit")
async def exam_submit(body: ExamSubmitRequest, user: dict = Depends(require_ai_quota)):
    try:
        answers = [a.model_dump() for a in body.answers]
        async with metered(user["app_user_id"], "exam_submit"):
            return await submit_exam_attempt(user["app_user_id"], body.examAttemptId, answers, user["access_token"])
    except Exception:
        logger.exception("Failed to submit proficiency exam")
        raise HTTPException(status_code=500, detail="Couldn't grade the exam right now. Please try again.")
