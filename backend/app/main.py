import os

import sentry_sdk
from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.config import ENVIRONMENT, SENTRY_DSN, is_configured
from app.routers import account_router
from app.routers import billing_router
from app.routers import evalutations_router
from app.routers import problem_generation_router
from app.routers import proficiency_router
from app.auth import require_user

# Error reporting is on only when a DSN is configured (Terraform seeds it as PLACEHOLDER)
if is_configured(SENTRY_DSN):
    sentry_sdk.init(
        dsn=SENTRY_DSN,
        environment=ENVIRONMENT,
        traces_sample_rate=0.1,
        # Students' math work and emails stay out of error reports
        send_default_pii=False,
    )

app = FastAPI(title="MathTutor API", version="1.0.0")

allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:5173").split(",")
allowed_origins = [o.strip() for o in allowed_origins if o.strip()]

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Everything under /api requires a signed-in user. Routes that spend OpenAI credits
# additionally check the user's monthly quota (see require_ai_quota).
app.include_router(evalutations_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(problem_generation_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(proficiency_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(billing_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(account_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(billing_router.webhook_router)


@app.get("/")
def root():
    return {"message": "MathTutor backend running!"}


@app.get("/health")
def health():
    return {"status": "ok"}
