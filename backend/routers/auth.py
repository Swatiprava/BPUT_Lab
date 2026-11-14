"""
Authentication router — Login via Supabase Auth
"""

from fastapi import APIRouter, HTTPException
from pydantic import BaseModel
from supabase_client import get_supabase_client, get_supabase_admin

router = APIRouter()


class LoginRequest(BaseModel):
    email: str
    password: str


class LoginResponse(BaseModel):
    access_token: str
    user_id: str
    student: dict


@router.post("/login")
async def login(request: LoginRequest):
    """Authenticate a student using Supabase Auth."""
    try:
        # Normalize email/username
        email = request.email.strip()
        if "@" not in email:
            email = f"{email}@bput.ac.in"

        supabase = get_supabase_client()
        auth_response = supabase.auth.sign_in_with_password(
            {"email": email, "password": request.password}
        )

        if not auth_response.user:
            raise HTTPException(status_code=401, detail="Invalid credentials")

        # Fetch student profile
        admin = get_supabase_admin()
        student_response = (
            admin.table("students")
            .select("*")
            .eq("auth_user_id", auth_response.user.id)
            .execute()
        )

        student_data = student_response.data[0] if student_response.data else None

        # Fallback if student profile not yet linked by auth_user_id
        if not student_data:
            username = email.split("@")[0]
            fallback_res = (
                admin.table("students")
                .select("*")
                .eq("username", username)
                .execute()
            )
            if fallback_res.data:
                student_data = fallback_res.data[0]
                # Auto-link auth_user_id
                admin.table("students").update({"auth_user_id": auth_response.user.id}).eq("id", student_data["id"]).execute()

        return {
            "access_token": auth_response.session.access_token,
            "user_id": auth_response.user.id,
            "student": student_data,
        }

    except HTTPException:
        raise
    except Exception as e:
        error_msg = str(e)
        if "Invalid login credentials" in error_msg or "invalid_grant" in error_msg:
            raise HTTPException(status_code=401, detail="Invalid email/username or password")
        raise HTTPException(status_code=500, detail=f"Login failed: {error_msg}")



@router.post("/logout")
async def logout():
    """Logout is handled client-side by clearing the session."""
    return {"message": "Logged out successfully"}


@router.get("/me")
async def get_current_user(authorization: str = ""):
    """Get current user profile from JWT token."""
    if not authorization.startswith("Bearer "):
        raise HTTPException(status_code=401, detail="Missing authorization header")

    token = authorization.replace("Bearer ", "")

    try:
        supabase = get_supabase_client()
        user_response = supabase.auth.get_user(token)

        if not user_response.user:
            raise HTTPException(status_code=401, detail="Invalid token")

        admin = get_supabase_admin()
        student_response = (
            admin.table("students")
            .select("*")
            .eq("auth_user_id", user_response.user.id)
            .single()
            .execute()
        )

        return {"student": student_response.data}

    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=401, detail=f"Authentication failed: {str(e)}")
