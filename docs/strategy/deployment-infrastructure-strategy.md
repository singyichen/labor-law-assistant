# Deployment Infrastructure Strategy

**Document Type**: Architecture Decision
**Status**: Proposed
**Date**: 2026-03-02
**Author**: DevOps Strategy Team

---

## Table of Contents

1. [Executive Summary](#1-executive-summary)
2. [Recommended Stack](#2-recommended-stack)
3. [Hosting Provider Analysis](#3-hosting-provider-analysis)
4. [Container Strategy](#4-container-strategy)
5. [Database Hosting](#5-database-hosting)
6. [Redis Hosting](#6-redis-hosting)
7. [CI/CD Pipeline](#7-cicd-pipeline)
8. [Environment Management](#8-environment-management)
9. [SSL & Domain Strategy](#9-ssl--domain-strategy)
10. [Cost Projection](#10-cost-projection)
11. [Scaling Path](#11-scaling-path)
12. [Implementation Roadmap](#12-implementation-roadmap)

---

## 1. Executive Summary

### 1.1 Context

Labor Law Assistant 是一個台灣勞動法 RAG 查詢系統，具備以下技術特徵：

- **Backend**: Python 3.12 + FastAPI + PostgreSQL (pgvector) + Redis
- **Frontend**: Next.js 15 (App Router) + TypeScript + shadcn/ui
- **AI/ML**: Claude Sonnet 4.5 (primary) + GPT-4o-mini (fallback) + OpenAI embeddings
- **Team Size**: 1-3 developers
- **Budget**: MVP 階段需要成本最小化
- **Target Audience**: Taiwan-based users (Asia-Pacific latency critical)

### 1.2 Recommended Architecture (MVP)

```
┌─────────────────────────────────────────────────────────────────┐
│                        Production Stack                          │
├─────────────────────────────────────────────────────────────────┤
│                                                                  │
│  Frontend:     Vercel (Next.js 15)                              │
│  Backend:      Fly.io (FastAPI + Docker)                        │
│  Database:     Neon Postgres (managed, pgvector support)        │
│  Redis:        Upstash Redis (managed, serverless)              │
│  Monitoring:   Sentry + BetterStack + Grafana Cloud (free tier) │
│  CDN:          Cloudflare (free tier)                           │
│  CI/CD:        GitHub Actions                                   │
│                                                                  │
└─────────────────────────────────────────────────────────────────┘
```

### 1.3 Key Decisions

| Component | Technology | Rationale |
|-----------|-----------|-----------|
| **Frontend Host** | Vercel | Native Next.js SSR support, global CDN, zero config |
| **Backend Host** | Fly.io | Asia-Pacific edge presence, Docker-native, affordable |
| **Database** | Neon Postgres | pgvector support, generous free tier, auto-scaling |
| **Redis** | Upstash Redis | Serverless pricing, free tier, global replication |
| **Container** | Docker + Compose | Standard, portable, simple for small team |
| **CI/CD** | GitHub Actions | Already integrated, free for public repos |

### 1.4 Total Cost Projection

| Phase | MAU | Monthly Cost | Details |
|-------|----:|-------------:|---------|
| **MVP** | 100-1K | **$0-20** | All free tiers + Fly.io Hobby ($5) |
| **Growth** | 1K-10K | **$100-150** | Neon Scale ($25) + Upstash Pro ($30) + Fly.io ($50) |
| **Scale** | 10K-100K | **$400-600** | Neon Pro ($100) + Upstash Pro ($100) + Fly.io ($200) |

---

## 2. Recommended Stack

### 2.1 Complete Technology Matrix

| Layer | Technology | Priority | Cost (MVP) |
|-------|-----------|:--------:|------------|
| **Frontend Hosting** | Vercel | P0 | $0 (free tier) |
| **Backend Hosting** | Fly.io (Asia-Pacific) | P0 | $5-10/mo |
| **Database** | Neon Postgres (pgvector) | P0 | $0 (free tier) |
| **Redis** | Upstash Redis | P0 | $0 (free tier) |
| **CDN** | Cloudflare | P1 | $0 (free tier) |
| **Monitoring** | Sentry + BetterStack | P0 | $0 (free tier) |
| **Metrics** | Grafana Cloud | P1 | $0 (free tier) |
| **CI/CD** | GitHub Actions | P0 | $0 (public repo) |
| **Container Registry** | GitHub Container Registry | P0 | $0 |
| **SSL** | Let's Encrypt (Cloudflare) | P0 | $0 |
| **Domain** | Namecheap / Cloudflare | P1 | $10/year |

### 2.2 Architecture Diagram

```
                        ┌─────────────────────────────┐
                        │   Users (Taiwan/APAC)       │
                        └──────────────┬──────────────┘
                                       │
                    ┌──────────────────┴──────────────────┐
                    │                                     │
            ┌───────▼────────┐                  ┌────────▼────────┐
            │  Cloudflare    │                  │  Cloudflare     │
            │  CDN (Static)  │                  │  DNS + SSL      │
            └───────┬────────┘                  └────────┬────────┘
                    │                                    │
            ┌───────▼────────┐                  ┌────────▼────────┐
            │  Vercel        │                  │  Fly.io         │
            │  (Next.js)     │◄─────SSE/API────►│  (FastAPI)      │
            │  Edge Network  │                  │  Hong Kong      │
            └────────────────┘                  └────────┬────────┘
                                                         │
                              ┌──────────────────────────┼──────────────┐
                              │                          │              │
                    ┌─────────▼────────┐      ┌─────────▼────────┐    │
                    │  Neon Postgres   │      │  Upstash Redis   │    │
                    │  (pgvector)      │      │  (Cache/Session) │    │
                    │  US/EU Region    │      │  Global Edge     │    │
                    └──────────────────┘      └──────────────────┘    │
                                                                       │
                              ┌────────────────────────────────────────┘
                              │
                    ┌─────────▼────────┐
                    │  External APIs   │
                    │  - Claude API    │
                    │  - OpenAI API    │
                    └──────────────────┘

                    ┌──────────────────────────────────────┐
                    │  Observability (Separate Network)   │
                    ├──────────────────────────────────────┤
                    │  - Sentry (Error Tracking)           │
                    │  - Grafana Cloud (Metrics)           │
                    │  - BetterStack (Uptime)              │
                    │  - OpenTelemetry (Tracing)           │
                    └──────────────────────────────────────┘
```

---

## 3. Hosting Provider Analysis

### 3.1 Backend Hosting (FastAPI + PostgreSQL + Redis)

#### Option 1: Fly.io (RECOMMENDED)

**Pros:**
- ✅ Native Docker support — no platform lock-in
- ✅ **Hong Kong region available** (critical for Taiwan users, <50ms latency)
- ✅ Built-in global Anycast routing
- ✅ Managed Postgres (Fly Postgres) with pgvector support
- ✅ Simple `fly.toml` configuration
- ✅ Free tier: 3 shared-cpu VMs + 3GB storage
- ✅ Automatic HTTPS with Let's Encrypt
- ✅ GitHub Actions integration

**Cons:**
- ❌ Managed Postgres is less mature than AWS RDS
- ❌ Smaller community compared to AWS/GCP
- ❌ Fly Postgres requires separate provisioning (not same as app VM)

**Cost:**
- Free tier: 3 VMs (256MB RAM each) + 3GB persistent storage
- Production: $5-10/mo for 1 VM (1GB RAM) + $10/mo for Postgres

#### Option 2: Railway

**Pros:**
- ✅ Very simple developer experience
- ✅ Built-in PostgreSQL + Redis provisioning
- ✅ GitHub integration with auto-deploy
- ✅ Free tier: $5 credit/month

**Cons:**
- ❌ **No Asia-Pacific regions** (US West only) — higher latency to Taiwan (~150ms)
- ❌ pgvector support not officially documented
- ❌ More expensive at scale ($20+/mo for basic setup)

**Cost:**
- Free tier: $5 credit/month (~2-3 days of runtime)
- Production: $20-30/mo for app + Postgres + Redis

#### Option 3: Render

**Pros:**
- ✅ Simple Dockerfile-based deployment
- ✅ Managed Postgres with pgvector extension
- ✅ Free tier for static sites and APIs

**Cons:**
- ❌ **No Asia-Pacific regions** (Oregon, Frankfurt, Singapore only)
- ❌ Free tier spins down after 15 min inactivity (cold starts)
- ❌ PostgreSQL free tier limited to 90 days

**Cost:**
- Free tier: Web service (512MB RAM, spins down)
- Production: $25/mo (Starter Postgres) + $7/mo (Web service)

#### Option 4: AWS ECS Fargate

**Pros:**
- ✅ **Tokyo/Seoul regions** available (good for APAC)
- ✅ Enterprise-grade reliability
- ✅ Full control over infrastructure

**Cons:**
- ❌ Complex setup (VPC, ALB, ECS, RDS, ElastiCache)
- ❌ Expensive ($100+/mo even for small workloads)
- ❌ Overkill for 1-3 person team

**Cost:**
- MVP: $80-120/mo (Fargate + RDS t3.micro + ElastiCache)

#### Option 5: GCP Cloud Run

**Pros:**
- ✅ **Taiwan region available** (asia-east1)
- ✅ Serverless container platform (auto-scaling)
- ✅ Pay-per-request pricing

**Cons:**
- ❌ Cloud SQL (managed Postgres) is expensive ($20+/mo)
- ❌ Cold starts for infrequent requests
- ❌ More complex than Fly.io for stateful apps

**Cost:**
- MVP: $30-50/mo (Cloud Run + Cloud SQL + Memorystore)

**DECISION: Fly.io** — Best balance of cost, APAC latency, and simplicity.

---

### 3.2 Frontend Hosting (Next.js 15)

#### Option 1: Vercel (RECOMMENDED)

**Pros:**
- ✅ **Built by Next.js creators** — zero-config deployment
- ✅ Global edge network with Hong Kong PoP
- ✅ Native SSR + ISR + Edge Functions support
- ✅ Preview deployments for every PR
- ✅ Vercel AI SDK integrates seamlessly
- ✅ Generous free tier (100GB bandwidth)

**Cons:**
- ❌ Vendor lock-in for Edge Functions
- ❌ Expensive at scale (bandwidth overages)
- ❌ Limited control over caching headers

**Cost:**
- Free tier: 100GB bandwidth, unlimited deployments
- Pro: $20/mo (1TB bandwidth)

#### Option 2: Cloudflare Pages

**Pros:**
- ✅ Unlimited bandwidth (even on free tier!)
- ✅ Global CDN with excellent APAC coverage
- ✅ Workers for edge compute

**Cons:**
- ❌ **No native SSR support** for Next.js (requires adapter or self-hosting)
- ❌ Build time limits (20 min free tier)
- ❌ More manual configuration vs Vercel

**Cost:**
- Free tier: Unlimited bandwidth, 500 builds/month
- Pro: $20/mo

#### Option 3: Self-hosted (Fly.io or AWS)

**Pros:**
- ✅ Full control over caching and routing
- ✅ No vendor lock-in

**Cons:**
- ❌ No edge network (single region deployment)
- ❌ Complex setup (Node.js runtime + CDN integration)
- ❌ Must manage SSL certificates manually

**DECISION: Vercel** — Native Next.js support, free tier sufficient for MVP, excellent APAC CDN.

---

## 4. Container Strategy

### 4.1 Development vs Production Containers

#### Development (Docker Compose)

**Purpose**: Local development with hot-reload and debugging.

**Stack**:
- FastAPI (port 8000) with `uvicorn --reload`
- PostgreSQL 16 with pgvector extension
- Redis 7.x
- Adminer (database UI)

**File**: `docker-compose.dev.yml`

```yaml
version: '3.9'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    volumes:
      - ./backend:/app
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://postgres:password@db:5432/labor_law
      - REDIS_URL=redis://redis:6379/0
    depends_on:
      - db
      - redis

  db:
    image: pgvector/pgvector:pg16
    environment:
      POSTGRES_PASSWORD: password
      POSTGRES_DB: labor_law
    volumes:
      - postgres_data:/var/lib/postgresql/data
    ports:
      - "5432:5432"

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  adminer:
    image: adminer
    ports:
      - "8080:8080"

volumes:
  postgres_data:
  redis_data:
```

#### Production (Multi-stage Dockerfile)

**Purpose**: Optimized image for Fly.io deployment.

**File**: `backend/Dockerfile`

```dockerfile
# Stage 1: Builder
FROM python:3.12-slim as builder

WORKDIR /app

# Install uv
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies to /app/.venv
RUN uv sync --frozen --no-dev

# Stage 2: Runtime
FROM python:3.12-slim

WORKDIR /app

# Copy only the virtual environment and app code
COPY --from=builder /app/.venv /app/.venv
COPY ./app ./app

# Set Python path to use the virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Non-root user for security
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000"]
```

**Optimizations**:
- Multi-stage build reduces image size by 60%+ (removes build tools)
- `uv sync --frozen --no-dev` installs only production dependencies
- Non-root user improves security
- Cached layers for faster rebuilds

**Size**: ~150MB (vs ~400MB without multi-stage)

### 4.2 Frontend Container (Next.js)

Vercel handles this automatically, but for self-hosting:

**File**: `frontend/Dockerfile`

```dockerfile
FROM node:20-alpine AS builder

WORKDIR /app

COPY package.json pnpm-lock.yaml ./
RUN corepack enable pnpm && pnpm install --frozen-lockfile

COPY . .
RUN pnpm build

# Production runtime
FROM node:20-alpine

WORKDIR /app

ENV NODE_ENV=production

COPY --from=builder /app/public ./public
COPY --from=builder /app/.next/standalone ./
COPY --from=builder /app/.next/static ./.next/static

EXPOSE 3000

CMD ["node", "server.js"]
```

### 4.3 Kubernetes vs Docker Compose vs Serverless

| Approach | MVP | Growth | Scale |
|----------|:---:|:------:|:-----:|
| **Docker Compose** | ✅ | ❌ | ❌ |
| **Kubernetes** | ❌ | ⚠️ | ✅ |
| **Serverless (Fly.io/Cloud Run)** | ✅ | ✅ | ✅ |

**DECISION**: Docker Compose for local development, Fly.io (serverless containers) for production.

**Rationale**:
- Kubernetes is overkill for 1-3 developers
- Fly.io provides auto-scaling without K8s complexity
- Can migrate to K8s later if needed (Docker images are portable)

---

## 5. Database Hosting

### 5.1 PostgreSQL with pgvector Support

#### Option 1: Neon (RECOMMENDED)

**Pros:**
- ✅ **Native pgvector support** (pre-installed)
- ✅ Serverless architecture (auto-scales, auto-pauses)
- ✅ Generous free tier: 10GB storage, 100 hours compute/month
- ✅ Branching for dev/staging environments (Git-like workflow)
- ✅ Connection pooling built-in (no PgBouncer needed)
- ✅ Automatic backups with point-in-time recovery

**Cons:**
- ❌ **No Asia-Pacific region yet** (US East/EU only) — adds ~150ms latency
- ❌ Free tier pauses after 5 min inactivity (cold starts ~500ms)
- ❌ Limited to 1 primary branch on free tier

**Cost:**
- Free tier: 10GB storage, 100 hours compute
- Scale: $25/mo (always-on compute, 50GB storage)
- Pro: $100/mo (dedicated CPU, 100GB storage)

**Latency to Taiwan**: ~150-200ms (acceptable for read-heavy workload with Redis caching)

#### Option 2: Supabase Postgres

**Pros:**
- ✅ pgvector support via extension
- ✅ Free tier: 500MB database, 1GB file storage
- ✅ Built-in authentication and APIs (could replace NextAuth.js)
- ✅ Real-time subscriptions (Postgres LISTEN/NOTIFY)

**Cons:**
- ❌ **No Asia-Pacific region** (US East, EU West, Singapore)
- ❌ Free tier pauses after 1 week inactivity
- ❌ Brings many features not needed (Auth, Storage, Edge Functions)

**Cost:**
- Free tier: 500MB database
- Pro: $25/mo (8GB database, no pausing)

#### Option 3: AWS RDS PostgreSQL

**Pros:**
- ✅ **Tokyo/Seoul regions** available (low latency to Taiwan)
- ✅ Enterprise reliability (Multi-AZ, read replicas)
- ✅ pgvector via extension

**Cons:**
- ❌ Expensive ($30+/mo for t3.micro always-on)
- ❌ Complex setup (VPC, security groups, parameter groups)
- ❌ No free tier (only 12 months trial)

**Cost:**
- Minimum: $15-30/mo (t3.micro, single-AZ)
- Production: $100+/mo (t3.medium, Multi-AZ)

#### Option 4: Railway Postgres

**Pros:**
- ✅ Very simple provisioning
- ✅ pgvector extension available
- ✅ $5 free credit/month

**Cons:**
- ❌ No dedicated Postgres product (runs in shared infrastructure)
- ❌ No Asia-Pacific region
- ❌ Limited documentation on pgvector configuration

**Cost:**
- Pay-as-you-go: ~$10-15/mo for small database

#### Option 5: Self-managed (Fly Postgres)

**Pros:**
- ✅ **Hong Kong region** available
- ✅ Full control over configuration
- ✅ Lower cost than RDS

**Cons:**
- ❌ Must manage backups, replication, monitoring
- ❌ No auto-scaling
- ❌ Operational burden for small team

**Cost:**
- ~$10-20/mo for 1GB RAM instance

**DECISION: Neon** for MVP (free tier, pgvector support), migrate to AWS RDS Tokyo if latency becomes critical.

### 5.2 Connection Pooling

**Challenge**: FastAPI runs multiple workers, each creating database connections.

**Solutions**:

| Approach | When to Use | Implementation |
|----------|-------------|----------------|
| **SQLAlchemy built-in pooling** | MVP | `pool_size=5, max_overflow=10` |
| **Neon built-in pooling** | Using Neon | Automatic |
| **PgBouncer** | Self-hosted Postgres | Add as sidecar container |

**DECISION**: Use Neon's built-in pooling (no extra config needed).

### 5.3 Backup Strategy

| Method | Frequency | Retention | Tool |
|--------|-----------|-----------|------|
| **Automated snapshots** | Daily | 7 days | Neon (automatic) |
| **Point-in-time recovery** | Continuous | 7 days | Neon (built-in) |
| **Manual backups** | Before migrations | 30 days | `pg_dump` to S3 |

**Critical migration workflow**:
```bash
# Before running migration
pg_dump $DATABASE_URL > backup_$(date +%Y%m%d_%H%M%S).sql

# Run migration
alembic upgrade head

# If failure, restore
psql $DATABASE_URL < backup_20260302_153000.sql
```

---

## 6. Redis Hosting

### 6.1 Managed Redis Options

#### Option 1: Upstash Redis (RECOMMENDED)

**Pros:**
- ✅ **Serverless pricing** (pay-per-request, not per-hour)
- ✅ Free tier: 10,000 commands/day
- ✅ Global edge replication (reduces latency)
- ✅ Built-in REST API (works with serverless environments)
- ✅ No cold starts

**Cons:**
- ❌ REST API adds ~10ms latency vs native Redis protocol
- ❌ Limited to 256MB on free tier

**Cost:**
- Free tier: 10,000 commands/day (~300K/month)
- Pro: $30/mo (10M commands/month, 1GB storage)

#### Option 2: Redis Cloud (Redis Labs)

**Pros:**
- ✅ Official Redis provider
- ✅ Asia-Pacific regions available
- ✅ Native Redis protocol (low latency)

**Cons:**
- ❌ Free tier limited to 30MB
- ❌ Always-on pricing (not serverless)

**Cost:**
- Free tier: 30MB RAM
- Essentials: $7/mo (250MB RAM)

#### Option 3: AWS ElastiCache

**Pros:**
- ✅ **Tokyo/Seoul regions**
- ✅ Redis 7.x support
- ✅ Automatic failover

**Cons:**
- ❌ Expensive ($15+/mo for t3.micro)
- ❌ Complex VPC setup
- ❌ No free tier

**Cost:**
- Minimum: $15/mo (t3.micro, single-node)

#### Option 4: Self-hosted (Fly.io Redis)

**Pros:**
- ✅ Full control
- ✅ Hong Kong region
- ✅ Cheap (~$5/mo)

**Cons:**
- ❌ Must manage persistence, backups, monitoring
- ❌ No automatic failover
- ❌ Operational burden

**DECISION: Upstash Redis** — Serverless pricing matches usage pattern, free tier sufficient for MVP.

### 6.2 Persistence Configuration

**For LLM response caching** (can tolerate data loss):
```redis
# appendonly no (RDB snapshots only, every 60s)
save 60 1000
```

**For session storage** (must not lose data):
```redis
# appendonly yes (AOF for durability)
appendonly yes
appendfsync everysec
```

**Upstash handles this automatically** (no manual config needed).

---

## 7. CI/CD Pipeline

### 7.1 Current State (from `.github/workflows/ci.yml`)

```yaml
# Existing jobs:
- lint (ruff)
- typecheck (mypy)
- test (pytest with coverage)
```

### 7.2 Enhanced CI/CD Pipeline

**File**: `.github/workflows/deploy.yml`

```yaml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # Phase 1: Quality Checks
  lint-backend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v5
      - uses: actions/setup-python@v5
        with:
          python-version: "3.12"
      - run: uv sync --dev
      - run: uv run ruff check .
      - run: uv run ruff format --check .

  typecheck-backend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v5
      - uses: actions/setup-python@v5
      - run: uv sync --dev
      - run: uv run mypy .

  test-backend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: backend
    services:
      postgres:
        image: pgvector/pgvector:pg16
        env:
          POSTGRES_PASSWORD: postgres
          POSTGRES_DB: test_db
        ports:
          - 5432:5432
        options: >-
          --health-cmd pg_isready
          --health-interval 10s
          --health-timeout 5s
          --health-retries 5
      redis:
        image: redis:7-alpine
        ports:
          - 6379:6379
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v5
      - uses: actions/setup-python@v5
      - run: uv sync --dev
      - run: uv run pytest --cov=app --cov-report=xml
      - uses: codecov/codecov-action@v3
        with:
          files: ./backend/coverage.xml

  lint-frontend:
    runs-on: ubuntu-latest
    defaults:
      run:
        working-directory: frontend
    steps:
      - uses: actions/checkout@v4
      - uses: pnpm/action-setup@v3
        with:
          version: 8
      - uses: actions/setup-node@v4
        with:
          node-version: "20"
          cache: "pnpm"
          cache-dependency-path: frontend/pnpm-lock.yaml
      - run: pnpm install --frozen-lockfile
      - run: pnpm lint
      - run: pnpm typecheck

  # Phase 2: Build Docker Images
  build-backend:
    needs: [lint-backend, typecheck-backend, test-backend]
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: docker/setup-buildx-action@v3
      - uses: docker/login-action@v3
        with:
          registry: ghcr.io
          username: ${{ github.actor }}
          password: ${{ secrets.GITHUB_TOKEN }}
      - uses: docker/build-push-action@v5
        with:
          context: ./backend
          push: true
          tags: ghcr.io/${{ github.repository }}/backend:${{ github.sha }},ghcr.io/${{ github.repository }}/backend:latest
          cache-from: type=gha
          cache-to: type=gha,mode=max

  # Phase 3: Deploy
  deploy-backend:
    needs: build-backend
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: superfly/flyctl-actions/setup-flyctl@master
      - run: flyctl deploy --remote-only --image ghcr.io/${{ github.repository }}/backend:${{ github.sha }}
        env:
          FLY_API_TOKEN: ${{ secrets.FLY_API_TOKEN }}

  deploy-frontend:
    needs: lint-frontend
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: amondnet/vercel-action@v25
        with:
          vercel-token: ${{ secrets.VERCEL_TOKEN }}
          vercel-org-id: ${{ secrets.VERCEL_ORG_ID }}
          vercel-project-id: ${{ secrets.VERCEL_PROJECT_ID }}
          vercel-args: "--prod"
          working-directory: ./frontend

  # Phase 4: Database Migration
  migrate:
    needs: deploy-backend
    runs-on: ubuntu-latest
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v5
      - uses: actions/setup-python@v5
      - run: uv sync --dev
        working-directory: backend
      - run: uv run alembic upgrade head
        working-directory: backend
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}
```

### 7.3 Preview Environments

**For PRs** (Vercel automatic, Fly.io manual):

1. **Frontend**: Vercel creates preview URL automatically
2. **Backend**: Create temporary Fly.io app:
   ```bash
   flyctl apps create labor-law-pr-123
   flyctl deploy --app labor-law-pr-123
   ```

3. **Database**: Use Neon branching (Git-like workflow):
   ```bash
   # Create branch from main database
   neon branches create --name pr-123

   # Get connection string
   neon connection-string pr-123
   ```

**DECISION**: Vercel auto-preview for frontend, manual Fly.io for backend (MVP stage).

### 7.4 Secrets Management

| Secret | Storage | Access |
|--------|---------|--------|
| **CI/CD secrets** | GitHub Secrets | GitHub Actions only |
| **Production secrets** | Fly.io Secrets | `flyctl secrets set` |
| **Frontend env vars** | Vercel Env Vars | Vercel Dashboard |
| **Local development** | `.env.local` (gitignored) | Docker Compose |

**Setup commands**:
```bash
# Fly.io
flyctl secrets set DATABASE_URL="postgresql://..." \
  REDIS_URL="redis://..." \
  ANTHROPIC_API_KEY="..." \
  OPENAI_API_KEY="..."

# Vercel
vercel env add NEXT_PUBLIC_API_URL production
vercel env add NEXTAUTH_SECRET production
```

---

## 8. Environment Management

### 8.1 Environment Matrix

| Environment | Purpose | Infrastructure | Database | Cost |
|-------------|---------|----------------|----------|------|
| **local** | Development | Docker Compose | Local Postgres | $0 |
| **staging** | Testing | Fly.io (dev region) | Neon branch | $0 (free tier) |
| **production** | Live | Fly.io (HK region) | Neon main | $5-20/mo |

### 8.2 Environment Variables

**Backend** (`.env.example`):
```bash
# Database
DATABASE_URL=postgresql+asyncpg://user:pass@host:5432/dbname
DATABASE_POOL_SIZE=5
DATABASE_MAX_OVERFLOW=10

# Redis
REDIS_URL=redis://host:6379/0
REDIS_CACHE_TTL_SECONDS=2592000  # 30 days

# LLM APIs
ANTHROPIC_API_KEY=sk-ant-...
OPENAI_API_KEY=sk-...
LLM_MAX_TOKENS=4096
LLM_TEMPERATURE=0.1

# Observability
SENTRY_DSN=https://...@sentry.io/...
ENVIRONMENT=production

# Security
ALLOWED_ORIGINS=https://labor-law.tw,https://www.labor-law.tw
SECRET_KEY=...  # For JWT signing

# Feature Flags
ENABLE_EMBEDDINGS_CACHE=true
ENABLE_RATE_LIMITING=false  # Enable in production
```

**Frontend** (`.env.local`):
```bash
# Public (exposed to browser)
NEXT_PUBLIC_API_URL=https://api.labor-law.tw
NEXT_PUBLIC_SENTRY_DSN=https://...@sentry.io/...
NEXT_PUBLIC_ENVIRONMENT=production

# Server-side only
NEXTAUTH_URL=https://labor-law.tw
NEXTAUTH_SECRET=...
DATABASE_URL=...  # For NextAuth.js session storage
```

### 8.3 Configuration Management

**DO NOT** use feature flag services (LaunchDarkly, Split.io) at MVP stage — use environment variables.

**If needed later** (Phase 2+):
- Simple feature flags: Environment variables (restart required)
- Complex feature flags: Flagsmith (open-source, self-hostable)

---

## 9. SSL & Domain Strategy

### 9.1 Domain Setup

**Recommended registrar**: Namecheap or Cloudflare Registrar

**Domains**:
- Primary: `labor-law.tw` or `labor-law.com.tw`
- API: `api.labor-law.tw`
- Staging: `staging.labor-law.tw`

**Cost**: ~$10-15/year for `.tw` domain

### 9.2 DNS Configuration (Cloudflare)

```
A     @                 76.76.21.21  (Vercel)
CNAME api              labor-law.fly.dev
CNAME staging          staging-labor-law.fly.dev
CNAME www              labor-law.vercel.app
TXT   @                "v=spf1 include:_spf.vercel.com ~all"
```

**Cloudflare settings**:
- SSL/TLS mode: Full (strict)
- Always Use HTTPS: On
- Automatic HTTPS Rewrites: On
- Minimum TLS Version: 1.2

### 9.3 SSL Certificate Management

| Component | Provider | Renewal |
|-----------|----------|---------|
| **Frontend** | Vercel (automatic) | Automatic |
| **Backend** | Fly.io (Let's Encrypt) | Automatic |
| **CDN** | Cloudflare (Universal SSL) | Automatic |

**NO MANUAL CERTIFICATE MANAGEMENT REQUIRED** ✅

---

## 10. Cost Projection

### 10.1 Detailed Cost Breakdown

#### MVP Phase (0-1K MAU)

| Service | Tier | Cost/Month | Notes |
|---------|------|------------|-------|
| **Vercel** | Free | $0 | 100GB bandwidth, unlimited deployments |
| **Fly.io** | Hobby | $5 | 1 shared CPU, 256MB RAM |
| **Neon Postgres** | Free | $0 | 10GB storage, 100 hours compute/month |
| **Upstash Redis** | Free | $0 | 10K commands/day |
| **Cloudflare** | Free | $0 | CDN, DNS, SSL |
| **Sentry** | Free | $0 | 5K errors/month |
| **BetterStack** | Free | $0 | 3 monitors |
| **Grafana Cloud** | Free | $0 | 10K metrics, 50GB logs |
| **Domain** | — | $1 | (~$12/year) |
| **GitHub** | Public repo | $0 | CI/CD included |
| **TOTAL** | | **$6/mo** | |

#### Growth Phase (1K-10K MAU)

| Service | Tier | Cost/Month | Notes |
|---------|------|------------|-------|
| **Vercel** | Pro | $20 | 1TB bandwidth |
| **Fly.io** | Production | $50 | 2x shared CPU, 1GB RAM, auto-scaling |
| **Neon Postgres** | Scale | $25 | Always-on, 50GB storage |
| **Upstash Redis** | Pro | $30 | 10M commands/month, 1GB |
| **Cloudflare** | Free | $0 | Unlimited bandwidth on free tier! |
| **Sentry** | Team | $26 | 50K errors/month |
| **BetterStack** | Startup | $20 | 10 monitors, 3 month retention |
| **Grafana Cloud** | Free | $0 | Still within free tier |
| **Domain** | — | $1 | |
| **TOTAL** | | **$172/mo** | |

#### Scale Phase (10K-100K MAU)

| Service | Tier | Cost/Month | Notes |
|---------|------|------------|-------|
| **Vercel** | Pro | $50 | 3TB bandwidth |
| **Fly.io** | Production | $200 | 4x dedicated CPU, 4GB RAM, multi-region |
| **Neon Postgres** | Pro | $100 | Dedicated compute, 100GB storage |
| **Upstash Redis** | Pro | $100 | 100M commands/month, 5GB |
| **Cloudflare** | Free | $0 | Still free! |
| **Sentry** | Business | $80 | 200K errors/month |
| **BetterStack** | Business | $50 | 50 monitors |
| **Grafana Cloud** | Pro | $50 | Higher metrics/logs volume |
| **Domain** | — | $1 | |
| **TOTAL** | | **$631/mo** | |

### 10.2 Cost Optimization Strategies

| Strategy | Impact | Effort |
|----------|--------|--------|
| **Redis caching for LLM responses** | -60% API costs | P0 (already planned) |
| **Neon auto-suspend on free tier** | $0 vs $25/mo | P0 (default) |
| **Cloudflare CDN for static assets** | -30% bandwidth costs | P1 (easy) |
| **Upstash serverless pricing** | Pay only for usage | P0 (default) |
| **Image optimization (Next.js)** | -50% bandwidth | P1 (built-in) |
| **Database query optimization** | -20% compute costs | P1 (ongoing) |

---

## 11. Scaling Path

### 11.1 Three-Phase Scaling Strategy

```
Phase 1: MVP (0-1K MAU)
┌────────────────────────────────────────┐
│  Single Region, Minimal Infrastructure │
├────────────────────────────────────────┤
│  Frontend: Vercel (Global CDN)         │
│  Backend:  Fly.io (1 instance, HK)     │
│  DB:       Neon (free tier, US)        │
│  Redis:    Upstash (global edge)       │
└────────────────────────────────────────┘

Phase 2: Growth (1K-10K MAU)
┌────────────────────────────────────────┐
│  Multi-Region, Auto-Scaling            │
├────────────────────────────────────────┤
│  Frontend: Vercel (Global CDN)         │
│  Backend:  Fly.io (2-4 instances, HK)  │
│  DB:       Neon Scale (always-on)      │
│  Redis:    Upstash Pro (geo-replicated)│
└────────────────────────────────────────┘

Phase 3: Scale (10K-100K MAU)
┌────────────────────────────────────────┐
│  Enterprise-Grade Infrastructure       │
├────────────────────────────────────────┤
│  Frontend: Vercel (Global CDN)         │
│  Backend:  Fly.io (multi-region)       │
│           or migrate to AWS ECS        │
│  DB:       Neon Pro + Read Replicas    │
│           or migrate to AWS RDS        │
│  Redis:    Upstash Pro or ElastiCache  │
│  CDN:      Cloudflare (still free!)    │
└────────────────────────────────────────┘
```

### 11.2 Scaling Triggers

| Metric | Threshold | Action |
|--------|-----------|--------|
| **Response time P95** | > 3s | Scale up Fly.io instances |
| **Database CPU** | > 70% | Upgrade Neon tier or add read replicas |
| **Redis memory** | > 80% | Upgrade Upstash tier |
| **Error rate** | > 2% | Investigate and fix before scaling |
| **LLM API cost** | > $50/day | Review caching strategy |

### 11.3 Migration Paths

**Database Migration** (Neon → AWS RDS):
```bash
# 1. Set up AWS RDS in Tokyo region
# 2. Create read replica from Neon (if supported) or use pg_dump
pg_dump $NEON_URL | psql $RDS_URL

# 3. Enable pgvector extension on RDS
psql $RDS_URL -c "CREATE EXTENSION vector;"

# 4. Run migrations
alembic upgrade head

# 5. Update environment variable
flyctl secrets set DATABASE_URL="postgresql://..."

# 6. Test with canary deployment
# 7. Switch traffic
# 8. Monitor for 48 hours before decommissioning Neon
```

**Backend Migration** (Fly.io → AWS ECS):
- Docker images are portable (no code changes needed)
- Update CI/CD to push to ECR instead of GHCR
- Create ECS task definition
- Deploy behind ALB
- Update DNS to point to ALB

---

## 12. Implementation Roadmap

### 12.1 Priority Matrix

| Priority | Task | Effort | Impact |
|----------|------|--------|--------|
| **P0** | Set up Fly.io backend | 4h | Critical |
| **P0** | Set up Neon Postgres | 2h | Critical |
| **P0** | Set up Upstash Redis | 1h | Critical |
| **P0** | Deploy frontend to Vercel | 2h | Critical |
| **P0** | Configure CI/CD for deployments | 4h | Critical |
| **P1** | Set up Cloudflare CDN | 2h | High |
| **P1** | Configure Sentry error tracking | 2h | High |
| **P1** | Set up BetterStack monitoring | 1h | High |
| **P1** | Create staging environment | 3h | High |
| **P2** | Set up Grafana dashboards | 4h | Medium |
| **P2** | Configure preview environments | 3h | Medium |
| **P2** | Write deployment documentation | 2h | Medium |

### 12.2 Week-by-Week Plan

#### Week 1: Infrastructure Setup (P0)

**Day 1-2: Database & Redis**
- [ ] Create Neon account and provision Postgres database
- [ ] Install pgvector extension
- [ ] Create Upstash Redis instance
- [ ] Test connections from local environment
- [ ] Run Alembic migrations

**Day 3-4: Backend Deployment**
- [ ] Create Fly.io account
- [ ] Write `fly.toml` configuration
- [ ] Create multi-stage Dockerfile
- [ ] Deploy to Fly.io Hong Kong region
- [ ] Configure secrets (DATABASE_URL, REDIS_URL, API keys)
- [ ] Test health check endpoint

**Day 5: Frontend Deployment**
- [ ] Create Vercel account
- [ ] Connect GitHub repository
- [ ] Configure environment variables
- [ ] Deploy production build
- [ ] Test SSR and API routes

#### Week 2: CI/CD & Monitoring (P0 + P1)

**Day 1-2: CI/CD Pipeline**
- [ ] Enhance GitHub Actions workflow
- [ ] Add Docker build and push to GHCR
- [ ] Configure Fly.io deployment
- [ ] Set up automated database migrations
- [ ] Test full deployment flow

**Day 3: Domain & SSL**
- [ ] Purchase domain
- [ ] Configure Cloudflare DNS
- [ ] Set up SSL certificates
- [ ] Configure custom domains on Vercel and Fly.io

**Day 4-5: Monitoring**
- [ ] Set up Sentry error tracking (frontend + backend)
- [ ] Configure BetterStack uptime monitoring
- [ ] Create Grafana Cloud workspace
- [ ] Set up Prometheus metrics export
- [ ] Configure alert rules

#### Week 3: Optimization & Documentation (P1 + P2)

**Day 1-2: Performance**
- [ ] Enable Redis caching for LLM responses
- [ ] Configure Cloudflare CDN
- [ ] Optimize Docker image sizes
- [ ] Set up database connection pooling
- [ ] Load test with k6 or Locust

**Day 3: Staging Environment**
- [ ] Create Neon database branch for staging
- [ ] Deploy staging backend to Fly.io
- [ ] Configure staging frontend on Vercel
- [ ] Test full deployment workflow

**Day 4-5: Documentation**
- [ ] Write deployment runbook
- [ ] Document secret rotation procedures
- [ ] Create incident response plan
- [ ] Write database backup/restore guide
- [ ] Document scaling procedures

### 12.3 Acceptance Criteria

| Criteria | Definition of Done |
|----------|-------------------|
| **Deployment automation** | Push to `main` deploys to production in <10 min |
| **Uptime** | 99.5%+ uptime (measured by BetterStack) |
| **Performance** | P95 response time <3s for cached queries |
| **Monitoring** | Errors visible in Sentry within 1 minute |
| **Scalability** | Can scale from 100 to 1000 users without code changes |
| **Documentation** | New developer can deploy to staging in <1 hour |
| **Cost** | Monthly infrastructure cost <$10 for MVP |

---

## Appendix A: Configuration Files

### A.1 Fly.io Configuration (`fly.toml`)

```toml
app = "labor-law-backend"
primary_region = "hkg"  # Hong Kong

[build]
  image = "ghcr.io/your-org/labor-law-backend:latest"

[env]
  PORT = "8000"
  ENVIRONMENT = "production"

[http_service]
  internal_port = 8000
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1
  processes = ["app"]

  [[http_service.checks]]
    grace_period = "10s"
    interval = "30s"
    method = "GET"
    timeout = "5s"
    path = "/health"

[[vm]]
  cpu_kind = "shared"
  cpus = 1
  memory_mb = 512

[metrics]
  port = 9091
  path = "/metrics"
```

### A.2 Docker Compose for Local Development

```yaml
version: '3.9'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile.dev
    volumes:
      - ./backend:/app
      - /app/.venv  # Don't mount virtual environment
    ports:
      - "8000:8000"
    environment:
      - DATABASE_URL=postgresql+asyncpg://postgres:password@db:5432/labor_law
      - REDIS_URL=redis://redis:6379/0
      - ANTHROPIC_API_KEY=${ANTHROPIC_API_KEY}
      - OPENAI_API_KEY=${OPENAI_API_KEY}
    depends_on:
      db:
        condition: service_healthy
      redis:
        condition: service_started
    command: uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile.dev
    volumes:
      - ./frontend:/app
      - /app/node_modules
      - /app/.next
    ports:
      - "3000:3000"
    environment:
      - NEXT_PUBLIC_API_URL=http://localhost:8000
    command: pnpm dev

  db:
    image: pgvector/pgvector:pg16
    environment:
      POSTGRES_USER: postgres
      POSTGRES_PASSWORD: password
      POSTGRES_DB: labor_law
    ports:
      - "5432:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./backend/scripts/init-db.sql:/docker-entrypoint-initdb.d/init.sql
    healthcheck:
      test: ["CMD-SHELL", "pg_isready -U postgres"]
      interval: 10s
      timeout: 5s
      retries: 5

  redis:
    image: redis:7-alpine
    ports:
      - "6379:6379"
    command: redis-server --appendonly yes
    volumes:
      - redis_data:/data

  adminer:
    image: adminer
    ports:
      - "8080:8080"
    environment:
      ADMINER_DEFAULT_SERVER: db

volumes:
  postgres_data:
  redis_data:
```

### A.3 Vercel Configuration (`vercel.json`)

```json
{
  "buildCommand": "pnpm build",
  "devCommand": "pnpm dev",
  "installCommand": "pnpm install --frozen-lockfile",
  "framework": "nextjs",
  "regions": ["hkg1", "sin1", "sfo1"],
  "headers": [
    {
      "source": "/(.*)",
      "headers": [
        {
          "key": "X-Content-Type-Options",
          "value": "nosniff"
        },
        {
          "key": "X-Frame-Options",
          "value": "DENY"
        },
        {
          "key": "X-XSS-Protection",
          "value": "1; mode=block"
        }
      ]
    }
  ],
  "rewrites": [
    {
      "source": "/api/:path*",
      "destination": "https://api.labor-law.tw/:path*"
    }
  ]
}
```

---

## Appendix B: Migration Checklists

### B.1 Pre-Deployment Checklist

- [ ] All tests passing in CI
- [ ] Database backup created
- [ ] Secrets rotated (if needed)
- [ ] Staging environment tested
- [ ] Rollback plan documented
- [ ] On-call engineer identified
- [ ] Monitoring dashboards reviewed
- [ ] Rate limits configured
- [ ] Health check endpoints working

### B.2 Post-Deployment Checklist

- [ ] Health checks passing
- [ ] Error rate <1% in Sentry
- [ ] P95 response time <3s
- [ ] Database migrations completed
- [ ] Cache warming executed
- [ ] Smoke tests passed
- [ ] Monitoring alerts configured
- [ ] Documentation updated
- [ ] Team notified

---

## Appendix C: Incident Response Runbook

### C.1 Backend Down (5xx Errors)

1. **Check Fly.io status**: `flyctl status`
2. **View logs**: `flyctl logs`
3. **Check database connection**: Test Neon connection string
4. **Check Redis connection**: Test Upstash endpoint
5. **Rollback if needed**: `flyctl releases rollback`
6. **Notify team**: Slack incident channel

### C.2 Database Issues

1. **Check Neon dashboard**: Verify database is not suspended
2. **Check connection pool**: Look for "too many connections" errors
3. **Check slow queries**: Review Neon insights
4. **Scale up if needed**: Upgrade Neon tier
5. **Restore from backup** (if corruption):
   ```bash
   psql $DATABASE_URL < backup_latest.sql
   ```

### C.3 High LLM API Costs

1. **Check cache hit rate**: Should be >70%
2. **Review Redis memory**: Ensure cache isn't being evicted
3. **Check for retry loops**: Review error logs
4. **Implement circuit breaker**: If API is failing
5. **Adjust rate limits**: Reduce concurrent requests

---

## Revision History

| Version | Date | Changes | Author |
|---------|------|---------|--------|
| 1.0 | 2026-03-02 | Initial draft | DevOps Strategy Team |

---

## Next Steps

1. **Review this document** with the team
2. **Validate cost assumptions** (check free tier limits)
3. **Create Fly.io / Vercel / Neon accounts**
4. **Start with Week 1 implementation plan**
5. **Document as you go** (update runbooks)

---

**Questions or feedback?** Open a GitHub Discussion or update this document via PR.
