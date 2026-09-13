from pydantic import BaseModel
from typing import Optional


class BuyerProfileCreate(BaseModel):
    company_name: Optional[str] = None
    business_type: Optional[str] = None
    address: Optional[str] = None
    village: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class BuyerProfileResponse(BuyerProfileCreate):
    id: str