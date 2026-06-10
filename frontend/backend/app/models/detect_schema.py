from pydantic import BaseModel

class DetectResponse(BaseModel):
    merchant: str
    amount: int
    prediction: str
    risk_score: int