from pydantic import BaseModel
from typing import Optional


class BulkLotCreate(BaseModel):
    crop_lot_ids: list[str]
    crop_name: str
    variety: Optional[str] = None
    quality_grade: Optional[str] = None


class BulkLotResponse(BaseModel):
    id: str
    fpo_id: str
    crop_name: str
    quantity: float
    status: str