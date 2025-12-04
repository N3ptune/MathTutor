from sqlalchemy import Column, BigInteger, String, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class Problem(Base):
    __tablename__ = "problem"

    problemId = Column(BigInteger, primary_key=True, autoincrement=True)
    sectionId = Column(BigInteger, ForeignKey("section.sectionId"), nullable=False)
    problem = Column(String, nullable=False)

    section = relationship("Section", back_populates="problems")
    attempts = relationship("UserProblemAttempt", back_populates="problem")