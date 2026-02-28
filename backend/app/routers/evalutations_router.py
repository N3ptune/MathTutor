from fastapi import APIRouter, HTTPException, File, UploadFile, Form
from typing import Optional
from pydantic import BaseModel
from pdf2image import convert_from_bytes
import io
import json
import base64
from app.workers.evaluation_worker import evaluate_steps
import sympy as sp

router = APIRouter(prefix="/evaluate", tags=["Evaluation"])

class EvaluateResponse(BaseModel):
    feedback: list[str]
    extracted_steps: Optional[list[str]] = None

# Takes in the evaluation request
# Throws back the parsed and complete feedback
@router.post("/", response_model=EvaluateResponse)
async def evaluate(problemId: int = Form(...), steps: str = Form(...), image: Optional[UploadFile] = File(None)):
    try:
        try:
            parsed_steps = json.loads(steps)
        except Exception as e:
            parsed_steps = []

        image_base64_list = []

        if image is not None:
            filename = image.filename.lower()
            contents = await image.read()

            if filename.endswith('.pdf'):
                images = convert_from_bytes(contents)
                for img in images:
                    buffered = io.BytesIO()
                    img.save(buffered, format="PNG")
                    img_str = base64.b64encode(buffered.getvalue()).decode("utf-8")
                    image_base64_list.append(img_str)

            else:
                encoded = base64.b64encode(contents).decode("utf-8")
                image_base64_list.append(encoded)


        result = await evaluate_steps(problemId, parsed_steps, image_base64_list)

        return result
    
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    