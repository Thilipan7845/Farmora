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

    # Check crop lot
    lot_result = (
        supabase
        .table("crop_lots")
        .select("*")
        .eq("id", offer.crop_lot_id)
        .single()
        .execute()
    )

    if not lot_result.data:
        raise HTTPException(
            status_code=404,
            detail="Crop lot not found",
        )

    crop_lot = lot_result.data

    # Crop lot must be available
    if crop_lot["availability"] != "available":
        raise HTTPException(
            status_code=400,
            detail="Crop lot is not available",
        )

    # Offer quantity cannot exceed crop quantity
    if offer.quantity > float(crop_lot["quantity"]):
        raise HTTPException(
            status_code=400,
            detail="Offer quantity exceeds available crop quantity",
        )

    # Create offer
    result = (
        supabase
        .table("offers")
        .insert(
            {
                "crop_lot_id": offer.crop_lot_id,
                "buyer_id": buyer_id,
                "quantity": offer.quantity,
                "offered_price": offer.offered_price,
                "message": offer.message,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create offer",
        )

    return {
        "message": "Offer created successfully",
        "offer": result.data[0],
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
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "buyer_id": buyer_id,
        "offers": result.data,
    }


# ============================================================
# FARMER — INCOMING OFFERS
# ============================================================

@router.get("/incoming")
def get_incoming_offers(
    current_user: dict = Depends(get_current_user),
):
    farmer_id = current_user["sub"]

    # Find crop lots owned by this farmer
    lots_result = (
        supabase
        .table("crop_lots")
        .select("id")
        .eq("farmer_id", farmer_id)
        .execute()
    )

    lot_ids = [
        lot["id"]
        for lot in lots_result.data
    ]

    if not lot_ids:
        return {
            "farmer_id": farmer_id,
            "offers": [],
        }

    # Find offers for the farmer's crop lots
    offers_result = (
        supabase
        .table("offers")
        .select("*")
        .in_("crop_lot_id", lot_ids)
        .order("created_at", desc=True)
        .execute()
    )

    offers = offers_result.data

    # Find buyer IDs
    buyer_ids = list(
        {
            offer["buyer_id"]
            for offer in offers
        }
    )

    buyers = {}

    if buyer_ids:

        buyers_result = (
            supabase
            .table("buyers")
            .select("*")
            .in_("id", buyer_ids)
            .execute()
        )

        buyers = {
            buyer["id"]: buyer
            for buyer in buyers_result.data
        }

    # Add buyer information to every offer
    enriched_offers = []

    for offer in offers:

        buyer = buyers.get(
            offer["buyer_id"],
            {},
        )

        enriched_offers.append(
            {
                **offer,
                "buyer": {
                    "id": offer["buyer_id"],
                    "company_name": buyer.get(
                        "company_name"
                    ),
                    "business_type": buyer.get(
                        "business_type"
                    ),
                    "district": buyer.get(
                        "district"
                    ),
                    "state": buyer.get(
                        "state"
                    ),
                },
            }
        )

    return {
        "farmer_id": farmer_id,
        "offers": enriched_offers,
    }


# ============================================================
# BUYER — GET SINGLE OFFER
# ============================================================

@router.get("/{offer_id}")
def get_offer(
    offer_id: str,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase
        .table("offers")
        .select("*")
        .eq("id", offer_id)
        .eq("buyer_id", buyer_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )

    return result.data


# ============================================================
# BUYER — UPDATE OFFER
# ============================================================

@router.put("/{offer_id}")
def update_offer(
    offer_id: str,
    offer: OfferCreate,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase
        .table("offers")
        .update(
            {
                "quantity": offer.quantity,
                "offered_price": offer.offered_price,
                "message": offer.message,
            }
        )
        .eq("id", offer_id)
        .eq("buyer_id", buyer_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )

    return {
        "message": "Offer updated successfully",
        "offer": result.data[0],
    }


# ============================================================
# FARMER — ACCEPT / REJECT OFFER
# ============================================================

@router.put("/{offer_id}/status")
def update_offer_status(
    offer_id: str,
    status: str,
    current_user: dict = Depends(get_current_user),
):
    farmer_id = current_user["sub"]

    # Only these statuses are allowed
    if status not in ["accepted", "rejected"]:
        raise HTTPException(
            status_code=400,
            detail="Status must be 'accepted' or 'rejected'",
        )

    # Find offer
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

    # Check that the farmer owns the crop lot
    lot_result = (
        supabase
        .table("crop_lots")
        .select("*")
        .eq("id", offer["crop_lot_id"])
        .eq("farmer_id", farmer_id)
        .single()
        .execute()
    )

    if not lot_result.data:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to update this offer",
        )

    crop_lot = lot_result.data

    # --------------------------------------------------------
    # ACCEPT OFFER
    # --------------------------------------------------------

    if status == "accepted":

        if crop_lot["availability"] != "available":
            raise HTTPException(
                status_code=400,
                detail="Crop lot is no longer available",
            )

        if offer["quantity"] > float(
            crop_lot["quantity"]
        ):
            raise HTTPException(
                status_code=400,
                detail="Offer quantity exceeds available crop quantity",
            )

    # Update offer status
    result = (
        supabase
        .table("offers")
        .update(
            {
                "status": status,
            }
        )
        .eq("id", offer_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to update offer status",
        )

    # --------------------------------------------------------
    # RESERVE CROP LOT AFTER ACCEPTANCE
    # --------------------------------------------------------

    if status == "accepted":

        reserve_result = (
            supabase
            .table("crop_lots")
            .update(
                {
                    "availability": "reserved",
                }
            )
            .eq(
                "id",
                crop_lot["id"],
            )
            .eq(
                "farmer_id",
                farmer_id,
            )
            .execute()
        )

        if not reserve_result.data:
            raise HTTPException(
                status_code=400,
                detail="Offer accepted but crop lot could not be reserved",
            )

    return {
        "message": (
            "Offer accepted successfully"
            if status == "accepted"
            else "Offer rejected successfully"
        ),
        "offer": result.data[0],
    }


# ============================================================
# CREATE NEGOTIATION
# ============================================================

@router.post("/negotiations")
def create_negotiation(
    negotiation: NegotiationCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Find offer
    offer_result = (
        supabase
        .table("offers")
        .select("*")
        .eq("id", negotiation.offer_id)
        .single()
        .execute()
    )

    if not offer_result.data:
        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )

    offer = offer_result.data

    # --------------------------------------------------------
    # BUYER OR FARMER MUST OWN THE OFFER
    # --------------------------------------------------------

    if offer["buyer_id"] == user_id:

        allowed = True

    else:

        lot_result = (
            supabase
            .table("crop_lots")
            .select("id")
            .eq(
                "id",
                offer["crop_lot_id"],
            )
            .eq(
                "farmer_id",
                user_id,
            )
            .single()
            .execute()
        )

        allowed = bool(lot_result.data)

    if not allowed:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to negotiate this offer",
        )

    # Create negotiation
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


# ============================================================
# GET NEGOTIATIONS
# ============================================================

@router.get("/{offer_id}/negotiations")
def get_negotiations(
    offer_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Find offer
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

    # Buyer owns offer
    allowed = offer["buyer_id"] == user_id

    # Farmer owns crop lot
    if not allowed:

        lot_result = (
            supabase
            .table("crop_lots")
            .select("id")
            .eq(
                "id",
                offer["crop_lot_id"],
            )
            .eq(
                "farmer_id",
                user_id,
            )
            .single()
            .execute()
        )

        allowed = bool(lot_result.data)

    if not allowed:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to view these negotiations",
        )

    result = (
        supabase
        .table("negotiations")
        .select("*")
        .eq(
            "offer_id",
            offer_id,
        )
        .order(
            "created_at",
            desc=False,
        )
        .execute()
    )

    return {
        "offer_id": offer_id,
        "negotiations": result.data,
    }