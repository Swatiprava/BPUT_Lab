"""
Students router — Get registered students by semester
"""

from fastapi import APIRouter, HTTPException, Query
from supabase_client import get_supabase_admin

router = APIRouter()


@router.get("/")
async def get_students(semester: int = Query(None, description="Filter by semester")):
    """Get all students, optionally filtered by semester."""
    try:
        admin = get_supabase_admin()
        query = admin.table("students").select("id, name, registration_number, semester, username, auth_user_id, created_at").order("registration_number")

        if semester:
            query = query.eq("semester", semester)

        response = query.execute()
        return {"students": response.data}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch students: {str(e)}")

