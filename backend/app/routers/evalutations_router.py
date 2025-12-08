from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from app.workers.evaluation_worker import evaluate_steps
import sympy as sp

router = APIRouter(prefix="/evaluate", tags=["Evaluation"])

class EvaluateRequest(BaseModel):
    problemId: int
    steps: list[str]

class EvaluateResponse(BaseModel):
    feedback: list[str]

# Takes in the evaluation request
# Throws back the parsed and complete feedback
@router.post("/", response_model=EvaluateResponse)
async def evaluate(request: EvaluateRequest):
    try:
        feedback = await evaluate_steps(request.problemId, request.steps)
        return {"feedback": feedback}
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    