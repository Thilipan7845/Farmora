from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.crop_lot import CropLotCreate


router = APIRouter()


# ============================================================
# CREATE CROP LOT (FARMER)
# ============================================================

@router.post("")
def create_crop_lot(
    lot: CropLotCreate,
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    # Check farmer profile

    farmer_result = (
        supabase
        .table("farmers")
        .select("id")
        .eq("id", farmer_id)
        .single()
        .execute()
    )


    if not farmer_result.data:

        raise HTTPException(
            status_code=404,
            detail="Farmer profile not found",
        )



    result = (
        supabase
        .table("crop_lots")
        .insert(
            {
                "farmer_id": farmer_id,
                **lot.model_dump(mode="json"),
            }
        )
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=400,
            detail="Failed to create crop lot",
        )


    return {

        "message": "Crop lot created successfully",

        "crop_lot": result.data[0]

    }



# ============================================================
# GET MY CROP LOTS (FARMER)
# ============================================================

@router.get("")
def get_my_crop_lots(
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    result = (
        supabase
        .table("crop_lots")
        .select("*")
        .eq("farmer_id", farmer_id)
        .order(
            "created_at",
            desc=True
        )
        .execute()
    )


    return {

        "farmer_id": farmer_id,

        "crop_lots": result.data

    }




# ============================================================
# GET AVAILABLE CROP LOTS (BUYER MARKETPLACE)
# ============================================================

@router.get("/available")
def get_available_crop_lots(
    current_user: dict = Depends(get_current_user),
):


    result = (
        supabase
        .table("crop_lots")
        .select("*")
        .eq(
            "availability",
            "available"
        )
        .order(
            "created_at",
            desc=True
        )
        .execute()
    )


    return {

        "crop_lots": result.data

    }


# ============================================================
# GET CROP DETAILS - BUYER
# ============================================================

@router.get("/details/{lot_id}")
def get_crop_details_for_buyer(
    lot_id: str,
    current_user: dict = Depends(get_current_user),
):

    result = (
        supabase
        .table("crop_lots")
        .select(
            """
            *,
            farmers(
                id,
                name,
                location
            )
            """
        )
        .eq(
            "id",
            lot_id
        )
        .single()
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=404,
            detail="Crop lot not found"
        )


    return {
        "crop_lot": result.data
    }

# ============================================================
# GET SINGLE CROP LOT
# ============================================================

@router.get("/{lot_id}")
def get_crop_lot(
    lot_id: str,
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    result = (
        supabase
        .table("crop_lots")
        .select("*")
        .eq(
            "id",
            lot_id
        )
        .eq(
            "farmer_id",
            farmer_id
        )
        .single()
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=404,
            detail="Crop lot not found",
        )


    return result.data




# ============================================================
# UPDATE CROP LOT (FARMER)
# ============================================================

@router.put("/{lot_id}")
def update_crop_lot(
    lot_id: str,
    lot: CropLotCreate,
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    result = (
        supabase
        .table("crop_lots")
        .update(
            lot.model_dump(
                mode="json",
                exclude_unset=True
            )
        )
        .eq(
            "id",
            lot_id
        )
        .eq(
            "farmer_id",
            farmer_id
        )
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=404,
            detail="Crop lot not found",
        )


    return {

        "message": "Crop lot updated successfully",

        "crop_lot": result.data[0]

    }




# ============================================================
# DELETE CROP LOT (FARMER)
# ============================================================

@router.delete("/{lot_id}")
def delete_crop_lot(
    lot_id: str,
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    result = (
        supabase
        .table("crop_lots")
        .delete()
        .eq(
            "id",
            lot_id
        )
        .eq(
            "farmer_id",
            farmer_id
        )
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=404,
            detail="Crop lot not found",
        )


    return {

        "message": "Crop lot deleted successfully"

    }