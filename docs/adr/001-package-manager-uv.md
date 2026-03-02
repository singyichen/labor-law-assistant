# ADR-001: Use uv as Package Manager

**Status**: Accepted
**Date**: 2025-02-13

## Context

The project needs a Python package manager for dependency management, virtual environment creation, and development workflow tooling. The main candidates are:

- **pip + venv**: Standard library tooling, widely used but slow and lacking lockfile support.
- **poetry**: Popular all-in-one tool, but slower resolution and complex pyproject.toml format.
- **uv**: Rust-based, extremely fast, pip-compatible, supports PEP 621 pyproject.toml natively.

Key requirements:
- Fast dependency resolution and installation (developer experience).
- Lockfile support for reproducible builds.
- Compatibility with PEP 621 `pyproject.toml` standard.
- Support for dependency groups (dev, test, production).

## Decision

Use **uv** as the project's package manager.

## Consequences

### Easier
- Dependency resolution is 10-100x faster than pip/poetry.
- Native PEP 621 support — standard `pyproject.toml` format, no vendor lock-in.
- `uv.lock` provides reproducible builds.
- `uv run` simplifies running tools without activating venv.
- Dependency groups via `[dependency-groups]` in pyproject.toml.

### Harder
- Team members need to install uv (`curl -LsSf https://astral.sh/uv/install.sh | sh`).
- Relatively newer tool (2024), less established than pip/poetry.
- Some CI environments may need explicit uv setup (`astral-sh/setup-uv` GitHub Action).
