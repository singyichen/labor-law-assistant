"""Shared test fixtures.

Provides reusable fixtures for the test suite, including an async HTTP
client that communicates with the FastAPI app via ASGI transport.
"""

from collections.abc import AsyncGenerator

import httpx
import pytest
from fastapi import FastAPI

from app.main import app


@pytest.fixture
def test_app() -> FastAPI:
    """Provide the FastAPI application instance for testing.

    Returns:
        FastAPI: The application instance defined in app.main.
    """
    return app


@pytest.fixture
async def client(
    test_app: FastAPI,
) -> AsyncGenerator[httpx.AsyncClient, None]:
    """Provide an async HTTP client bound to the test application.

    Uses httpx.ASGITransport to send requests directly to the FastAPI app
    without starting a real server.

    Args:
        test_app: The FastAPI application fixture.

    Yields:
        httpx.AsyncClient: An async client for making test requests.
    """
    async with httpx.AsyncClient(
        transport=httpx.ASGITransport(app=test_app),
        base_url="http://testserver",
    ) as test_client:
        yield test_client
