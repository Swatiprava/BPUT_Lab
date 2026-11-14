"""
Experiments router — Get experiments for a subject
"""

from fastapi import APIRouter, HTTPException, Query
from supabase_client import get_supabase_admin

router = APIRouter()


@router.get("/")
async def get_experiments(
    subject_id: str = Query(None, description="Filter by subject ID"),
):
    """Get all experiments, optionally filtered by subject."""
    try:
        admin = get_supabase_admin()
        query = (
            admin.table("experiments")
            .select("*, subjects(code, name, language)")
            .order("experiment_number")
        )

        if subject_id:
            query = query.eq("subject_id", subject_id)

        response = query.execute()
        return {"experiments": response.data}

    except Exception as e:
        raise HTTPException(
            status_code=500, detail=f"Failed to fetch experiments: {str(e)}"
        )


@router.get("/{experiment_id}")
async def get_experiment(experiment_id: str):
    """Get a single experiment with full details."""
    try:
        admin = get_supabase_admin()
        response = (
            admin.table("experiments")
            .select("*, subjects(code, name, language, semester)")
            .eq("id", experiment_id)
            .single()
            .execute()
        )
        return {"experiment": response.data}

    except Exception as e:
        raise HTTPException(status_code=404, detail=f"Experiment not found: {str(e)}")
