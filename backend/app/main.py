from fastapi import FastAPI
from app.database.supabase_client import supabase
from app.routes import health, auth, farmers, buyers, fpos

app = FastAPI(title="Farmora API")


app.include_router(health.router, prefix="/api")
app.include_router(auth.router, prefix="/api/auth")
app.include_router(farmers.router, prefix="/api/farmers")
app.include_router(buyers.router, prefix="/api/buyers")
app.include_router(fpos.router, prefix="/api/fpos")

@app.get("/")
def root():
    return {"message": "Farmora API is running"}