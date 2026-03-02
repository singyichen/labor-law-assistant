"""Application configuration via environment variables."""

import logging
from typing import Literal

from pydantic import SecretStr, model_validator
from pydantic_settings import BaseSettings


class Settings(BaseSettings):
    """Application settings loaded from environment variables.

    Loads configuration from environment variables and .env file.
    Sensitive values use SecretStr to prevent accidental log exposure.

    Attributes:
        app_env: Runtime environment (development / staging / production).
        app_debug: Debug mode flag. Automatically disabled in production.
        app_port: HTTP server port number.
        log_level: Logging level (DEBUG / INFO / WARNING / ERROR / CRITICAL).
        cors_origins: Allowed CORS origins for frontend requests.
        anthropic_api_key: Anthropic API key for Claude integration.
            Required in production; optional in development.
    """

    app_env: Literal["development", "staging", "production"] = "development"
    app_debug: bool = True
    app_port: int = 8000
    log_level: str = "INFO"

    cors_origins: list[str] = ["http://localhost:3000"]

    anthropic_api_key: SecretStr = SecretStr("")

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}

    @model_validator(mode="after")
    def validate_production_settings(self) -> "Settings":
        """Ensure critical settings are configured in production.

        Raises:
            ValueError: If ANTHROPIC_API_KEY is missing in production.

        Returns:
            Settings: The validated settings instance.
        """
        if self.app_env == "production":
            if not self.anthropic_api_key.get_secret_value():
                raise ValueError(
                    "ANTHROPIC_API_KEY must be set in production environment"
                )
            self.app_debug = False
        return self

    def setup_logging(self) -> None:
        """Configure logging based on log_level setting."""
        logging.basicConfig(
            level=getattr(logging, self.log_level.upper(), logging.INFO),
            format="%(asctime)s - %(name)s - %(levelname)s - %(message)s",
        )


settings = Settings()
settings.setup_logging()
