from sqlalchemy import Column, BigInteger, Text, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class AiEvaluation(Base):
    __tablename__ = "aieval"

    evalId = Column(BigInteger, primary_key=True)
    attemptId = Column(BigInteger, ForeignKey("userproblemattempt.attemptId"), nullable=False)
    input = Column(Text, nullable=False)
    output = Column(Text, nullable=False)

    attempt = relationship("UserProblemAttempt", back_populates="ai_evals")
