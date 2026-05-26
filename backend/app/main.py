from fastapi import FastAPI

from backend.app.routes.history import router as history_router
from backend.app.routes.detect import router as detect_router
from backend.app.routes.home import router as home_router
from backend.app.routes.auth import router as auth_router

from backend.app.database import engine, Base

from backend.app.models.user_model import UserModel
from backend.app.models.transaction import Transaction

Base.metadata.create_all(bind=engine)

app = FastAPI()

app.include_router(history_router)
app.include_router(detect_router)
app.include_router(home_router)
app.include_router(auth_router)