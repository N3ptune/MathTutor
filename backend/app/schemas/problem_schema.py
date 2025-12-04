from pydantic import BaseModel

class ProblemBase(BaseModel):
    problem: str
    sectionId: int

class ProblemCreate(ProblemBase):
    pass

class ProblemRead(ProblemBase):
    problemId: int

    class Config:
        orm_mode = True