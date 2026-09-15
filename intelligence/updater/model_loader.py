import os
import joblib

MODEL_DIR = os.getenv("MODEL_DIR", "models")


CROP_MODELS = {
    "cotton": "cotton_price_model.joblib",
    "onion": "onion_price_model.joblib",
    "rice": "rice_price_model.joblib",
    "sugarcane": "sugarcane_price_model.joblib",
    "tomato": "tomato_price_model.joblib",
    "wheat": "wheat_price_model.joblib",
}


def load_model(crop):

    crop = crop.lower()

    if crop not in CROP_MODELS:
        raise Exception("Model not available for this crop")

    path = os.path.join(
        MODEL_DIR,
        CROP_MODELS[crop]
    )

    return joblib.load(path)