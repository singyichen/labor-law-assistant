"""Global exception handling middleware for the FastAPI application."""

import logging

from fastapi import Request, Response
from starlette.middleware.base import BaseHTTPMiddleware, RequestResponseEndpoint
from starlette.responses import JSONResponse

from app.config import settings

logger = logging.getLogger(__name__)


class ExceptionHandlerMiddleware(BaseHTTPMiddleware):
    """Middleware that catches unhandled exceptions and returns safe JSON.

    In debug mode, includes the error message for development convenience.
    In production, returns a generic message to avoid leaking internals.
    """

    async def dispatch(
        self,
        request: Request,
        call_next: RequestResponseEndpoint,
    ) -> Response:
        """Process request and catch any unhandled exceptions.

        Args:
            request: The incoming HTTP request.
            call_next: The next middleware or route handler.

        Returns:
            Response: The normal response, or a 500 JSON error response.
        """
        try:
            return await call_next(request)
        except Exception as exc:
            logger.error(
                "Unhandled exception on %s %s: %s",
                request.method,
                request.url.path,
                exc,
                exc_info=True,
            )

            detail = str(exc) if settings.app_debug else "Internal server error"

            return JSONResponse(
                status_code=500,
                content={"detail": detail},
            )
