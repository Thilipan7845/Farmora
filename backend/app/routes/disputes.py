from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.dispute import DisputeCreate

router = APIRouter()


# ============================================================
# CREATE DISPUTE
# ============================================================

@router.post("")
def create_dispute(
    dispute: DisputeCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Make sure the order exists
    order_result = (
        supabase.table("orders")
        .select("*")
        .eq("id", dispute.order_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    order = order_result.data

    # Only the buyer who owns the order can raise a dispute
    if order["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to raise a dispute for this order",
        )

    result = (
        supabase.table("disputes")
        .insert(
            {
                "order_id": dispute.order_id,
                "raised_by": user_id,
                "category": dispute.category,
                "description": dispute.description,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create dispute",
        )

    return {
        "message": "Dispute created successfully",
        "dispute": result.data[0],
    }


# ============================================================
# GET MY DISPUTES
# ============================================================

@router.get("")
def get_my_disputes(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("disputes")
        .select("*")
        .eq("raised_by", user_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "user_id": user_id,
        "disputes": result.data,
    }


# ============================================================
# GET SINGLE DISPUTE
# ============================================================

@router.get("/{dispute_id}")
def get_dispute(
    dispute_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("disputes")
        .select("*")
        .eq("id", dispute_id)
        .eq("raised_by", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Dispute not found",
        )

    return result.data


# ============================================================
# UPDATE MY DISPUTE
# ============================================================

@router.put("/{dispute_id}")
def update_dispute(
    dispute_id: str,
    dispute: DisputeCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Make sure the dispute belongs to the current user
    existing_result = (
        supabase.table("disputes")
        .select("*")
        .eq("id", dispute_id)
        .eq("raised_by", user_id)
        .single()
        .execute()
    )

    if not existing_result.data:
        raise HTTPException(
            status_code=404,
            detail="Dispute not found",
        )

    # Make sure the new order exists
    order_result = (
        supabase.table("orders")
        .select("id, buyer_id")
        .eq("id", dispute.order_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    if order_result.data["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to use this order",
        )

    result = (
        supabase.table("disputes")
        .update(
            {
                "order_id": dispute.order_id,
                "category": dispute.category,
                "description": dispute.description,
            }
        )
        .eq("id", dispute_id)
        .eq("raised_by", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Dispute not found",
        )

    return {
        "message": "Dispute updated successfully",
        "dispute": result.data[0],
    }