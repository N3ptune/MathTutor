from sqlalchemy import Column, BigInteger, String
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class User(Base):
    __tablename__ = "user"

    personId = Column(BigInteger, primary_key=True, autoincrement=True)
    email = Column(String, nullable=False)
    firstName = Column(String, nullable=False)
    lastName = Column(String, nullable=False)

    classes = relationship("Class", back_populates="person")
    proficiency = relationship("Proficiency", back_populates="user")
    review_guides = relationship("ReviewGuide", back_populates="user")
    attempts = relationship("UserProblemAttempt", back_populates="user")