from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
import sympy as sp

router = APIRouter(tags=["Evaluation"])

class EvaluateRequest(BaseModel):
    problem: str

class EvaluateResponse(BaseModel):
    problem: str
    result: str
    steps: list[str]

@router.post("/evaluate", response_model=EvaluateResponse)
def evaluate_math(req: EvaluateRequest):
    try:
        # Parse the expression safely
        expr = sp.sympify(req.problem)

        # Solve/simplify the expression
        simplified = sp.simplify(expr)

        # Dummy "steps" (you can expand later)
        steps = [
            f"Original: {req.problem}",
            f"Simplified: {simplified}"
        ]

        return EvaluateResponse(
            problem=req.problem,
            result=str(simplified),
            steps=steps
        )

    except Exception as e:
        raise HTTPException(status_code=400, detail=str(e))
