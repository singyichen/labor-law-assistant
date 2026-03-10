# ADR-002: Use FastAPI as Web Framework

**Status**: Accepted
**Date**: 2025-02-13

## Context

The project needs a Python web framework for building the backend API. The system will serve a labor law query assistant with RAG (Retrieval-Augmented Generation) pipeline. Key requirements:

- Async support for concurrent LLM API calls and database queries.
- Strong typing and validation (Pydantic integration).
- Auto-generated API documentation (OpenAPI/Swagger).
- Active community and ecosystem.

Main candidates:
- **FastAPI**: Modern async framework with Pydantic integration and auto docs.
- **Django + DRF**: Mature full-stack framework, but heavier and less async-native.
- **Flask**: Lightweight but lacks native async, typing, and validation.

## Decision

Use **FastAPI** as the web framework.

## Consequences

### Easier
- Native async/await for concurrent I/O (LLM calls, DB queries, vector search).
- Built-in Pydantic validation for request/response schemas.
- Auto-generated OpenAPI docs at `/docs` and `/redoc`.
- First-class dependency injection system.
- Strong typing works well with mypy strict mode.
- Large ecosystem of middleware (CORS, auth, rate limiting).

### Harder
- No built-in admin interface (unlike Django).
- Need to assemble components manually (ORM, auth, migrations).
- Requires understanding of async Python patterns.

## Referenced by

- [PRD README.md](../prd/README.md) — Appendix B Technology Stack
- [Epic 01: Chat Interface](../prd/epics/01-chat-interface.md) — Technical Dependencies
