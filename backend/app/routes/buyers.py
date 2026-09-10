from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.buyer import BuyerProfileCreate


router = APIRouter()


@router.post("/profile")
def create_buyer_profile(
    profile: BuyerProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    profile_result = (
        supabase.table("profiles")
        .upsert(
            {
                "id": user_id,
                "full_name": current_user.get("user_metadata", {}).get("full_name"),
                "phone": current_user.get("phone"),
                "role": "buyer",
            }
        )
        .execute()
    )

    if not profile_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create user profile",
        )

    buyer_result = (
        supabase.table("buyers")
        .upsert(
            {
                "id": user_id,
                **profile.model_dump(),
            }
        )
        .execute()
    )

    if not buyer_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create buyer profile",
        )

    return {
        "message": "Buyer profile created successfully",
        "buyer": buyer_result.data[0],
    }


@router.get("/profile")
def get_buyer_profile(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("buyers")
        .select("*")
        .eq("id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Buyer profile not found",
        )

    return result.data


@router.put("/profile")
def update_buyer_profile(
    profile: BuyerProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("buyers")
        .update(profile.model_dump(exclude_unset=True))
        .eq("id", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Buyer profile not found",
        )

    return {
        "message": "Buyer profile updated successfully",
        "buyer": result.data[0],
    }
