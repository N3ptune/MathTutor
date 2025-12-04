from sqlalchemy import Column, BigInteger, String, ForeignKey
from sqlalchemy.orm import relationship
from backend.app.db.session import Base

class Course(Base):
    __tablename__ = "class"

    classId = Column(BigInteger, primary_key=True, autoincrement=True)
    name = Column(String, nullable=False)
    personId = Column(BigInteger, ForeignKey("person.personId"))

    person = relationship("Person", back_populates="classes")
    sections = relationship("Section", back_populates="class_")
    review_guides = relationship("ReviewGuide", back_populates="class_")
