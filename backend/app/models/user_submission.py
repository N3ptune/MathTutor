from sqlalchemy import Column, BigInteger, Boolean, Text, ForeignKey
from sqlalchemy.orm import relationship
from app.db.session import Base

class UserSubmission(Base):
    __tablename__ = "usersubmission"

    submissionId = Column(BigInteger, primary_key=True)
    attemptId = Column(BigInteger, ForeignKey("userproblemattempt.attemptId"), nullable=False)
    userInput = Column(Text, nullable=False)
    mistakeFlag = Column(Boolean, nullable=False)

    attempt = relationship("UserProblemAttempt", back_populates="submissions")
