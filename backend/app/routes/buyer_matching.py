from fastapi import APIRouter, Depends, HTTPException

from app.core.security import get_current_user
from app.schemas.buyer_matching import BuyerMatchRequest
from app.services.buyer_matching_service import (
    match_buyers_for_crop_lot,
)


router = APIRouter()


@router.post("")
def find_matching_buyers(
    request: BuyerMatchRequest,
    current_user: dict = Depends(get_current_user),
):
    farmer_id = current_user["sub"]

    try:
        result = match_buyers_for_crop_lot(
            crop_lot_id=request.crop_lot_id,
            farmer_id=farmer_id,
        )

        return result

    except ValueError as error:

        raise HTTPException(
            status_code=404,
            detail=str(error),
        )