"""
Submissions router — Student code submissions
"""

from fastapi import APIRouter, HTTPException, Query
from pydantic import BaseModel
from typing import Optional
from datetime import datetime, timezone
from supabase_client import get_supabase_admin

router = APIRouter()


class SubmissionCreate(BaseModel):
    student_id: str
    experiment_id: str
    code: str
    output: Optional[str] = None
    status: str = "submitted"


def _ensure_student(admin, student_id: str) -> str:
    """Ensure a student record exists in the students table for student_id."""
    if not student_id:
        return student_id

    try:
        # 1. Check if student_id matches students.id
        res = admin.table("students").select("id").eq("id", student_id).execute()
        if res.data and len(res.data) > 0:
            return res.data[0]["id"]

        # 2. Check if student_id matches students.auth_user_id
        res_auth = admin.table("students").select("id").eq("auth_user_id", student_id).execute()
        if res_auth.data and len(res_auth.data) > 0:
            return res_auth.data[0]["id"]

        # 3. Create student profile if not found so foreign key succeeds
        clean_id = student_id.replace("-", "")[:8]
        new_student = {
            "id": student_id,
            "name": f"Student {clean_id}",
            "registration_number": f"REG{clean_id}",
            "semester": 5,
            "username": f"user_{clean_id}",
            "auth_user_id": student_id,
        }
        ins_res = admin.table("students").insert(new_student).execute()
        if ins_res.data and len(ins_res.data) > 0:
            return ins_res.data[0]["id"]
    except Exception as e:
        print(f"Warning in _ensure_student for {student_id}: {e}")
        try:
            check = admin.table("students").select("id").eq("id", student_id).execute()
            if check.data and len(check.data) > 0:
                return check.data[0]["id"]
        except Exception:
            pass

    return student_id


@router.get("/")
async def get_submissions(
    student_id: str = Query(None, description="Filter by student ID"),
    experiment_id: str = Query(None, description="Filter by experiment ID"),
):
    """Get submissions, optionally filtered by student and/or experiment."""
    try:
        admin = get_supabase_admin()
        actual_student_id = _ensure_student(admin, student_id) if student_id else None
        print(f"[GET /submissions] student_id={student_id} -> actual_student_id={actual_student_id}, experiment_id={experiment_id}")

        try:
            query = (
                admin.table("submissions")
                .select("*, experiments(title, experiment_number, subjects(code, name))")
                .order("submitted_at", desc=True)
            )
            if actual_student_id:
                query = query.eq("student_id", actual_student_id)
            if experiment_id:
                query = query.eq("experiment_id", experiment_id)
            response = query.execute()
            print(f"[GET /submissions] Returning {len(response.data)} submissions")
            return {"submissions": response.data}
        except Exception as join_err:
            print(f"[GET /submissions] Join query failed: {join_err}, trying fallback")
            # Fallback to direct select without nested join for speed
            query = (
                admin.table("submissions")
                .select("*")
                .order("submitted_at", desc=True)
            )
            if actual_student_id:
                query = query.eq("student_id", actual_student_id)
            if experiment_id:
                query = query.eq("experiment_id", experiment_id)
            response = query.execute()
            print(f"[GET /submissions] Fallback returning {len(response.data)} submissions")
            return {"submissions": response.data}

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch submissions: {str(e)}"
        )


@router.post("/")
async def create_submission(submission: SubmissionCreate):
    """Create or update a submission for an experiment."""
    try:
        admin = get_supabase_admin()
        valid_student_id = _ensure_student(admin, submission.student_id)
        print(f"[POST /submissions] student_id={submission.student_id} -> valid_student_id={valid_student_id}, experiment_id={submission.experiment_id}")

        # Check if a submission already exists for this student + experiment
        existing = (
            admin.table("submissions")
            .select("id")
            .eq("student_id", valid_student_id)
            .eq("experiment_id", submission.experiment_id)
            .execute()
        )
        print(f"[POST /submissions] Existing submissions found: {len(existing.data)}")

        data = {
            "student_id": valid_student_id,
            "experiment_id": submission.experiment_id,
            "code": submission.code,
            "output": submission.output,
            "status": submission.status,
            "submitted_at": datetime.now(timezone.utc).isoformat(),
        }

        if existing.data:
            # Update existing submission
            response = (
                admin.table("submissions")
                .update(data)
                .eq("id", existing.data[0]["id"])
                .execute()
            )
            print(f"[POST /submissions] Updated submission id={existing.data[0]['id']}")
        else:
            # Insert new submission
            response = admin.table("submissions").insert(data).execute()
            print(f"[POST /submissions] Inserted new submission: {response.data}")

        return {"submission": response.data}

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to create submission: {str(e)}"
        )


@router.get("/{submission_id}")
async def get_submission(submission_id: str):
    """Get a single submission by ID."""
    try:
        admin = get_supabase_admin()
        response = (
            admin.table("submissions")
            .select("*, experiments(title, experiment_number, subjects(code, name))")
            .eq("id", submission_id)
            .single()
            .execute()
        )
        return {"submission": response.data}

    except Exception as e:
        raise HTTPException(
            status_code=404, detail=f"Submission not found: {str(e)}"
        )
