from pydantic import BaseModel
from typing import Optional


# ============================================================
# PAYMENT
# ============================================================

class PaymentCreate(BaseModel):
    order_id: str
    amount: float
    payment_method: str
    transaction_reference: Optional[str] = None


class PaymentResponse(PaymentCreate):
    id: str
    status: str
    paid_at: Optional[str] = None
    created_at: str
    updated_at: str