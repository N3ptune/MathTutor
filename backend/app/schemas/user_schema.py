from pydantic import BaseModel

class UserBase(BaseModel):
    email: str
    firstName: str
    lastName: str

class UserCreate(UserBase):
    pass

class UserRead(UserBase):
    personId: int

    class Config:
        orm_mode = True
