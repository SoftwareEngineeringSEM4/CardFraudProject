from pydantic import BaseModel

class TransactionResponse(BaseModel):
    id : int
    merchant : str
    amount : int
    status : str
    date: str