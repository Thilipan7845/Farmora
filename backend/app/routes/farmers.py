from fastapi import APIRouter, Depends, HTTPException
from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.farmer import FarmerProfileCreate

router = APIRouter()


@router.post("/profile")
def create_farmer_profile(
    profile: FarmerProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Create the common user profile
    profile_result = (
        supabase.table("profiles")
        .upsert(
            {
                "id": user_id,
                "full_name": current_user.get("user_metadata", {}).get("full_name"),
                "phone": current_user.get("phone"),
                "role": "farmer",
            }
        )
        .execute()
    )

    if not profile_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create user profile",
        )

    # Create the farmer profile
    farmer_result = (
        supabase.table("farmers")
        .upsert(
            {
                "id": user_id,
                **profile.model_dump(),
            }
        )
        .execute()
    )

    if not farmer_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create farmer profile",
        )

    return {
        "message": "Farmer profile created successfully",
        "farmer": farmer_result.data[0],
    }


@router.get("/profile")
def get_farmer_profile(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("farmers")
        .select("*")
        .eq("id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    return result.data


@router.put("/profile")
def update_farmer_profile(
    profile: FarmerProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("farmers")
        .update(profile.model_dump(exclude_unset=True))
        .eq("id", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )

    return {
        "message": "Farmer profile updated successfully",
        "farmer": result.data[0],
    }