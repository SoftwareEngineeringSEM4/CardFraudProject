from sqlalchemy import Column, Integer, String
from backend.app.database import Base

class Transaction(Base):

    __tablename__ = "transactions"

    id = Column(Integer, primary_key=True, index=True)
    merchant = Column(String)
    amount = Column(Integer)
    status = Column(String)
    location = Column(String)
    time = Column(String)
    date = Column(String)