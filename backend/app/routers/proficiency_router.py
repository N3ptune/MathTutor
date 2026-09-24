import logging

from fastapi import APIRouter, Depends, HTTPException
from pydantic import BaseModel

from app.auth import require_user
from app.services.proficiency_service import get_app_user_id
from app.workers.proficiency_exam_worker import start_exam_attempt, submit_exam_attempt

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/proficiency", tags=["Proficiency"])


class ExamStartRequest(BaseModel):
    sectionId: int


class ExamAnswer(BaseModel):
    examQuestionId: int
    answer: str


class ExamSubmitRequest(BaseModel):
    examAttemptId: int
    answers: list[ExamAnswer]


@router.post("/exam/start")
async def exam_start(body: ExamStartRequest, user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        return await start_exam_attempt(app_user_id, body.sectionId, user["access_token"])
    except Exception:
        logger.exception("Failed to start proficiency exam")
        raise HTTPException(status_code=500, detail="Failed to start proficiency exam")


@router.post("/exam/submit")
async def exam_submit(body: ExamSubmitRequest, user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        answers = [a.model_dump() for a in body.answers]
        return await submit_exam_attempt(app_user_id, body.examAttemptId, answers, user["access_token"])
    except Exception:
        logger.exception("Failed to submit proficiency exam")
        raise HTTPException(status_code=500, detail="Failed to submit proficiency exam")
