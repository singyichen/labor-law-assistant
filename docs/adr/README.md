# Architecture Decision Records (ADR)

This directory contains Architecture Decision Records for the Labor Law Assistant project.

## What is an ADR?

An ADR captures an important architectural decision along with its context and consequences.

## Format

Each ADR follows this structure:

- **Status**: Accepted / Proposed / Deprecated / Superseded
- **Context**: The forces at play, including technical, business, and project constraints.
- **Decision**: The change we are making.
- **Consequences**: What becomes easier or harder as a result.

## Index

| ADR | Title | Status | Date |
|-----|-------|--------|------|
| [001](001-package-manager-uv.md) | Use uv as package manager | Accepted | 2025-02-13 |
| [002](002-web-framework-fastapi.md) | Use FastAPI as web framework | Accepted | 2025-02-13 |
| [003](003-orm-sqlalchemy.md) | Use SQLAlchemy 2.0 as ORM | Accepted | 2025-02-13 |
| [004](004-frontend-nextjs.md) | Use Next.js as frontend framework | Accepted | 2025-02-13 |
| [005](005-caching-redis.md) | Use Redis as caching layer | Accepted | 2025-02-13 |
| [006](006-observability-stack.md) | Observability stack (Sentry, structlog, Prometheus, Grafana, OpenTelemetry) | Accepted | 2025-02-13 |
| [007](007-embedding-model.md) | Use OpenAI text-embedding-3 as embedding model | Accepted | 2025-02-13 |
| [008](008-llm-provider.md) | Use Anthropic Claude as primary LLM provider | Accepted | 2025-02-13 |
| [009](009-authentication-strategy.md) | Anonymous-first authentication with optional OAuth2 | Accepted | 2025-02-13 |
