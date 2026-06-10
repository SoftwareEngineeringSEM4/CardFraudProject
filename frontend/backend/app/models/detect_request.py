from pydantic import BaseModel

class DetectRequest(BaseModel):
    merchant: str
    amount: float
    age: int
    gender: str