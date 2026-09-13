from pydantic import BaseModel
from typing import Optional


class IntelligenceDecisionRequest(BaseModel):
    crop: str
    market: str
    variety: Optional[str] = None
    grade: Optional[str] = None

    storage_available: bool
    storage_cost: float

    demand_level: str

    quantity: float
    transport_cost: float
    storage_expense: float