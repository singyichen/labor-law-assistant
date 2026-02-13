"""FastAPI application entry point."""

from fastapi import FastAPI

from app.api.routes.health import router as health_router
from app.config import settings

app = FastAPI(
    title="Labor Law Assistant API",
    description="Taiwan Labor Law Query Assistant",
    version="0.1.0",
    debug=settings.app_debug,
)

app.include_router(health_router)
