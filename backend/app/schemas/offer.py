from pydantic import BaseModel
from typing import Optional


# ============================================================
# OFFER
# ============================================================

class OfferCreate(BaseModel):
    crop_lot_id: str
    quantity: float
    offered_price: float
    message: Optional[str] = None


class OfferResponse(OfferCreate):
    id: str
    buyer_id: str
    status: str
    created_at: str
    updated_at: str


# ============================================================
# NEGOTIATION
# ============================================================

class NegotiationCreate(BaseModel):
    offer_id: str
    sender_type: str
    offered_price: float
    quantity: float
    message: Optional[str] = None


class NegotiationResponse(NegotiationCreate):
    id: str
    created_at: str