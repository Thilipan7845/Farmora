from fastapi import APIRouter, Depends

from app.core.security import get_current_user
from app.database.supabase_client import supabase


router = APIRouter()


# ============================================================
# BUYER DASHBOARD
# ============================================================

@router.get("/dashboard")
def get_buyer_dashboard(
    current_user: dict = Depends(get_current_user),
):

    buyer_id = current_user["sub"]


    # --------------------------------------------------------
    # 1. Pending Offers
    # --------------------------------------------------------

    offers_result = (
        supabase
        .table("offers")
        .select("id,status")
        .eq("buyer_id", buyer_id)
        .execute()
    )


    offers = offers_result.data or []


    pending_offers = len(
        [
            offer
            for offer in offers
            if offer.get("status") == "pending"
        ]
    )



    # --------------------------------------------------------
    # 2. Orders
    # --------------------------------------------------------

    orders_result = (
        supabase
        .table("orders")
        .select("id,total_amount,status")
        .eq("buyer_id", buyer_id)
        .execute()
    )


    orders = orders_result.data or []



    active_orders = len(
        [
            order
            for order in orders
            if order.get("status") != "completed"
        ]
    )



    total_purchase = sum(
        float(order.get("total_amount", 0) or 0)
        for order in orders
    )



    pending_payment = 0


    return {

        "pending_offers": pending_offers,

        "active_orders": active_orders,

        "total_purchase": total_purchase,

        "pending_payment": pending_payment

    }