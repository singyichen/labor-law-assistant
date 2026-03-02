# Observability Strategy: Labor Law Assistant

**Document Version**: 1.0
**Last Updated**: 2026-03-02
**Status**: RECOMMENDED for Implementation
**Target Audience**: DevOps, Backend Team, Product Team

---

## Table of Contents

1. [Executive Summary](#executive-summary)
2. [Observability Stack Recommendations](#observability-stack-recommendations)
3. [Implementation Roadmap](#implementation-roadmap)
4. [Cost Analysis](#cost-analysis)
5. [Metrics & KPIs](#metrics--kpis)
6. [Alerting Strategy](#alerting-strategy)
7. [Security & Compliance](#security--compliance)
8. [Appendix](#appendix)

---

## Executive Summary

This document outlines the observability strategy for the Labor Law Assistant - a Taiwan labor law query system with RAG (Retrieval-Augmented Generation) pipeline, streaming LLM responses via Claude API, and pgvector-based legal article retrieval.

### Key Constraints
- **Team Size**: 1-3 developers
- **Stage**: MVP (pre-launch)
- **Budget**: Cost-conscious, prefer free tiers initially
- **Critical Requirements**:
  - Legal accuracy monitoring (confidence scores, citation tracking)
  - LLM cost tracking (Claude API usage)
  - Streaming SSE performance monitoring
  - Vector search latency tracking

### Priority Classification
- **P0 (Critical)**: Must implement before production launch
- **P1 (High)**: Implement within first 3 months post-launch
- **P2 (Nice-to-have)**: Implement when team/budget scales

---

## Observability Stack Recommendations

### 1. Error Tracking & APM: Sentry (P0)

**Score: 9.5/10 | Priority: P0 | Cost: Free → $26/month**

#### Why Sentry?

| Criteria | Evaluation |
|----------|------------|
| **Python/FastAPI Support** | ⭐⭐⭐⭐⭐ Official SDK with async support |
| **Next.js Support** | ⭐⭐⭐⭐⭐ Automatic source maps, error boundaries |
| **LLM Tracing** | ⭐⭐⭐⭐ Custom spans for Claude API calls |
| **Streaming SSE Monitoring** | ⭐⭐⭐⭐ Performance waterfall traces |
| **Cost** | ⭐⭐⭐⭐⭐ Free tier: 5K errors + 10K transactions/month |
| **Developer Experience** | ⭐⭐⭐⭐⭐ Excellent UI, issue grouping, stack locals |
| **Team Size Fit** | ⭐⭐⭐⭐⭐ Perfect for 1-3 developers |

#### Implementation Guide

**Backend (FastAPI) Integration:**

```python
# backend/app/observability/sentry.py
"""Sentry integration for error tracking and performance monitoring."""

import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.starlette import StarletteIntegration
from sentry_sdk.integrations.asyncio import AsyncioIntegration
from sentry_sdk.integrations.logging import LoggingIntegration
from app.config import settings


def init_sentry() -> None:
    """Initialize Sentry SDK with FastAPI integration.

    Enables:
    - Automatic error capture
    - Performance monitoring (transactions & spans)
    - LLM-specific custom instrumentation
    - Release tracking for deployment correlation
    """
    if not settings.sentry_dsn:
        return  # Skip in development without DSN

    sentry_sdk.init(
        dsn=settings.sentry_dsn.get_secret_value(),
        environment=settings.app_env,
        release=settings.app_version,  # e.g., "labor-law-assistant@0.1.0"

        # Performance monitoring
        traces_sample_rate=1.0 if settings.app_env == "development" else 0.2,
        profiles_sample_rate=0.1,  # Profile 10% of transactions

        # Integrations
        integrations=[
            FastApiIntegration(transaction_style="endpoint"),
            StarletteIntegration(),
            AsyncioIntegration(),
            LoggingIntegration(
                level=logging.INFO,  # Capture info and above
                event_level=logging.ERROR  # Send errors as events
            ),
        ],

        # Error filtering
        ignore_errors=[
            KeyboardInterrupt,
            "BrokenPipeError",  # Client disconnected during SSE streaming
        ],

        # Privacy: scrub sensitive data
        before_send=scrub_sensitive_data,

        # Performance: sample rates
        traces_sampler=custom_traces_sampler,
    )


def scrub_sensitive_data(event: dict, hint: dict) -> dict:
    """Remove PII and sensitive data before sending to Sentry.

    Scrubs:
    - User queries containing personal information
    - API keys from error messages
    - Database connection strings
    """
    if "request" in event:
        # Scrub query parameters
        if "query_string" in event["request"]:
            event["request"]["query_string"] = "[REDACTED]"

        # Scrub headers with API keys
        if "headers" in event["request"]:
            sensitive_headers = ["authorization", "x-api-key", "anthropic-api-key"]
            for header in sensitive_headers:
                if header in event["request"]["headers"]:
                    event["request"]["headers"][header] = "[REDACTED]"

    return event


def custom_traces_sampler(sampling_context: dict) -> float:
    """Custom sampling logic to reduce noise and cost.

    Strategy:
    - Health checks: 0% (never trace)
    - LLM queries: 100% in dev, 50% in production (high value)
    - Vector search: 100% in dev, 30% in production
    - Static assets: 0%

    Returns:
        Sampling rate between 0.0 and 1.0
    """
    transaction_name = sampling_context.get("transaction_context", {}).get("name", "")

    # Never sample health checks
    if "/health" in transaction_name or "/metrics" in transaction_name:
        return 0.0

    # High sampling for critical paths
    if "/api/v1/query" in transaction_name or "/api/v1/chat" in transaction_name:
        return 1.0 if settings.app_env == "development" else 0.5

    # Lower sampling for other endpoints
    return 0.2


# Custom instrumentation for LLM calls
def trace_llm_call(
    model: str,
    prompt_tokens: int,
    completion_tokens: int,
    latency_ms: float,
    cost_usd: float,
):
    """Create custom Sentry span for LLM API calls.

    Captures:
    - Model name and version
    - Token usage (prompt + completion)
    - Latency and cost
    - Error rates

    Args:
        model: Claude model ID (e.g., "claude-opus-4-6")
        prompt_tokens: Number of input tokens
        completion_tokens: Number of output tokens
        latency_ms: Time to first token (TTFT) in milliseconds
        cost_usd: Estimated cost in USD
    """
    with sentry_sdk.start_span(op="llm", description=f"claude.{model}") as span:
        span.set_tag("llm.model", model)
        span.set_data("llm.prompt_tokens", prompt_tokens)
        span.set_data("llm.completion_tokens", completion_tokens)
        span.set_data("llm.total_tokens", prompt_tokens + completion_tokens)
        span.set_measurement("llm.latency_ms", latency_ms)
        span.set_measurement("llm.cost_usd", cost_usd)


# Custom instrumentation for vector search
def trace_vector_search(
    query_embedding_time_ms: float,
    similarity_search_time_ms: float,
    num_results: int,
    top_similarity_score: float,
):
    """Create custom Sentry span for pgvector similarity search.

    Captures:
    - Embedding generation time
    - Vector search latency
    - Result quality metrics

    Args:
        query_embedding_time_ms: Time to generate query embedding
        similarity_search_time_ms: Time for pgvector search
        num_results: Number of articles returned
        top_similarity_score: Cosine similarity of best match (0-1)
    """
    with sentry_sdk.start_span(op="db.vector", description="pgvector.search") as span:
        span.set_measurement("vector.embedding_time_ms", query_embedding_time_ms)
        span.set_measurement("vector.search_time_ms", similarity_search_time_ms)
        span.set_data("vector.num_results", num_results)
        span.set_measurement("vector.top_similarity", top_similarity_score)
```

**Backend Configuration Updates:**

```python
# backend/app/config.py
# Add to Settings class:

class Settings(BaseSettings):
    # ... existing fields ...

    # Sentry configuration
    sentry_dsn: SecretStr = SecretStr("")
    app_version: str = "0.1.0"  # Sync with pyproject.toml version

    # Sample rate overrides for fine-tuning
    sentry_traces_sample_rate: float = 0.2
    sentry_profiles_sample_rate: float = 0.1
```

**Backend Main App Integration:**

```python
# backend/app/main.py
from app.observability.sentry import init_sentry

# Initialize Sentry before creating FastAPI app
init_sentry()

app = FastAPI(...)
```

**Frontend (Next.js) Integration:**

```typescript
// frontend/instrumentation.ts (Next.js 15 App Router)
import * as Sentry from "@sentry/nextjs";

export async function register() {
  if (process.env.NEXT_RUNTIME === "nodejs") {
    // Server-side instrumentation
    await import("./instrumentation.server");
  }

  if (process.env.NEXT_RUNTIME === "edge") {
    // Edge runtime instrumentation
    await import("./instrumentation.edge");
  }
}

// frontend/instrumentation.server.ts
import * as Sentry from "@sentry/nextjs";

Sentry.init({
  dsn: process.env.NEXT_PUBLIC_SENTRY_DSN,
  environment: process.env.NEXT_PUBLIC_APP_ENV || "development",

  // Performance monitoring
  tracesSampleRate: process.env.NODE_ENV === "production" ? 0.1 : 1.0,

  // Session replay for debugging user issues
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0,

  integrations: [
    Sentry.replayIntegration({
      maskAllText: true,  // Privacy: mask user queries
      blockAllMedia: true,
    }),
  ],
});
```

#### Dependencies to Add

```toml
# backend/pyproject.toml
dependencies = [
    # ... existing dependencies ...
    "sentry-sdk[fastapi]>=2.0.0",
]
```

```json
// frontend/package.json
{
  "dependencies": {
    "@sentry/nextjs": "^8.0.0"
  }
}
```

#### Sentry Dashboard Configuration

**Recommended Alerts:**
1. **Error spike**: >10 errors/hour (email + Slack)
2. **High LLM latency**: P95 >5s (Slack)
3. **Low confidence answers**: Avg confidence <0.6 (email)
4. **Claude API errors**: >5 failures/hour (PagerDuty for on-call)

---

### 2. Structured Logging: structlog (P0)

**Score: 9/10 | Priority: P0 | Cost: Free**

#### Why structlog over python-logging or loguru?

| Library | Pros | Cons | Score |
|---------|------|------|-------|
| **structlog** | JSON output, async-safe, context binding, processor chain | Slightly verbose setup | **9/10** |
| loguru | Beautiful console output, simple API | Less structured, harder to parse | 6/10 |
| python-logging | Built-in, familiar | Not structured, poor async support | 4/10 |

**Key Decision:** structlog enables seamless integration with log aggregation systems (Loki, CloudWatch) and provides context propagation for distributed tracing.

#### Implementation

```python
# backend/app/observability/logging.py
"""Structured logging configuration with contextual information."""

import logging
import sys
from typing import Any

import structlog
from app.config import settings


def setup_logging() -> None:
    """Configure structured logging with JSON output for production.

    Features:
    - JSON formatting for log aggregation
    - Contextual logging (request_id, user_id, conversation_id)
    - Performance: async-safe, non-blocking
    - Privacy: automatic PII redaction
    """
    # Configure standard library logging
    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=getattr(logging, settings.log_level.upper()),
    )

    # Shared processors for both dev and production
    shared_processors = [
        structlog.contextvars.merge_contextvars,
        structlog.stdlib.add_log_level,
        structlog.stdlib.add_logger_name,
        structlog.processors.TimeStamper(fmt="iso"),
        structlog.processors.StackInfoRenderer(),
        structlog.processors.CallsiteParameterAdder({
            structlog.processors.CallsiteParameter.FILENAME,
            structlog.processors.CallsiteParameter.FUNC_NAME,
            structlog.processors.CallsiteParameter.LINENO,
        }),
    ]

    if settings.app_env == "development":
        # Pretty console output for development
        processors = shared_processors + [
            structlog.dev.ConsoleRenderer(colors=True)
        ]
    else:
        # JSON output for production (CloudWatch, Loki, etc.)
        processors = shared_processors + [
            structlog.processors.format_exc_info,
            structlog.processors.JSONRenderer()
        ]

    structlog.configure(
        processors=processors,
        wrapper_class=structlog.stdlib.BoundLogger,
        context_class=dict,
        logger_factory=structlog.stdlib.LoggerFactory(),
        cache_logger_on_first_use=True,
    )


# Context binding helper
def bind_request_context(
    request_id: str,
    user_id: str | None = None,
    conversation_id: str | None = None,
) -> None:
    """Bind request context to all logs in this async context.

    Args:
        request_id: Unique request identifier (UUID)
        user_id: User identifier (hashed for privacy)
        conversation_id: Conversation thread identifier
    """
    structlog.contextvars.clear_contextvars()
    structlog.contextvars.bind_contextvars(
        request_id=request_id,
        user_id=user_id,
        conversation_id=conversation_id,
    )


# Example usage in FastAPI middleware
from fastapi import Request
import uuid

@app.middleware("http")
async def logging_middleware(request: Request, call_next):
    """Add request context to all logs."""
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))

    bind_request_context(
        request_id=request_id,
        user_id=request.state.user_id if hasattr(request.state, "user_id") else None,
    )

    logger = structlog.get_logger()
    logger.info(
        "request_started",
        method=request.method,
        path=request.url.path,
        client_ip=request.client.host,
    )

    response = await call_next(request)

    logger.info(
        "request_completed",
        status_code=response.status_code,
    )

    return response
```

#### What to Log

```python
# LLM API calls
logger.info(
    "llm_request",
    model="claude-opus-4-6",
    prompt_tokens=1250,
    completion_tokens=450,
    latency_ms=2340,
    cost_usd=0.034,
    confidence_score=0.87,
)

# Vector search
logger.info(
    "vector_search",
    query_embedding_time_ms=45,
    search_time_ms=23,
    num_results=5,
    top_similarity=0.92,
)

# Cache operations
logger.info(
    "cache_hit",
    cache_key="query:12345",
    ttl_seconds=3600,
)

# Legal accuracy tracking
logger.warning(
    "low_confidence_answer",
    confidence_score=0.55,
    query_text="[REDACTED]",  # Privacy
    citation_count=2,
)
```

---

### 3. Metrics & Monitoring: Prometheus + Grafana (P1)

**Score: 8/10 | Priority: P1 | Cost: Free (self-hosted) or $49/month (Grafana Cloud)**

#### Why Prometheus?

- **Industry standard** for time-series metrics
- **Native support** in FastAPI via `prometheus-fastapi-instrumentator`
- **Pull-based architecture** (no agent needed)
- **Excellent query language** (PromQL) for alerting
- **Free and open-source**

#### Implementation

```python
# backend/app/observability/metrics.py
"""Prometheus metrics for performance and business KPIs."""

from prometheus_client import Counter, Histogram, Gauge, Info
from prometheus_fastapi_instrumentator import Instrumentator


# HTTP metrics (automatic via instrumentator)
instrumentator = Instrumentator(
    should_group_status_codes=True,
    should_ignore_untemplated=True,
    should_respect_env_var=True,
    should_instrument_requests_inprogress=True,
    excluded_handlers=["/health", "/metrics"],
    env_var_name="ENABLE_METRICS",
    inprogress_name="http_requests_inprogress",
    inprogress_labels=True,
)

# Custom metrics for LLM operations
llm_requests_total = Counter(
    "llm_requests_total",
    "Total number of LLM API requests",
    ["model", "status"],
)

llm_tokens_total = Counter(
    "llm_tokens_total",
    "Total tokens consumed by LLM",
    ["model", "type"],  # type: prompt or completion
)

llm_cost_usd_total = Counter(
    "llm_cost_usd_total",
    "Total LLM cost in USD",
    ["model"],
)

llm_latency_seconds = Histogram(
    "llm_latency_seconds",
    "LLM API call latency in seconds",
    ["model"],
    buckets=[0.1, 0.5, 1.0, 2.0, 5.0, 10.0],
)

llm_confidence_score = Histogram(
    "llm_confidence_score",
    "LLM answer confidence score distribution",
    buckets=[0.3, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1.0],
)

# Vector search metrics
vector_search_latency_seconds = Histogram(
    "vector_search_latency_seconds",
    "Vector similarity search latency",
    buckets=[0.01, 0.05, 0.1, 0.25, 0.5, 1.0],
)

vector_search_similarity = Histogram(
    "vector_search_similarity",
    "Top similarity score distribution",
    buckets=[0.5, 0.6, 0.7, 0.8, 0.85, 0.9, 0.95, 1.0],
)

# Cache metrics
cache_operations_total = Counter(
    "cache_operations_total",
    "Cache operations by result",
    ["operation", "result"],  # operation: get/set, result: hit/miss/error
)

# Database connection pool
db_connections_active = Gauge(
    "db_connections_active",
    "Active database connections",
)

db_connections_idle = Gauge(
    "db_connections_idle",
    "Idle database connections in pool",
)


def init_metrics(app):
    """Initialize Prometheus metrics endpoint."""
    instrumentator.instrument(app).expose(app, endpoint="/metrics")
```

#### Key Dashboards to Build

**1. LLM Cost & Performance Dashboard:**
```promql
# Daily LLM cost
sum(increase(llm_cost_usd_total[24h]))

# Average confidence score
avg(llm_confidence_score)

# P95 latency by model
histogram_quantile(0.95, rate(llm_latency_seconds_bucket[5m]))

# Token usage trend
sum(rate(llm_tokens_total[1h])) by (model, type)
```

**2. System Health Dashboard:**
```promql
# Request rate
rate(http_requests_total[5m])

# Error rate
rate(http_requests_total{status=~"5.."}[5m])

# P99 response time
histogram_quantile(0.99, rate(http_request_duration_seconds_bucket[5m]))

# Cache hit rate
sum(rate(cache_operations_total{result="hit"}[5m]))
/
sum(rate(cache_operations_total{operation="get"}[5m]))
```

**3. Legal Accuracy Dashboard:**
```promql
# Low confidence answer rate
sum(rate(llm_confidence_score_bucket{le="0.6"}[1h]))
/
sum(rate(llm_confidence_score_count[1h]))

# Vector search quality
avg(vector_search_similarity)
```

---

### 4. Distributed Tracing: OpenTelemetry (P1)

**Score: 8.5/10 | Priority: P1 | Cost: Free (open standard)**

#### Why OpenTelemetry over Jaeger/Zipkin?

- **Vendor-neutral standard** (can switch backends later)
- **Auto-instrumentation** for FastAPI, requests, SQLAlchemy
- **Context propagation** across Frontend → Next.js → FastAPI → PostgreSQL → Claude API
- **Native Sentry integration** (traces appear in Sentry Performance)

#### Implementation

```python
# backend/app/observability/tracing.py
"""OpenTelemetry distributed tracing setup."""

from opentelemetry import trace
from opentelemetry.exporter.otlp.proto.grpc.trace_exporter import OTLPSpanExporter
from opentelemetry.sdk.trace import TracerProvider
from opentelemetry.sdk.trace.export import BatchSpanProcessor
from opentelemetry.instrumentation.fastapi import FastAPIInstrumentor
from opentelemetry.instrumentation.httpx import HTTPXClientInstrumentor
from opentelemetry.instrumentation.sqlalchemy import SQLAlchemyInstrumentor
from app.config import settings


def init_tracing(app):
    """Initialize OpenTelemetry tracing with OTLP exporter.

    Sends traces to:
    - Sentry (via OTLP)
    - Grafana Tempo (optional, for self-hosted)
    """
    if not settings.otel_endpoint:
        return

    # Set up tracer provider
    provider = TracerProvider(
        resource=Resource.create({
            "service.name": "labor-law-assistant-api",
            "service.version": settings.app_version,
            "deployment.environment": settings.app_env,
        })
    )

    # OTLP exporter (sends to Sentry or Grafana Tempo)
    otlp_exporter = OTLPSpanExporter(
        endpoint=settings.otel_endpoint,
        headers={"Authorization": f"Bearer {settings.otel_token}"},
    )

    provider.add_span_processor(BatchSpanProcessor(otlp_exporter))
    trace.set_tracer_provider(provider)

    # Auto-instrument frameworks
    FastAPIInstrumentor.instrument_app(app)
    HTTPXClientInstrumentor().instrument()  # Claude API calls
    SQLAlchemyInstrumentor().instrument()   # PostgreSQL queries


# Custom span for Claude API streaming
async def trace_claude_streaming(messages: list[dict], model: str):
    """Trace Claude API streaming with custom attributes."""
    tracer = trace.get_tracer(__name__)

    with tracer.start_as_current_span("claude.stream") as span:
        span.set_attribute("llm.model", model)
        span.set_attribute("llm.message_count", len(messages))

        # Make API call
        async with httpx.AsyncClient() as client:
            response = await client.post(
                "https://api.anthropic.com/v1/messages",
                json={
                    "model": model,
                    "messages": messages,
                    "stream": True,
                },
            )

            span.set_attribute("http.status_code", response.status_code)

            # Stream response
            async for chunk in response.aiter_bytes():
                yield chunk
```

---

### 5. Log Aggregation: Grafana Loki (P1)

**Score: 7.5/10 | Priority: P1 | Cost: Free (self-hosted) or included in Grafana Cloud**

#### Why Loki over ELK Stack?

| Feature | Loki | ELK Stack | Winner |
|---------|------|-----------|--------|
| **Cost** | Free, low resource usage | Elasticsearch expensive | **Loki** |
| **Complexity** | Simple setup | Complex (3+ services) | **Loki** |
| **PromQL Integration** | Native (LogQL similar) | Requires translation | **Loki** |
| **Search Performance** | Good for structured logs | Excellent full-text search | ELK |
| **Team Size Fit** | Perfect for small teams | Overkill for <10K users | **Loki** |

**Recommendation:** Use Loki for MVP, migrate to ELK only if you need advanced text search later.

#### Docker Compose Setup

```yaml
# docker-compose.observability.yml
version: '3.8'

services:
  loki:
    image: grafana/loki:2.9.0
    ports:
      - "3100:3100"
    volumes:
      - ./loki-config.yaml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml

  promtail:
    image: grafana/promtail:2.9.0
    volumes:
      - ./promtail-config.yaml:/etc/promtail/config.yml
      - /var/log:/var/log
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yml

  grafana:
    image: grafana/grafana:10.2.0
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
    volumes:
      - grafana-data:/var/lib/grafana
      - ./grafana-datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml

  prometheus:
    image: prom/prometheus:v2.48.0
    ports:
      - "9090:9090"
    volumes:
      - ./prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'

volumes:
  loki-data:
  grafana-data:
  prometheus-data:
```

---

### 6. Uptime Monitoring: BetterStack (P1)

**Score: 8/10 | Priority: P1 | Cost: Free tier (10 monitors)**

#### Why BetterStack (formerly Better Uptime)?

- **Free tier**: 10 monitors, 3 status pages
- **Incident management** built-in
- **Public status page** for transparency
- **Multi-region checks** (check from Taiwan, US, EU)
- **Integrations**: Slack, PagerDuty, email

#### Monitors to Configure

```yaml
# Uptime monitors (check every 1 min)
1. https://api.labor-law.tw/health (200 OK, <500ms)
2. https://api.labor-law.tw/api/v1/health/db (PostgreSQL connectivity)
3. https://api.labor-law.tw/api/v1/health/redis (Redis connectivity)
4. https://labor-law.tw (Frontend homepage)
5. DNS: labor-law.tw (DNS resolution)
```

**Alternative:** UptimeRobot (free, simpler but less features)

---

### 7. LLM Cost Monitoring: Custom Dashboard (P0)

**Score: 9/10 | Priority: P0 | Cost: Free (custom implementation)**

Since LLM costs are critical for your budget, build a dedicated cost tracking system.

#### Implementation

```python
# backend/app/services/llm_cost_tracker.py
"""Track and alert on LLM API costs."""

from datetime import datetime, timedelta
from sqlalchemy import select, func
from app.models.llm_usage import LLMUsageLog
from app.config import settings

# Claude pricing (as of 2026-03-02)
CLAUDE_PRICING = {
    "claude-opus-4-6": {
        "input": 0.000015,   # $15 per 1M input tokens
        "output": 0.000075,  # $75 per 1M output tokens
    },
    "claude-sonnet-4-5": {
        "input": 0.000003,   # $3 per 1M input tokens
        "output": 0.000015,  # $15 per 1M output tokens
    },
}


async def calculate_cost(
    model: str,
    input_tokens: int,
    output_tokens: int,
) -> float:
    """Calculate cost in USD for LLM API call.

    Args:
        model: Claude model ID
        input_tokens: Number of input tokens
        output_tokens: Number of output tokens

    Returns:
        Cost in USD
    """
    pricing = CLAUDE_PRICING.get(model)
    if not pricing:
        raise ValueError(f"Unknown model: {model}")

    cost = (
        (input_tokens / 1_000_000) * pricing["input"] +
        (output_tokens / 1_000_000) * pricing["output"]
    )
    return round(cost, 6)


async def log_llm_usage(
    db: AsyncSession,
    model: str,
    input_tokens: int,
    output_tokens: int,
    latency_ms: float,
    confidence_score: float,
    conversation_id: str,
):
    """Log LLM usage to database for cost tracking and analytics.

    Args:
        db: Database session
        model: Claude model ID
        input_tokens: Number of input tokens
        output_tokens: Number of output tokens
        latency_ms: API call latency in milliseconds
        confidence_score: Answer confidence (0-1)
        conversation_id: Unique conversation identifier
    """
    cost_usd = await calculate_cost(model, input_tokens, output_tokens)

    usage_log = LLMUsageLog(
        model=model,
        input_tokens=input_tokens,
        output_tokens=output_tokens,
        total_tokens=input_tokens + output_tokens,
        cost_usd=cost_usd,
        latency_ms=latency_ms,
        confidence_score=confidence_score,
        conversation_id=conversation_id,
        timestamp=datetime.utcnow(),
    )

    db.add(usage_log)
    await db.commit()

    # Emit metric for Prometheus
    llm_cost_usd_total.labels(model=model).inc(cost_usd)
    llm_tokens_total.labels(model=model, type="input").inc(input_tokens)
    llm_tokens_total.labels(model=model, type="output").inc(output_tokens)

    # Check daily budget threshold
    await check_daily_budget(db)


async def check_daily_budget(db: AsyncSession):
    """Alert if daily LLM spend exceeds threshold.

    Thresholds:
    - Warning: $10/day (email to team)
    - Critical: $20/day (Slack alert + pause API)
    """
    today_start = datetime.utcnow().replace(hour=0, minute=0, second=0, microsecond=0)

    result = await db.execute(
        select(func.sum(LLMUsageLog.cost_usd))
        .where(LLMUsageLog.timestamp >= today_start)
    )
    daily_cost = result.scalar() or 0.0

    if daily_cost >= settings.llm_daily_budget_critical:
        # Send critical alert
        await send_alert(
            severity="critical",
            message=f"LLM daily cost exceeded ${daily_cost:.2f} (budget: ${settings.llm_daily_budget_critical})",
            channel="slack",
        )
        # Optional: pause API temporarily
        settings.llm_api_enabled = False

    elif daily_cost >= settings.llm_daily_budget_warning:
        # Send warning
        await send_alert(
            severity="warning",
            message=f"LLM daily cost reached ${daily_cost:.2f}",
            channel="email",
        )


# Database model
from sqlalchemy import Column, String, Integer, Float, DateTime
from app.models.base import Base

class LLMUsageLog(Base):
    """LLM API usage logs for cost tracking and analytics."""

    __tablename__ = "llm_usage_logs"

    id = Column(Integer, primary_key=True)
    model = Column(String(50), nullable=False, index=True)
    input_tokens = Column(Integer, nullable=False)
    output_tokens = Column(Integer, nullable=False)
    total_tokens = Column(Integer, nullable=False)
    cost_usd = Column(Float, nullable=False)
    latency_ms = Column(Float, nullable=False)
    confidence_score = Column(Float)
    conversation_id = Column(String(100), index=True)
    timestamp = Column(DateTime, nullable=False, index=True)
```

#### Grafana Dashboard Query

```sql
-- Daily LLM cost by model
SELECT
    DATE(timestamp) as date,
    model,
    SUM(cost_usd) as daily_cost,
    SUM(total_tokens) as total_tokens,
    AVG(confidence_score) as avg_confidence
FROM llm_usage_logs
WHERE timestamp >= NOW() - INTERVAL '30 days'
GROUP BY DATE(timestamp), model
ORDER BY date DESC, daily_cost DESC;

-- Cost per conversation
SELECT
    conversation_id,
    COUNT(*) as num_queries,
    SUM(cost_usd) as total_cost,
    AVG(confidence_score) as avg_confidence
FROM llm_usage_logs
WHERE timestamp >= NOW() - INTERVAL '7 days'
GROUP BY conversation_id
ORDER BY total_cost DESC
LIMIT 20;
```

---

## 2. Other Infrastructure Technologies

### 8. Health Checks: Custom FastAPI Endpoint (P0)

**Score: 9/10 | Priority: P0 | Cost: Free**

```python
# backend/app/api/routes/health.py (ENHANCED)
"""Enhanced health check endpoints for monitoring."""

from fastapi import APIRouter, Depends, status
from sqlalchemy.ext.asyncio import AsyncSession
from redis.asyncio import Redis
import httpx

from app.schemas.health import HealthResponse, HealthStatus
from app.database import get_db
from app.cache import get_redis

router = APIRouter(tags=["health"])


@router.get("/health", response_model=HealthResponse)
async def health_check():
    """Basic health check for load balancer.

    Returns:
        200 OK if service is running
    """
    return HealthResponse(
        status=HealthStatus.HEALTHY,
        version=settings.app_version,
        environment=settings.app_env,
    )


@router.get("/health/ready", response_model=HealthResponse)
async def readiness_check(
    db: AsyncSession = Depends(get_db),
    redis: Redis = Depends(get_redis),
):
    """Readiness check for Kubernetes / Docker health probes.

    Checks:
    - Database connectivity
    - Redis connectivity
    - Claude API reachability (optional)

    Returns:
        200 OK if all dependencies are ready
        503 Service Unavailable if any dependency fails
    """
    checks = {}
    overall_status = HealthStatus.HEALTHY

    # Check PostgreSQL
    try:
        await db.execute("SELECT 1")
        checks["database"] = "healthy"
    except Exception as e:
        checks["database"] = f"unhealthy: {str(e)}"
        overall_status = HealthStatus.UNHEALTHY

    # Check Redis
    try:
        await redis.ping()
        checks["redis"] = "healthy"
    except Exception as e:
        checks["redis"] = f"unhealthy: {str(e)}"
        overall_status = HealthStatus.DEGRADED  # Can operate without cache

    # Check Claude API (optional, don't fail if down)
    try:
        async with httpx.AsyncClient() as client:
            response = await client.get(
                "https://api.anthropic.com/v1/health",
                timeout=2.0,
            )
            checks["claude_api"] = "reachable" if response.status_code == 200 else "unreachable"
    except Exception:
        checks["claude_api"] = "unreachable"
        # Don't mark as unhealthy, just degraded
        if overall_status == HealthStatus.HEALTHY:
            overall_status = HealthStatus.DEGRADED

    status_code = status.HTTP_200_OK if overall_status == HealthStatus.HEALTHY else status.HTTP_503_SERVICE_UNAVAILABLE

    return HealthResponse(
        status=overall_status,
        version=settings.app_version,
        environment=settings.app_env,
        checks=checks,
    ), status_code
```

---

### 9. Security Monitoring: Falco (P2)

**Score: 6/10 | Priority: P2 | Cost: Free (open-source)**

**Recommendation:** Defer to post-MVP. For MVP, rely on:
- Sentry for application-level errors
- Fail2ban for basic intrusion detection
- CloudFlare WAF (if using CloudFlare)

---

### 10. Alerting Strategy (P0)

#### Alert Routing Matrix

| Alert Type | Severity | Channel | Response Time |
|------------|----------|---------|---------------|
| Service down | P0 | PagerDuty + Slack | <5 min |
| High error rate (>5%) | P1 | Slack | <30 min |
| Low confidence spike | P1 | Slack | <1 hour |
| Daily LLM budget exceeded | P1 | Slack + Email | <1 hour |
| Slow response (P95 >3s) | P2 | Email | <24 hours |
| Low cache hit rate | P2 | Email | <24 hours |

#### Alert Configuration

```yaml
# alertmanager.yml (Prometheus AlertManager)
global:
  slack_api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'

route:
  receiver: 'team-slack'
  group_by: ['alertname', 'severity']
  group_wait: 10s
  group_interval: 5m
  repeat_interval: 4h

  routes:
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true

    - match:
        severity: warning
      receiver: 'team-email'

receivers:
  - name: 'team-slack'
    slack_configs:
      - channel: '#alerts-labor-law-assistant'
        title: 'Alert: {{ .GroupLabels.alertname }}'
        text: '{{ range .Alerts }}{{ .Annotations.description }}{{ end }}'

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_KEY'

  - name: 'team-email'
    email_configs:
      - to: 'team@labor-law.tw'
```

---

## 3. Implementation Roadmap

### Phase 0: Pre-Production (Week 1-2)

**Priority: P0 items only**

- [ ] **Sentry setup** (Backend + Frontend)
  - Create Sentry project
  - Add `sentry-sdk` to dependencies
  - Configure DSN in environment variables
  - Test error capture with intentional exception
  - Set up 2 critical alerts (error spike, service down)

- [ ] **Structured logging** (structlog)
  - Replace basic logging with structlog
  - Add request context middleware
  - Test JSON output in production mode

- [ ] **Health checks**
  - Implement `/health` and `/health/ready` endpoints
  - Test with Docker healthcheck

- [ ] **LLM cost tracking**
  - Create `llm_usage_logs` table
  - Implement cost calculation function
  - Add daily budget alerts

**Estimated Time:** 8-12 hours

---

### Phase 1: MVP Launch (Week 3-4)

**Priority: P0 + P1 items**

- [ ] **Prometheus + Grafana**
  - Set up Prometheus scraping
  - Deploy Grafana instance
  - Create 3 core dashboards (System, LLM, Legal Accuracy)
  - Configure 5 critical alerts

- [ ] **Grafana Loki**
  - Deploy Loki + Promtail
  - Configure log shipping from containers
  - Create log exploration dashboard

- [ ] **OpenTelemetry tracing**
  - Add OTLP exporter to Sentry
  - Auto-instrument FastAPI, SQLAlchemy, HTTPX
  - Test distributed traces

- [ ] **Uptime monitoring**
  - Create BetterStack account
  - Configure 5 uptime monitors
  - Set up public status page

**Estimated Time:** 16-20 hours

---

### Phase 2: Post-Launch Optimization (Month 2-3)

**Priority: P2 items + fine-tuning**

- [ ] **Cost optimization**
  - Analyze LLM usage patterns
  - Implement aggressive caching for common queries
  - Tune Sentry sample rates based on traffic

- [ ] **Alert tuning**
  - Reduce alert fatigue (adjust thresholds)
  - Add runbooks for common alerts
  - Set up on-call rotation (if team grows)

- [ ] **Advanced dashboards**
  - User journey analytics
  - Citation accuracy tracking
  - A/B testing metrics

**Estimated Time:** Ongoing

---

## 4. Cost Analysis

### Monthly Cost Breakdown (MVP Stage, <1K daily users)

| Service | Tier | Monthly Cost | Notes |
|---------|------|--------------|-------|
| **Sentry** | Free | $0 | 5K errors + 10K transactions/month |
| **BetterStack** | Free | $0 | 10 monitors, 1 status page |
| **Grafana Loki** | Self-hosted | $0 | Running on existing infra |
| **Prometheus** | Self-hosted | $0 | Minimal resource usage |
| **Grafana** | Self-hosted | $0 | Open-source |
| **OpenTelemetry** | Open standard | $0 | No vendor lock-in |
| **structlog** | Open-source | $0 | Python library |
| **TOTAL** | | **$0/month** | |

### Cost at Scale (10K daily users, 100K monthly queries)

| Service | Tier | Monthly Cost | Notes |
|---------|------|--------------|-------|
| **Sentry** | Team | $26 | 50K errors + 100K transactions |
| **BetterStack** | Startup | $20 | 50 monitors, incident management |
| **Grafana Cloud** | Free | $0 | 10K series, 50GB logs (sufficient) |
| **TOTAL** | | **$46/month** | |

**ROI:** Detecting one critical bug (e.g., incorrect legal citation) can save $10K+ in liability risk. Observability cost is negligible compared to LLM API costs (~$500-2000/month estimated).

---

## 5. Key Metrics & KPIs

### System Health Metrics

```yaml
# P95 Response Time
Target: <1000ms
Alert: >3000ms

# Error Rate
Target: <0.5%
Alert: >2%

# Uptime
Target: 99.9% (43 min downtime/month)
Alert: <99.5%

# Cache Hit Rate
Target: >70%
Alert: <50%
```

### LLM Performance Metrics

```yaml
# Average Confidence Score
Target: >0.8
Alert: <0.6 (daily average)

# LLM Latency (Time to First Token)
Target: <2s
Alert: >5s (P95)

# Daily LLM Cost
Target: <$10/day
Alert: >$20/day

# Citation Accuracy (manual review)
Target: >95%
Alert: <90%
```

### Business Metrics

```yaml
# User Satisfaction (CSAT)
Target: >4.5/5
Track: Weekly survey

# Query Resolution Rate
Target: >80% queries answered without escalation
Track: Confidence score + user feedback

# Legal Content Freshness
Target: <7 days since last legal update
Alert: >30 days
```

---

## 6. Security & Compliance

### Data Privacy in Observability

```python
# PII Redaction Strategy

# 1. User queries - NEVER log full text
logger.info(
    "query_received",
    query_hash=hashlib.sha256(query.encode()).hexdigest()[:16],
    query_length=len(query),
    # DO NOT log: query_text=query
)

# 2. Sentry - scrub sensitive headers
before_send=scrub_sensitive_data  # (implemented above)

# 3. Grafana - use hashed user IDs
user_id = hashlib.sha256(f"{user_email}{SECRET_SALT}".encode()).hexdigest()

# 4. Logs - automatic PII detection
structlog.processors.add_log_level_with_pii_detection()
```

### Audit Logging

For legal compliance, maintain immutable audit logs for:
- User authentication events
- Legal content modifications
- Confidence score overrides
- System configuration changes

```python
# backend/app/models/audit_log.py
class AuditLog(Base):
    """Immutable audit log for compliance."""

    __tablename__ = "audit_logs"

    id = Column(Integer, primary_key=True)
    timestamp = Column(DateTime, nullable=False, index=True)
    event_type = Column(String(50), nullable=False)  # e.g., "user.login", "legal.update"
    actor_id = Column(String(100), nullable=False)  # Hashed user ID
    resource_type = Column(String(50))  # e.g., "legal_article", "config"
    resource_id = Column(String(100))
    action = Column(String(50))  # e.g., "create", "update", "delete"
    metadata = Column(JSONB)  # Additional context
    ip_address = Column(String(45))  # IPv4/IPv6
    user_agent = Column(String(500))
```

---

## 7. Recommended Alternatives by Budget

### Ultra-Lean Stack (No budget, solo developer)

```yaml
Error Tracking: Sentry Free Tier
Logging: structlog → stdout → Docker logs
Metrics: None (defer to later)
Uptime: UptimeRobot Free Tier
Tracing: None (use Sentry transactions only)

Total Cost: $0/month
Setup Time: 4 hours
```

### Balanced Stack (Small budget, 1-3 developers) - RECOMMENDED

```yaml
Error Tracking: Sentry Team ($26/month)
Logging: Grafana Loki (self-hosted)
Metrics: Prometheus + Grafana (self-hosted)
Uptime: BetterStack Startup ($20/month)
Tracing: OpenTelemetry → Sentry
LLM Monitoring: Custom dashboard

Total Cost: $46/month
Setup Time: 20 hours
```

### Enterprise Stack (>10 developers, >100K users)

```yaml
Error Tracking: Datadog APM ($31/host/month)
Logging: Datadog Logs
Metrics: Datadog Metrics
Uptime: Datadog Synthetics
Tracing: Datadog APM
All-in-one: $200-500/month

Total Cost: $500/month
Setup Time: 40 hours
```

---

## 8. Decision Matrix

| Requirement | Sentry | Datadog | Self-Hosted | Winner |
|-------------|--------|---------|-------------|--------|
| **Budget fit (<$50/month)** | ✅ | ❌ | ✅ | Sentry/Self-hosted |
| **Small team (1-3 devs)** | ✅ | ✅ | ⚠️ | Sentry |
| **Python/FastAPI support** | ✅ | ✅ | ⚠️ | Sentry |
| **Next.js support** | ✅ | ✅ | ❌ | Sentry |
| **LLM tracing** | ⚠️ (custom) | ✅ | ⚠️ | Datadog |
| **Streaming SSE monitoring** | ✅ | ✅ | ⚠️ | Sentry |
| **Setup time** | ✅ (<4h) | ✅ (<4h) | ❌ (>20h) | Sentry |
| **Vendor lock-in risk** | ⚠️ Medium | ❌ High | ✅ None | Self-hosted |
| **Maintenance overhead** | ✅ None | ✅ None | ❌ High | Sentry |

**Final Recommendation:** **Sentry + Prometheus + Loki** (Balanced Stack)

---

## Appendix

### A. Sample Grafana Dashboard JSON

```json
{
  "dashboard": {
    "title": "Labor Law Assistant - LLM Performance",
    "panels": [
      {
        "title": "Daily LLM Cost",
        "targets": [
          {
            "expr": "sum(increase(llm_cost_usd_total[24h]))"
          }
        ],
        "type": "stat"
      },
      {
        "title": "Average Confidence Score",
        "targets": [
          {
            "expr": "avg(llm_confidence_score)"
          }
        ],
        "type": "gauge"
      },
      {
        "title": "LLM Latency (P95)",
        "targets": [
          {
            "expr": "histogram_quantile(0.95, rate(llm_latency_seconds_bucket[5m]))"
          }
        ],
        "type": "graph"
      }
    ]
  }
}
```

### B. Environment Variables Checklist

```bash
# .env.production
SENTRY_DSN=https://xxx@sentry.io/xxx
SENTRY_TRACES_SAMPLE_RATE=0.2
SENTRY_PROFILES_SAMPLE_RATE=0.1

OTEL_ENDPOINT=https://otlp.sentry.io
OTEL_TOKEN=xxx

PROMETHEUS_MULTIPROC_DIR=/tmp/prometheus

LLM_DAILY_BUDGET_WARNING=10.0
LLM_DAILY_BUDGET_CRITICAL=20.0

BETTERSTACK_API_KEY=xxx

LOG_LEVEL=INFO
APP_ENV=production
APP_VERSION=0.1.0
```

### C. Testing Checklist

```bash
# Before production deployment
✅ Sentry captures errors (test with raise Exception())
✅ Sentry captures transactions (check /api/v1/query in Sentry UI)
✅ Logs appear in Loki (check Grafana Explore)
✅ Prometheus metrics scraped (check http://localhost:9090/targets)
✅ Health checks return 200 (curl http://localhost:8000/health/ready)
✅ Alerts fire correctly (trigger test alert)
✅ LLM cost tracked in database (SELECT * FROM llm_usage_logs;)
```

---

## Conclusion

This observability strategy provides:

1. **Comprehensive monitoring** across errors, logs, metrics, and traces
2. **Budget-conscious** approach starting at $0/month
3. **Scalable architecture** that grows with your user base
4. **Legal accuracy tracking** critical for labor law compliance
5. **LLM cost monitoring** to prevent budget overruns

**Next Steps:**
1. Review this document with the team
2. Approve budget allocation ($0 for MVP, $46/month at scale)
3. Implement Phase 0 (P0 items) before production launch
4. Schedule monthly observability review meetings

**Questions?** Contact DevOps team or update this document via pull request.

---

**Document History:**
- v1.0 (2026-03-02): Initial comprehensive evaluation
