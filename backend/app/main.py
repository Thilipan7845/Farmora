from fastapi import FastAPI
from app.database.supabase_client import supabase
from app.routes import health, auth, farmers, buyers, fpos, crop_lots, market, offers, orders, logistics, payments, support, disputes, notifications, location
app = FastAPI(title="Farmora API")


app.include_router(health.router, prefix="/api")
app.include_router(auth.router, prefix="/api/auth")
app.include_router(farmers.router, prefix="/api/farmers")
app.include_router(buyers.router, prefix="/api/buyers")
app.include_router(fpos.router, prefix="/api/fpos")
app.include_router(crop_lots.router, prefix="/api/crop-lots")
app.include_router(market.router, prefix="/api/market")
app.include_router(offers.router, prefix="/api/offers")
app.include_router(orders.router, prefix="/api/orders")
app.include_router(logistics.router, prefix="/api/logistics")
app.include_router(payments.router, prefix="/api/payments")
app.include_router(support.router, prefix="/api/support")
app.include_router(disputes.router, prefix="/api/disputes")
app.include_router(notifications.router, prefix="/api/notifications")
app.include_router(location.router, prefix="/api/location")

@app.get("/")
def root():
    return {"message": "Farmora API is running"}