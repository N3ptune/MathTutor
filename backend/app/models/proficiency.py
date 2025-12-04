from sqlalchemy import Column, BigInteger, Float, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class Proficiency(Base):
    __tablename__ = "proficiency"

    proficiencyId = Column(BigInteger, primary_key=True)
    userId = Column(BigInteger, ForeignKey("person.personId"), nullable=False)
    sectionId = Column(BigInteger, ForeignKey("section.sectionId"), nullable=False)
    rating = Column(Float, nullable=False)

    user = relationship("Person", back_populates="proficiencies")
    section = relationship("Section", back_populates="proficiencies")
