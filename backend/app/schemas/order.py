from pydantic import BaseModel


# ============================================================
# ORDER
# ============================================================

class OrderCreate(BaseModel):
    offer_id: str
    quantity: float
    agreed_price: float


class OrderResponse(OrderCreate):
    id: str
    farmer_id: str
    buyer_id: str
    crop_lot_id: str
    total_amount: float
    status: str
    created_at: str
    updated_at: str