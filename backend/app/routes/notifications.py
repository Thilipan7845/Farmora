from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.notification import NotificationCreate

router = APIRouter()


# ============================================================
# CREATE NOTIFICATION
# ============================================================

@router.post("")
def create_notification(
    notification: NotificationCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("notifications")
        .insert(
            {
                "user_id": user_id,
                "title": notification.title,
                "message": notification.message,
                "notification_type": notification.notification_type,
                "is_read": False,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create notification",
        )

    return {
        "message": "Notification created successfully",
        "notification": result.data[0],
    }


# ============================================================
# GET MY NOTIFICATIONS
# ============================================================

@router.get("")
def get_my_notifications(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("notifications")
        .select("*")
        .eq("user_id", user_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "user_id": user_id,
        "notifications": result.data,
    }


# ============================================================
# GET SINGLE NOTIFICATION
# ============================================================

@router.get("/{notification_id}")
def get_notification(
    notification_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("notifications")
        .select("*")
        .eq("id", notification_id)
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Notification not found",
        )

    return result.data


# ============================================================
# MARK NOTIFICATION AS READ
# ============================================================

@router.put("/{notification_id}/read")
def mark_notification_as_read(
    notification_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("notifications")
        .update({"is_read": True})
        .eq("id", notification_id)
        .eq("user_id", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Notification not found",
        )

    return {
        "message": "Notification marked as read",
        "notification": result.data[0],
    }
