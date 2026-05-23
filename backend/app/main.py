from fastapi import FastAPI
from backend.app.routes.history import router as history_router
from backend.app.routes.detect import router as detect_router
from backend.app.routes.home import router as home_router

app = FastAPI()

app.include_router(history_router)
app.include_router(detect_router)
app.include_router(home_router)