"""FastAPI application entry point."""

import logging
from collections.abc import AsyncGenerator
from contextlib import asynccontextmanager

from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from app.api.routes.health import router as health_router
from app.config import settings
from app.core.exceptions import ExceptionHandlerMiddleware

logger = logging.getLogger(__name__)


@asynccontextmanager
async def lifespan(app: FastAPI) -> AsyncGenerator[None, None]:
    """Handle application startup and shutdown events.

    Startup: initialize shared resources (DB pools, API clients).
    Shutdown: release resources gracefully.

    Args:
        app: The FastAPI application instance.

    Yields:
        None: Control is handed to the application between startup and shutdown.
    """
    logger.info("Starting up Labor Law Assistant API (%s)", settings.app_env)
    # TODO: Initialize database connection pool
    # TODO: Initialize vector DB client
    yield
    logger.info("Shutting down Labor Law Assistant API")
    # TODO: Close database connections
    # TODO: Close vector DB client


app = FastAPI(
    title="Labor Law Assistant API",
    description="Taiwan Labor Law Query Assistant",
    version="0.1.0",
    debug=settings.app_debug,
    lifespan=lifespan,
)

app.add_middleware(ExceptionHandlerMiddleware)
app.add_middleware(
    CORSMiddleware,
    allow_origins=settings.cors_origins,
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# Health check at root level (stable path for load balancers)
app.include_router(health_router)

# API v1 routes (business logic endpoints will be added here)
# Example: app.include_router(query_router, prefix="/api/v1")
