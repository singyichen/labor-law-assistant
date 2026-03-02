"""Unit tests for application configuration."""

import pytest
from pydantic import SecretStr, ValidationError

from app.config import Settings


def test_default_settings() -> None:
    """Verify default settings values in development mode."""
    config = Settings(
        _env_file=None,  # type: ignore[call-arg]
    )

    assert config.app_env == "development"
    assert config.app_debug is True
    assert config.app_port == 8000
    assert config.log_level == "INFO"
    assert config.cors_origins == ["http://localhost:3000"]


def test_production_disables_debug() -> None:
    """Verify that production environment forces app_debug to False."""
    config = Settings(
        app_env="production",
        app_debug=True,
        anthropic_api_key=SecretStr("sk-ant-test-key"),
        _env_file=None,  # type: ignore[call-arg]
    )

    assert config.app_debug is False


def test_production_requires_api_key() -> None:
    """Verify that production raises ValueError without API key."""
    with pytest.raises(ValidationError, match="ANTHROPIC_API_KEY"):
        Settings(
            app_env="production",
            anthropic_api_key=SecretStr(""),
            _env_file=None,  # type: ignore[call-arg]
        )


def test_invalid_app_env_rejected() -> None:
    """Verify that invalid app_env values are rejected."""
    with pytest.raises(ValidationError):
        Settings(
            app_env="invalid_env",  # type: ignore[arg-type]
            _env_file=None,  # type: ignore[call-arg]
        )
