from pydantic import BaseModel
from typing import Optional
from datetime import date


class MarketPriceCreate(BaseModel):
    crop_name: str
    market_name: str
    district: Optional[str] = None
    state: Optional[str] = None
    variety: Optional[str] = None
    grade: Optional[str] = None
    min_price: Optional[float] = None
    max_price: Optional[float] = None
    modal_price: Optional[float] = None
    price_date: date


class MarketPriceResponse(MarketPriceCreate):
    id: str
    created_at: str


class MarketArrivalCreate(BaseModel):
    crop_name: str
    market_name: str
    district: Optional[str] = None
    state: Optional[str] = None
    arrival_quantity: float
    arrival_date: date


class MarketArrivalResponse(MarketArrivalCreate):
    id: str
    created_at: str