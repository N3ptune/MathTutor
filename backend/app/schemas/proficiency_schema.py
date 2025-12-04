from pydantic import BaseModel

class ProficiencyBase(BaseModel):
    userId: int
    sectionId: int
    rating: float

class ProficiencyCreate(ProficiencyBase):
    pass

class ProficiencyRead(ProficiencyBase):
    proficiencyId: int

    class Config:
        orm_mode = True
