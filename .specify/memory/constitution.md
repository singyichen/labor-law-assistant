# Labor Law Assistant Constitution

## Core Principles

### I. Legal Accuracy (NON-NEGOTIABLE)

- All legal content MUST cite specific Taiwan labor law articles (e.g., Labor Standards Act SS24)
- LLM responses MUST include `confidence_score` and `source_articles`; confidence < 0.7 or empty sources triggers mandatory disclaimer
- Legal calculation modules require 95% test coverage with government calculator cross-validation
- Legal calculation errors are automatically classified as Critical severity
- Fabricated legal information is strictly prohibited; when uncertain, the system MUST direct users to the 1955 hotline or qualified legal professionals

### II. Spec-First Development (RECOMMENDED)

- New feature development SHOULD begin with a specification in `specs/`
- Use `/speckit.specify` to create feature specs before implementation
- Completed features are marked with `touch specs/<feature-dir>/.completed`
- Stop hook provides reminders for active specs; enforcement relies on code review and developer discipline
- Bug fixes and emergency hotfixes may skip spec creation based on complexity and urgency

### III. Privacy by Design

- PII (name, national ID, phone, salary) MUST be anonymized in logging and LLM prompts
- Redis session data retention MUST NOT exceed 24 hours
- PostgreSQL persistent storage requires explicit user consent
- CORS MUST NOT use `allow_origins=["*"]`; only explicitly listed origins are allowed
- API keys, tokens, and secrets MUST NOT be hardcoded; use environment variables or secret manager

### IV. Communication Protocol

- User-facing conversation MUST use Traditional Chinese (zh-TW)
- Technical terms retain English form (e.g., P-value, API, JWT)
- Variable names, function names, and string literals MUST be written in English; new or modified comments (docstrings and inline) MUST be written in Traditional Chinese; existing English comments do not require retroactive conversion
- All newly produced documents, commit messages, and spec files MUST be written in Traditional Chinese; existing base config files (constitution, templates, scripts) remain in English; spec template headings remain in English, content is written in Traditional Chinese
- Legal terminology MUST use official MOL terminology

### V. Incremental Delivery

- Each edit MUST leave the codebase in a working state
- Read related files before modifying code to ensure architectural compatibility
- Test-first: proactively ask whether to write or update tests
- Clean up before completion: remove debug statements, dead code, and rejected approach remnants
- `# TODO` comments MUST include an issue number (e.g., `# TODO(#123): implement rate limiting`)

### VI. Observability and Resilience

- structlog logging MUST include `request_id`, `user_id`, `endpoint` context
- Primary LLM timeout (>45s), rate limit (429), or service unavailable (503) triggers automatic fallback to GPT-4o-mini
- SSE streaming for LLM responses; target TTFB < 2s, chunk latency < 200ms
- API performance targets: p95 < 500ms, p99 < 1s, error rate < 0.5%
- Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1

## Technical Stack

> **This is the authoritative technical standard; all documents and implementations MUST comply.**

### Runtime & Package Management

| Component | Technology | Version | Notes |
|-----------|-----------|---------|-------|
| **Python** | Python | 3.12+ | Backend language |
| **Package Manager (Backend)** | uv | latest | Replaces pip/poetry |
| **Node.js** | Node.js | 20+ | Frontend runtime |
| **Package Manager (Frontend)** | pnpm | latest | Frontend dependencies |

### Core Framework

| Component | Technology | Notes |
|-----------|-----------|-------|
| **Backend** | FastAPI | REST API server |
| **ORM** | SQLAlchemy 2.0 + asyncpg | Async database access |
| **Frontend** | Next.js 15 (App Router) | SSR, UI components |
| **UI** | shadcn/ui + Tailwind CSS | Component library |
| **State** | TanStack Query + Zustand | Client state management |

### AI / ML

| Component | Technology | Notes |
|-----------|-----------|-------|
| **LLM (Primary)** | Anthropic Claude Sonnet 4.5 | Legal Q&A generation |
| **LLM (Fallback)** | OpenAI GPT-4o-mini | Automatic fallback |
| **Embedding** | OpenAI text-embedding-3-large | 1536 dims |
| **Vector Search** | pgvector | PostgreSQL extension |

### Infrastructure

| Component | Technology | Notes |
|-----------|-----------|-------|
| **Database** | PostgreSQL + pgvector | Neon Postgres |
| **Cache** | Redis (Upstash) | Serverless, global edge |
| **Deployment (FE)** | Vercel | Global CDN |
| **Deployment (BE)** | Fly.io | Hong Kong region |
| **CI/CD** | GitHub Actions | Automated pipelines |

### Development Tools

| Component | Technology | Notes |
|-----------|-----------|-------|
| **Linting (Python)** | Ruff | Check + format |
| **Type Check (Python)** | mypy | Strict mode |
| **Testing (Python)** | pytest + pytest-asyncio | Unit + integration |
| **Linting (TS)** | ESLint + Prettier | Code quality |
| **Testing (TS)** | Vitest + Playwright | Unit + E2E |

## Quality Gates

### Testing Requirements

- General code coverage: 80% minimum
- Legal module coverage: 95% minimum (app/services/legal/, app/utils/calculator/, frontend/components/calculator/)
- Frontend legal calculators: golden dataset cross-validation required
- All prompt templates in `app/prompts/` must have variable substitution tests

### Code Quality

- All code MUST pass Ruff check (Python) and ESLint (TypeScript)
- Python functions MUST have type hints and Google-style docstrings (new or modified docstrings written in Traditional Chinese)
- TypeScript strict mode; `any` type is prohibited
- pre-commit hooks enforce `ruff format` and `ruff check --fix`

### Performance Requirements

- API p95 < 500ms, p99 < 1s
- LLM streaming TTFB < 2s
- Frontend initial JS < 200KB (gzipped)
- Core Web Vitals: LCP < 2.5s, FID < 100ms, CLS < 0.1

## Governance

- This constitution is the highest governing document for the project
- All Specs, Plans, and implementations MUST comply with constitution principles
- Technical stack changes MUST be documented in an ADR before updating the constitution
- PR merges MUST verify constitution compliance
- Constitution amendments require explicit documentation of change rationale and version update

---

**Version**: 1.2.0 | **Ratified**: 2026-03-12 | **Last Amended**: 2026-03-17
