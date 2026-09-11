CROP_PROFILES = {

    "cotton": {
        "shelf_life_days": 270,
        "storage_risk": "LOW",
        "cold_storage_required": False
    },

    "rice": {
        "shelf_life_days": 180,
        "storage_risk": "LOW",
        "cold_storage_required": False
    },

    "wheat": {
        "shelf_life_days": 180,
        "storage_risk": "LOW",
        "cold_storage_required": False
    },

    "sugarcane": {
        "shelf_life_days": 3,
        "storage_risk": "HIGH",
        "cold_storage_required": False
    },

    "onion": {
        "shelf_life_days": 90,
        "storage_risk": "MEDIUM",
        "cold_storage_required": False
    },

    "tomato": {
        "shelf_life_days": 7,
        "storage_risk": "HIGH",
        "cold_storage_required": True
    }

}


def get_crop_profile(crop):

    return CROP_PROFILES.get(
        crop.lower(),
        {
            "shelf_life_days": 30,
            "storage_risk": "MEDIUM",
            "cold_storage_required": False
        }
    )