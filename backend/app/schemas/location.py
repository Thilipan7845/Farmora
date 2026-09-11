from pydantic import BaseModel


# ============================================================
# LOCATION DISTANCE
# ============================================================

class LocationDistanceRequest(BaseModel):
    source_latitude: float
    source_longitude: float
    destination_latitude: float
    destination_longitude: float


class LocationDistanceResponse(BaseModel):
    distance_km: float
