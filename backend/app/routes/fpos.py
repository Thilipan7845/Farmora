from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.fpo import FPOProfileCreate
from app.schemas.fpo_member import FPOMemberCreate


router = APIRouter()


# ============================================================
# FPO PROFILE
# ============================================================

@router.post("/profile")
def create_fpo_profile(
    profile: FPOProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Make sure a profile exists for this user
    profile_result = (
        supabase.table("profiles")
        .upsert(
            {
                "id": user_id,
                "full_name": current_user.get("user_metadata", {}).get("full_name"),
                "phone": current_user.get("phone"),
                "role": "fpo",
            }
        )
        .execute()
    )

    if not profile_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create user profile",
        )

    # Create the FPO record
    fpo_result = (
        supabase.table("fpos")
        .insert(
            {
                "user_id": user_id,
                **profile.model_dump(),
            }
        )
        .execute()
    )

    if not fpo_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create FPO profile",
        )

    return {
        "message": "FPO profile created successfully",
        "fpo": fpo_result.data[0],
    }


@router.get("/profile")
def get_fpo_profile(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("fpos")
        .select("*")
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="FPO profile not found",
        )

    return result.data


@router.put("/profile")
def update_fpo_profile(
    profile: FPOProfileCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("fpos")
        .update(profile.model_dump(exclude_unset=True))
        .eq("user_id", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="FPO profile not found",
        )

    return {
        "message": "FPO profile updated successfully",
        "fpo": result.data[0],
    }


# ============================================================
# FPO MEMBERS
# ============================================================

@router.post("/members")
def add_fpo_member(
    member: FPOMemberCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Find the FPO belonging to the logged-in user
    fpo_result = (
        supabase.table("fpos")
        .select("id")
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    if not fpo_result.data:
        raise HTTPException(
            status_code=404,
            detail="FPO profile not found",
        )

    fpo_id = fpo_result.data["id"]

    # Add the farmer to the FPO
    result = (
        supabase.table("fpo_members")
        .insert(
            {
                "fpo_id": fpo_id,
                "farmer_id": member.farmer_id,
                "status": member.status,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to add FPO member",
        )

    return {
        "message": "Farmer added to FPO successfully",
        "member": result.data[0],
    }


@router.get("/members")
def get_fpo_members(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Find the FPO belonging to the logged-in user
    fpo_result = (
        supabase.table("fpos")
        .select("id")
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    if not fpo_result.data:
        raise HTTPException(
            status_code=404,
            detail="FPO profile not found",
        )

    fpo_id = fpo_result.data["id"]

    # Get all members of this FPO
    result = (
        supabase.table("fpo_members")
        .select("*")
        .eq("fpo_id", fpo_id)
        .execute()
    )

    return {
        "fpo_id": fpo_id,
        "members": result.data,
    }