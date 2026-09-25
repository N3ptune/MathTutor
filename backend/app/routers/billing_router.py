import logging

from fastapi import APIRouter, Depends, HTTPException, Request

from app.auth import require_user
from app.services import billing_service
from app.services.proficiency_service import get_app_user_id
from app.services.usage_service import get_period_usage, get_subscription, next_period_start, plan_for

logger = logging.getLogger(__name__)

router = APIRouter(prefix="/billing", tags=["Billing"])
# Stripe calls this directly, so it lives outside /api and its sign-in requirement;
# the request is authenticated by its Stripe signature instead.
webhook_router = APIRouter(tags=["Billing"])


@router.get("/status")
async def billing_status(user: dict = Depends(require_user)):
    app_user_id = await get_app_user_id(user["access_token"], user["id"])
    subscription = await get_subscription(app_user_id)
    plan = plan_for(subscription)
    actions_used, _ = await get_period_usage(app_user_id)

    return {
        "plan": plan.name,
        "planLabel": plan.label,
        "actionsUsed": actions_used,
        "actionsLimit": plan.monthly_actions,
        "resetsAt": next_period_start().isoformat(),
        "subscriptionStatus": subscription.get("status") if subscription else None,
        "currentPeriodEnd": subscription.get("currentPeriodEnd") if subscription else None,
        "cancelAtPeriodEnd": bool(subscription and subscription.get("cancelAtPeriodEnd")),
        "hasBillingAccount": bool(subscription and subscription.get("stripeCustomerId")),
        "billingEnabled": billing_service.billing_enabled(),
    }


@router.post("/checkout")
async def checkout(user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        return {"url": await billing_service.create_checkout_url(app_user_id, user.get("email", ""))}
    except HTTPException:
        raise
    except Exception:
        logger.exception("Failed to start checkout")
        raise HTTPException(status_code=500, detail="Couldn't start checkout. Please try again.")


@router.post("/portal")
async def portal(user: dict = Depends(require_user)):
    try:
        app_user_id = await get_app_user_id(user["access_token"], user["id"])
        return {"url": await billing_service.create_portal_url(app_user_id)}
    except HTTPException:
        raise
    except Exception:
        logger.exception("Failed to open billing portal")
        raise HTTPException(status_code=500, detail="Couldn't open billing. Please try again.")


@webhook_router.post("/billing/webhook")
async def stripe_webhook(request: Request):
    event = billing_service.verify_webhook(await request.body(), request.headers.get("stripe-signature"))
    try:
        await billing_service.handle_event(event)
    except Exception:
        # A non-2xx makes Stripe retry the event later, which is what we want here
        logger.exception("Failed to handle Stripe event %s", event.get("id"))
        raise HTTPException(status_code=500, detail="Webhook handling failed")
    return {"received": True}
