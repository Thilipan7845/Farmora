from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.order import OrderCreate


router = APIRouter()


# ============================================================
# CREATE ORDER FROM ACCEPTED OFFER
# ============================================================

@router.post("")
def create_order(
    order: OrderCreate,
    current_user: dict = Depends(get_current_user),
):
    buyer_id = current_user["sub"]

    # --------------------------------------------------------
    # CHECK BUYER PROFILE
    # --------------------------------------------------------

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

    # --------------------------------------------------------
    # GET OFFER
    # --------------------------------------------------------

    offer_result = (
        supabase
        .table("offers")
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

    # --------------------------------------------------------
    # CHECK BUYER OWNS OFFER
    # --------------------------------------------------------

    if offer["buyer_id"] != buyer_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to create an order from this offer",
        )

    # --------------------------------------------------------
    # OFFER MUST BE ACCEPTED
    # --------------------------------------------------------

    if offer["status"] != "accepted":
        raise HTTPException(
            status_code=400,
            detail="Order can only be created from an accepted offer",
        )

    # --------------------------------------------------------
    # GET CROP LOT
    # --------------------------------------------------------

    lot_result = (
        supabase
        .table("crop_lots")
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

    # --------------------------------------------------------
    # CHECK CROP LOT
    # --------------------------------------------------------

    if crop_lot["availability"] != "reserved":
        raise HTTPException(
            status_code=400,
            detail="Crop lot is not reserved for this accepted offer",
        )

    # --------------------------------------------------------
    # CHECK QUANTITY
    # --------------------------------------------------------

    if order.quantity <= 0:
        raise HTTPException(
            status_code=400,
            detail="Order quantity must be greater than zero",
        )

    if order.quantity > float(
        offer["quantity"]
    ):
        raise HTTPException(
            status_code=400,
            detail="Order quantity cannot exceed accepted offer quantity",
        )

    if order.quantity > float(
        crop_lot["quantity"]
    ):
        raise HTTPException(
            status_code=400,
            detail="Order quantity exceeds crop lot quantity",
        )

    # --------------------------------------------------------
    # AGREED PRICE
    # --------------------------------------------------------

    if order.agreed_price <= 0:
        raise HTTPException(
            status_code=400,
            detail="Agreed price must be greater than zero",
        )

    # --------------------------------------------------------
    # CALCULATE TOTAL
    # --------------------------------------------------------

    total_amount = (
        order.quantity
        * order.agreed_price
    )

    # --------------------------------------------------------
    # CREATE ORDER
    # --------------------------------------------------------

    result = (
        supabase
        .table("orders")
        .insert(
            {
                "offer_id": order.offer_id,
                "farmer_id": crop_lot["farmer_id"],
                "buyer_id": buyer_id,
                "crop_lot_id": crop_lot["id"],
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
        supabase
        .table("orders")
        .select("*")
        .eq("buyer_id", buyer_id)
        .order(
            "created_at",
            desc=True,
        )
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
        supabase
        .table("orders")
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

    allowed_statuses = [
        "pending",
        "confirmed",
        "processing",
        "shipped",
        "delivered",
        "completed",
        "cancelled",
    ]

    if status not in allowed_statuses:
        raise HTTPException(
            status_code=400,
            detail=(
                "Invalid order status. "
                "Allowed values: "
                + ", ".join(allowed_statuses)
            ),
        )

    result = (
        supabase
        .table("orders")
        .update(
            {
                "status": status,
            }
        )
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