# ADR-007: Use OpenAI text-embedding-3 as Embedding Model

**Status**: Accepted
**Date**: 2025-02-13

## Context

The RAG pipeline requires an embedding model to convert user queries and legal articles into vectors for similarity search via pgvector. The system processes Traditional Chinese (zh-TW) legal text with formal terminology, while user queries are typically in colloquial Chinese.

Key requirements:
- High-quality Traditional Chinese understanding (formal legal text + colloquial queries).
- Compatible with pgvector HNSW index in PostgreSQL.
- Low operational overhead for a small team (1-3 developers).
- Cost-effective at MVP scale (~5,000 queries/month).

Data volume: ~2,500 vectors (400 law articles x 5 chunks + 100 FAQ docs x 3 chunks).

### Candidates Evaluated

| Model | zh-TW Quality | Dimensions | Cost (per 1M tokens) | Self-hosted |
|-------|:------------:|:----------:|:--------------------:|:-----------:|
| **OpenAI text-embedding-3-large** | 9.0/10 | 256-3072 (configurable) | $0.13 | No |
| **OpenAI text-embedding-3-small** | 8.5/10 | 512 | $0.02 | No |
| Cohere embed-multilingual-v3.0 | 9.5/10 | 1024 | $0.10 | No |
| Voyage voyage-multilingual-2 | 8.0/10 | 1024 | $0.12 | No |
| bge-m3 (open-source) | 8.5/10 | 1024 | Free | Yes (GPU needed) |
| multilingual-e5-large (open-source) | 7.5/10 | 1024 | Free | Yes (GPU needed) |

**Open-source models rejected**: Self-hosting requires GPU infrastructure (~$60-2,234/month) vs API cost of <$1/month at current scale. Not cost-effective for a small team.

**Cohere noted as strong alternative**: Best multilingual support, but smaller ecosystem and slightly higher cost. Consider if expanding to Southeast Asian languages.

## Decision

Use **OpenAI `text-embedding-3-large`** at **1536 dimensions** as the primary embedding model.

| Concern | Decision |
|---------|----------|
| Primary model | `text-embedding-3-large` (1536 dims) |
| MVP alternative | `text-embedding-3-small` (512 dims) for faster validation |
| Fallback provider | Cohere `embed-multilingual-v3.0` (if OpenAI unavailable) |
| Dimension | 1536 (optimal balance of accuracy vs pgvector performance) |
| Caching | Redis with 90-day TTL for query embeddings |
| pgvector index | HNSW with m=16, ef_construction=64 |

### Cost Projection

| Phase | Queries/month | Cache Hit Rate | API Cost/month |
|-------|:------------:|:--------------:|:--------------:|
| MVP | 5,000 | 50% | < $0.01 |
| Growth | 50,000 | 80% | < $0.03 |
| Scale | 500,000 | 85% | < $0.10 |

### Migration Path

```
Start: text-embedding-3-small (MVP validation)
  |
  +-- If Recall@5 < 85% --> Upgrade to text-embedding-3-large
  +-- If expanding to SEA languages --> Evaluate Cohere
  +-- If volume > 1M/month --> Consider self-hosted bge-m3
```

## Consequences

### Easier
- Embedding cost is negligible (< $1/month even at scale) — not a cost concern.
- Configurable dimensions allow starting at 512 (small) and upgrading to 1536 (large) without changing infrastructure.
- Zero operational overhead — fully managed API, no GPU infrastructure.
- pgvector HNSW index at 1536 dims delivers < 30ms P95 query latency for 2,500 vectors.
- Redis caching (90-day TTL) reduces API calls by 80%+.

### Harder
- Depends on OpenAI API availability (mitigated by Cohere fallback + Redis cache).
- Upgrading from small to large requires re-embedding all vectors (one-time migration ~$0.10).
- Using a different provider than the LLM (Anthropic) means two API vendor dependencies.
- Must ensure OpenAI data processing terms comply with legal industry requirements.

## Referenced by

- [PRD README.md](../prd/README.md) — §8 Tech Stack, Appendix B ADR Summary
- [Epic 02: RAG Legal Search](../prd/epics/02-rag-legal-search.md) — Technical Dependencies, RAG Pipeline
