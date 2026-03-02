# Deployment Quick Start Guide

**Document Type**: Implementation Checklist
**Date**: 2026-03-02
**Estimated Time**: 8-12 hours total

---

## Prerequisites

Before you begin, ensure you have:

- [ ] GitHub account with access to the repository
- [ ] Credit card for service signups (even for free tiers)
- [ ] Domain name purchased (optional for MVP, can use `.fly.dev` subdomain)
- [ ] API keys: Anthropic Claude, OpenAI
- [ ] Command-line tools installed:
  - `flyctl` (Fly.io CLI)
  - `psql` (PostgreSQL client)
  - `docker` & `docker-compose`
  - `gh` (GitHub CLI, optional)

---

## Phase 1: Account Setup (30 minutes)

### Step 1.1: Create Accounts

```bash
# 1. Fly.io
open https://fly.io/app/sign-up
# Sign up with GitHub OAuth

# 2. Neon
open https://neon.tech/
# Sign up with GitHub OAuth

# 3. Upstash
open https://upstash.com/
# Sign up with GitHub OAuth

# 4. Vercel
open https://vercel.com/signup
# Sign up with GitHub OAuth

# 5. Cloudflare (for DNS/CDN)
open https://dash.cloudflare.com/sign-up

# 6. Sentry
open https://sentry.io/signup/
# Sign up with GitHub OAuth

# 7. BetterStack
open https://betterstack.com/
# Sign up with GitHub OAuth
```

### Step 1.2: Install CLI Tools

```bash
# Fly.io CLI
curl -L https://fly.io/install.sh | sh

# Verify installation
flyctl version

# Authenticate
flyctl auth login

# Vercel CLI (optional, can use web UI)
npm install -g vercel

# Neon CLI (optional)
brew install neon
```

---

## Phase 2: Database Setup (45 minutes)

### Step 2.1: Create Neon Database

**Via Web UI**:
1. Go to https://console.neon.tech/
2. Click "Create Project"
3. Name: `labor-law-assistant`
4. Region: `US East` (or `EU West`)
5. Postgres version: `16`
6. Click "Create Project"

**Enable pgvector extension**:
```sql
-- Connect to your database via psql or Neon SQL Editor
CREATE EXTENSION IF NOT EXISTS vector;

-- Verify
SELECT * FROM pg_extension WHERE extname = 'vector';
```

### Step 2.2: Save Connection String

```bash
# From Neon dashboard, copy connection string:
# postgresql://user:password@ep-xyz.us-east-2.aws.neon.tech/neondb?sslmode=require

# Save to local .env
echo "DATABASE_URL=postgresql+asyncpg://user:password@host/db?sslmode=require" >> backend/.env.local
```

### Step 2.3: Run Initial Migrations

```bash
cd backend

# Install dependencies
uv sync

# Create initial migration
uv run alembic revision --autogenerate -m "Initial schema"

# Review migration file in backend/alembic/versions/

# Apply migration
uv run alembic upgrade head

# Verify tables created
psql $DATABASE_URL -c "\dt"
```

### Step 2.4: Create Database Branch for Staging

**Via Neon CLI**:
```bash
# Create staging branch from main
neonctl branches create --name staging --parent main

# Get connection string
neonctl connection-string staging

# Save to GitHub Secrets (for CI/CD)
gh secret set STAGING_DATABASE_URL --body "postgresql://..."
```

---

## Phase 3: Redis Setup (15 minutes)

### Step 3.1: Create Upstash Redis

**Via Web UI**:
1. Go to https://console.upstash.com/
2. Click "Create Database"
3. Name: `labor-law-cache`
4. Type: `Regional` (for free tier)
5. Region: `asia-pacific-1` (Singapore)
6. Click "Create"

### Step 3.2: Get Connection Details

```bash
# From Upstash dashboard, copy REST URL and token

# For production (REST API)
echo "UPSTASH_REDIS_REST_URL=https://..." >> backend/.env.local
echo "UPSTASH_REDIS_REST_TOKEN=..." >> backend/.env.local

# For local development (use Docker Compose Redis instead)
# See docker-compose.yml
```

### Step 3.3: Test Connection

```python
# backend/tests/test_redis.py
import os
from redis import asyncio as aioredis

async def test_redis_connection():
    redis_url = os.getenv("UPSTASH_REDIS_REST_URL")
    token = os.getenv("UPSTASH_REDIS_REST_TOKEN")

    redis = aioredis.from_url(
        redis_url,
        password=token,
        decode_responses=True
    )

    await redis.set("test_key", "test_value")
    value = await redis.get("test_key")
    assert value == "test_value"

    await redis.close()
```

---

## Phase 4: Backend Deployment (2 hours)

### Step 4.1: Create Fly.io App

```bash
cd backend

# Create fly.toml interactively
flyctl launch

# Prompts:
# App name: labor-law-backend
# Region: Hong Kong (hkg)
# Set up Postgres: No (we're using Neon)
# Set up Redis: No (we're using Upstash)
# Deploy now: No (we'll set secrets first)
```

### Step 4.2: Configure `fly.toml`

**File**: `backend/fly.toml`

```toml
app = "labor-law-backend"
primary_region = "hkg"

[build]
  dockerfile = "Dockerfile"

[env]
  PORT = "8000"
  ENVIRONMENT = "production"

[http_service]
  internal_port = 8000
  force_https = true
  auto_stop_machines = true
  auto_start_machines = true
  min_machines_running = 1

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

### Step 4.3: Create Production Dockerfile

**File**: `backend/Dockerfile`

```dockerfile
# Multi-stage build for optimized image size
FROM python:3.12-slim as builder

WORKDIR /app

# Install uv
RUN pip install uv

# Copy dependency files
COPY pyproject.toml uv.lock ./

# Install dependencies
RUN uv sync --frozen --no-dev

# Runtime stage
FROM python:3.12-slim

WORKDIR /app

# Copy virtual environment from builder
COPY --from=builder /app/.venv /app/.venv

# Copy application code
COPY ./app ./app
COPY ./alembic ./alembic
COPY ./alembic.ini ./alembic.ini

# Set PATH to use virtual environment
ENV PATH="/app/.venv/bin:$PATH"

# Create non-root user
RUN useradd -m -u 1000 appuser && chown -R appuser:appuser /app
USER appuser

EXPOSE 8000

CMD ["uvicorn", "app.main:app", "--host", "0.0.0.0", "--port", "8000", "--workers", "2"]
```

### Step 4.4: Set Secrets

```bash
# Set all secrets at once
flyctl secrets set \
  DATABASE_URL="postgresql+asyncpg://user:pass@host/db" \
  REDIS_URL="redis://upstash-url" \
  UPSTASH_REDIS_REST_URL="https://..." \
  UPSTASH_REDIS_REST_TOKEN="..." \
  ANTHROPIC_API_KEY="sk-ant-..." \
  OPENAI_API_KEY="sk-..." \
  SECRET_KEY="$(openssl rand -hex 32)" \
  SENTRY_DSN="https://...@sentry.io/..." \
  ALLOWED_ORIGINS="https://labor-law.vercel.app"

# Verify secrets are set (values are hidden)
flyctl secrets list
```

### Step 4.5: Deploy to Fly.io

```bash
# First deployment
flyctl deploy

# Watch logs
flyctl logs

# Check status
flyctl status

# Test health endpoint
curl https://labor-law-backend.fly.dev/health
```

### Step 4.6: Run Database Migrations

```bash
# Option 1: Run locally (connect to production DB)
export DATABASE_URL="postgresql+asyncpg://..."
uv run alembic upgrade head

# Option 2: Run in Fly.io container
flyctl ssh console
cd /app
python -m alembic upgrade head
exit
```

---

## Phase 5: Frontend Deployment (1 hour)

### Step 5.1: Configure Vercel Project

**Via Web UI**:
1. Go to https://vercel.com/new
2. Import Git Repository: `your-org/labor-law-assistant`
3. Framework Preset: `Next.js`
4. Root Directory: `frontend`
5. **Don't deploy yet** — set environment variables first

### Step 5.2: Set Environment Variables

**Production Environment Variables** (via Vercel Dashboard):

```bash
# Public (exposed to browser)
NEXT_PUBLIC_API_URL=https://labor-law-backend.fly.dev
NEXT_PUBLIC_SENTRY_DSN=https://...@sentry.io/...
NEXT_PUBLIC_ENVIRONMENT=production

# Server-side only
NEXTAUTH_URL=https://labor-law.vercel.app
NEXTAUTH_SECRET=<generate with `openssl rand -base64 32`>
DATABASE_URL=<same as backend, for NextAuth.js session storage>
```

**To set via CLI**:
```bash
cd frontend

vercel env add NEXT_PUBLIC_API_URL production
# Paste: https://labor-law-backend.fly.dev

vercel env add NEXTAUTH_SECRET production
# Paste: <generated secret>

# Repeat for all variables
```

### Step 5.3: Configure `vercel.json`

**File**: `frontend/vercel.json`

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
        },
        {
          "key": "Referrer-Policy",
          "value": "strict-origin-when-cross-origin"
        }
      ]
    }
  ]
}
```

### Step 5.4: Deploy to Vercel

```bash
cd frontend

# Deploy to production
vercel --prod

# Output: https://labor-law.vercel.app

# Test deployment
curl https://labor-law.vercel.app
```

---

## Phase 6: CI/CD Setup (2 hours)

### Step 6.1: Add GitHub Secrets

```bash
# Using GitHub CLI
gh secret set FLY_API_TOKEN --body "<from https://fly.io/user/personal_access_tokens>"
gh secret set VERCEL_TOKEN --body "<from https://vercel.com/account/tokens>"
gh secret set VERCEL_ORG_ID --body "<from vercel.json or dashboard>"
gh secret set VERCEL_PROJECT_ID --body "<from vercel.json or dashboard>"
gh secret set PRODUCTION_DATABASE_URL --body "postgresql://..."
gh secret set ANTHROPIC_API_KEY --body "sk-ant-..."
gh secret set OPENAI_API_KEY --body "sk-..."

# Verify secrets are set
gh secret list
```

### Step 6.2: Create Deployment Workflow

**File**: `.github/workflows/deploy.yml`

```yaml
name: Deploy

on:
  push:
    branches: [main]
  pull_request:
    branches: [main]

jobs:
  # ============================================
  # Phase 1: Quality Checks
  # ============================================

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
        env:
          DATABASE_URL: postgresql+asyncpg://postgres:postgres@localhost:5432/test_db
          REDIS_URL: redis://localhost:6379/0
      - uses: codecov/codecov-action@v3

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

  # ============================================
  # Phase 2: Build Docker Image (only on main)
  # ============================================

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

  # ============================================
  # Phase 3: Deploy (only on main)
  # ============================================

  deploy-backend:
    needs: build-backend
    runs-on: ubuntu-latest
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

  # ============================================
  # Phase 4: Post-Deployment Tasks
  # ============================================

  migrate-database:
    needs: deploy-backend
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: astral-sh/setup-uv@v5
      - uses: actions/setup-python@v5
      - run: uv sync
        working-directory: backend
      - run: uv run alembic upgrade head
        working-directory: backend
        env:
          DATABASE_URL: ${{ secrets.PRODUCTION_DATABASE_URL }}

  smoke-test:
    needs: [deploy-backend, deploy-frontend]
    runs-on: ubuntu-latest
    steps:
      - name: Test backend health
        run: |
          curl --fail https://labor-law-backend.fly.dev/health || exit 1
      - name: Test frontend
        run: |
          curl --fail https://labor-law.vercel.app || exit 1
```

### Step 6.3: Test Deployment Workflow

```bash
# Make a small change
echo "# Test deployment" >> README.md

# Commit and push
git add README.md
git commit -m "test: trigger deployment workflow"
git push origin main

# Watch workflow
gh workflow view deploy
gh run watch
```

---

## Phase 7: Monitoring Setup (1 hour)

### Step 7.1: Configure Sentry

**Backend** (`backend/app/main.py`):

```python
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.sqlalchemy import SqlalchemyIntegration

sentry_sdk.init(
    dsn=os.getenv("SENTRY_DSN"),
    environment=os.getenv("ENVIRONMENT", "development"),
    traces_sample_rate=1.0 if os.getenv("ENVIRONMENT") == "development" else 0.1,
    profiles_sample_rate=0.1,
    integrations=[
        FastApiIntegration(),
        SqlalchemyIntegration(),
    ],
)
```

**Frontend** (`frontend/sentry.client.config.ts`):

```typescript
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_ENVIRONMENT,
  tracesSampleRate: 1.0,
  replaysOnErrorSampleRate: 1.0,
  replaysSessionSampleRate: 0.1,
});
```

### Step 7.2: Set Up BetterStack Uptime Monitoring

1. Go to https://betterstack.com/uptime
2. Add monitors:
   - **Backend Health**: `https://labor-law-backend.fly.dev/health` (every 1 min)
   - **Frontend**: `https://labor-law.vercel.app` (every 1 min)
   - **API Endpoint**: `https://labor-law-backend.fly.dev/api/v1/health` (every 1 min)
3. Configure alerts:
   - Slack webhook: `https://hooks.slack.com/services/...`
   - Email: `your-team@example.com`

### Step 7.3: Set Up Grafana Cloud

1. Go to https://grafana.com/auth/sign-up/create-user
2. Create stack (free tier)
3. Copy Prometheus remote write endpoint
4. Configure Fly.io metrics export:

```bash
# Add to fly.toml
[metrics]
  port = 9091
  path = "/metrics"

# Deploy
flyctl deploy
```

5. Add Prometheus data source in Grafana:
   - URL: `https://labor-law-backend.fly.dev:9091/metrics`
   - Auth: None (public metrics endpoint)

---

## Phase 8: Domain & SSL (30 minutes)

### Step 8.1: Configure Cloudflare DNS

**If you own a domain** (e.g., `labor-law.tw`):

1. Go to Cloudflare dashboard
2. Add site: `labor-law.tw`
3. Update nameservers at your registrar to Cloudflare's
4. Add DNS records:

```
Type  Name  Content                     Proxy
A     @     76.76.21.21                 ✅ Proxied (Vercel)
CNAME api   labor-law-backend.fly.dev   ✅ Proxied
CNAME www   labor-law.vercel.app        ✅ Proxied
```

5. SSL/TLS settings:
   - Mode: `Full (strict)`
   - Always Use HTTPS: `On`
   - Automatic HTTPS Rewrites: `On`

### Step 8.2: Configure Custom Domain on Vercel

1. Go to Vercel project settings → Domains
2. Add domain: `labor-law.tw`
3. Add domain: `www.labor-law.tw`
4. Vercel will provide DNS records (already set in Cloudflare)
5. Wait for DNS propagation (~5 minutes)

### Step 8.3: Configure Custom Domain on Fly.io

```bash
# Add certificate for api.labor-law.tw
flyctl certs create api.labor-law.tw

# Check certificate status
flyctl certs show api.labor-law.tw

# Update ALLOWED_ORIGINS
flyctl secrets set ALLOWED_ORIGINS="https://labor-law.tw,https://www.labor-law.tw"
```

### Step 8.4: Verify SSL

```bash
# Test HTTPS
curl -I https://labor-law.tw
curl -I https://api.labor-law.tw/health

# Check SSL grade
open https://www.ssllabs.com/ssltest/analyze.html?d=labor-law.tw
```

---

## Phase 9: Final Verification (30 minutes)

### Step 9.1: Smoke Test Checklist

- [ ] Frontend loads: `https://labor-law.tw`
- [ ] Backend health check: `https://api.labor-law.tw/health`
- [ ] API responds: `curl https://api.labor-law.tw/api/v1/query -d '{"query":"加班費怎麼算"}'`
- [ ] Database connected: Check backend logs for no connection errors
- [ ] Redis connected: Check cache hit logs
- [ ] Sentry receiving errors: Trigger test error
- [ ] BetterStack monitoring: All green
- [ ] SSL certificate valid: No browser warnings

### Step 9.2: Performance Benchmarks

```bash
# Test response time from Taiwan
curl -w "@curl-format.txt" -o /dev/null -s https://api.labor-law.tw/health

# curl-format.txt:
# time_namelookup:  %{time_namelookup}s\n
# time_connect:     %{time_connect}s\n
# time_total:       %{time_total}s\n

# Expected results:
# time_namelookup:  0.05s  (DNS lookup)
# time_connect:     0.15s  (TCP handshake)
# time_total:       0.25s  (total time)
```

### Step 9.3: Load Testing (Optional)

```bash
# Install k6
brew install k6

# Create load test script
cat > load-test.js <<EOF
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '30s', target: 10 },
    { duration: '1m', target: 10 },
    { duration: '30s', target: 0 },
  ],
};

export default function () {
  const res = http.get('https://api.labor-law.tw/health');
  check(res, {
    'status is 200': (r) => r.status === 200,
    'response time < 500ms': (r) => r.timings.duration < 500,
  });
  sleep(1);
}
EOF

# Run load test
k6 run load-test.js
```

---

## Phase 10: Documentation (1 hour)

### Step 10.1: Update README

Add deployment information to `README.md`:

```markdown
## Deployment

### Production URLs
- Frontend: https://labor-law.tw
- Backend API: https://api.labor-law.tw
- API Docs: https://api.labor-law.tw/docs

### Infrastructure
- **Frontend**: Vercel (Next.js 15)
- **Backend**: Fly.io Hong Kong (FastAPI)
- **Database**: Neon Postgres (pgvector)
- **Redis**: Upstash (global edge)
- **Monitoring**: Sentry + Grafana + BetterStack

### Deployment Process
1. Push to `main` branch triggers CI/CD
2. GitHub Actions runs tests
3. Docker image built and pushed to GHCR
4. Fly.io deploys backend
5. Vercel deploys frontend
6. Database migrations run automatically

### Manual Deployment
\`\`\`bash
# Backend
cd backend
flyctl deploy

# Frontend
cd frontend
vercel --prod
\`\`\`

### Rollback
\`\`\`bash
# Backend
flyctl releases rollback

# Frontend
vercel rollback
\`\`\`
```

### Step 10.2: Create Runbook

**File**: `docs/runbooks/deployment.md`

```markdown
# Deployment Runbook

## Emergency Rollback

### Backend
\`\`\`bash
flyctl releases list
flyctl releases rollback <version>
\`\`\`

### Frontend
\`\`\`bash
vercel rollback <deployment-url>
\`\`\`

## Database Migration Rollback
\`\`\`bash
# Downgrade one version
uv run alembic downgrade -1

# Downgrade to specific version
uv run alembic downgrade <revision>
\`\`\`

## Incident Response

### Backend Down
1. Check Fly.io status: \`flyctl status\`
2. View logs: \`flyctl logs\`
3. Check database: Test Neon connection
4. Rollback if needed: \`flyctl releases rollback\`

### High Error Rate
1. Check Sentry dashboard
2. Review recent deployments
3. Check external API status (Claude, OpenAI)
4. Scale up if needed: \`flyctl scale count 2\`

### Database Issues
1. Check Neon dashboard for suspended instance
2. Verify connection pool not exhausted
3. Review slow queries in Neon insights
4. Consider upgrading tier if needed
```

---

## Troubleshooting

### Issue: Fly.io deployment fails

**Symptoms**: `flyctl deploy` returns error

**Solutions**:
```bash
# Check logs
flyctl logs

# Common issues:
# 1. Secrets not set
flyctl secrets list

# 2. Build fails
docker build -t test-build -f backend/Dockerfile backend/

# 3. Health check fails
curl https://your-app.fly.dev/health
```

### Issue: Vercel build fails

**Symptoms**: Build logs show error

**Solutions**:
```bash
# Check build logs in Vercel dashboard

# Common issues:
# 1. Environment variables missing
vercel env ls

# 2. Node version mismatch
# Add to package.json:
"engines": {
  "node": ">=20.0.0"
}

# 3. Build command wrong
# Check vercel.json buildCommand
```

### Issue: Database connection timeout

**Symptoms**: Backend logs show "connection timeout"

**Solutions**:
```bash
# 1. Check Neon instance is not suspended
# Go to Neon dashboard → check if paused

# 2. Test connection manually
psql $DATABASE_URL -c "SELECT 1;"

# 3. Check connection pool settings
# In backend/app/database.py:
# pool_size=5, max_overflow=10

# 4. Upgrade Neon tier if free tier exhausted
```

---

## Next Steps After Deployment

1. **Monitor for 24 hours**
   - Check error rates in Sentry
   - Review response times in Grafana
   - Monitor costs in provider dashboards

2. **Set up alerts**
   - Configure Sentry alert rules
   - Set up Slack notifications
   - Create PagerDuty integration (if needed)

3. **Optimize performance**
   - Enable Redis caching
   - Add database indexes
   - Optimize slow queries

4. **Documentation**
   - Document any issues encountered
   - Update runbooks
   - Share deployment learnings with team

5. **Security hardening**
   - Rotate secrets
   - Enable rate limiting
   - Set up WAF rules in Cloudflare

---

## Cost Monitoring

### Weekly Cost Check

```bash
# Fly.io
flyctl billing show

# Neon (check dashboard)
open https://console.neon.tech/billing

# Upstash (check dashboard)
open https://console.upstash.com/billing

# Vercel (check dashboard)
open https://vercel.com/account/billing
```

### Set Budget Alerts

1. **Fly.io**: Email alerts at $10, $20, $50
2. **Vercel**: Spend limit at $50/month
3. **Neon**: Email alerts at $20
4. **Claude API**: Budget alert at $50/day
5. **OpenAI**: Budget alert at $50/month

---

## Summary

You now have a production-ready deployment with:

✅ Backend API running on Fly.io (Hong Kong)
✅ Frontend on Vercel with global CDN
✅ PostgreSQL (pgvector) on Neon
✅ Redis caching on Upstash
✅ CI/CD with GitHub Actions
✅ Monitoring with Sentry + BetterStack + Grafana
✅ SSL certificates with Cloudflare
✅ Automated database migrations

**Total setup time**: 8-12 hours
**Total cost**: $6/month (MVP) → scales to $172/month at 10K MAU

**Questions?** See the [full deployment strategy](./deployment-infrastructure-strategy.md) for detailed explanations.

---

**Last Updated**: 2026-03-02
