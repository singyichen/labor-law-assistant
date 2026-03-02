"""Integration tests for health check endpoint."""

import httpx
import pytest


@pytest.mark.asyncio
async def test_health_check_returns_ok(client: httpx.AsyncClient) -> None:
    """Verify that GET /health returns 200 with HealthResponse schema.

    Args:
        client: Async HTTP client fixture bound to the test app.
    """
    response = await client.get("/health")

    assert response.status_code == 200
    data = response.json()
    assert data == {"status": "ok"}
    assert "status" in data
