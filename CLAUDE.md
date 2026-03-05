# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Labor Law Assistant - 台灣勞動法律查詢助手系統

## Tech Stack

### Backend
- Language: Python 3.12+
- Package Manager: uv
- Framework: FastAPI
- ORM: SQLAlchemy 2.0 + asyncpg
- Database: PostgreSQL + pgvector
- Migration: Alembic
- Config: pydantic-settings
- Linting/Formatting: ruff
- Type Checking: mypy (strict mode)
- Testing: pytest + pytest-asyncio + httpx

### Frontend
- Framework: Next.js 15 (App Router)
- Language: TypeScript (strict mode)
- Package Manager: pnpm
- UI: shadcn/ui + Tailwind CSS
- State: TanStack Query + Zustand
- Chat/Streaming: Vercel AI SDK + react-markdown
- Testing: Vitest + Playwright
- Linting: ESLint + Prettier

### Infrastructure
- Caching / Session: Redis (Upstash)
- Logging: structlog
- Error Tracking: Sentry
- Metrics: Prometheus + Grafana
- Log Aggregation: Grafana Loki
- Tracing: OpenTelemetry
- Uptime Monitoring: BetterStack

### Deployment
- Frontend: Vercel (global CDN)
- Backend: Fly.io (Hong Kong)
- Database: Neon Postgres (pgvector)
- Redis: Upstash (serverless, global edge)
- CDN / DNS: Cloudflare
- CI/CD: GitHub Actions
- Container: Docker Compose (dev) + multi-stage Dockerfile (prod)

### AI / ML
- LLM (Primary): Anthropic Claude Sonnet 4.5
- LLM (Fallback): OpenAI GPT-4o-mini
- Embedding: OpenAI text-embedding-3-large (1536 dims)
- Vector Search: pgvector (PostgreSQL extension, no separate vector DB)

### Auth
- Anonymous: UUID session cookie + Redis session
- Registered: NextAuth.js v5 (Google + Line Login) + JWT
- Session: Redis (24h TTL) → PostgreSQL (persistent)

Technical decisions are documented in [docs/adr/](docs/adr/).

## Development Commands

```bash
# Install dependencies (run from backend/)
cd backend
uv sync --dev

# Run the application
uv run uvicorn app.main:app --reload

# Run tests
uv run pytest

# Run tests with coverage
uv run pytest --cov=app --cov-report=term-missing

# Type checking
uv run mypy .

# Linting
uv run ruff check .

# Format code
uv run ruff format .

# Install pre-commit hooks (run from project root)
uv run pre-commit install

# --- Frontend (run from frontend/) ---
cd frontend
pnpm install

# Run dev server
pnpm dev

# Run tests
pnpm test

# Type checking
pnpm tsc --noEmit

# Linting
pnpm lint
```

## Architecture

```
labor-law-assistant/
├── backend/                 # Python FastAPI backend
│   ├── app/                 # Application source code
│   │   ├── api/routes/      # API route handlers
│   │   ├── core/            # Core logic, middleware, exceptions
│   │   ├── models/          # SQLAlchemy models
│   │   ├── schemas/         # Pydantic request/response schemas
│   │   ├── services/        # Service layer
│   │   ├── utils/           # Utility functions
│   │   ├── config.py        # Settings (pydantic-settings)
│   │   └── main.py          # FastAPI entry point
│   ├── tests/               # Test suite
│   │   ├── unit/            # Unit tests
│   │   └── integration/     # Integration tests
│   └── pyproject.toml       # Dependencies & tool configs
├── frontend/                # Next.js frontend
│   ├── app/                 # App Router pages
│   ├── components/          # React components
│   ├── lib/                 # Utilities and API client
│   └── stores/              # Zustand stores
├── docs/                    # Project documentation
│   ├── adr/                 # Architecture Decision Records (10 ADRs)
│   ├── prd/                 # Product Requirements Document
│   │   ├── README.md        # Product-level PRD (vision, users, NFR, timeline)
│   │   └── epics/           # Feature specs per epic (7 epics)
│   ├── design/              # UX wireframes and interaction flows
│   ├── testing/             # Testing strategy
│   └── strategy/            # Strategic planning documents
└── .claude/                 # Claude Code configuration
    ├── commands/             # 5 workflow commands (write, review, test, fix, release)
    ├── skills/               # 28 knowledge-domain skills (6 categories)
    ├── agents/               # Agent definitions
    ├── SKILLS.md             # Skills & commands directory
    └── AGENTS.md             # Agents reference
```

## Communication

- 對話總是用繁體中文回覆、唯有專有技術名詞以英文呈現（例如 P-value）
- 程式碼內容（包括 string）以及註解總是以英文撰寫

## Code Style

### Python (Backend)

- 使用 4 格縮排
- 變數命名使用 snake_case（禁止單字母變數）
- 所有函數必須有 docstring 說明，清楚定義其用途、所有參數、依賴關係、和預期回傳類型
- 使用 pytest 而非 unittest
- 函數必須有完整的 type hints
- 優先使用 f-string 而非 format()

### TypeScript (Frontend)

- 使用 2 格縮排
- 變數命名使用 camelCase，React 元件使用 PascalCase
- 使用 TypeScript strict mode，禁止 `any` 類型
- 優先使用 functional components + hooks
- 使用 `interface` 定義 props，使用 `type` 定義聯合/交叉類型

## Git Workflow

### Commit 規範

- 頻繁提交：每次完成一組功能後必須 commit
- 提交訊息請涵蓋變更的全部範圍，並保持訊息簡潔
- Commit message 格式：`<type>: <description>`，type 必須使用以下之一：

| Type | 用途 | 範例 |
|------|------|------|
| `feat` | 新功能 | `feat: add overtime calculator component` |
| `fix` | 修復 bug | `fix: correct leave calculation for part-time workers` |
| `docs` | 文件變更 | `docs: add API endpoint documentation` |
| `refactor` | 重構（不改變功能） | `refactor: extract PII detection into service class` |
| `test` | 測試相關 | `test: add unit tests for severance calculator` |
| `style` | 格式化（不影響邏輯） | `style: apply ruff formatting to api routes` |
| `chore` | 建構/工具/依賴 | `chore: upgrade FastAPI to 0.115` |
| `perf` | 效能優化 | `perf: add Redis caching for FAQ queries` |
| `ci` | CI/CD 變更 | `ci: add Playwright E2E tests to GitHub Actions` |

### 分支命名規範

- 格式：`<type>/<short-description>`，使用小寫英文和 `-` 連接
- type 與 commit type 對應：

| 分支前綴 | 用途 | 範例 |
|---------|------|------|
| `feat/` | 新功能開發 | `feat/overtime-calculator` |
| `fix/` | Bug 修復 | `fix/pii-regex-false-positive` |
| `docs/` | 文件更新 | `docs/testing-strategy` |
| `refactor/` | 重構 | `refactor/rag-pipeline` |
| `test/` | 測試補充 | `test/legal-accuracy-golden-data` |
| `chore/` | 建構/依賴 | `chore/upgrade-dependencies` |

### PR 完整流程

開發完成後，依序執行以下步驟（全部自動完成，不需等待使用者指示）：

1. **Commit** — 使用正確的 type 提交變更
2. **Code Review** — 執行 `/review` command 審查所有變更（組合 code-review-checklist → code-review → code-smell → pr-review 四個 skill），根據審查結果修正問題
3. **測試驗證**（程式碼變更時）— 執行 `/test` command 驗證測試覆蓋率和品質（組合 test-plan → bdd-scenario → test-data-strategy → test-coverage 等六個 skill）
4. **Push** — 推送到遠端分支
5. **建立 PR** — Test Plan 中每個檢查項必須逐一驗證，已通過標記為 `[x]`，未通過保留 `[ ]` 並說明原因
6. **Merge + 清理** — 自動執行以下步驟：
   1. `gh pr merge <number> --merge` — merge PR
   2. `git checkout main && git pull` — 切回 main 並拉取最新
   3. `git fetch --prune` — 清理已刪除的遠端分支追蹤
   4. `git branch -d <branch-name>` — 刪除本地分支
   5. `git push origin --delete <branch-name>` — 刪除遠端分支

> **純文件變更**（僅 `.md` 檔案）：可跳過步驟 3（`/test`），但仍需執行步驟 2（`/review`）確認交叉引用和內容一致性。

### 保護規則

- 永遠 *不要* 推送到 main 分支（main 或 master），避免干擾 prod 環境
- 開始實作新功能時必須建立並切換到新的 Git 分支

## Workflow Commands

本專案提供 5 個 workflow commands，每個 command 會自動組合多個 skill 執行。詳細說明見 [.claude/SKILLS.md](.claude/SKILLS.md)。

| Command | 用途 | 觸發時機 |
|---------|------|---------|
| `/write` | 新功能實作（需求 → 設計 → BDD → Code Review） | 開發新功能時 |
| `/review` | 程式碼審查（checklist → review → code smell → PR review） | PR 前自動執行 |
| `/test` | 測試規劃與執行（test plan → BDD → coverage → tracking） | 程式碼變更時自動執行 |
| `/fix` | Bug 修復（defect report → 探索測試 → regression） | 修復 bug 時 |
| `/release` | 發布準備（regression → traceability → quality gate） | 版本發布前 |

### 法律模組特殊要求

- `/test` 法律模組 coverage 門檻為 95%（一般為 80%）
- `/review` 必須驗證法條引用和計算正確性
- `/fix` 法律計算錯誤自動分類為 Critical
- `/release` 法律合規為阻斷性品質門檻

## Important Notes

- 法律內容必須準確且符合台灣最新勞動法規
- 所有法律資訊應附上適當的免責聲明
- 用戶輸入需要驗證和清理

