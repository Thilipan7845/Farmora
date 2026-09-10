from pydantic import BaseModel
from typing import Optional


class FarmerProfileCreate(BaseModel):
    farm_name: Optional[str] = None
    address: Optional[str] = None
    village: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class FarmerProfileResponse(FarmerProfileCreate):
    id: str