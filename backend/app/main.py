import os

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import evalutations_router
from app.routers import problem_generation_router

app = FastAPI(title="MathTutor API", version="1.0.0")

allowed_origins = os.getenv("ALLOWED_ORIGINS", "http://localhost:5173").split(",")

app.add_middleware(
    CORSMiddleware,
    allow_origins=allowed_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

app.include_router(evalutations_router.router, prefix="/api")
app.include_router(problem_generation_router.router, prefix="/api")


@app.get("/")
def root():
    return {"message": "MathTutor backend running!"}


@app.get("/health")
def health():
    return {"status": "ok"}
