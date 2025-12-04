from pydantic import BaseModel

class UserSubmissionBase(BaseModel):
    attemptId: int
    userInput: str
    mistakeFlag: bool

class UserSubmissionCreate(UserSubmissionBase):
    pass

class UserSubmissionRead(UserSubmissionBase):
    submissionId: int

    class Config:
        orm_mode = True
