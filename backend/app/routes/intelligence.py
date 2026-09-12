from fastapi import APIRouter, Depends

from app.core.security import get_current_user
from app.schemas.intelligence import IntelligenceDecisionRequest
from app.services.intelligence_service import get_market_decision


router = APIRouter()


@router.post("/decision")
def create_market_decision(
    request: IntelligenceDecisionRequest,
    current_user: dict = Depends(get_current_user),
):
    return get_market_decision(request)