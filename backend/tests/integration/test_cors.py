"""Integration tests for CORS middleware."""

import httpx
import pytest


@pytest.mark.asyncio
async def test_cors_allows_configured_origin(client: httpx.AsyncClient) -> None:
    """Verify that CORS headers are present for allowed origins.

    Args:
        client: Async HTTP client fixture bound to the test app.
    """
    response = await client.options(
        "/health",
        headers={
            "Origin": "http://localhost:3000",
            "Access-Control-Request-Method": "GET",
        },
    )

    assert (
        response.headers.get("access-control-allow-origin") == "http://localhost:3000"
    )


@pytest.mark.asyncio
async def test_cors_blocks_unknown_origin(client: httpx.AsyncClient) -> None:
    """Verify that CORS does not allow unknown origins.

    Args:
        client: Async HTTP client fixture bound to the test app.
    """
    response = await client.options(
        "/health",
        headers={
            "Origin": "http://evil-site.com",
            "Access-Control-Request-Method": "GET",
        },
    )

    assert response.headers.get("access-control-allow-origin") != "http://evil-site.com"
