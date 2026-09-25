from fastapi import APIRouter, Depends, HTTPException, File, UploadFile, Form
from app.auth import require_ai_quota
from typing import Optional
from pydantic import BaseModel
import json
import logging
from app.workers.evaluation_worker import evaluate_steps
from app.services.document_service import parse_upload, UnsupportedUpload, MAX_UPLOAD_BYTES
from app.services.proficiency_service import record_and_update_proficiency
from app.services.usage_service import metered

logger = logging.getLogger(__name__)

# Guardrails on what a student can send us
MAX_STEPS = 50
MAX_STEP_LENGTH = 2000

router = APIRouter(prefix="/evaluate", tags=["Evaluation"])

class EvaluateResponse(BaseModel):
    feedback: list[str]
    step_correct: list[Optional[bool]] = []
    all_correct: bool = False
    extracted_steps: Optional[list[str]] = None
    # Lets the student report this grade as wrong; None if saving the attempt failed
    attempt_id: Optional[int] = None


def clean_steps(raw: str) -> list[str]:
    """Parses the submitted JSON step list, drops blank steps, and rejects anything malformed."""
    try:
        parsed = json.loads(raw)
    except Exception:
        parsed = []

    if (
        not isinstance(parsed, list)
        or len(parsed) > MAX_STEPS
        or not all(isinstance(s, str) and len(s) <= MAX_STEP_LENGTH for s in parsed)
    ):
        raise HTTPException(status_code=400, detail="Invalid steps")

    return [s.strip() for s in parsed if s.strip()]


# Takes in the evaluation request
# Throws back the parsed and complete feedback
@router.post("/", response_model=EvaluateResponse)
async def evaluate(
    problemId: int = Form(...),
    steps: str = Form(...),
    image: Optional[UploadFile] = File(None),
    user: dict = Depends(require_ai_quota),
):
    try:
        parsed_steps = clean_steps(steps)

        # An empty submission would still spend an AI call and count as a wrong attempt
        if not parsed_steps and image is None:
            raise HTTPException(status_code=400, detail="Enter at least one step or attach a file.")

        image_base64_list = []
        document_text = ""

        if image is not None:
            # Detects PDF vs image from the file contents, extracts PDF text locally,
            # and only falls back to images for pages with no text layer
            upload = parse_upload(await image.read(MAX_UPLOAD_BYTES + 1))
            image_base64_list = upload.images_base64
            document_text = upload.text

        async with metered(user["app_user_id"], "evaluate"):
            result = await evaluate_steps(
                problemId, parsed_steps, image_base64_list, document_text, user["access_token"]
            )

        try:
            result["attempt_id"] = await record_and_update_proficiency(
                user["app_user_id"], problemId, result, parsed_steps, user["access_token"]
            )
        except Exception:
            # Proficiency bookkeeping is best-effort; a student's feedback shouldn't be
            # blocked by it failing.
            logger.exception("Failed to record proficiency for this attempt")

        return result

    except HTTPException:
        raise
    except UnsupportedUpload as e:
        raise HTTPException(status_code=400, detail=str(e))
    except Exception:
        logger.exception("Evaluation failed")
        raise HTTPException(status_code=500, detail="We couldn't grade that right now. Please try again.")
    