from pydantic import BaseModel
from typing import Optional
from datetime import date


class CropLotCreate(BaseModel):
    crop_name: str
    variety: Optional[str] = None
    quantity: float
    quality_grade: Optional[str] = None
    expected_price: Optional[float] = None
    harvest_date: Optional[date] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None
    crop_image_url: Optional[str] = None


class CropLotResponse(CropLotCreate):
    id: str
    farmer_id: str
    availability: str
    status: str
    created_at: str
    updated_at: str