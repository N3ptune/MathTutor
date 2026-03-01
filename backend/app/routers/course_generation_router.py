from fastapi import APIRouter
from pydantic import BaseModel
from app.services.supabase_service import push_course_to_supabase
from app.workers.course_generation_worker import generate_course

router = APIRouter(prefix="/course_generation", tags=["Course Generation"])

class CourseGenerationRequest(BaseModel):
    topic: str

@router.post("/")
async def generate_course_endpoint(request: CourseGenerationRequest):
    try:
        course_structure = await generate_course(request.topic)
        await push_course_to_supabase(course_structure)
        return {"message": "Course generated and pushed to Supabase successfully"}
    except Exception as e:
        return {"error": str(e)}
