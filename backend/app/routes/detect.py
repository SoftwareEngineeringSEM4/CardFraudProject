from fastapi import APIRouter
from backend.app.services.detect_service import detect_latest_transaction
from backend.app.models.detect_schema import DetectResponse

router = APIRouter()

@router.get ("/detect/latest")
def detect ():
    return {
        "success": True,
        "message": "Detection success",
        "data": detect_latest_transaction()
    }
