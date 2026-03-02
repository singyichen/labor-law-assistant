"""Integration tests for global exception handler middleware."""

from collections.abc import AsyncGenerator

import httpx
import pytest
from fastapi import APIRouter, FastAPI

from app.core.exceptions import ExceptionHandlerMiddleware

error_router = APIRouter()


@error_router.get("/test-error")
async def trigger_error() -> None:
    """Raise an exception to test the global handler."""
    raise RuntimeError("Test error for exception handler")


@pytest.fixture
async def error_client() -> AsyncGenerator[httpx.AsyncClient, None]:
    """Provide an async HTTP client with ExceptionHandlerMiddleware.

    Creates an isolated FastAPI app with the exception handler middleware
    and a test route that raises an error.

    Yields:
        httpx.AsyncClient: Client bound to the test app.
    """
    test_app = FastAPI(debug=False)
    test_app.add_middleware(ExceptionHandlerMiddleware)
    test_app.include_router(error_router)

    async with httpx.AsyncClient(
        transport=httpx.ASGITransport(app=test_app),
        base_url="http://testserver",
    ) as client:
        yield client


@pytest.mark.asyncio
async def test_exception_handler_returns_500(
    error_client: httpx.AsyncClient,
) -> None:
    """Verify that unhandled exceptions return 500 with JSON body.

    Args:
        error_client: Async HTTP client with exception handler middleware.
    """
    response = await error_client.get("/test-error")

    assert response.status_code == 500
    data = response.json()
    assert "detail" in data
    # In debug mode (default), the actual error message is returned
    assert data["detail"] == "Test error for exception handler"
