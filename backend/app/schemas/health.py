"""Health check response schema."""

from pydantic import BaseModel


class HealthResponse(BaseModel):
    """Response model for the health check endpoint.

    Attributes:
        status: Service health indicator, always "ok" when reachable.
    """

    status: str
