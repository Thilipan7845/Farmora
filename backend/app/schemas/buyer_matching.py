from pydantic import BaseModel
from typing import Optional


class BuyerMatchRequest(BaseModel):
    crop_lot_id: str


class BuyerMatchResponse(BaseModel):
    buyer_id: str
    company_name: Optional[str] = None
    business_type: Optional[str] = None
    crop_name: str
    required_quantity: float
    available_quantity: float
    quality_grade: Optional[str] = None
    preferred_location: Optional[str] = None
    match_score: float