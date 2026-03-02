# ADR-003: Use SQLAlchemy 2.0 as ORM

**Status**: Accepted
**Date**: 2025-02-13

## Context

The project needs an ORM for PostgreSQL database access. The system will store labor law articles, user query records, and RAG pipeline metadata (including vector embeddings for similarity search). Key requirements:

- Async support for FastAPI integration.
- PostgreSQL extension support (pgvector for RAG vector search).
- Compatibility with mypy strict mode.
- Mature migration tooling.
- Pure Python toolchain (consistent with uv, pytest, ruff ecosystem).

Two candidates were evaluated:

### Prisma Client Python
- Non-official community project maintained by a single developer.
- Requires Node.js runtime for Prisma CLI and migrations.
- Does not support PostgreSQL extensions (pgvector, pg_trgm).
- Limited mypy strict mode compatibility.
- ~2.2k GitHub stars, lacks enterprise-level production cases.

### SQLAlchemy 2.0
- Official project with 20+ years of history, maintained by a dedicated team.
- Full async support via `asyncpg` driver.
- pgvector support via `pgvector-python` extension.
- Complete mypy strict support with `Mapped` type annotations.
- Alembic for migrations (pure Python, no external runtime needed).
- Used in production by Dropbox, Reddit, Yelp, and many others.

## Decision

Use **SQLAlchemy 2.0** with **asyncpg** driver and **Alembic** for migrations.

Supporting libraries:
- `asyncpg`: High-performance async PostgreSQL driver.
- `alembic`: Database migration tool with autogenerate support.
- `pgvector`: Vector similarity search extension for RAG pipeline.

## Consequences

### Easier
- pgvector integration enables vector similarity search directly in PostgreSQL, critical for the RAG pipeline's dual-source retrieval (legal articles + internal documents).
- Alembic provides pure Python migrations, consistent with the project toolchain.
- Extensive documentation, tutorials, and community support.
- FastAPI official documentation uses SQLAlchemy as the default ORM.
- `Mapped` type annotations provide full mypy strict compatibility.
- Mature connection pooling and performance optimization tools.

### Harder
- Steeper learning curve compared to Prisma's declarative API.
- Requires manual model definitions (no schema auto-generation).
- More boilerplate code for basic CRUD operations.
- Need to manually keep Pydantic schemas and SQLAlchemy models in sync.
