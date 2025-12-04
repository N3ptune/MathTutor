from pydantic import BaseModel

class UserProblemAttemptBase(BaseModel):
    userId: int
    problemId: int
    aiFeedback: str | None = None
    isCorrect: bool
    profChange: float

class UserProblemAttemptCreate(UserProblemAttemptBase):
    pass

class UserProblemAttemptRead(UserProblemAttemptBase):
    attemptId: int

    class Config:
        orm_mode = True
