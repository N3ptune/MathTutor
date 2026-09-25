import logging

from fastapi import APIRouter, Depends, HTTPException, Form
from app.auth import require_ai_quota
from app.workers.problem_generation_worker import generate_problem_for_section
from app.services.usage_service import metered


logger = logging.getLogger(__name__)

router = APIRouter(prefix="/problem_generation", tags=["Problem Generation"])


@router.post("/generate/")
async def generate_problem(
    section_id: int = Form(...), course_id: int = Form(...), personal: bool = Form(False),
    user: dict = Depends(require_ai_quota),
):
    # Students may only generate their own practice problems. Shared course problems set
    # everyone's proficiency denominator, so they're added by scripts/top_up_course_problems.py.
    if not personal:
        raise HTTPException(status_code=403, detail="Only personal practice problems can be generated.")

    try:
        async with metered(user["app_user_id"], "generate_problem"):
            problem = await generate_problem_for_section(
                course_id, section_id, user["access_token"], source="user", created_by=user["app_user_id"]
            )
        return {"status": "success", "problem": problem}
    except Exception:
        logger.exception("Problem generation failed")
        raise HTTPException(status_code=500, detail="Couldn't generate a problem right now. Please try again.")
