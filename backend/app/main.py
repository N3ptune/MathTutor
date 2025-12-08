from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers import evalutations_router

app = FastAPI(title="MathTutor API", version="1.0.0")

# Allow your frontend during development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routes
app.include_router(evalutations_router.router, prefix="/api")

@app.get("/")
def root():
    return {"message": "MathTutor backend running!"}
