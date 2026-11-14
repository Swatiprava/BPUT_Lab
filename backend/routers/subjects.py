"""
Subjects router — Get lab subjects by semester
"""

from fastapi import APIRouter, HTTPException, Query
from supabase_client import get_supabase_admin

router = APIRouter()


@router.get("/")
async def get_subjects(semester: int = Query(None, description="Filter by semester")):
    """Get all subjects, optionally filtered by semester."""
    try:
        admin = get_supabase_admin()
        query = admin.table("subjects").select("*").order("semester").order("code")

        if semester:
            query = query.eq("semester", semester)

        response = query.execute()
        return {"subjects": response.data}

    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Failed to fetch subjects: {str(e)}")


@router.get("/{subject_id}")
async def get_subject(subject_id: str):
    """Get a single subject by ID."""
    try:
        admin = get_supabase_admin()
        response = (
            admin.table("subjects")
            .select("*")
            .eq("id", subject_id)
            .single()
            .execute()
        )
        return {"subject": response.data}

    except Exception as e:
        raise HTTPException(status_code=404, detail=f"Subject not found: {str(e)}")
