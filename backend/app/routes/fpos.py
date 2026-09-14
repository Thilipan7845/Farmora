from fastapi import APIRouter, Depends, HTTPException
from app.schemas.bulk_lot import BulkLotCreate

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
# ============================================================
# GET MEMBER CROPS
# ============================================================

@router.get("/member-crops")
def get_member_crops(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Find FPO
    fpo_result = (
        supabase
        .table("fpos")
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


    # Get FPO members
    members_result = (
        supabase
        .table("fpo_members")
        .select("farmer_id")
        .eq("fpo_id", fpo_id)
        .execute()
    )

    farmer_ids = [
        member["farmer_id"]
        for member in members_result.data
    ]


    if not farmer_ids:
        return {
            "fpo_id": fpo_id,
            "crops": []
        }


    # Get farmer crops
    crops_result = (
        supabase
        .table("crop_lots")
        .select("*")
        .in_("farmer_id", farmer_ids)
        .execute()
    )


    return {
        "fpo_id": fpo_id,
        "crops": crops_result.data
    }
# ============================================================
# CREATE BULK LOT
# ============================================================

@router.post("/bulk-lots")
def create_bulk_lot(
    bulk_lot: BulkLotCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]


    # Find FPO
    fpo_result = (
        supabase
        .table("fpos")
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


    total_quantity = 0


    # Verify crop lots belong to FPO members
    for crop_lot_id in bulk_lot.crop_lot_ids:

        crop_result = (
            supabase
            .table("crop_lots")
            .select("*")
            .eq("id", crop_lot_id)
            .single()
            .execute()
        )

        if not crop_result.data:
            raise HTTPException(
                status_code=404,
                detail=f"Crop lot {crop_lot_id} not found",
            )

        crop = crop_result.data


        member_check = (
            supabase
            .table("fpo_members")
            .select("*")
            .eq("fpo_id", fpo_id)
            .eq("farmer_id", crop["farmer_id"])
            .execute()
        )


        if not member_check.data:
            raise HTTPException(
                status_code=403,
                detail="Crop lot does not belong to FPO member",
            )


        total_quantity += float(crop["quantity"])


    # Create bulk lot
    bulk_result = (
        supabase
        .table("bulk_lots")
        .insert(
            {
                "fpo_id": fpo_id,
                "crop_name": bulk_lot.crop_name,
                "variety": bulk_lot.variety,
                "quality_grade": bulk_lot.quality_grade,
                "quantity": total_quantity,
            }
        )
        .execute()
    )


    if not bulk_result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create bulk lot",
        )


    bulk_lot_id = bulk_result.data[0]["id"]


    # Create mapping records
    items = []

    for crop_lot_id in bulk_lot.crop_lot_ids:

        items.append(
            {
                "bulk_lot_id": bulk_lot_id,
                "crop_lot_id": crop_lot_id,
                "quantity": (
                    supabase
                    .table("crop_lots")
                    .select("quantity")
                    .eq("id", crop_lot_id)
                    .single()
                    .execute()
                    .data["quantity"]
                )
            }
        )


    item_result = (
        supabase
        .table("bulk_lot_items")
        .insert(items)
        .execute()
    )


    return {
        "message": "Bulk lot created successfully",
        "bulk_lot": bulk_result.data[0],
        "items": item_result.data
    }