"""Health check route."""

from fastapi import APIRouter

from app.schemas.health import HealthResponse

router = APIRouter()


@router.get("/health", response_model=HealthResponse)
async def health_check() -> HealthResponse:
    """Return application health status.

    Used by load balancers and monitoring systems to verify service availability.

    Returns:
        HealthResponse: A response with status set to "ok".
    """
    return HealthResponse(status="ok")
