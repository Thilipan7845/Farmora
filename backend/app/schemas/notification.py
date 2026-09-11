from pydantic import BaseModel
from typing import Optional


# ============================================================
# NOTIFICATION
# ============================================================

class NotificationCreate(BaseModel):
    title: str
    message: str
    notification_type: Optional[str] = None


class NotificationResponse(NotificationCreate):
    id: str
    user_id: str
    is_read: bool
    created_at: str