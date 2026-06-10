from fastapi import APIRouter

from backend.app.models.detect_request import DetectRequest
from backend.app.services.detect_service import detect_transaction

router = APIRouter()

@router.post("/detect")
def detect(data: DetectRequest):

    result = detect_transaction(data)

    return {
        "success": True,
        "message": "Detection success",
        "data": result
    }