from fastapi import APIRouter, Depends, HTTPException

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

    # --------------------------------------------------------
    # GET ORDER
    # --------------------------------------------------------

    order_result = (
        supabase
        .table("orders")
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

    # --------------------------------------------------------
    # CHECK BUYER OWNERSHIP
    # --------------------------------------------------------

    if order["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to make a payment for this order",
        )

    # --------------------------------------------------------
    # PAYMENT ONLY AFTER DELIVERY
    # --------------------------------------------------------

    if order["status"] != "delivered":
        raise HTTPException(
            status_code=400,
            detail="Payment can only be created after the order is delivered",
        )

    # --------------------------------------------------------
    # CHECK PAYMENT AMOUNT
    # --------------------------------------------------------

    if payment.amount <= 0:
        raise HTTPException(
            status_code=400,
            detail="Payment amount must be greater than zero",
        )

    order_total = float(order["total_amount"])
    payment_amount = float(payment.amount)

    if payment_amount != order_total:
        raise HTTPException(
            status_code=400,
            detail=(
                f"Payment amount must exactly match "
                f"the order total of {order_total}"
            ),
        )

    # --------------------------------------------------------
    # CHECK FOR EXISTING ACTIVE PAYMENT
    # --------------------------------------------------------

    existing_result = (
        supabase
        .table("payments")
        .select("*")
        .eq("order_id", payment.order_id)
        .in_(
            "status",
            [
                "pending",
                "processing",
                "completed",
            ],
        )
        .execute()
    )

    if existing_result.data:
        raise HTTPException(
            status_code=400,
            detail="An active payment already exists for this order",
        )

    # --------------------------------------------------------
    # CREATE PAYMENT
    # --------------------------------------------------------

    payment_data = {
        "order_id": payment.order_id,
        "amount": payment.amount,
        "payment_method": payment.payment_method,
        "transaction_reference": payment.transaction_reference,
        "status": "pending",
    }

    result = (
        supabase
        .table("payments")
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

    # Get buyer's orders
    orders_result = (
        supabase
        .table("orders")
        .select("id")
        .eq("buyer_id", user_id)
        .execute()
    )

    order_ids = [
        order["id"]
        for order in orders_result.data
    ]

    if not order_ids:
        return {
            "payments": []
        }

    # Get payments for those orders
    result = (
        supabase
        .table("payments")
        .select("*")
        .in_("order_id", order_ids)
        .order(
            "created_at",
            desc=True,
        )
        .execute()
    )

    return {
        "payments": result.data
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

    # --------------------------------------------------------
    # GET PAYMENT
    # --------------------------------------------------------

    payment_result = (
        supabase
        .table("payments")
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

    # --------------------------------------------------------
    # CHECK ORDER OWNERSHIP
    # --------------------------------------------------------

    order_result = (
        supabase
        .table("orders")
        .select("id")
        .eq(
            "id",
            payment["order_id"],
        )
        .eq(
            "buyer_id",
            user_id,
        )
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to view this payment",
        )

    return payment


# ============================================================
# UPDATE PAYMENT STATUS
# ============================================================

@router.put("/{payment_id}/status")
def update_payment_status(
    payment_id: str,
    status: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    # --------------------------------------------------------
    # VALID PAYMENT STATUSES
    # --------------------------------------------------------

    allowed_statuses = [
        "pending",
        "processing",
        "completed",
        "failed",
        "refunded",
    ]

    if status not in allowed_statuses:
        raise HTTPException(
            status_code=400,
            detail=(
                "Invalid payment status. "
                "Allowed values: "
                + ", ".join(allowed_statuses)
            ),
        )

    # --------------------------------------------------------
    # GET PAYMENT
    # --------------------------------------------------------

    payment_result = (
        supabase
        .table("payments")
        .select("*")
        .eq(
            "id",
            payment_id,
        )
        .single()
        .execute()
    )

    if not payment_result.data:
        raise HTTPException(
            status_code=404,
            detail="Payment not found",
        )

    payment = payment_result.data

    # --------------------------------------------------------
    # GET ORDER
    # --------------------------------------------------------

    order_result = (
        supabase
        .table("orders")
        .select("*")
        .eq(
            "id",
            payment["order_id"],
        )
        .single()
        .execute()
    )

    if not order_result.data:
        raise HTTPException(
            status_code=404,
            detail="Order not found",
        )

    order = order_result.data

    # --------------------------------------------------------
    # CHECK BUYER OWNERSHIP
    # --------------------------------------------------------

    if order["buyer_id"] != user_id:
        raise HTTPException(
            status_code=403,
            detail="You are not allowed to update this payment",
        )

    # --------------------------------------------------------
    # PREVENT CHANGING COMPLETED PAYMENT
    # --------------------------------------------------------

    if payment["status"] == "completed":
        raise HTTPException(
            status_code=400,
            detail="Completed payment cannot be changed",
        )

    # --------------------------------------------------------
    # PAYMENT STATUS UPDATE
    # --------------------------------------------------------

    payment_update_data = {
        "status": status,
    }

    # Record payment completion time
    if status == "completed":
        from datetime import datetime, timezone

        payment_update_data["paid_at"] = (
            datetime.now(timezone.utc).isoformat()
        )

    payment_update = (
        supabase
        .table("payments")
        .update(payment_update_data)
        .eq(
            "id",
            payment_id,
        )
        .execute()
    )

    if not payment_update.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to update payment status",
        )

    # --------------------------------------------------------
    # PAYMENT COMPLETED
    # --------------------------------------------------------

    if status == "completed":

        # --------------------------------------------
        # ORDER → COMPLETED
        # --------------------------------------------

        order_update = (
            supabase
            .table("orders")
            .update(
                {
                    "status": "completed",
                }
            )
            .eq(
                "id",
                payment["order_id"],
            )
            .execute()
        )

        if not order_update.data:
            raise HTTPException(
                status_code=400,
                detail=(
                    "Payment completed, "
                    "but order could not be marked completed"
                ),
            )

        # --------------------------------------------
        # CROP LOT → SOLD
        # --------------------------------------------

        crop_lot_update = (
            supabase
            .table("crop_lots")
            .update(
                {
                    "availability": "sold",
                    "status": "completed",
                }
            )
            .eq(
                "id",
                order["crop_lot_id"],
            )
            .execute()
        )

        if not crop_lot_update.data:
            raise HTTPException(
                status_code=400,
                detail=(
                    "Payment completed and order completed, "
                    "but crop lot could not be marked as sold"
                ),
            )

        return {
            "message": (
                "Payment completed successfully. "
                "Order and crop lot finalized."
            ),
            "payment": payment_update.data[0],
            "order": order_update.data[0],
            "crop_lot": crop_lot_update.data[0],
        }

    # --------------------------------------------------------
    # PAYMENT FAILED / REFUNDED / PROCESSING / PENDING
    # --------------------------------------------------------

    return {
        "message": "Payment status updated successfully",
        "payment": payment_update.data[0],
    }