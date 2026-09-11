from fastapi import APIRouter, Depends

from math import radians, sin, cos, sqrt, atan2

from app.core.security import get_current_user
from app.schemas.location import (
    LocationDistanceRequest,
    LocationDistanceResponse,
)

router = APIRouter()


# ============================================================
# CALCULATE DISTANCE BETWEEN TWO LOCATIONS
# ============================================================

@router.post(
    "/distance",
    response_model=LocationDistanceResponse,
)
def calculate_distance(
    location: LocationDistanceRequest,
    current_user: dict = Depends(get_current_user),
):
    # Earth's radius in kilometers
    earth_radius_km = 6371.0

    # Convert degrees to radians
    source_lat = radians(location.source_latitude)
    source_lon = radians(location.source_longitude)

    destination_lat = radians(location.destination_latitude)
    destination_lon = radians(location.destination_longitude)

    # Difference between coordinates
    delta_lat = destination_lat - source_lat
    delta_lon = destination_lon - source_lon

    # Haversine formula
    a = (
        sin(delta_lat / 2) ** 2
        + cos(source_lat)
        * cos(destination_lat)
        * sin(delta_lon / 2) ** 2
    )

    c = 2 * atan2(sqrt(a), sqrt(1 - a))

    distance_km = earth_radius_km * c

    return {
        "distance_km": round(distance_km, 2)
    }