from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.offer import OfferCreate, NegotiationCreate

router = APIRouter()


# ============================================================
# OFFERS
# ============================================================

@router.post("")
def create_offer(
    offer: OfferCreate,
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

    # Make sure the crop lot exists
    lot_result = (
        supabase.table("crop_lots")
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

    # Create the offer
    result = (
        supabase.table("offers")
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


@router.get("")
def get_my_offers(
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("offers")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "buyer_id": buyer_id,
        "offers": result.data,
    }


@router.get("/{offer_id}")
def get_offer(
    offer_id: str,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("offers")
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


@router.put("/{offer_id}")
def update_offer(
    offer_id: str,
    offer: OfferCreate,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("offers")
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
# NEGOTIATIONS
# ============================================================

@router.post("/negotiations")
def create_negotiation(
    negotiation: NegotiationCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Make sure the offer exists
    offer_result = (
        supabase.table("offers")
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

    # Only the buyer who created the offer can add a negotiation
    if offer_result.data["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to negotiate this offer",
        )

    result = (
        supabase.table("negotiations")
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


@router.get("/{offer_id}/negotiations")
def get_negotiations(
    offer_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Make sure the current user owns the offer
    offer_result = (
        supabase.table("offers")
        .select("id")
        .eq("id", offer_id)
        .eq("buyer_id", user_id)
        .single()
        .execute()
    )

    if not offer_result.data:
        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )

    result = (
        supabase.table("negotiations")
        .select("*")
        .eq("offer_id", offer_id)
        .order("created_at", desc=False)
        .execute()
    )

    return {
        "offer_id": offer_id,
        "negotiations": result.data,
    }