from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.database.supabase_client import supabase
from app.schemas.support_ticket import SupportTicketCreate

router = APIRouter()


# ============================================================
# CREATE SUPPORT TICKET
# ============================================================

@router.post("")
def create_support_ticket(
    ticket: SupportTicketCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("support_tickets")
        .insert(
            {
                "user_id": user_id,
                "subject": ticket.subject,
                "description": ticket.description,
                "category": ticket.category,
                "priority": ticket.priority,
            }
        )
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=400,
            detail="Failed to create support ticket",
        )

    return {
        "message": "Support ticket created successfully",
        "ticket": result.data[0],
    }


# ============================================================
# GET MY SUPPORT TICKETS
# ============================================================

@router.get("")
def get_my_support_tickets(
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("support_tickets")
        .select("*")
        .eq("user_id", user_id)
        .order("created_at", desc=True)
        .execute()
    )

    return {
        "user_id": user_id,
        "tickets": result.data,
    }


# ============================================================
# GET SINGLE SUPPORT TICKET
# ============================================================

@router.get("/{ticket_id}")
def get_support_ticket(
    ticket_id: str,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("support_tickets")
        .select("*")
        .eq("id", ticket_id)
        .eq("user_id", user_id)
        .single()
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Support ticket not found",
        )

    return result.data


# ============================================================
# UPDATE MY SUPPORT TICKET
# ============================================================

@router.put("/{ticket_id}")
def update_support_ticket(
    ticket_id: str,
    ticket: SupportTicketCreate,
    current_user: dict = Depends(get_current_user),
):
    user_id = current_user["sub"]

    result = (
        supabase.table("support_tickets")
        .update(
            {
                "subject": ticket.subject,
                "description": ticket.description,
                "category": ticket.category,
                "priority": ticket.priority,
            }
        )
        .eq("id", ticket_id)
        .eq("user_id", user_id)
        .execute()
    )

    if not result.data:
        raise HTTPException(
            status_code=404,
            detail="Support ticket not found",
        )

    return {
        "message": "Support ticket updated successfully",
        "ticket": result.data[0],
    }