from fastapi import APIRouter, Depends

from app.core.security import get_current_user
from app.database.supabase_client import supabase


router = APIRouter()


# ============================================================
# FARMER DASHBOARD
# ============================================================

@router.get("/dashboard")
def get_farmer_dashboard(
    current_user: dict = Depends(get_current_user),
):

    farmer_id = current_user["sub"]


    # ---------------------------------------------------------
    # 1. Get farmer crop lots
    # ---------------------------------------------------------

    crops_result = (
        supabase
        .table("crop_lots")
        .select("id")
        .eq("farmer_id", farmer_id)
        .execute()
    )


    crops = crops_result.data or []

    crop_count = len(crops)



    # ---------------------------------------------------------
    # 2. Get offers received
    # ---------------------------------------------------------

    lot_ids = [
        crop["id"]
        for crop in crops
    ]


    offer_count = 0


    if lot_ids:

        offers_result = (
            supabase
            .table("offers")
            .select("id")
            .in_("crop_lot_id", lot_ids)
            .execute()
        )


        offer_count = len(
            offers_result.data or []
        )



    # ---------------------------------------------------------
    # 3. Get farmer orders
    # ---------------------------------------------------------

    orders_result = (
        supabase
        .table("orders")
        .select("id")
        .eq("farmer_id", farmer_id)
        .execute()
    )


    orders = orders_result.data or []


    order_count = len(orders)



    # ---------------------------------------------------------
    # 4. Calculate earnings
    # ---------------------------------------------------------

    total_earnings = 0.0


    order_ids = [
        order["id"]
        for order in orders
    ]


    if order_ids:

        payments_result = (
            supabase
            .table("payments")
            .select("amount,status")
            .in_("order_id", order_ids)
            .execute()
        )


        payments = payments_result.data or []


        for payment in payments:

            if payment.get("status") == "completed":

                total_earnings += float(
                    payment.get("amount", 0) or 0
                )



    # ---------------------------------------------------------
    # Response
    # ---------------------------------------------------------

    return {

        "crop_count": crop_count,

        "offer_count": offer_count,

        "order_count": order_count,

        "total_earnings": total_earnings

    }