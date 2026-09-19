from fastapi import APIRouter, HTTPException, File, UploadFile, Form
from typing import Optional
from pydantic import BaseModel
import json
import logging
from app.workers.evaluation_worker import evaluate_steps
from app.services.document_service import parse_upload, UnsupportedUpload, MAX_UPLOAD_BYTES

logger = logging.getLogger(__name__)

# Guardrails on what a student can send us
MAX_STEPS = 50
MAX_STEP_LENGTH = 2000

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
        except Exception:
            parsed_steps = []

        if (
            not isinstance(parsed_steps, list)
            or len(parsed_steps) > MAX_STEPS
            or not all(isinstance(s, str) and len(s) <= MAX_STEP_LENGTH for s in parsed_steps)
        ):
            raise HTTPException(status_code=400, detail="Invalid steps")

        image_base64_list = []
        document_text = ""

        if image is not None:
            # Detects PDF vs image from the file contents, extracts PDF text locally,
            # and only falls back to images for pages with no text layer
            upload = parse_upload(await image.read(MAX_UPLOAD_BYTES + 1))
            image_base64_list = upload.images_base64
            document_text = upload.text

        result = await evaluate_steps(problemId, parsed_steps, image_base64_list, document_text)

        return result
    
    except HTTPException:
        raise
    except UnsupportedUpload as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception:
        logger.exception("Evaluation failed")
        raise HTTPException(status_code=500, detail="Evaluation failed")
    