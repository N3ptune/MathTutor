import logging

from fastapi import APIRouter, Depends, HTTPException

from app.auth import require_user
from app.services.account_service import delete_account, export_user_data
from app.services.proficiency_service import get_app_user_id

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/account", tags=["Account"])


@router.get("/export")
async def export(user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        return await export_user_data(app_user_id, user["access_token"])
    except Exception:
        logger.exception("Failed to export account data")
        raise HTTPException(status_code=500, detail="Couldn't export your data. Please try again.")


@router.delete("")
async def delete(user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        await delete_account(app_user_id, user["id"])
    except HTTPException:
        raise
    except Exception:
        logger.exception("Failed to delete account")
        raise HTTPException(
            status_code=500,
            detail="Couldn't delete your account. Please try again, or contact support.",
        )
    return {"deleted": True}
