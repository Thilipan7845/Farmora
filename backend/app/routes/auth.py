from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase

router = APIRouter()


@router.get("/me")
def get_me(current_user: dict = Depends(get_current_user)):
    user_id = current_user["sub"]

    result = (
        supabase.table("profiles")
        .select("id, full_name, phone, role")
        .eq("id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="User profile not found",
        )

    return {
        "user_id": user_id,
        "full_name": result.data.get("full_name"),
        "phone": result.data.get("phone"),
        "role": result.data.get("role"),
    }