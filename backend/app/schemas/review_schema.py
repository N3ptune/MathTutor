from pydantic import BaseModel

class ReviewBase(BaseModel):
    userId: int
    classId: int
    content: str

class ReviewCreate(ReviewBase):
    pass

class ReviewRead(ReviewBase):
    guideId: int

    class Config:
        orm_mode = True
