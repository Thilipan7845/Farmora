from fastapi import APIRouter, Depends, HTTPException
from datetime import datetime, timezone

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.payment import PaymentCreate

router = APIRouter()


# ============================================================
# CREATE PAYMENT
# ============================================================

@router.post("")
def create_payment(
    payment: PaymentCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get the order
    order_result = (
        supabase.table("orders")
        .select("*")
        .eq("id", payment.order_id)
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
            detail="You are not allowed to make a payment for this order",
        )

    # Make sure the payment amount matches the order total
    if payment.amount != float(order["total_amount"]):
        raise HTTPException(
            status_code=400,
            detail="Payment amount does not match the order total",
        )

    # Create payment
    payment_data = {
        "order_id": payment.order_id,
        "amount": payment.amount,
        "payment_method": payment.payment_method,
        "transaction_reference": payment.transaction_reference,
    }

    result = (
        supabase.table("payments")
        .insert(payment_data)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create payment",
        )

    return {
        "message": "Payment created successfully",
        "payment": result.data[0],
    }


# ============================================================
# GET MY PAYMENTS
# ============================================================

@router.get("")
def get_my_payments(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get orders belonging to the current buyer
    orders_result = (
        supabase.table("orders")
        .select("id")
        .eq("buyer_id", user_id)
        .execute()
    )

    order_ids = [order["id"] for order in orders_result.data]

    if not order_ids:
        return {
            "payments": [],
        }

    result = (
        supabase.table("payments")
        .select("*")
        .in_("order_id", order_ids)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "payments": result.data,
    }


# ============================================================
# GET SINGLE PAYMENT
# ============================================================

@router.get("/{payment_id}")
def get_payment(
    payment_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # Get payment
    payment_result = (
        supabase.table("payments")
        .select("*")
        .eq("id", payment_id)
        .single()
        .execute()
    )

    if not payment_result.data:
        raise HTTPException(
            status_code=404,
            detail="Payment not found",
        )

    payment = payment_result.data

    # Verify ownership through the order
    order_result = (
        supabase.table("orders")
        .select("id")
        .eq("id", payment["order_id"])
        .eq("buyer_id", user_id)
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to view this payment",
        )

    return payment