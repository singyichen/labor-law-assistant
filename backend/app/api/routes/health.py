"""Health check route."""

from fastapi import APIRouter

router = APIRouter()


@router.get("/health")
async def health_check() -> dict[str, str]:
    """Return application health status.

    Used by load balancers and monitoring systems to verify service availability.

    Returns:
        dict[str, str]: A dictionary with key "status" set to "ok".
    """
    return {"status": "ok"}
