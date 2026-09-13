from pydantic import BaseModel
from typing import Optional
from datetime import date


# ============================================================
# LOGISTICS
# ============================================================

class LogisticsCreate(BaseModel):
    order_id: str
    pickup_location: str
    delivery_location: str
    pickup_latitude: Optional[float] = None
    pickup_longitude: Optional[float] = None
    delivery_latitude: Optional[float] = None
    delivery_longitude: Optional[float] = None
    distance_km: Optional[float] = None
    transport_type: Optional[str] = None
    transport_cost: Optional[float] = None
    estimated_delivery_date: Optional[date] = None


class LogisticsResponse(LogisticsCreate):
    id: str
    status: str
    created_at: str
    updated_at: str
    