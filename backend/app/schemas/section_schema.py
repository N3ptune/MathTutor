from pydantic import BaseModel

class SectionBase(BaseModel):
    classId: int
    name: str

class SectionCreate(SectionBase):
    pass

class SectionRead(SectionBase):
    sectionId: int

    class Config:
        orm_mode = True
