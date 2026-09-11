from pydantic import BaseModel
from typing import Optional


# ============================================================
# DISPUTE
# ============================================================

class DisputeCreate(BaseModel):
    order_id: str
    category: str
    description: str


class DisputeResponse(DisputeCreate):
    id: str
    raised_by: str
    status: str
    resolution: Optional[str] = None
    created_at: str
    updated_at: str
    resolved_at: Optional[str] = None