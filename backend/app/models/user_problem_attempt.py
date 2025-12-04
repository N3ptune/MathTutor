from sqlalchemy import Column, BigInteger, Boolean, Float, ForeignKey, Text
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class UserProblemAttempt(Base):
    __tablename__ = "userproblemattempt"

    attemptId = Column(BigInteger, primary_key=True)
    userId = Column(BigInteger, ForeignKey("person.personId"), nullable=False)
    problemId = Column(BigInteger, ForeignKey("problem.problemId"), nullable=False)
    aiFeedback = Column(Text)
    isCorrect = Column(Boolean, nullable=False)
    profChange = Column(Float, nullable=False)

    user = relationship("Person", back_populates="attempts")
    problem = relationship("Problem", back_populates="attempts")
    submissions = relationship("UserSubmission", back_populates="attempt")
    ai_evals = relationship("AiEval", back_populates="attempt")
