import logging

from fastapi import APIRouter, HTTPException, Form
from app.workers.problem_generation_worker import generate_problem_for_section


logger = logging.getLogger(__name__)

router = APIRouter(prefix="/problem_generation", tags=["Problem Generation"])

@router.post("/generate/")
async def generate_problem(section_id: int = Form(...), course_id: int = Form(...)):
    try:
        problem = await generate_problem_for_section(course_id, section_id)
        return {"status": "success", "problem": problem}
    except Exception:
        logger.exception("Problem generation failed")
        raise HTTPException(status_code=500, detail="Problem generation failed")
