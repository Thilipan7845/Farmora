from pydantic import BaseModel
from typing import Optional


class FPOProfileCreate(BaseModel):
    name: str
    registration_number: Optional[str] = None
    contact_person: Optional[str] = None
    phone: Optional[str] = None
    email: Optional[str] = None
    address: Optional[str] = None
    village: Optional[str] = None
    district: Optional[str] = None
    state: Optional[str] = None
    latitude: Optional[float] = None
    longitude: Optional[float] = None


class FPOProfileResponse(FPOProfileCreate):
    id: str
    user_id: str