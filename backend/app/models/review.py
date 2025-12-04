from sqlalchemy import Column, BigInteger, Text, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class Review(Base):
    __tablename__ = "reviewguide"

    guideId = Column(BigInteger, primary_key=True)
    userId = Column(BigInteger, ForeignKey("person.personId"), nullable=False)
    classId = Column(BigInteger, ForeignKey("class.classId"), nullable=False)
    content = Column(Text, nullable=False)

    user = relationship("Person", back_populates="review_guides")
    class_ = relationship("Class", back_populates="review_guides")
