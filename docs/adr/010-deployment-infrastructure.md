# ADR-010: Deployment Infrastructure (Vercel, Fly.io, Neon, Upstash)

**Status**: Accepted
**Date**: 2025-02-13

## Context

The project needs a deployment strategy for a monorepo with separate backend (FastAPI) and frontend (Next.js 15) services, plus managed PostgreSQL (with pgvector) and Redis. The infrastructure must support Asia-Pacific users (primarily Taiwan) with acceptable latency.

Key constraints:
- Small team (1-3 developers) — minimal DevOps overhead.
- Budget-conscious MVP — prefer free tiers.
- Taiwan-based users — Asia-Pacific region availability matters.
- Legal content — reliability important but not enterprise-grade SLA.
- No dedicated DevOps engineer — deployment must be simple.

### Candidates Evaluated

#### Backend Hosting

| Provider | APAC Region | Docker | Cost (MVP) | Complexity |
|----------|:-----------:|:------:|:----------:|:----------:|
| **Fly.io** | Hong Kong | Native | $5/mo | Low |
| Railway | US only | Native | $5/mo | Lowest |
| Render | Singapore | Native | $7/mo | Low |
| AWS ECS | Tokyo | Native | $100+/mo | High |
| GCP Cloud Run | Taiwan | Native | $10/mo | Medium |

**Railway rejected**: No APAC region — unacceptable latency for Taiwan users.
**AWS ECS rejected**: Overkill complexity and cost for 1-3 person team at MVP stage.
**GCP Cloud Run**: Good latency (Taiwan region) but Cloud SQL for pgvector is expensive.

#### Frontend Hosting

| Provider | SSR Support | Edge | Preview Deploys | Cost (MVP) |
|----------|:-----------:|:----:|:---------------:|:----------:|
| **Vercel** | Native | Global | Automatic | $0 |
| Cloudflare Pages | Partial | Global | Yes | $0 |
| Self-hosted (Docker) | Full | No | Manual | $5+/mo |

**Vercel wins**: Next.js official platform, zero-config SSR, automatic preview deployments per PR, global CDN with Hong Kong PoP.

#### Database Hosting

| Provider | pgvector | Serverless | Cost (MVP) | PITR Backup |
|----------|:--------:|:----------:|:----------:|:-----------:|
| **Neon** | Yes | Auto-pause | $0 | 7-day |
| Supabase | Yes | No | $0 | Daily |
| AWS RDS | Yes | No | $30+/mo | Configurable |
| Railway Postgres | Yes | No | $5/mo | Manual |

**Neon wins**: Serverless auto-pause saves cost, native pgvector, Git-like branching for dev/staging, generous free tier (10GB storage).
**Trade-off**: US East region (~200ms latency), mitigated by Redis caching (70%+ cache hit rate).

#### Redis Hosting

| Provider | Serverless | Global Edge | Cost (MVP) | Persistence |
|----------|:----------:|:-----------:|:----------:|:-----------:|
| **Upstash** | Yes | Yes | $0 | Yes |
| Redis Cloud | No | No | $5/mo | Yes |
| Railway Redis | No | No | $5/mo | Configurable |
| AWS ElastiCache | No | No | $15+/mo | Yes |

**Upstash wins**: Pay-per-request pricing, global edge replication, REST API for serverless, free tier (10K commands/day).

## Decision

Use a **managed services stack** optimized for small team and MVP budget:

| Layer | Provider | Region | Cost (MVP) |
|-------|----------|--------|:----------:|
| Frontend | Vercel | Global CDN (HK PoP) | $0/mo |
| Backend | Fly.io | Hong Kong | $5/mo |
| Database | Neon Postgres | US East (cached via Redis) | $0/mo |
| Redis | Upstash | Global edge | $0/mo |
| CDN / DNS | Cloudflare | Global | $0/mo |
| CI/CD | GitHub Actions | — | $0/mo |
| **Total** | | | **~$6/mo** |

### Container Strategy

| Environment | Tool | Purpose |
|-------------|------|---------|
| Development | Docker Compose | Local PostgreSQL + Redis + FastAPI |
| Production | Multi-stage Dockerfile → Fly.io | Optimized image (~150MB) |
| Frontend prod | Vercel (managed) | No container needed |

**No Kubernetes**: Overkill for 1-3 person team. Fly.io provides auto-scaling. Docker images remain portable for future K8s migration if needed.

### CI/CD Pipeline

```
Push to branch
    |
    v
GitHub Actions: lint (ruff) + typecheck (mypy) + test (pytest)
    |
    v
Merge to main
    |
    +-- Vercel: auto-deploy frontend (automatic)
    +-- Fly.io: auto-deploy backend (via GitHub Actions)
    +-- Alembic: run database migrations (pre-deploy step)
```

- **Preview environments**: Vercel auto-creates per PR; Fly.io staging via manual trigger.
- **Secrets**: GitHub Secrets (CI) + Fly.io Secrets (prod) + Vercel Env Vars (frontend).
- **Docker image caching**: GitHub Actions cache for faster builds.

### Scaling Path

| Phase | MAU | Monthly Cost | Changes |
|-------|----:|:-----------:|---------|
| MVP | 100-1K | $6 | All free tiers + Fly.io minimal |
| Growth | 1K-10K | ~$172 | Neon Scale + Upstash Pro + Fly.io 2-4 instances |
| Scale | 10K-100K | ~$631 | Multi-region + dedicated compute |
| Enterprise | 100K+ | — | Evaluate AWS ECS + RDS Tokyo migration |

## Consequences

### Easier
- Total MVP infrastructure cost is ~$6/month — nearly free to start.
- No DevOps expertise required — all managed services with simple CLI deployment.
- Fly.io Hong Kong region provides <50ms latency for Taiwan users.
- Vercel handles Next.js SSR, CDN, preview deployments with zero configuration.
- Neon serverless auto-pause means no cost when idle (nights, weekends).
- Docker Compose for local dev ensures consistent environment across team.
- No vendor lock-in on backend — standard Docker images portable to any provider.
- GitHub Actions CI already exists — extending to CD is straightforward.

### Harder
- Neon database is in US East (~200ms latency) — relies on Redis caching to mask latency. Must monitor cache hit rate.
- Multiple providers to manage (Vercel, Fly.io, Neon, Upstash, Cloudflare) vs single cloud provider.
- Free tiers have limits — must monitor usage and plan upgrades before hitting limits.
- Fly.io requires credit card even for free tier allocation.
- Cross-provider debugging is harder than single-vendor (mitigated by Sentry + OpenTelemetry).
- Alembic migrations in CI/CD require careful handling (rollback strategy, migration testing).

## Referenced by

- [PRD README.md](../prd/README.md) — §8 Tech Stack, §8.4.1 Infrastructure Costs, Appendix B ADR Summary
- [Epic 02: RAG Legal Search](../prd/epics/02-rag-legal-search.md) — Related ADRs
- [Epic 05: Accessibility & i18n](../prd/epics/05-accessibility-i18n.md) — PWA Offline Scope, Related ADRs
- [Epic 07: Future Features](../prd/epics/07-future-features.md) — Technical Dependencies
- [Wireframes](../design/wireframes.md) — Cross-References
- [Testing Strategy](../testing/testing-strategy.md) — ADR References
