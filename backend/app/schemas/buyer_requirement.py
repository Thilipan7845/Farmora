from pydantic import BaseModel
from typing import Optional


class BuyerRequirementCreate(BaseModel):
    crop_name: str
    quantity: float
    quality_grade: Optional[str] = None
    min_price: Optional[float] = None
    max_price: Optional[float] = None
    preferred_location: Optional[str] = None
    delivery_required: bool = False
    delivery_location: Optional[str] = None


class BuyerRequirementResponse(BuyerRequirementCreate):
    id: str
    buyer_id: str
    status: str
    created_at: str
    updated_at: str