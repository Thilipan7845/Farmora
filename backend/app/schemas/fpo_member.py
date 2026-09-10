from pydantic import BaseModel
from typing import Optional


class FPOMemberCreate(BaseModel):
    farmer_id: str
    status: Optional[str] = "active"


class FPOMemberResponse(BaseModel):
    id: str
    fpo_id: str
    farmer_id: str
    joined_at: str
    status: str