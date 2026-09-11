from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.buyer import BuyerProfileCreate
from app.schemas.buyer_requirement import BuyerRequirementCreate

router = APIRouter()


# ============================================================
# BUYER PROFILE
# ============================================================

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


# ============================================================
# BUYER REQUIREMENTS
# ============================================================

@router.post("/requirements")
def create_buyer_requirement(
    requirement: BuyerRequirementCreate,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    # Make sure the buyer profile exists
    buyer_result = (
        supabase.table("buyers")
        .select("id")
        .eq("id", buyer_id)
        .single()
        .execute()
    )

    if not buyer_result.data:
        raise HTTPException(
            status_code=404,
            detail="Buyer profile not found",
        )

    # Create the buyer requirement
    result = (
        supabase.table("buyer_requirements")
        .insert(
            {
                "buyer_id": buyer_id,
                **requirement.model_dump(),
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create buyer requirement",
        )

    return {
        "message": "Buyer requirement created successfully",
        "requirement": result.data[0],
    }


@router.get("/requirements")
def get_buyer_requirements(
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("buyer_requirements")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "buyer_id": buyer_id,
        "requirements": result.data,
    }