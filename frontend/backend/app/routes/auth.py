from fastapi import APIRouter, Depends, HTTPException  
from fastapi.security import OAuth2PasswordBearer

from sqlalchemy.orm import Session

from pydantic import BaseModel
from passlib.context import CryptContext
from jose import jwt, JWTError
from datetime import datetime, timedelta

from backend.app.database import SessionLocal
from backend.app.models.user_model import UserModel

router = APIRouter()

pwd_context = CryptContext(
    schemes=["bcrypt"],
    deprecated="auto"
)

SECRET_KEY = "mysecretkey"
ALGORITHM = "HS256"
ACCESS_TOKEN_EXPIRE_MINUTES = 30

oauth2_scheme = OAuth2PasswordBearer(
    tokenUrl="login"
)

# FORMAT DATA USER
class UserRegister(BaseModel):
    username: str
    email: str
    password: str

class UserLogin(BaseModel):
    email: str
    password: str

# DATABASE SESSION
def get_db():

    db = SessionLocal()

    try:
        yield db

    finally:
        db.close()

# FUNCTION BUAT TOKEN
def create_access_token(data: dict):

    to_encode = data.copy()

    expire = datetime.utcnow() + timedelta(
        minutes=ACCESS_TOKEN_EXPIRE_MINUTES
    )

    to_encode.update({
        "exp": expire
    })

    encoded_jwt = jwt.encode(
        to_encode,
        SECRET_KEY,
        algorithm=ALGORITHM
    )

    return encoded_jwt

# VERIFY TOKEN
def verify_token(
    token: str = Depends(oauth2_scheme)
):

    try:

        payload = jwt.decode(
            token,
            SECRET_KEY,
            algorithms=[ALGORITHM]
        )

        username = payload.get("sub")

        if username is None:

            raise HTTPException(
                status_code=401,
                detail="Invalid token"
            )

        return username

    except JWTError:

        raise HTTPException(
            status_code=401,
            detail="Token invalid or expired"
        )

# REGISTER
@router.post("/register")
def register(
    user: UserRegister,
    db: Session = Depends(get_db)
):

    existing_user = db.query(UserModel).filter(
        UserModel.username == user.username
    ).first()

    if existing_user:

        raise HTTPException(
            status_code=400,
            detail="Username already exists"
        )

    existing_email = db.query(UserModel).filter(
        UserModel.email == user.email
    ).first()

    if existing_email:

        raise HTTPException(
            status_code=400,
            detail="Email already exists"
        )

    hashed_password = pwd_context.hash(
        user.password
    )

    new_user = UserModel(
        username=user.username,
        email=user.email,
        password=hashed_password
    )

    db.add(new_user)

    db.commit()

    db.refresh(new_user)

    return {
        "success": True,
        "message": "User registered successfully",
        "data": {
            "username": new_user.username,
            "email": new_user.email
        }
    }

# LOGIN
@router.post("/login")
def login(
    user: UserLogin,
    db: Session = Depends(get_db)
):

    db_user = db.query(UserModel).filter(
        UserModel.email == user.email
    ).first()

    if (
        not db_user
        or
        not pwd_context.verify(
            user.password,
            db_user.password
        )
    ):

        raise HTTPException(
            status_code=401,
            detail="Invalid email or password"
        )

    token = create_access_token({
        "sub": db_user.username
    })

    return {
        "access_token": token,
        "token_type": "bearer"
    }

# AUTH CHECK
@router.get("/auth")
def auth_home():

    return {
        "message": "Auth route working"
    }

# PROFILE
@router.get("/profile")
def profile(
    username: str = Depends(verify_token)
):

    return {
        "success": True,
        "message": "Profile accessed successfully",
        "data": {
            "username": username
        }
    }