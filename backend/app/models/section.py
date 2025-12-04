from sqlalchemy import Column, BigInteger, String, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class Section(Base):
    __tablename__ = "section"

    sectionId = Column(BigInteger, primary_key=True)
    classId = Column(BigInteger, ForeignKey("class.classId"), nullable=False)
    name = Column(String, nullable=False)

    class_ = relationship("Class", back_populates="sections")
    problems = relationship("Problem", back_populates="section")
    proficiencies = relationship("Proficiency", back_populates="section")
