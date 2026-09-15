from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.offer import OfferCreate, NegotiationCreate


router = APIRouter()


# ============================================================
# CREATE OFFER — BUYER
# ============================================================

@router.post("")
def create_offer(
    offer: OfferCreate,
    current_user: dict = Depends(get_current_user),
):

    buyer_id = current_user["sub"]


    # Check buyer profile

    buyer_result = (
        supabase
        .table("buyers")
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


    # Check crop lot / bulk lot

    lot = None


    if offer.bulk_lot_id:

        result = (
            supabase
            .table("bulk_lots")
            .select("*")
            .eq("id", offer.bulk_lot_id)
            .single()
            .execute()
        )

        lot = result.data


    elif offer.crop_lot_id:

        result = (
            supabase
            .table("crop_lots")
            .select("*")
            .eq("id", offer.crop_lot_id)
            .single()
            .execute()
        )

        lot = result.data


    else:

        raise HTTPException(
            status_code=400,
            detail="crop_lot_id or bulk_lot_id is required",
        )


    if not lot:

        raise HTTPException(
            status_code=404,
            detail="Lot not found",
        )


    # Availability check

    if "availability" in lot:

        if lot["availability"] != "available":

            raise HTTPException(
                status_code=400,
                detail="Crop lot is not available",
            )


    elif "status" in lot:

        if lot["status"] != "available":

            raise HTTPException(
                status_code=400,
                detail="Bulk lot is not available",
            )


    # Quantity check

    if offer.quantity <= 0:

        raise HTTPException(
            status_code=400,
            detail="Quantity must be greater than zero",
        )


    if offer.quantity > float(lot["quantity"]):

        raise HTTPException(
            status_code=400,
            detail="Offer quantity exceeds available quantity",
        )


    # Create offer

    offer_result = (
        supabase
        .table("offers")
        .insert(
            {
                "crop_lot_id": offer.crop_lot_id,
                "bulk_lot_id": offer.bulk_lot_id,
                "buyer_id": buyer_id,
                "quantity": offer.quantity,
                "offered_price": offer.offered_price,
                "message": offer.message,
            }
        )
        .execute()
    )


    if not offer_result.data:

        raise HTTPException(
            status_code=400,
            detail="Failed to create offer",
        )


    return {
        "message": "Offer created successfully",
        "offer": offer_result.data[0],
    }



# ============================================================
# BUYER — MY OFFERS
# ============================================================

@router.get("")
def get_my_offers(
    current_user: dict = Depends(get_current_user),
):

    buyer_id = current_user["sub"]


    result = (
        supabase
        .table("offers")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order(
            "created_at",
            desc=True
        )
        .execute()
    )


    return {
        "buyer_id": buyer_id,
        "offers": result.data,
    }



# ============================================================
# FARMER / FPO — INCOMING OFFERS
# ============================================================

@router.get("/incoming")
def get_incoming_offers(
    current_user: dict = Depends(get_current_user),
):

    user_id = current_user["sub"]


    # Farmer crop lots

    crop_result = (
        supabase
        .table("crop_lots")
        .select("id")
        .eq("farmer_id", user_id)
        .execute()
    )


    crop_ids = [
        item["id"]
        for item in crop_result.data
    ]



    # FPO profile lookup

    fpo_result = (
        supabase
        .table("fpos")
        .select("id")
        .eq("user_id", user_id)
        .execute()
    )


    fpo_ids = [
        item["id"]
        for item in fpo_result.data
    ]



    # FPO bulk lots

    bulk_result = (
        supabase
        .table("bulk_lots")
        .select("id")
        .in_("fpo_id", fpo_ids)
        .execute()
    )


    bulk_ids = [
        item["id"]
        for item in bulk_result.data
    ]



    # Fetch offers

    result = (
        supabase
        .table("offers")
        .select("*")
        .execute()
    )


    offers = []


    for offer in result.data:

        if (
            offer.get("crop_lot_id") in crop_ids
            or
            offer.get("bulk_lot_id") in bulk_ids
        ):

            offers.append(offer)



    return {
        "user_id": user_id,
        "offers": offers,
    }



# ============================================================
# UPDATE OFFER STATUS
# ============================================================

@router.put("/{offer_id}/status")
def update_offer_status(
    offer_id: str,
    status: str,
    current_user: dict = Depends(get_current_user),
):

    user_id = current_user["sub"]


    if status not in [
        "accepted",
        "rejected",
    ]:

        raise HTTPException(
            status_code=400,
            detail="Invalid status",
        )


    offer_result = (
        supabase
        .table("offers")
        .select("*")
        .eq("id", offer_id)
        .single()
        .execute()
    )


    if not offer_result.data:

        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )


    offer = offer_result.data


    allowed = False



    # Farmer ownership

    if offer.get("crop_lot_id"):

        crop_check = (
            supabase
            .table("crop_lots")
            .select("id")
            .eq(
                "id",
                offer["crop_lot_id"]
            )
            .eq(
                "farmer_id",
                user_id
            )
            .execute()
        )


        allowed = bool(crop_check.data)



    # FPO ownership

    if offer.get("bulk_lot_id"):


        fpo_result = (
            supabase
            .table("fpos")
            .select("id")
            .eq(
                "user_id",
                user_id
            )
            .execute()
        )


        fpo_ids = [
            item["id"]
            for item in fpo_result.data
        ]



        bulk_check = (
            supabase
            .table("bulk_lots")
            .select("id")
            .eq(
                "id",
                offer["bulk_lot_id"]
            )
            .in_(
                "fpo_id",
                fpo_ids
            )
            .execute()
        )


        allowed = bool(bulk_check.data)



    if not allowed:

        raise HTTPException(
            status_code=403,
            detail="Not allowed",
        )



    result = (
        supabase
        .table("offers")
        .update(
            {
                "status": status
            }
        )
        .eq(
            "id",
            offer_id
        )
        .execute()
    )


    return {
        "message": "Offer status updated",
        "offer": result.data[0],
    }



# ============================================================
# NEGOTIATION
# ============================================================

@router.post("/negotiations")
def create_negotiation(
    negotiation: NegotiationCreate,
    current_user: dict = Depends(get_current_user),
):


    result = (
        supabase
        .table("negotiations")
        .insert(
            {
                "offer_id": negotiation.offer_id,
                "sender_type": negotiation.sender_type,
                "offered_price": negotiation.offered_price,
                "quantity": negotiation.quantity,
                "message": negotiation.message,
            }
        )
        .execute()
    )


    if not result.data:

        raise HTTPException(
            status_code=400,
            detail="Failed to create negotiation",
        )


    return {
        "message": "Negotiation created successfully",
        "negotiation": result.data[0],
    }