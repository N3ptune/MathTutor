import logging

from fastapi import APIRouter, Depends, HTTPException, Form
from app.auth import require_user
from app.workers.problem_generation_worker import generate_problem_for_section
from app.services.proficiency_service import get_app_user_id


logger = logging.getLogger(__name__)

router = APIRouter(prefix="/problem_generation", tags=["Problem Generation"])

@router.post("/generate/")
async def generate_problem(
    section_id: int = Form(...), course_id: int = Form(...), personal: bool = Form(False),
    user: dict = Depends(require_user),
):
    try:
        if personal:
            app_user_id = await get_app_user_id(user["access_token"], user["id"])
            problem = await generate_problem_for_section(
                course_id, section_id, user["access_token"], source="user", created_by=app_user_id
            )
        else:
            problem = await generate_problem_for_section(course_id, section_id, user["access_token"])
        return {"status": "success", "problem": problem}
    except Exception:
        logger.exception("Problem generation failed")
        raise HTTPException(status_code=500, detail="Problem generation failed")
