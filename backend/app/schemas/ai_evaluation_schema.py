from pydantic import BaseModel

class AiEvalBase(BaseModel):
    attemptId: int
    input: str
    output: str

class AiEvalCreate(AiEvalBase):
    pass

class AiEvalRead(AiEvalBase):
    evalId: int

    class Config:
        orm_mode = True
