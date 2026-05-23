from fastapi import APIRouter
from backend.app.services.home_service import get_home_summary

router = APIRouter()

@router.get("/home")
def home():
    return{
        "success": True,
        "message": "Home data fetched successfully",
        "data": get_home_summary()
    }

