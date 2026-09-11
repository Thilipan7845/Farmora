from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.order import OrderCreate

router = APIRouter()


# ============================================================
# CREATE ORDER
# ============================================================

@router.post("")
def create_order(
    order: OrderCreate,
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

    # Get the offer
    offer_result = (
        supabase.table("offers")
        .select("*")
        .eq("id", order.offer_id)
        .single()
        .execute()
    )

    if not offer_result.data:
        raise HTTPException(
            status_code=404,
            detail="Offer not found",
        )

    offer = offer_result.data

    # Make sure the current user owns the offer
    if offer["buyer_id"] != buyer_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to create an order from this offer",
        )

    # Get the crop lot
    lot_result = (
        supabase.table("crop_lots")
        .select("*")
        .eq("id", offer["crop_lot_id"])
        .single()
        .execute()
    )

    if not lot_result.data:
        raise HTTPException(
            status_code=404,
            detail="Crop lot not found",
        )

    crop_lot = lot_result.data

    farmer_id = crop_lot["farmer_id"]
    crop_lot_id = crop_lot["id"]

    # Calculate total amount
    total_amount = order.quantity * order.agreed_price

    # Create the order
    result = (
        supabase.table("orders")
        .insert(
            {
                "offer_id": order.offer_id,
                "farmer_id": farmer_id,
                "buyer_id": buyer_id,
                "crop_lot_id": crop_lot_id,
                "quantity": order.quantity,
                "agreed_price": order.agreed_price,
                "total_amount": total_amount,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create order",
        )

    return {
        "message": "Order created successfully",
        "order": result.data[0],
    }


# ============================================================
# GET MY ORDERS
# ============================================================

@router.get("")
def get_my_orders(
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("orders")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "buyer_id": buyer_id,
        "orders": result.data,
    }


# ============================================================
# GET SINGLE ORDER
# ============================================================

@router.get("/{order_id}")
def get_order(
    order_id: str,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("orders")
        .select("*")
        .eq("id", order_id)
        .eq("buyer_id", buyer_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    return result.data


# ============================================================
# UPDATE ORDER STATUS
# ============================================================

@router.put("/{order_id}/status")
def update_order_status(
    order_id: str,
    status: str,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    result = (
        supabase.table("orders")
        .update({"status": status})
        .eq("id", order_id)
        .eq("buyer_id", buyer_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    return {
        "message": "Order status updated successfully",
        "order": result.data[0],
    }