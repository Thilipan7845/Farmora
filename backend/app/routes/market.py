from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.market import (
    MarketPriceCreate,
    MarketArrivalCreate,
)


router = APIRouter()


# ------------------------------------------------------------
# MARKET PRICES
# ------------------------------------------------------------

@router.post("/prices")
def create_market_price(
    price: MarketPriceCreate,
    current_user: dict = Depends(get_current_user),
):
    result = (
        supabase.table("market_prices")
        .insert(
            price.model_dump(mode="json")
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create market price",
        )

    return {
        "message": "Market price created successfully",
        "market_price": result.data[0],
    }


@router.get("/prices")
def get_market_prices(
    current_user: dict = Depends(get_current_user),
):
    result = (
        supabase.table("market_prices")
        .select("*")
        .order("price_date", desc=True)
        .execute()
    )

    return {
        "market_prices": result.data,
    }


# ------------------------------------------------------------
# MARKET ARRIVALS
# ------------------------------------------------------------

@router.post("/arrivals")
def create_market_arrival(
    arrival: MarketArrivalCreate,
    current_user: dict = Depends(get_current_user),
):
    result = (
        supabase.table("market_arrivals")
        .insert(
            arrival.model_dump(mode="json")
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create market arrival",
        )

    return {
        "message": "Market arrival created successfully",
        "market_arrival": result.data[0],
    }


@router.get("/arrivals")
def get_market_arrivals(
    current_user: dict = Depends(get_current_user),
):
    result = (
        supabase.table("market_arrivals")
        .select("*")
        .order("arrival_date", desc=True)
        .execute()
    )

    return {
        "market_arrivals": result.data,
    }