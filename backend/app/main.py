from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware
from app.routers.evalutations_router import router as evaluate_router

app = FastAPI(title="MathTutor API", version="1.0.0")

# Allow your frontend during development
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],       # You can restrict later
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Register routes
app.include_router(evaluate_router, prefix="/api")

@app.get("/")
def root():
    return {"message": "MathTutor backend running!"}
