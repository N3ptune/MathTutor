import os

import logging

from fastapi import Depends, FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import evalutations_router
from app.routers import problem_generation_router
from app.routers import proficiency_router
from app.auth import require_user

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

# Everything under /api spends OpenAI credits, so it requires a signed-in user
app.include_router(evalutations_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(problem_generation_router.router, prefix="/api", dependencies=[Depends(require_user)])
app.include_router(proficiency_router.router, prefix="/api", dependencies=[Depends(require_user)])


@app.get("/")
def root():
    return {"message": "MathTutor backend running!"}


@app.get("/health")
def health():
    return {"status": "ok"}
