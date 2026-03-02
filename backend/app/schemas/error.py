"""Error response schema."""

from pydantic import BaseModel


class ErrorResponse(BaseModel):
    """Standard error response model for API errors.

    Attributes:
        detail: Human-readable error description.
    """

    detail: str
