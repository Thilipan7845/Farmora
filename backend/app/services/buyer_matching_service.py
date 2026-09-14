from typing import Any
from math import radians, sin, cos, sqrt, atan2

from app.database.supabase_client import supabase


# ============================================================
# DISTANCE CALCULATION
# ============================================================

def calculate_distance_km(
    latitude_1: float,
    longitude_1: float,
    latitude_2: float,
    longitude_2: float,
) -> float:

    earth_radius_km = 6371.0

    lat1 = radians(latitude_1)
    lon1 = radians(longitude_1)

    lat2 = radians(latitude_2)
    lon2 = radians(longitude_2)

    delta_lat = lat2 - lat1
    delta_lon = lon2 - lon1

    a = (
        sin(delta_lat / 2) ** 2
        + cos(lat1)
        * cos(lat2)
        * sin(delta_lon / 2) ** 2
    )

    c = 2 * atan2(
        sqrt(a),
        sqrt(1 - a),
    )

    return round(
        earth_radius_km * c,
        2,
    )


# ============================================================
# LOCATION SCORE
# ============================================================

def calculate_location_score(
    crop_lot: dict,
    farmer: dict | None,
    buyer: dict,
    preferred_location: str | None,
) -> tuple[float, float | None, str]:

    farmer_latitude = crop_lot.get("latitude")
    farmer_longitude = crop_lot.get("longitude")

    if farmer_latitude is None and farmer:
        farmer_latitude = farmer.get("latitude")

    if farmer_longitude is None and farmer:
        farmer_longitude = farmer.get("longitude")

    buyer_latitude = buyer.get("latitude")
    buyer_longitude = buyer.get("longitude")


    if (
        farmer_latitude is not None
        and farmer_longitude is not None
        and buyer_latitude is not None
        and buyer_longitude is not None
    ):

        distance_km = calculate_distance_km(
            float(farmer_latitude),
            float(farmer_longitude),
            float(buyer_latitude),
            float(buyer_longitude),
        )

        if distance_km <= 25:
            return (
                15.0,
                distance_km,
                "Buyer is within 25 km of the farmer",
            )

        if distance_km <= 50:
            return (
                13.0,
                distance_km,
                "Buyer is within 50 km of the farmer",
            )

        if distance_km <= 100:
            return (
                10.0,
                distance_km,
                "Buyer is within 100 km of the farmer",
            )

        if distance_km <= 250:
            return (
                7.0,
                distance_km,
                "Buyer is within 250 km of the farmer",
            )

        return (
            4.0,
            distance_km,
            "Buyer is located farther away",
        )


    return (
        10.0,
        None,
        "Location comparison unavailable",
    )


# ============================================================
# BUYER MATCHING
# ============================================================

def match_buyers_for_crop_lot(
    crop_lot_id: str | None = None,
    bulk_lot_id: str | None = None,
    farmer_id: str | None = None,
) -> dict[str, Any]:


    # --------------------------------------------------------
    # GET CROP LOT / BULK LOT
    # --------------------------------------------------------

    if bulk_lot_id:

        lot_result = (
            supabase
            .table("bulk_lots")
            .select("*")
            .eq("id", bulk_lot_id)
            .single()
            .execute()
        )

        if not lot_result.data:
            raise ValueError(
                "Bulk lot not found"
            )

        crop_lot = lot_result.data


    elif crop_lot_id:

        lot_result = (
            supabase
            .table("crop_lots")
            .select("*")
            .eq("id", crop_lot_id)
            .eq("farmer_id", farmer_id)
            .single()
            .execute()
        )

        if not lot_result.data:
            raise ValueError(
                "Crop lot not found"
            )

        crop_lot = lot_result.data


    else:

        raise ValueError(
            "crop_lot_id or bulk_lot_id required"
        )


    crop_name = crop_lot["crop_name"]

    available_quantity = float(
        crop_lot["quantity"]
    )

    crop_quality = crop_lot.get(
        "quality_grade"
    )

    expected_price = crop_lot.get(
        "expected_price"
    )


    if expected_price is not None:
        expected_price = float(
            expected_price
        )


    # --------------------------------------------------------
    # FARMER PROFILE
    # --------------------------------------------------------

    farmer = None

    if farmer_id:

        farmer_result = (
            supabase
            .table("farmers")
            .select("*")
            .eq("id", farmer_id)
            .single()
            .execute()
        )

        farmer = farmer_result.data


    # --------------------------------------------------------
    # BUYER REQUIREMENTS
    # --------------------------------------------------------

    requirements_result = (
        supabase
        .table("buyer_requirements")
        .select("*")
        .eq("crop_name", crop_name)
        .eq("status", "active")
        .execute()
    )

    requirements = requirements_result.data


    if not requirements:

        return {
            "crop_lot_id": crop_lot_id,
            "bulk_lot_id": bulk_lot_id,
            "crop_name": crop_name,
            "available_quantity": available_quantity,
            "matches": [],
        }


    buyer_ids = list(
        {
            item["buyer_id"]
            for item in requirements
        }
    )


    buyers_result = (
        supabase
        .table("buyers")
        .select("*")
        .in_("id", buyer_ids)
        .execute()
    )


    buyers = {
        buyer["id"]: buyer
        for buyer in buyers_result.data
    }


    matches = []


    for requirement in requirements:

        buyer = buyers.get(
            requirement["buyer_id"]
        )

        if not buyer:
            continue


        required_quantity = float(
            requirement["quantity"]
        )


        score = 40.0

        reasons = [
            "Crop matches buyer requirement"
        ]


        # Quantity

        if available_quantity >= required_quantity:

            score += 20

            reasons.append(
                "Quantity requirement satisfied"
            )

        else:

            score += (
                20 *
                (
                    available_quantity /
                    required_quantity
                )
            )


        # Quality

        requirement_quality = (
            requirement.get(
                "quality_grade"
            )
        )


        if (
            requirement_quality
            and crop_quality
            and requirement_quality.lower()
            ==
            crop_quality.lower()
        ):

            score += 15

            reasons.append(
                "Quality grade matches"
            )


        else:

            score += 10


        # Price

        score += 5


        # Location

        (
            location_score,
            distance_km,
            location_reason,
        ) = calculate_location_score(
            crop_lot,
            farmer,
            buyer,
            requirement.get(
                "preferred_location"
            ),
        )


        score += location_score

        reasons.append(
            location_reason
        )


        score = min(
            round(score, 2),
            100
        )


        matches.append(
            {
                "buyer_id":
                    buyer["id"],

                "company_name":
                    buyer.get(
                        "company_name"
                    ),

                "crop_name":
                    crop_name,

                "required_quantity":
                    required_quantity,

                "available_quantity":
                    available_quantity,

                "quality_grade":
                    requirement_quality,

                "distance_km":
                    distance_km,

                "match_score":
                    score,

                "match_reasons":
                    reasons,
            }
        )


    matches.sort(
        key=lambda x:
            x["match_score"],
        reverse=True,
    )


    return {
        "crop_lot_id": crop_lot_id,
        "bulk_lot_id": bulk_lot_id,
        "crop_name": crop_name,
        "available_quantity": available_quantity,
        "matches": matches,
    }