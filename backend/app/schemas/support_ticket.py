from pydantic import BaseModel
from typing import Optional


# ============================================================
# SUPPORT TICKET
# ============================================================

class SupportTicketCreate(BaseModel):
    subject: str
    description: str
    category: Optional[str] = None
    priority: Optional[str] = "medium"


class SupportTicketResponse(SupportTicketCreate):
    id: str
    user_id: str
    status: str
    created_at: str
    updated_at: str