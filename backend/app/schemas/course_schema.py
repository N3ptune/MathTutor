from pydantic import BaseModel
from typing import Optional

class CourseBase(BaseModel):
    name: str
    personId: int

class CourseCreate(CourseBase):
    pass

class CourseRead(CourseBase):
    classId: int

    class Config:
        orm_mode = True
