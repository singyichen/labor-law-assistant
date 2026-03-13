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
│   │   ├── prompts/         # LLM prompt templates (testable, version-controlled)
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
├── specs/                   # Feature specifications (spec-kit)
│   └── NNN-feature-name/    # Each feature gets a numbered directory
│       ├── spec.md           # Feature specification
│       ├── plan.md           # Implementation plan
│       ├── tasks.md          # Task breakdown
│       ├── research.md       # Research notes
│       ├── data-model.md     # Data model design
│       ├── contracts/        # API contracts
│       ├── checklists/       # Quality checklists
│       └── .completed        # Marker file when feature is done
├── .specify/                # Spec-kit configuration
│   ├── memory/
│   │   └── constitution.md  # Project constitution (6 core principles)
│   └── templates/           # Spec-kit templates (spec, plan, tasks, checklist)
├── scripts/bash/            # Spec-kit shell scripts
├── docs/                    # Project documentation
│   ├── adr/                 # Architecture Decision Records (10 ADRs)
│   ├── prd/                 # Product Requirements Document
│   │   ├── README.md        # Product-level PRD (vision, users, NFR, timeline)
│   │   └── epics/           # Feature specs per epic (7 epics)
│   ├── design/              # UX wireframes and interaction flows
│   ├── testing/             # Testing strategy
│   └── strategy/            # Strategic planning documents
└── .claude/                 # Claude Code configuration
    ├── commands/             # 5 workflow + 9 spec-kit commands
    ├── skills/               # 28 knowledge-domain skills (6 categories)
    ├── agents/               # Agent definitions
    ├── hooks/                # Spec enforcement hooks (check-spec.sh, remind-spec.sh)
    ├── settings.json         # Hooks configuration (shared via git)
    ├── SKILLS.md             # Skills & commands directory
    └── AGENTS.md             # Agents reference
```

## Communication

- **繁體中文優先**：新產出的文件、註解、commit message、spec 文件皆以繁體中文撰寫；既有基礎設定檔（constitution、templates、scripts）維持英文
- 對話總是用繁體中文回覆、唯有專有技術名詞以英文呈現（例如 P-value）
- 程式碼中的變數名、函數名、string literals 以英文撰寫；註解（含 docstring 與 inline comment）以繁體中文撰寫

## Code Style

### Python (Backend)

- 使用 4 格縮排
- 變數命名使用 snake_case（禁止單字母變數）
- 所有函數必須有 docstring（Google style：`Args:`, `Returns:`, `Raises:`，以繁體中文撰寫），清楚定義用途、參數、依賴關係、和預期回傳類型
- 使用 pytest 而非 unittest
- 函數必須有完整的 type hints
- 優先使用 f-string 而非 format()

### TypeScript (Frontend)

- 使用 2 格縮排
- 變數命名使用 camelCase，React 元件使用 PascalCase
- 使用 TypeScript strict mode，禁止 `any` 類型
- 優先使用 functional components + hooks
- 使用 `interface` 定義 props，使用 `type` 定義聯合/交叉類型
- JSDoc 使用 `@param`, `@returns`, `@throws` 標籤

## General Coding Rules

### 命名規範
- 使用有意義的英文單字，符合語言生態圈慣例
- 優先參考既有程式碼命名風格；如需優化，先完成功能後再向使用者建議

### 程式碼結構與品質
- **設計原則**：遵循 SOLID（適用 service layer）、DRY、KISS、YAGNI 原則——當 DRY 導致過度抽象時，KISS 優先；不為假設性未來需求編寫程式碼（YAGNI）
- **單一職責**：每個函式只做一件事，每個模組只負責一個關注點
- **穩健性**：關鍵邏輯必須包含基本的錯誤處理（Error Handling）與邊界檢查
- **依賴管理**：優先使用現有函式庫，避免不必要的外部套件引入或重複安裝

### 安全性規則（Backend）
- **輸入驗證**：所有使用者輸入必須經過驗證與清理，防止 SQL Injection、XSS 攻擊
- **PII 保護**：涉及個人識別資訊（姓名、身分證、電話、薪資等）必須在 logging 和 LLM prompt 中匿名化；Redis session 資料保留不超過 24 小時，PostgreSQL 持久化需使用者明確同意
- **CORS 設定**：不得使用 `allow_origins=["*"]`，必須明確列出允許的來源
- **CSRF 防護**：接受 cookie authentication 的 API 路由必須驗證 CSRF token
- **機密管理**：嚴禁將 API Keys、tokens 或其他機密資訊硬編碼於程式碼中，必須使用環境變數或 secret manager
- **依賴安全**：CI/CD pipeline 中整合 `uv run pip-audit`，Critical/High 級別漏洞阻斷部署

### 安全性規則（Frontend）
- **XSS 防護**：禁止使用 `dangerouslySetInnerHTML`，使用 react-markdown 渲染使用者內容
- **環境變數**：僅 `NEXT_PUBLIC_` 前綴的變數可暴露至前端，敏感 API key 必須透過 backend proxy 呼叫
- **依賴安全**：CI/CD pipeline 中整合 `pnpm audit`，Critical/High 級別漏洞阻斷部署

### 非同步與併發
- **I/O 操作**：資料庫查詢、外部 API 呼叫、檔案讀寫優先使用 `async def`；簡單同步 ORM 操作可使用 `run_in_threadpool`，但必須在 docstring 說明理由
- **禁止阻塞**：async context 中禁止使用 `time.sleep()`、同步 HTTP 請求等阻塞操作
- **連線池管理**：PostgreSQL pool: `min_size=10, max_size=50, timeout=30s`（env: `DB_POOL_MIN`, `DB_POOL_MAX`）；Redis pool: `max_connections=50, timeout=5s`（env: `REDIS_POOL_MAX`）
- **並行限制**：對外部 API 呼叫使用 `asyncio.Semaphore`，上限從環境變數 `MAX_LLM_CONCURRENCY` 讀取（預設 20，依 API tier 調整：Tier 1=10, Tier 2=30, Tier 3=50）
- **背景任務**：耗時操作（PDF 生成、批量匯入）使用 background task 處理，超過 5 秒的操作提供進度回報

### 資料庫規則
- **Migration**：所有 schema 變更必須透過 Alembic migration，禁止手動修改資料庫
- **N+1 預防**：一對多關係使用 `selectinload()`（2 次查詢），多對一使用 `joinedload()`（單次 JOIN）；避免在 nested relationship 使用 `joinedload`
- **Transaction 管理**：多步驟寫入操作必須包裝在 transaction 中，確保原子性
- **Index 規劃**：關聯欄位必須建立適當索引；pgvector HNSW index 參數：`m=32, ef_construction=128`，查詢時 `ef_search=80`（1536 維向量，目標 recall > 0.95、latency < 50ms）
- **查詢效能**：避免 `SELECT *`，使用 `load_only()` 明確指定所需欄位；結果集 > 100 筆必須使用 cursor-based pagination（keyset pagination）
- **Query Timeout**：API 查詢 statement timeout 設為 10s，admin 操作設為 60s；監控超過 1s 的 slow query（via `pg_stat_statements`）
- **Denormalization**：讀取比例 > 80% 的資料可考慮反正規化搭配定期同步，須記錄 trade-off 於 ADR

### RAG/LLM 規則
- **Prompt 可測試性**：所有 prompt template 統一放置於 `app/prompts/` 目錄，每個 prompt 配套測試驗證變數替換正確性
- **幻覺預防**：LLM 回應必須包含 `confidence_score` 和 `source_articles`；confidence < 0.7 或 source 為空時，強制附加免責聲明（初始目標值，待 beta 上線後依實際 precision/recall 數據調整，記錄於 ADR，季度複審）
- **快取策略**：分層快取——向量搜尋結果 Redis key: `qa:hash:{question_hash}:{context_hash}`, TTL: 1h；LLM 回應 TTL: 1h；法規內容更新時透過 admin 端點主動 invalidate；目標 cache hit rate > 60%（初始目標值，依上線後實際數據調整）
- **Fallback 機制**：主要 LLM timeout（>45s）、rate limit（429）、service unavailable（503）時自動切換至 GPT-4o-mini（fallback timeout: 30s），並記錄 fallback event 至 structlog
- **Streaming 回應**：使用 SSE 串流 LLM 回應，Backend 使用 `async for chunk in llm.stream()`，Frontend 使用 Vercel AI SDK `useChat`；目標 TTFB < 2s，chunk latency < 200ms，streaming timeout: 60s
- **RAG 查詢品質**：法條文本 chunk size 設為 1024 tokens，overlap 20%；hybrid search（pgvector cosine + full-text search）以 RRF 合併（k=60）；Top-K=5，rerank 後保留 Top-3（高 confidence > 0.9 可縮減至 Top-2，複雜查詢擴展至 Top-5）。以上為初始參數，須在 beta 階段透過 A/B test 驗證並記錄於 ADR
- **Batch Embedding**：批量向量化操作每次最多 100 chunks，使用 `asyncio.gather` 並行處理多批次；embedding API latency 目標 p99 < 500ms

### 錯誤處理與 Logging
- **Backend**：使用自定義 `HTTPException` 子類別（如 `ValidationError`, `LegalContentError`）統一錯誤格式；structlog 必須包含 `request_id`, `user_id`, `endpoint` context
- **Frontend**：使用 TanStack Query 的 `onError` 統一處理 API 錯誤，避免分散的 try-catch
- **Log Level**：INFO（正常流程）、WARNING（降級/fallback）、ERROR（失敗需介入）

### 註解與文件
- 註解僅限於解釋「為什麼（Why）」而非「做什麼（What）」——程式碼本身應具備自解釋性
- Docstring 用於定義函式的用途與契約（參數、回傳值），inline 註解用於解釋非直覺的邏輯
- 除非使用者要求，否則不主動撰寫外部 Markdown 文件

### Lint 修復
- 略過非安全性規則（排版、import 順序等），交由 ruff format 自動處理；pre-commit hook 已配置 `ruff format` 和 `ruff check --fix`，commit 前自動格式化
- 安全性或錯誤預測類提示（如 memory leak、潛在 null pointer），應先向使用者回報再修改

### AI 工作流程

#### Spec-Kit Workflow

新功能開發必須依照以下流程進行：

```
/speckit.specify <功能描述>  → specs/NNN-feature/spec.md（規格文件）
/speckit.clarify             → 釐清規格疑問（可選）
/speckit.plan                → specs/NNN-feature/plan.md（實作計畫）
/speckit.tasks               → specs/NNN-feature/tasks.md（任務清單）
/speckit.analyze             → 跨文件一致性分析（可選）
/speckit.implement           → 執行實作
```

**重要規則**：
- 不可跳過 `/speckit.specify` 直接寫程式碼（PreToolUse hook 強制執行，無 spec 時程式碼寫入會被阻擋）
- 每個 spec 目錄包含：spec.md, plan.md, tasks.md, checklists/
- 遵循 User Story 優先順序（P1 → P2 → P3）進行實作
- 功能完成後執行 `touch specs/<feature-dir>/.completed` 標記完成

#### Constitution Reference

所有開發必須遵循 [constitution.md](.specify/memory/constitution.md) 的 6 個核心原則：
1. **Legal Accuracy**（NON-NEGOTIABLE）— 法律內容必須引用具體法條，confidence < 0.7 強制免責聲明
2. **Spec-First Development**（NON-NEGOTIABLE）— 先寫 spec 再寫程式碼
3. **Privacy by Design** — PII 匿名化、session 24h TTL、禁止硬編碼機密
4. **Communication Protocol** — 繁中優先（新文件、註解、commit message；基礎設定檔維持英文）、英文變數/函數名、MOL 官方術語
5. **Incremental Delivery** — 最小增量、測試優先、完成前清理
6. **Observability and Resilience** — structlog context、LLM fallback、streaming SLO

#### AI Agent 行為準則

**禁止事項**：
1. 不要擅自修改 `pyproject.toml` 或 `package.json` 中的版本號，除非使用者明確要求
2. 不要使用 `pip install` 直接安裝套件，Backend 使用 `uv add`，Frontend 使用 `pnpm add`
3. 不要擅自變更 linter、formatter、測試框架等工具設定
4. 不要在未讀取檔案的情況下提出修改建議

**必須遵守**：
1. Backend 所有 Python 指令必須透過 `uv run` 執行（如 `uv run pytest`、`uv run mypy .`）
2. 修改前必先閱讀相關檔案內容，確保新程式碼與整體架構相容
3. 若專案已有 `/tests` 目錄，主動詢問是否同步撰寫或更新測試
4. 任務結束前清理：刪除 debug 用的 `print`/`console.log`、被駁回方案的遺留程式碼
5. `# TODO` 必須包含 issue number（如 `# TODO(#123): implement rate limiting`），不得保留無 context 的 `# FIXME`

### API 設計規範
- **版本控制**：MVP 階段（pre-v1.0）breaking change 可在 `/api/v1/` 內迭代，搭配 changelog 記錄；正式上線後 breaking change 必須增加版本號（`/api/v2/`），舊版本保留至少 3 個月並在 response header 加入 `X-Deprecation-Warning`
- **一致性**：所有 endpoint 回傳統一的 JSON 結構（`data`, `error`, `meta`），error 格式包含 `code` 和 `message`
- **Nested Resources**：API 回傳含巢狀資源時，必須在 docstring 標註使用的 loader（`selectinload` / `joinedload`），目標每 endpoint 查詢數 < 5

### 效能優化

#### Backend
- **快取策略**：GET endpoint 善用 Redis 快取，key 格式 `{service}:{resource}:{id}:{version}`；top 100 FAQ 查詢預熱（每 30 分鐘更新）
- **Cold Start**：app 啟動時預建 connection pool（`asyncpg.create_pool`）；health check endpoint 搭配 30s keepalive 防止休眠

#### Frontend
- **ISR**：內容頁面 `revalidate: 1800`（30min），純靜態頁面 `revalidate: 3600`；提供 on-demand revalidation 端點 `/api/revalidate?path=`
- **TanStack Query**：法律內容 `staleTime: 30min, cacheTime: 1h`；使用者資料 `staleTime: 5min, cacheTime: 10min`
- **Asset 優化**：使用 Next.js Image（WebP, quality=80），`next/font` 搭配 `display=swap`；lazy load below-fold 圖片
- **Bundle Size**：Initial JS < 200KB（gzipped），Total < 500KB；>50KB 元件使用 dynamic import；月度使用 `@next/bundle-analyzer` 分析

#### SLO 與監控
- **API 效能目標**：p95 < 500ms, p99 < 1s, error rate < 0.5%
- **告警閾值**：p99 > 2s（warning）、p99 > 5s（critical）、error rate > 1%（critical）
- **Core Web Vitals**：LCP < 2.5s, FID < 100ms, CLS < 0.1, TTFB < 800ms
- **Dashboard**：Grafana（latency, RPS, cache hit rate, LLM usage）+ Vercel Analytics（前端 RUM）

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

開發完成後，依序執行以下步驟（步驟 1-6 自動完成，步驟 7 Merge 需使用者確認）：

1. **Commit** — 使用正確的 type 提交變更
2. **Code Review** — 執行 `/review` command 審查所有變更（組合 code-review-checklist → code-review → code-smell → pr-review 四個 skill），根據審查結果修正問題
3. **測試驗證**（程式碼變更時）— 執行 `/test` command 驗證測試覆蓋率和品質（組合 test-plan → bdd-scenario → test-data-strategy → test-coverage 等六個 skill）
4. **Push** — 推送到遠端分支
5. **建立 PR** — Test Plan 中每個檢查項必須逐一驗證，已通過標記為 `[x]`，未通過保留 `[ ]` 並說明原因
6. **Qodo Code Review 修正** — PR 建立後 qodo-code-review bot 會自動審查，依以下流程處理：
   1. 取得 review findings：`gh api repos/{owner}/{repo}/pulls/{number}/comments --jq '.[] | {path, line, body}'`
   2. 逐一修正 findings，commit 並 push 到同一分支
   3. 取得 review thread IDs：`gh api graphql` 查詢 `reviewThreads`
   4. Resolve 已修正的 threads：`gh api graphql` 呼叫 `resolveReviewThread(input: {threadId: "PRRT_xxx"})`
   5. 注意：push 後 bot 會重新審查，需確認新一輪無新 findings 後再 merge
7. **Merge + 清理** — 確認使用者同意後執行以下步驟：
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

本專案提供 5 個 workflow commands 和 9 個 spec-kit commands。詳細說明見 [.claude/SKILLS.md](.claude/SKILLS.md)。

### Workflow Commands

| Command | 用途 | 觸發時機 |
|---------|------|---------|
| `/write` | 新功能實作（spec-kit → 需求 → 設計 → BDD → Code Review） | 開發新功能時 |
| `/review` | 程式碼審查（checklist → review → code smell → PR review） | PR 前自動執行 |
| `/test` | 測試規劃與執行（test plan → BDD → coverage → tracking） | 程式碼變更時自動執行 |
| `/fix` | Bug 修復（defect report → 探索測試 → regression） | 修復 bug 時 |
| `/release` | 發布準備（regression → traceability → quality gate） | 版本發布前 |

### Spec-Kit Commands

| Command | 用途 |
|---------|------|
| `/speckit.specify` | 從自然語言描述建立 feature spec |
| `/speckit.plan` | 建立技術實作計畫 |
| `/speckit.tasks` | 產生可執行的任務清單 |
| `/speckit.implement` | 依任務清單執行實作 |
| `/speckit.constitution` | 建立或更新專案 constitution |
| `/speckit.clarify` | 識別並釐清 spec 中的模糊點 |
| `/speckit.analyze` | 跨文件一致性分析 |
| `/speckit.checklist` | 產生品質驗證清單 |
| `/speckit.taskstoissues` | 將任務轉換為 GitHub Issues |

### 法律模組特殊要求

法律模組範圍：`app/services/legal/`、`app/utils/calculator/`、`frontend/components/calculator/`

- `/test` 法律模組 coverage 門檻為 95%（一般為 80%），前端計算元件必須使用 golden dataset 驗證
- `/review` 必須驗證法條引用和計算正確性
- `/fix` 法律計算錯誤自動分類為 Critical
- `/release` 法律合規為阻斷性品質門檻

## Important Notes

- 本專案為法律諮詢輔助系統，所有法律相關規則詳見：安全性規則（PII 保護）、RAG/LLM 規則（幻覺預防與免責聲明）、法律模組特殊要求（coverage 95%、法條驗證）

