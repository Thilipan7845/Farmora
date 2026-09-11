from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.logistics import LogisticsCreate

router = APIRouter()


# ============================================================
# CREATE LOGISTICS
# ============================================================

@router.post("")
def create_logistics(
    logistics: LogisticsCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get the order
    order_result = (
        supabase.table("orders")
        .select("*")
        .eq("id", logistics.order_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    order = order_result.data

    # Make sure the current user owns the order
    if order["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to create logistics for this order",
        )

    # Create logistics record
    result = (
        supabase.table("logistics")
        .insert(
            {
                "order_id": logistics.order_id,
                "pickup_location": logistics.pickup_location,
                "delivery_location": logistics.delivery_location,
                "pickup_latitude": logistics.pickup_latitude,
                "pickup_longitude": logistics.pickup_longitude,
                "delivery_latitude": logistics.delivery_latitude,
                "delivery_longitude": logistics.delivery_longitude,
                "distance_km": logistics.distance_km,
                "transport_type": logistics.transport_type,
                "transport_cost": logistics.transport_cost,
                "estimated_delivery_date": (
                    logistics.estimated_delivery_date.isoformat()
                    if logistics.estimated_delivery_date
                    else None
                ),
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create logistics",
        )

    return {
        "message": "Logistics created successfully",
        "logistics": result.data[0],
    }


# ============================================================
# GET MY LOGISTICS
# ============================================================

@router.get("")
def get_my_logistics(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get orders belonging to the buyer
    orders_result = (
        supabase.table("orders")
        .select("id")
        .eq("buyer_id", user_id)
        .execute()
    )

    order_ids = [order["id"] for order in orders_result.data]

    if not order_ids:
        return {
            "logistics": [],
        }

    result = (
        supabase.table("logistics")
        .select("*")
        .in_("order_id", order_ids)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "logistics": result.data,
    }


# ============================================================
# GET SINGLE LOGISTICS
# ============================================================

@router.get("/{logistics_id}")
def get_logistics(
    logistics_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get logistics record
    logistics_result = (
        supabase.table("logistics")
        .select("*")
        .eq("id", logistics_id)
        .single()
        .execute()
    )

    if not logistics_result.data:
        raise HTTPException(
            status_code=404,
            detail="Logistics record not found",
        )

    logistics = logistics_result.data

    # Verify that the order belongs to the current buyer
    order_result = (
        supabase.table("orders")
        .select("id")
        .eq("id", logistics["order_id"])
        .eq("buyer_id", user_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to view this logistics record",
        )

    return logistics


# ============================================================
# UPDATE LOGISTICS STATUS
# ============================================================

@router.put("/{logistics_id}/status")
def update_logistics_status(
    logistics_id: str,
    status: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get logistics record
    logistics_result = (
        supabase.table("logistics")
        .select("order_id")
        .eq("id", logistics_id)
        .single()
        .execute()
    )

    if not logistics_result.data:
        raise HTTPException(
            status_code=404,
            detail="Logistics record not found",
        )

    order_id = logistics_result.data["order_id"]

    # Verify ownership through the order
    order_result = (
        supabase.table("orders")
        .select("id")
        .eq("id", order_id)
        .eq("buyer_id", user_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to update this logistics record",
        )

    # Update status
    result = (
        supabase.table("logistics")
        .update({"status": status})
        .eq("id", logistics_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to update logistics status",
        )

    return {
        "message": "Logistics status updated successfully",
        "logistics": result.data[0],
    }