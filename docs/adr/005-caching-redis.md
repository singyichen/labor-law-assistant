# ADR-005: Use Redis as Caching Layer

**Status**: Accepted
**Date**: 2025-02-13

## Context

The system uses a RAG pipeline that calls Anthropic Claude API for every query. Without caching, each query incurs LLM API costs ($15/1M input tokens, $75/1M output tokens) and latency (~3-5 seconds). The system also performs vector similarity searches (pgvector) and retrieves legal article content from PostgreSQL.

Key observations:
- The system is **read-heavy** — legal content changes infrequently (only on law amendments).
- Many user queries are semantically identical ("How to calculate overtime pay?").
- Estimated cache hit rate: 70-80% for LLM responses, 90%+ for legal articles.
- Caching LLM responses at 70% hit rate saves ~60-70% of API costs.

### Candidates Evaluated

#### Redis
- Rich data structures (String, Hash, List, Set) — suitable for session management and complex cache patterns.
- Built-in persistence (RDB + AOF) and TTL management.
- Async Python support via `redis-py` with `hiredis`.
- FastAPI integration via `fastapi-cache2`.
- Can also serve as session store, reducing infrastructure complexity.

#### Memcached
- Simple key-value only — insufficient for session management (conversation history as List).
- No persistence — cache loss on restart.
- Multi-threaded but less feature-rich.

#### In-process Cache (lru_cache / cachetools)
- No shared state across multiple FastAPI workers.
- No persistence across restarts.
- Only suitable for pure function memoization.

### Vector Database Evaluation

Also evaluated whether a dedicated vector database (Pinecone, Qdrant, Weaviate) is needed:
- Current data volume: ~2,500 vectors (400 articles x 5 chunks + 100 docs x 3 chunks).
- pgvector with HNSW index handles <1M vectors efficiently (< 10ms Top-K search).
- A separate vector DB adds operational complexity and sync logic without benefit at this scale.

**Conclusion**: pgvector is sufficient. Reconsider when vector count exceeds 1M.

## Decision

Use **Redis** (single instance) as the application caching layer.

| Concern | Solution |
|---------|----------|
| Cache backend | Redis 7.x, single instance (2 GB), `allkeys-lru` eviction |
| Python client | `redis-py` with `hiredis` (async support) |
| FastAPI integration | `fastapi-cache2` with Redis backend |
| Session storage | Redis (same instance), conversation history with 24-hour TTL |
| Vector DB | Keep pgvector — no separate vector database needed |
| Full-text search | PostgreSQL built-in FTS + jieba segmentation — no Elasticsearch needed |
| Message queue | Not needed at MVP stage |

### Cache Layers and TTLs

| Data | TTL | Expected Hit Rate |
|------|----:|:-----------------:|
| LLM responses | 30 days | 70-80% |
| Legal article content | 7 days | 90%+ |
| Query embeddings | 90 days | 60-70% |
| Vector search results | 1 day | 50-60% |
| Session data | 24 hours | — |

### Scaling Path

| Phase | Trigger | Architecture |
|-------|---------|-------------|
| MVP | — | Single instance, 2 GB |
| Phase 2 | MAU > 50K | Redis Sentinel (1 master + 2 replicas) |
| Phase 3 | MAU > 500K | Redis Cluster (3 masters + 3 replicas) |

## Consequences

### Easier
- LLM API cost reduced by 60-70% through response caching.
- Response time for cached queries drops from ~5s to <50ms.
- Session management (conversation history) handled in Redis with automatic TTL expiry.
- Single Redis instance serves both cache and session storage — minimal infrastructure.
- pgvector stays in PostgreSQL — no cross-service sync needed for vector data.
- PostgreSQL FTS avoids adding Elasticsearch to the stack.

### Harder
- Adds Redis as an infrastructure dependency (must be available in all environments).
- Cache invalidation on law amendments requires careful implementation (must clear related LLM responses, not just article cache).
- Need graceful degradation logic when Redis is unavailable (fall back to direct DB/LLM calls).
- Two data stores to monitor (PostgreSQL + Redis).
