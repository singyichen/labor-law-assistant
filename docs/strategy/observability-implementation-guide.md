# Observability Implementation Guide

**Companion document to**: [observability-strategy.md](./observability-strategy.md)
**Target Audience**: Backend developers implementing observability
**Estimated Time**: 20 hours (Phase 0 + Phase 1)

---

## Quick Start: 30-Minute MVP Setup

For developers who want basic observability running today.

### Step 1: Install Dependencies (5 min)

```bash
cd backend

# Add observability dependencies
uv add "sentry-sdk[fastapi]>=2.0.0" \
       "structlog>=24.1.0" \
       "prometheus-client>=0.19.0" \
       "prometheus-fastapi-instrumentator>=7.0.0"
```

### Step 2: Configure Environment Variables (2 min)

```bash
# backend/.env.development
SENTRY_DSN=  # Leave empty for local development
APP_ENV=development
APP_VERSION=0.1.0
LOG_LEVEL=DEBUG
```

### Step 3: Initialize Sentry (10 min)

```python
# backend/app/observability/__init__.py
"""Observability module initialization."""

from .sentry import init_sentry
from .logging import setup_logging
from .metrics import init_metrics

__all__ = ["init_sentry", "setup_logging", "init_metrics"]
```

```python
# backend/app/observability/sentry.py
"""Minimal Sentry setup for quick start."""

import logging
import sentry_sdk
from sentry_sdk.integrations.fastapi import FastApiIntegration
from sentry_sdk.integrations.asyncio import AsyncioIntegration
from app.config import settings


def init_sentry() -> None:
    """Initialize Sentry SDK (no-op if DSN not configured)."""
    if not settings.sentry_dsn or not settings.sentry_dsn.get_secret_value():
        logging.info("Sentry disabled (no DSN configured)")
        return

    sentry_sdk.init(
        dsn=settings.sentry_dsn.get_secret_value(),
        environment=settings.app_env,
        traces_sample_rate=1.0 if settings.app_env == "development" else 0.1,
        integrations=[
            FastApiIntegration(transaction_style="endpoint"),
            AsyncioIntegration(),
        ],
    )
    logging.info("Sentry initialized for environment: %s", settings.app_env)
```

### Step 4: Update Configuration (3 min)

```python
# backend/app/config.py
# Add to Settings class:

from pydantic import SecretStr

class Settings(BaseSettings):
    # ... existing fields ...

    # Observability
    sentry_dsn: SecretStr = SecretStr("")
    app_version: str = "0.1.0"

    model_config = {"env_file": ".env", "env_file_encoding": "utf-8"}
```

### Step 5: Initialize in Main App (2 min)

```python
# backend/app/main.py
from app.observability import init_sentry, setup_logging

# Initialize observability BEFORE creating app
init_sentry()
setup_logging()

app = FastAPI(
    title="Labor Law Assistant API",
    version=settings.app_version,
    # ... rest of config
)
```

### Step 6: Test Error Capture (5 min)

```python
# Add test endpoint
@app.get("/sentry-test")
async def sentry_test():
    """Test endpoint to verify Sentry error capture."""
    division_by_zero = 1 / 0  # noqa: F841
    return {"status": "this will never return"}
```

```bash
# Test locally
curl http://localhost:8000/sentry-test

# Check Sentry dashboard (sentry.io) for error
# You should see "ZeroDivisionError: division by zero"
```

### Step 7: Structured Logging Setup (3 min)

```python
# backend/app/observability/logging.py
"""Minimal structured logging setup."""

import logging
import sys
import structlog


def setup_logging() -> None:
    """Configure structured logging for development."""
    logging.basicConfig(
        format="%(message)s",
        stream=sys.stdout,
        level=logging.INFO,
    )

    structlog.configure(
        processors=[
            structlog.stdlib.add_log_level,
            structlog.processors.TimeStamper(fmt="iso"),
            structlog.dev.ConsoleRenderer(colors=True),
        ],
        wrapper_class=structlog.stdlib.BoundLogger,
        logger_factory=structlog.stdlib.LoggerFactory(),
        cache_logger_on_first_use=True,
    )


# Usage in your code
import structlog

logger = structlog.get_logger()
logger.info("user_query_received", query_length=150, language="zh-TW")
```

**Done!** You now have basic error tracking and structured logging. Total time: ~30 minutes.

---

## Full Implementation Guide

### Part 1: Sentry Advanced Setup

#### 1.1 Custom Context and Tags

```python
# backend/app/middleware/sentry_context.py
"""Add request context to all Sentry events."""

from fastapi import Request
import sentry_sdk
import uuid


async def add_sentry_context(request: Request, call_next):
    """Middleware to enrich Sentry events with request context."""
    # Generate request ID
    request_id = request.headers.get("X-Request-ID", str(uuid.uuid4()))

    # Set Sentry context
    with sentry_sdk.configure_scope() as scope:
        scope.set_tag("request_id", request_id)
        scope.set_tag("endpoint", request.url.path)
        scope.set_tag("method", request.method)

        # User context (if authenticated)
        if hasattr(request.state, "user_id"):
            scope.set_user({
                "id": request.state.user_id,
                "ip_address": request.client.host,
            })

        # Conversation context (for debugging)
        conversation_id = request.headers.get("X-Conversation-ID")
        if conversation_id:
            scope.set_tag("conversation_id", conversation_id)

    response = await call_next(request)
    response.headers["X-Request-ID"] = request_id
    return response


# Add to app/main.py
app.middleware("http")(add_sentry_context)
```

#### 1.2 Custom Instrumentation for LLM Calls

```python
# backend/app/services/claude_client.py
"""Claude API client with Sentry instrumentation."""

import sentry_sdk
from anthropic import AsyncAnthropic
from app.config import settings


class ClaudeClient:
    """Anthropic Claude API client with observability."""

    def __init__(self):
        self.client = AsyncAnthropic(
            api_key=settings.anthropic_api_key.get_secret_value()
        )

    async def generate_response(
        self,
        messages: list[dict],
        model: str = "claude-opus-4-6",
        max_tokens: int = 2000,
    ) -> dict:
        """Generate response from Claude API with Sentry tracing.

        Args:
            messages: Conversation history
            model: Claude model identifier
            max_tokens: Maximum tokens to generate

        Returns:
            Response dict with content, usage, and metadata
        """
        with sentry_sdk.start_span(
            op="llm.claude",
            description=f"claude.{model}",
        ) as span:
            # Add LLM-specific tags
            span.set_tag("llm.model", model)
            span.set_tag("llm.max_tokens", max_tokens)
            span.set_data("llm.message_count", len(messages))

            try:
                response = await self.client.messages.create(
                    model=model,
                    max_tokens=max_tokens,
                    messages=messages,
                )

                # Record token usage
                span.set_measurement("llm.input_tokens", response.usage.input_tokens)
                span.set_measurement("llm.output_tokens", response.usage.output_tokens)

                # Calculate cost
                cost = self._calculate_cost(
                    model,
                    response.usage.input_tokens,
                    response.usage.output_tokens,
                )
                span.set_measurement("llm.cost_usd", cost)

                return {
                    "content": response.content[0].text,
                    "usage": {
                        "input_tokens": response.usage.input_tokens,
                        "output_tokens": response.usage.output_tokens,
                        "total_tokens": response.usage.input_tokens + response.usage.output_tokens,
                    },
                    "cost_usd": cost,
                    "model": model,
                }

            except Exception as e:
                # Capture LLM errors separately
                sentry_sdk.capture_exception(e)
                span.set_tag("error", True)
                raise

    def _calculate_cost(self, model: str, input_tokens: int, output_tokens: int) -> float:
        """Calculate API call cost in USD."""
        pricing = {
            "claude-opus-4-6": {"input": 0.000015, "output": 0.000075},
            "claude-sonnet-4-5": {"input": 0.000003, "output": 0.000015},
        }

        model_pricing = pricing.get(model, pricing["claude-opus-4-6"])
        return (
            (input_tokens / 1_000_000) * model_pricing["input"] +
            (output_tokens / 1_000_000) * model_pricing["output"]
        )
```

#### 1.3 Streaming SSE Instrumentation

```python
# backend/app/api/routes/chat.py
"""Chat endpoint with streaming support and observability."""

from fastapi import APIRouter
from fastapi.responses import StreamingResponse
import sentry_sdk
import structlog

router = APIRouter(prefix="/api/v1", tags=["chat"])
logger = structlog.get_logger()


@router.post("/chat/stream")
async def stream_chat_response(query: str):
    """Stream LLM response with Server-Sent Events.

    Sentry will automatically track:
    - Total request duration
    - Time to first byte (TTFB)
    - Streaming errors
    """
    async def generate_stream():
        """Generator for SSE stream."""
        with sentry_sdk.start_span(op="llm.stream", description="claude.stream") as span:
            try:
                tokens_sent = 0
                start_time = time.time()

                async for chunk in claude_client.stream(query):
                    tokens_sent += 1
                    yield f"data: {chunk}\n\n"

                    # Record time to first token
                    if tokens_sent == 1:
                        ttft = (time.time() - start_time) * 1000
                        span.set_measurement("llm.time_to_first_token_ms", ttft)
                        logger.info("stream_started", ttft_ms=ttft)

                # Record total tokens streamed
                span.set_measurement("llm.tokens_streamed", tokens_sent)

            except Exception as e:
                # Capture streaming errors
                sentry_sdk.capture_exception(e)
                logger.error("stream_error", error=str(e))
                yield f"data: {{\"error\": \"{str(e)}\"}}\n\n"

    return StreamingResponse(
        generate_stream(),
        media_type="text/event-stream",
    )
```

### Part 2: Prometheus Metrics

#### 2.1 Basic Setup

```python
# backend/app/observability/metrics.py
"""Prometheus metrics for system and business KPIs."""

from prometheus_client import Counter, Histogram, Gauge, Info
from prometheus_fastapi_instrumentator import Instrumentator
from prometheus_fastapi_instrumentator.metrics import Info as MetricInfo


# Initialize instrumentator
instrumentator = Instrumentator(
    should_group_status_codes=True,
    should_ignore_untemplated=True,
    excluded_handlers=["/health", "/metrics"],
)

# Custom metrics
llm_requests_total = Counter(
    "llm_requests_total",
    "Total LLM API requests",
    ["model", "status"],
)

llm_tokens_total = Counter(
    "llm_tokens_total",
    "Total LLM tokens consumed",
    ["model", "type"],
)

llm_cost_total = Counter(
    "llm_cost_usd_total",
    "Total LLM cost in USD",
    ["model"],
)

llm_latency = Histogram(
    "llm_latency_seconds",
    "LLM API latency",
    ["model"],
    buckets=[0.1, 0.5, 1.0, 2.0, 5.0, 10.0],
)

llm_confidence = Histogram(
    "llm_confidence_score",
    "LLM confidence score distribution",
    buckets=[0.3, 0.5, 0.6, 0.7, 0.8, 0.9, 0.95, 1.0],
)

vector_search_latency = Histogram(
    "vector_search_latency_seconds",
    "Vector similarity search latency",
    buckets=[0.01, 0.05, 0.1, 0.25, 0.5, 1.0],
)

cache_operations = Counter(
    "cache_operations_total",
    "Cache operations",
    ["operation", "result"],
)


def init_metrics(app):
    """Initialize Prometheus metrics endpoint."""
    instrumentator.instrument(app).expose(app, endpoint="/metrics")
```

#### 2.2 Usage in Services

```python
# backend/app/services/rag_service.py
"""RAG service with metrics instrumentation."""

import time
from app.observability.metrics import (
    llm_requests_total,
    llm_tokens_total,
    llm_cost_total,
    llm_latency,
    llm_confidence,
    vector_search_latency,
)


class RAGService:
    """Retrieval-Augmented Generation service."""

    async def query(self, user_query: str) -> dict:
        """Process user query with RAG pipeline.

        Steps:
        1. Vector search for relevant legal articles
        2. Generate embeddings
        3. LLM generation with context
        """
        # 1. Vector search
        search_start = time.time()
        articles = await self.vector_search(user_query)
        search_duration = time.time() - search_start

        # Record vector search metrics
        vector_search_latency.observe(search_duration)

        # 2. LLM generation
        llm_start = time.time()
        try:
            response = await self.generate_answer(user_query, articles)
            llm_duration = time.time() - llm_start

            # Record success metrics
            llm_requests_total.labels(
                model=response["model"],
                status="success"
            ).inc()

            llm_tokens_total.labels(
                model=response["model"],
                type="input"
            ).inc(response["usage"]["input_tokens"])

            llm_tokens_total.labels(
                model=response["model"],
                type="output"
            ).inc(response["usage"]["output_tokens"])

            llm_cost_total.labels(
                model=response["model"]
            ).inc(response["cost_usd"])

            llm_latency.labels(
                model=response["model"]
            ).observe(llm_duration)

            llm_confidence.observe(response["confidence_score"])

            return response

        except Exception as e:
            # Record failure metrics
            llm_requests_total.labels(
                model="claude-opus-4-6",
                status="error"
            ).inc()
            raise
```

### Part 3: Log Aggregation with Loki

#### 3.1 Docker Compose Setup

```yaml
# docker-compose.observability.yml
version: '3.8'

services:
  loki:
    image: grafana/loki:2.9.0
    ports:
      - "3100:3100"
    volumes:
      - ./config/loki-config.yaml:/etc/loki/local-config.yaml
      - loki-data:/loki
    command: -config.file=/etc/loki/local-config.yaml
    networks:
      - observability

  promtail:
    image: grafana/promtail:2.9.0
    volumes:
      - ./config/promtail-config.yaml:/etc/promtail/config.yml
      - /var/log:/var/log:ro
      - /var/lib/docker/containers:/var/lib/docker/containers:ro
    command: -config.file=/etc/promtail/config.yml
    depends_on:
      - loki
    networks:
      - observability

  grafana:
    image: grafana/grafana:10.2.0
    ports:
      - "3001:3000"
    environment:
      - GF_SECURITY_ADMIN_PASSWORD=admin
      - GF_USERS_ALLOW_SIGN_UP=false
    volumes:
      - grafana-data:/var/lib/grafana
      - ./config/grafana-datasources.yaml:/etc/grafana/provisioning/datasources/datasources.yaml
      - ./config/grafana-dashboards:/etc/grafana/provisioning/dashboards
    depends_on:
      - loki
      - prometheus
    networks:
      - observability

  prometheus:
    image: prom/prometheus:v2.48.0
    ports:
      - "9090:9090"
    volumes:
      - ./config/prometheus.yml:/etc/prometheus/prometheus.yml
      - prometheus-data:/prometheus
    command:
      - '--config.file=/etc/prometheus/prometheus.yml'
      - '--storage.tsdb.path=/prometheus'
    networks:
      - observability

volumes:
  loki-data:
  grafana-data:
  prometheus-data:

networks:
  observability:
    driver: bridge
```

#### 3.2 Loki Configuration

```yaml
# config/loki-config.yaml
auth_enabled: false

server:
  http_listen_port: 3100

ingester:
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
  chunk_idle_period: 5m
  chunk_retain_period: 30s

schema_config:
  configs:
    - from: 2024-01-01
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /loki/index
    cache_location: /loki/index_cache
    shared_store: filesystem
  filesystem:
    directory: /loki/chunks

limits_config:
  enforce_metric_name: false
  reject_old_samples: true
  reject_old_samples_max_age: 168h  # 1 week

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: true
  retention_period: 720h  # 30 days
```

#### 3.3 Promtail Configuration

```yaml
# config/promtail-config.yaml
server:
  http_listen_port: 9080
  grpc_listen_port: 0

positions:
  filename: /tmp/positions.yaml

clients:
  - url: http://loki:3100/loki/api/v1/push

scrape_configs:
  - job_name: docker-containers
    docker_sd_configs:
      - host: unix:///var/run/docker.sock
        refresh_interval: 5s
    relabel_configs:
      - source_labels: ['__meta_docker_container_name']
        regex: '/(.*)'
        target_label: 'container'
      - source_labels: ['__meta_docker_container_log_stream']
        target_label: 'stream'
    pipeline_stages:
      - json:
          expressions:
            timestamp: timestamp
            level: level
            logger: logger
            message: message
      - timestamp:
          source: timestamp
          format: RFC3339
      - labels:
          level:
          logger:
```

#### 3.4 Grafana Datasources

```yaml
# config/grafana-datasources.yaml
apiVersion: 1

datasources:
  - name: Loki
    type: loki
    access: proxy
    url: http://loki:3100
    isDefault: false
    jsonData:
      maxLines: 1000

  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus:9090
    isDefault: true
    jsonData:
      timeInterval: 15s
```

### Part 4: Alerting with AlertManager

#### 4.1 Prometheus Alerts

```yaml
# config/prometheus-alerts.yml
groups:
  - name: labor_law_assistant_alerts
    interval: 30s
    rules:
      # Service Health
      - alert: ServiceDown
        expr: up{job="labor-law-api"} == 0
        for: 1m
        labels:
          severity: critical
        annotations:
          summary: "Labor Law API is down"
          description: "API instance {{ $labels.instance }} is down for >1 minute"

      # Error Rate
      - alert: HighErrorRate
        expr: |
          (
            sum(rate(http_requests_total{status=~"5.."}[5m]))
            /
            sum(rate(http_requests_total[5m]))
          ) > 0.05
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "High error rate detected"
          description: "Error rate is {{ $value | humanizePercentage }} over the last 5 minutes"

      # LLM Cost
      - alert: DailyLLMBudgetExceeded
        expr: sum(increase(llm_cost_usd_total[24h])) > 20
        labels:
          severity: critical
        annotations:
          summary: "Daily LLM budget exceeded"
          description: "LLM cost is ${{ $value | humanize }} in the last 24 hours (budget: $20)"

      # Low Confidence
      - alert: LowConfidenceAnswers
        expr: |
          (
            sum(rate(llm_confidence_score_bucket{le="0.6"}[1h]))
            /
            sum(rate(llm_confidence_score_count[1h]))
          ) > 0.2
        for: 30m
        labels:
          severity: warning
        annotations:
          summary: "High rate of low-confidence answers"
          description: "{{ $value | humanizePercentage }} of answers have confidence <0.6"

      # Response Time
      - alert: SlowResponseTime
        expr: |
          histogram_quantile(0.95,
            rate(http_request_duration_seconds_bucket[5m])
          ) > 3
        for: 10m
        labels:
          severity: warning
        annotations:
          summary: "Slow API response time"
          description: "P95 response time is {{ $value }}s (threshold: 3s)"

      # Database
      - alert: DatabaseConnectionPoolExhausted
        expr: db_connections_active / (db_connections_active + db_connections_idle) > 0.9
        for: 5m
        labels:
          severity: warning
        annotations:
          summary: "Database connection pool nearly exhausted"
          description: "{{ $value | humanizePercentage }} of connections are active"
```

#### 4.2 AlertManager Configuration

```yaml
# config/alertmanager.yml
global:
  resolve_timeout: 5m
  slack_api_url: 'https://hooks.slack.com/services/YOUR/WEBHOOK/URL'

route:
  receiver: 'team-slack'
  group_by: ['alertname', 'severity']
  group_wait: 10s
  group_interval: 5m
  repeat_interval: 4h

  routes:
    # Critical alerts to PagerDuty
    - match:
        severity: critical
      receiver: 'pagerduty'
      continue: true

    # Warnings to email
    - match:
        severity: warning
      receiver: 'team-email'

receivers:
  - name: 'team-slack'
    slack_configs:
      - channel: '#alerts-labor-law'
        title: 'Alert: {{ .GroupLabels.alertname }}'
        text: |-
          {{ range .Alerts }}
          *Summary:* {{ .Annotations.summary }}
          *Description:* {{ .Annotations.description }}
          *Severity:* {{ .Labels.severity }}
          {{ end }}
        send_resolved: true

  - name: 'pagerduty'
    pagerduty_configs:
      - service_key: 'YOUR_PAGERDUTY_SERVICE_KEY'

  - name: 'team-email'
    email_configs:
      - to: 'team@labor-law.tw'
        from: 'alerts@labor-law.tw'
        smarthost: 'smtp.gmail.com:587'
        auth_username: 'alerts@labor-law.tw'
        auth_password: 'YOUR_APP_PASSWORD'
```

### Part 5: Testing Your Setup

#### 5.1 Local Testing Script

```bash
#!/bin/bash
# scripts/test-observability.sh

set -e

echo "🧪 Testing Observability Stack..."

# 1. Test Sentry error capture
echo "1️⃣ Testing Sentry error capture..."
curl -s http://localhost:8000/sentry-test || echo "✅ Sentry test endpoint triggered"

# 2. Test Prometheus metrics
echo "2️⃣ Testing Prometheus metrics..."
METRICS=$(curl -s http://localhost:8000/metrics)
if echo "$METRICS" | grep -q "llm_requests_total"; then
    echo "✅ Prometheus metrics exposed"
else
    echo "❌ Prometheus metrics missing"
    exit 1
fi

# 3. Test structured logging
echo "3️⃣ Testing structured logging..."
curl -s http://localhost:8000/api/v1/query -X POST -d '{"query":"test"}' > /dev/null
sleep 2
LOGS=$(docker logs labor-law-api 2>&1 | tail -5)
if echo "$LOGS" | grep -q "query_received"; then
    echo "✅ Structured logs working"
else
    echo "❌ Structured logs not found"
fi

# 4. Test health checks
echo "4️⃣ Testing health checks..."
HEALTH=$(curl -s http://localhost:8000/health/ready)
if echo "$HEALTH" | grep -q "healthy"; then
    echo "✅ Health checks working"
else
    echo "❌ Health checks failing"
    exit 1
fi

# 5. Test Grafana
echo "5️⃣ Testing Grafana..."
if curl -s http://localhost:3001 | grep -q "Grafana"; then
    echo "✅ Grafana accessible"
else
    echo "❌ Grafana not accessible"
fi

echo ""
echo "✅ All observability tests passed!"
echo ""
echo "📊 Dashboards:"
echo "  - Sentry: https://sentry.io"
echo "  - Grafana: http://localhost:3001 (admin/admin)"
echo "  - Prometheus: http://localhost:9090"
```

#### 5.2 Load Testing with k6

```javascript
// scripts/load-test.js
import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  stages: [
    { duration: '1m', target: 10 },  // Ramp up to 10 users
    { duration: '3m', target: 10 },  // Stay at 10 users
    { duration: '1m', target: 0 },   // Ramp down to 0 users
  ],
  thresholds: {
    http_req_duration: ['p(95)<3000'], // 95% of requests should be below 3s
    http_req_failed: ['rate<0.05'],     // Less than 5% error rate
  },
};

export default function () {
  const payload = JSON.stringify({
    query: '勞基法加班費如何計算？',
  });

  const params = {
    headers: {
      'Content-Type': 'application/json',
    },
  };

  const res = http.post('http://localhost:8000/api/v1/query', payload, params);

  check(res, {
    'status is 200': (r) => r.status === 200,
    'response has content': (r) => r.json('content') !== undefined,
    'confidence score present': (r) => r.json('confidence_score') !== undefined,
  });

  sleep(1);
}
```

```bash
# Run load test
k6 run scripts/load-test.js

# Check Grafana for metrics during load test
```

---

## Common Issues & Troubleshooting

### Issue 1: Sentry Not Capturing Errors

**Symptoms:**
- Errors not appearing in Sentry dashboard
- No transactions recorded

**Solutions:**

```python
# 1. Verify DSN is set
from app.config import settings
print(f"Sentry DSN: {settings.sentry_dsn.get_secret_value()[:20]}...")

# 2. Force flush (useful in tests)
import sentry_sdk
sentry_sdk.flush()

# 3. Check environment
import sentry_sdk
hub = sentry_sdk.Hub.current
print(f"Sentry client: {hub.client}")
print(f"Environment: {hub.client.options['environment']}")
```

### Issue 2: Prometheus Metrics Not Showing

**Symptoms:**
- `/metrics` endpoint returns 404
- Prometheus target shows "down"

**Solutions:**

```python
# 1. Ensure metrics are initialized
from app.main import app
from app.observability.metrics import init_metrics

init_metrics(app)

# 2. Check if endpoint is excluded
# Remove /metrics from excluded_handlers
instrumentator = Instrumentator(
    excluded_handlers=["/health"],  # Don't exclude /metrics
)

# 3. Verify Prometheus scrape config
# config/prometheus.yml
scrape_configs:
  - job_name: 'labor-law-api'
    static_configs:
      - targets: ['host.docker.internal:8000']  # Use this for Docker
```

### Issue 3: Logs Not Appearing in Loki

**Symptoms:**
- Grafana Explore shows no logs
- Promtail not scraping containers

**Solutions:**

```bash
# 1. Check Promtail status
docker logs promtail

# 2. Verify Promtail can reach Loki
docker exec promtail wget -O- http://loki:3100/ready

# 3. Check container labels
docker inspect labor-law-api | grep -A 10 "Labels"

# 4. Force JSON logging in production
# backend/app/config.py
APP_ENV=production  # This enables JSON logging
```

---

## Deployment Checklist

### Pre-Production

- [ ] Sentry DSN configured in environment
- [ ] Sentry alerts set up (error spike, high latency)
- [ ] Prometheus scraping working
- [ ] Grafana dashboards imported
- [ ] AlertManager configured with Slack webhook
- [ ] Health check endpoints tested
- [ ] LLM cost tracking tested
- [ ] Load testing completed (k6)

### Production

- [ ] Sentry release tracking enabled (`release=0.1.0`)
- [ ] Sentry sample rates tuned (20% for traces)
- [ ] Log retention configured (30 days)
- [ ] Metric retention configured (15 days)
- [ ] Alert on-call rotation set up
- [ ] Runbooks created for common alerts
- [ ] Status page configured (BetterStack)
- [ ] Monthly observability review scheduled

---

## Cost Optimization Tips

### 1. Reduce Sentry Costs

```python
# Smart sampling based on endpoint importance
def custom_traces_sampler(sampling_context):
    # Critical endpoints: always trace
    if "/api/v1/query" in sampling_context["transaction"]:
        return 1.0 if settings.app_env == "development" else 0.5

    # Health checks: never trace
    if "/health" in sampling_context["transaction"]:
        return 0.0

    # Everything else: low sample rate
    return 0.1
```

### 2. Optimize Log Volume

```python
# Don't log every request in production
if settings.app_env == "production":
    # Only log errors and important events
    structlog.configure(
        processors=[
            structlog.stdlib.filter_by_level,  # Filter by log level
            # ... other processors
        ]
    )

    # Only log 10% of successful queries
    if random.random() > 0.1:
        return  # Skip logging
```

### 3. Metric Cardinality Control

```python
# ❌ BAD: High cardinality (creates millions of time series)
llm_requests.labels(
    model=model,
    user_id=user_id,  # Don't do this!
    query_text=query_text  # Don't do this!
).inc()

# ✅ GOOD: Low cardinality
llm_requests.labels(
    model=model,
    status="success"
).inc()
```

---

## Next Steps

1. **Complete Phase 0 setup** (30 min quick start)
2. **Deploy observability stack** (docker-compose up)
3. **Import Grafana dashboards** (see appendix)
4. **Run load test** (k6 run load-test.js)
5. **Tune alerts** based on baseline metrics
6. **Schedule monthly review** to optimize costs

**Questions?** See main strategy document or contact DevOps team.
