from typing import Any
from math import radians, sin, cos, sqrt, atan2

from app.database.supabase_client import supabase


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

    # --------------------------------------------------------
    # DISTANCE-BASED MATCHING
    # --------------------------------------------------------

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

        if distance_km <= 500:
            return (
                4.0,
                distance_km,
                "Buyer is within 500 km of the farmer",
            )

        return (
            1.0,
            distance_km,
            "Buyer is located farther away",
        )

    # --------------------------------------------------------
    # TEXT LOCATION MATCHING
    # --------------------------------------------------------

    if preferred_location:

        location_values = []

        if farmer:
            for field in [
                "address",
                "village",
                "district",
                "state",
            ]:
                value = farmer.get(field)

                if value:
                    location_values.append(
                        str(value).lower()
                    )

        for value in location_values:

            if preferred_location.lower() in value:

                return (
                    15.0,
                    None,
                    "Buyer prefers the farmer's location",
                )

        return (
            5.0,
            None,
            "Buyer has a preferred location but exact location could not be confirmed",
        )

    return (
        10.0,
        None,
        "No specific buyer location preference",
    )


def match_buyers_for_crop_lot(
    crop_lot_id: str,
    farmer_id: str,
) -> dict[str, Any]:

    # --------------------------------------------------------
    # GET CROP LOT
    # --------------------------------------------------------

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
        raise ValueError("Crop lot not found")

    crop_lot = lot_result.data

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
        expected_price = float(expected_price)

    # --------------------------------------------------------
    # GET FARMER PROFILE
    # --------------------------------------------------------

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
    # GET ACTIVE BUYER REQUIREMENTS
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
            "crop_name": crop_name,
            "available_quantity": available_quantity,
            "matches": [],
        }

    # --------------------------------------------------------
    # GET BUYER IDS
    # --------------------------------------------------------

    buyer_ids = list(
        {
            requirement["buyer_id"]
            for requirement in requirements
        }
    )

    if not buyer_ids:

        return {
            "crop_lot_id": crop_lot_id,
            "crop_name": crop_name,
            "available_quantity": available_quantity,
            "matches": [],
        }

    # --------------------------------------------------------
    # GET BUYER PROFILES
    # --------------------------------------------------------

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

    # --------------------------------------------------------
    # CALCULATE MATCHES
    # --------------------------------------------------------

    matches = []

    for requirement in requirements:

        buyer_id = requirement["buyer_id"]

        buyer = buyers.get(buyer_id)

        if not buyer:
            continue

        required_quantity = float(
            requirement["quantity"]
        )

        requirement_quality = (
            requirement.get("quality_grade")
        )

        min_price = requirement.get(
            "min_price"
        )

        max_price = requirement.get(
            "max_price"
        )

        if min_price is not None:
            min_price = float(min_price)

        if max_price is not None:
            max_price = float(max_price)

        preferred_location = requirement.get(
            "preferred_location"
        )

        delivery_required = bool(
            requirement.get(
                "delivery_required",
                False,
            )
        )

        delivery_location = requirement.get(
            "delivery_location"
        )

        # ----------------------------------------------------
        # SCORE
        # ----------------------------------------------------

        score = 0.0

        reasons = []

        # ----------------------------------------------------
        # 1. CROP MATCH — 40 POINTS
        # ----------------------------------------------------

        score += 40.0

        reasons.append(
            "Crop matches buyer requirement"
        )

        # ----------------------------------------------------
        # 2. QUANTITY MATCH — 20 POINTS
        # ----------------------------------------------------

        if available_quantity >= required_quantity:

            score += 20.0

            reasons.append(
                "Buyer can purchase the full available quantity"
            )

        else:

            quantity_ratio = (
                available_quantity
                / required_quantity
            )

            quantity_score = (
                20.0
                * min(
                    quantity_ratio,
                    1.0,
                )
            )

            score += quantity_score

            reasons.append(
                "Available quantity is lower than buyer requirement"
            )

        # ----------------------------------------------------
        # 3. QUALITY MATCH — 15 POINTS
        # ----------------------------------------------------

        if (
            not requirement_quality
            or not crop_quality
        ):

            score += 10.0

            reasons.append(
                "Quality requirement is not fully specified"
            )

        elif (
            requirement_quality.lower()
            == crop_quality.lower()
        ):

            score += 15.0

            reasons.append(
                "Quality grade matches"
            )

        else:

            reasons.append(
                "Quality grade does not match"
            )

        # ----------------------------------------------------
        # 4. PRICE COMPATIBILITY — 10 POINTS
        # ----------------------------------------------------

        price_score = 0.0

        if expected_price is not None:

            if (
                min_price is not None
                and max_price is not None
            ):

                if (
                    min_price
                    <= expected_price
                    <= max_price
                ):

                    price_score = 10.0

                    reasons.append(
                        "Farmer's expected price is within buyer's price range"
                    )

                elif expected_price < min_price:

                    price_score = 7.0

                    reasons.append(
                        "Farmer's expected price is below buyer's range"
                    )

                else:

                    price_score = 3.0

                    reasons.append(
                        "Farmer's expected price is above buyer's range"
                    )

            elif min_price is not None:

                if expected_price >= min_price:

                    price_score = 10.0

                    reasons.append(
                        "Farmer's expected price meets buyer's minimum price"
                    )

            elif max_price is not None:

                if expected_price <= max_price:

                    price_score = 10.0

                    reasons.append(
                        "Farmer's expected price is within buyer's maximum price"
                    )

            else:

                price_score = 5.0

                reasons.append(
                    "Buyer has no price range specified"
                )

        else:

            price_score = 5.0

            reasons.append(
                "Farmer has not specified an expected price"
            )

        score += price_score

        # ----------------------------------------------------
        # 5. LOCATION — 15 POINTS
        # ----------------------------------------------------

        (
            location_score,
            distance_km,
            location_reason,
        ) = calculate_location_score(
            crop_lot=crop_lot,
            farmer=farmer,
            buyer=buyer,
            preferred_location=preferred_location,
        )

        score += location_score

        reasons.append(location_reason)

        # ----------------------------------------------------
        # DELIVERY INFORMATION
        # ----------------------------------------------------

        if delivery_required:

            reasons.append(
                f"Buyer requires delivery to {delivery_location or 'specified location'}"
            )

        else:

            reasons.append(
                "Buyer does not require delivery"
            )

        # ----------------------------------------------------
        # FINAL SCORE
        # ----------------------------------------------------

        score = min(
            round(score, 2),
            100.0,
        )

        matches.append(
            {
                "buyer_id": buyer_id,
                "company_name": buyer.get(
                    "company_name"
                ),
                "business_type": buyer.get(
                    "business_type"
                ),
                "crop_name": crop_name,
                "required_quantity": required_quantity,
                "available_quantity": available_quantity,
                "quality_grade": requirement_quality,
                "preferred_location": preferred_location,
                "delivery_required": delivery_required,
                "delivery_location": delivery_location,
                "buyer_min_price": min_price,
                "buyer_max_price": max_price,
                "farmer_expected_price": expected_price,
                "distance_km": distance_km,
                "match_score": score,
                "match_reasons": reasons,
            }
        )

    # --------------------------------------------------------
    # BEST MATCH FIRST
    # --------------------------------------------------------

    matches.sort(
        key=lambda item: item["match_score"],
        reverse=True,
    )

    return {
        "crop_lot_id": crop_lot_id,
        "crop_name": crop_name,
        "available_quantity": available_quantity,
        "matches": matches,
    }