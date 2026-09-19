from fastapi import APIRouter, HTTPException, File, UploadFile, Form
from typing import Optional
from pydantic import BaseModel
import json
from app.workers.evaluation_worker import evaluate_steps
from app.services.document_service import parse_upload, UnsupportedUpload

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
        document_text = ""

        if image is not None:
            # Detects PDF vs image from the file contents, extracts PDF text locally,
            # and only falls back to images for pages with no text layer
            upload = parse_upload(await image.read())
            image_base64_list = upload.images_base64
            document_text = upload.text

        result = await evaluate_steps(problemId, parsed_steps, image_base64_list, document_text)

        return result
    
    except UnsupportedUpload as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
    