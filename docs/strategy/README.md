# Strategy Documentation

This directory contains strategic planning and architecture documents for the Labor Law Assistant project.

## Directory Structure

```
strategy/
├── README.md (this file)
├── deployment-infrastructure-strategy.md    # Comprehensive deployment plan
├── infrastructure-comparison-tables.md      # Provider comparison matrices
├── deployment-quick-start-guide.md          # Step-by-step implementation
├── dual-source-rag-strategy.md              # RAG architecture (existing)
└── product-strategy-recommendation.md       # Product roadmap (existing)
```

---

## Deployment Infrastructure Documents

### 1. [Deployment Infrastructure Strategy](./deployment-infrastructure-strategy.md)

**Purpose**: Complete infrastructure architecture and decision rationale

**Contents**:
- Executive summary with recommended stack
- Detailed provider analysis (hosting, database, Redis, CDN)
- Container strategy (Docker, Kubernetes vs serverless)
- CI/CD pipeline design
- Cost projections (MVP → Growth → Scale)
- Scaling path and migration strategies
- Implementation roadmap

**Best for**: Understanding WHY each technology was chosen

**Read this if**: You need to understand the overall architecture or make infrastructure decisions

---

### 2. [Infrastructure Comparison Tables](./infrastructure-comparison-tables.md)

**Purpose**: Data-driven comparison of all infrastructure options

**Contents**:
- Backend hosting comparison (Fly.io, Railway, Render, AWS, GCP)
- Database comparison (Neon, Supabase, RDS, Railway)
- Redis comparison (Upstash, Redis Cloud, ElastiCache)
- Frontend hosting comparison (Vercel, Cloudflare Pages, AWS)
- Monitoring tools comparison (Sentry, Datadog, Grafana)
- Total Cost of Ownership (TCO) analysis
- Weighted scoring decision matrix

**Best for**: Quickly comparing specific providers

**Read this if**: You want to see side-by-side feature and cost comparisons

---

### 3. [Deployment Quick Start Guide](./deployment-quick-start-guide.md)

**Purpose**: Step-by-step implementation checklist

**Contents**:
- Phase-by-phase deployment steps (10 phases)
- Account setup instructions
- Configuration file templates
- CLI commands for deployment
- Troubleshooting guide
- Smoke testing checklist
- Cost monitoring setup

**Best for**: Actually deploying the infrastructure

**Read this if**: You're ready to deploy and need exact commands to run

---

## Recommended Reading Order

### For Product/Business Stakeholders

1. [Deployment Infrastructure Strategy](./deployment-infrastructure-strategy.md) (Section 1: Executive Summary)
2. [Infrastructure Comparison Tables](./infrastructure-comparison-tables.md) (Section 6: TCO Analysis)
3. Skip implementation details

**Time**: 30 minutes

**Outcome**: Understand cost, scalability, and key decisions

---

### For Technical Team (Backend/DevOps)

1. [Deployment Infrastructure Strategy](./deployment-infrastructure-strategy.md) (Full read)
2. [Infrastructure Comparison Tables](./infrastructure-comparison-tables.md) (Sections 1-3: Backend, DB, Redis)
3. [Deployment Quick Start Guide](./deployment-quick-start-guide.md) (Phases 2-8)

**Time**: 3-4 hours

**Outcome**: Ready to deploy backend infrastructure

---

### For Frontend Developers

1. [Deployment Infrastructure Strategy](./deployment-infrastructure-strategy.md) (Section 3.2: Frontend Hosting)
2. [Infrastructure Comparison Tables](./infrastructure-comparison-tables.md) (Section 4: Frontend Comparison)
3. [Deployment Quick Start Guide](./deployment-quick-start-guide.md) (Phase 5: Frontend Deployment)

**Time**: 1-2 hours

**Outcome**: Ready to deploy frontend to Vercel

---

## Quick Reference

### Recommended Stack (MVP)

| Component | Technology | Cost | Region |
|-----------|-----------|------|--------|
| **Frontend** | Vercel | $0 (free tier) | Global CDN |
| **Backend** | Fly.io | $5/mo | Hong Kong |
| **Database** | Neon Postgres | $0 (free tier) | US East |
| **Redis** | Upstash | $0 (free tier) | Global Edge |
| **CDN** | Cloudflare | $0 (free tier) | Global |
| **Monitoring** | Sentry + Grafana + BetterStack | $0 (free tier) | - |
| **CI/CD** | GitHub Actions | $0 (public repo) | - |
| **TOTAL** | | **$5/mo** | |

### Key Decisions

| Decision | Rationale |
|----------|-----------|
| **Fly.io over AWS** | Hong Kong region ($5 vs $100/mo), Docker-native, simpler for small team |
| **Neon over RDS** | Free tier with pgvector, serverless auto-pause, Git-like branching |
| **Upstash over ElastiCache** | Serverless pricing ($0 vs $15/mo), global edge replication |
| **Vercel over self-hosted** | Zero config for Next.js SSR, preview deployments, global CDN |
| **Docker over Kubernetes** | Simpler for 1-3 developers, portable, scales with Fly.io auto-scaling |

### Upgrade Triggers

| Metric | Threshold | Action | Cost Impact |
|--------|-----------|--------|------------|
| **MAU** | 1K → 10K | Upgrade Neon + Upstash + Fly.io | $6 → $172/mo |
| **Error rate** | >5K/month | Sentry Team tier | +$26/mo |
| **Response time** | P95 >3s | Scale Fly.io instances | +$25-50/mo |
| **Database latency** | >200ms | Migrate to AWS RDS Tokyo | +$50/mo |
| **Bandwidth** | >100GB/mo | Vercel Pro tier | +$20/mo |

---

## Related Documents

### In `/docs/adr/` (Architecture Decision Records)

- [ADR-002: FastAPI as Web Framework](../adr/002-web-framework-fastapi.md)
- [ADR-003: SQLAlchemy 2.0 as ORM](../adr/003-orm-sqlalchemy.md)
- [ADR-004: Next.js as Frontend](../adr/004-frontend-nextjs.md)
- [ADR-005: Redis Caching Strategy](../adr/005-caching-redis.md)
- [ADR-006: Observability Stack](../adr/006-observability-stack.md)

### In `/docs/strategy/`

- [Dual-Source RAG Strategy](./dual-source-rag-strategy.md) — Vector search architecture
- [Product Strategy Recommendation](./product-strategy-recommendation.md) — Product roadmap

---

## Implementation Timeline

| Phase | Duration | Deliverable |
|-------|----------|-------------|
| **Week 1** | 5 days | Infrastructure deployed (DB, Redis, Backend, Frontend) |
| **Week 2** | 5 days | CI/CD pipeline + monitoring + staging environment |
| **Week 3** | 5 days | Domain/SSL + optimization + documentation |
| **Total** | **15 days** | Production-ready infrastructure |

---

## Cost Tracking

Track monthly costs at: https://docs.google.com/spreadsheets/d/YOUR_SHEET

**Budget alerts**:
- Fly.io: Email at $10, $20, $50
- Claude API: Budget at $50/day
- OpenAI API: Budget at $50/month
- Vercel: Spending limit at $50/month

---

## Support & Feedback

**Questions about deployment?**
- Open a GitHub Discussion: [Link to discussions]
- Slack channel: `#infrastructure`
- Email: devops@your-team.com

**Found an error or improvement?**
- Submit a PR to update these docs
- Tag: `@devops-team` for review

---

## Document Metadata

| Document | Last Updated | Author | Version |
|----------|--------------|--------|---------|
| `deployment-infrastructure-strategy.md` | 2026-03-02 | DevOps Strategy Team | 1.0 |
| `infrastructure-comparison-tables.md` | 2026-03-02 | DevOps Strategy Team | 1.0 |
| `deployment-quick-start-guide.md` | 2026-03-02 | DevOps Strategy Team | 1.0 |

**Next review**: 2026-06-01 (after MVP launch)

---

**Happy deploying! 🚀**
