from fastapi import APIRouter, HTTPException
from backend.app.services.history_service import( get_history, get_latest_transaction, get_high_risk_transactions,
                                                get_transaction_by_id)
from backend.app.models.transaction_schema import TransactionResponse
from backend.app.utils.response import (success_response, error_response)

router = APIRouter()

@router.get("/history")
def history():
    return success_response(
        "History fetched successfully",
        get_history()
    )

@router.get("/history/latest")
def latest_history():
    return {
        "success": True,
        "message": "Latest transaction fetched successfully",
        "data": get_latest_transaction()
    }

@router.get("/history/high-risk")
def high_risk_history():
    return {
        "success": True,
        "message": "History risk transactions fetched successfully",
        "data": get_high_risk_transactions()
    }

@router.get("/history/{transaction_id}")
def transaction_detail(transaction_id: int):
    transaction = get_transaction_by_id(transaction_id)

    if transaction is None:
        raise HTTPException(
            status_code=404, detail="Transaction not found"
        )
    
    return success_response(
        "Transaction detail fetched successfully",
        transaction
    )