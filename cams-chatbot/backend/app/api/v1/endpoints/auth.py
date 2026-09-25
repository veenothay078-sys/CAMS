from typing import Dict, Any, List
from fastapi import APIRouter, Depends, HTTPException, status
from sqlalchemy.orm import Session
from app.database.session import get_db
from app.models.cams import User
from app.schemas.auth import Token, UserContext, DemoUserTokenRequest
from app.security.auth import get_current_user, create_access_token

router = APIRouter()

@router.get("/me", response_model=UserContext)
def read_current_user(current_user: Dict[str, Any] = Depends(get_current_user)):
    """Returns the authenticated user profile and roles."""
    return UserContext(
        id=current_user.get("id"),
        email=current_user.get("email"),
        full_name=current_user.get("full_name", "CAMS User"),
        role=current_user.get("role", "STUDENT"),
        degree_id=current_user.get("degree_id"),
        is_active=current_user.get("is_active", True)
    )


@router.post("/demo-token", response_model=Token)
def generate_demo_token(request: DemoUserTokenRequest, db: Session = Depends(get_db)):
    """
    Issues JWT token for existing CAMS users to facilitate testing across roles
    (e.g., admin@gmail.com, dinesh@gmail.com, student1@gmail.com).
    """
    user = db.query(User).filter(User.email == request.email, User.is_deleted == False).first()
    if not user:
        raise HTTPException(
            status_code=status.HTTP_404_NOT_FOUND,
            detail=f"User with email '{request.email}' not found in CAMS database"
        )

    token_data = {
        "id": user.id,
        "email": user.email,
        "full_name": user.full_name,
        "role": str(user.role.value if hasattr(user.role, 'value') else user.role),
        "degree_id": user.degree_id,
        "is_active": user.is_active
    }
    jwt_token = create_access_token(token_data)

    return Token(
        access_token=jwt_token,
        token_type="bearer",
        user_id=user.id,
        email=user.email,
        role=token_data["role"],
        full_name=user.full_name
    )


@router.get("/demo-users", response_model=List[UserContext])
def list_demo_users(db: Session = Depends(get_db)):
    """Lists representative CAMS database users for role switching."""
    users = db.query(User).filter(User.is_deleted == False).limit(20).all()
    return [
        UserContext(
            id=u.id,
            email=u.email,
            full_name=u.full_name,
            role=str(u.role.value if hasattr(u.role, 'value') else u.role),
            degree_id=u.degree_id,
            is_active=u.is_active
        )
        for u in users
    ]
