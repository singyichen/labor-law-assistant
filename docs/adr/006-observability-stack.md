# ADR-006: Observability Stack (Sentry, structlog, Prometheus, Grafana, OpenTelemetry)

**Status**: Accepted
**Date**: 2025-02-13

## Context

The system serves legal queries where accuracy is critical and LLM API costs can escalate quickly. Effective observability is needed for:

- **Error tracking**: Catch production bugs before users report them.
- **LLM cost monitoring**: Prevent runaway API costs (Claude API charges per token).
- **Performance monitoring**: Track response times, cache hit rates, and vector search latency.
- **Legal accuracy tracking**: Monitor confidence scores and citation quality.
- **Privacy compliance**: User queries may contain PII — logging must be privacy-safe.

Key constraints:
- Small team (1-3 developers) — low operational overhead required.
- Budget-conscious MVP — prefer free/open-source tools.
- Must support both Python/FastAPI backend and Next.js frontend.

### Candidates Evaluated

#### Error Tracking / APM
| Tool | Python Support | Next.js Support | LLM Tracing | Cost (MVP) |
|------|:-:|:-:|:-:|------|
| **Sentry** | Excellent | Excellent | Via custom spans | Free → $26/mo |
| Datadog | Excellent | Good | Native | $200+/mo |
| New Relic | Good | Good | Limited | $200+/mo |
| Self-hosted (Grafana) | Manual | Manual | Manual | Free (ops cost) |

#### Structured Logging
| Tool | Async Support | JSON Output | Integration |
|------|:-:|:-:|-------------|
| **structlog** | Yes | Native | First-class Sentry/OTEL integration |
| loguru | Yes | Plugin | Popular but less structured |
| stdlib logging | Yes | Via formatter | Verbose setup |

#### Metrics & Dashboards
| Tool | Cost | Ecosystem | Query Language |
|------|------|-----------|---------------|
| **Prometheus + Grafana** | Free (self-hosted) | Industry standard | PromQL |
| Datadog Metrics | $200+/mo | All-in-one | DQL |
| CloudWatch | Pay-per-use | AWS only | CloudWatch Insights |

#### Distributed Tracing
| Tool | Vendor Lock-in | Auto-instrumentation | Standard |
|------|:-:|:-:|----------|
| **OpenTelemetry** | None | FastAPI, httpx, SQLAlchemy | CNCF standard |
| Jaeger | None | Limited | OpenTracing |
| Zipkin | None | Limited | Custom |

## Decision

Adopt a **layered observability stack** using open-source and free-tier tools:

| Layer | Technology | Priority |
|-------|-----------|:--------:|
| Error Tracking + APM | Sentry (Free → Team tier) | P0 |
| Structured Logging | structlog | P0 |
| Log Aggregation | Grafana Loki (self-hosted) | P1 |
| Metrics | Prometheus + Grafana (self-hosted) | P1 |
| Distributed Tracing | OpenTelemetry → Sentry | P1 |
| Uptime Monitoring | BetterStack (Free tier) | P1 |
| Alerting | Prometheus AlertManager → Slack | P1 |

### Key Metrics to Track

| Category | Metric | Target | Alert Threshold |
|----------|--------|--------|----------------|
| System | P95 response time | < 1s | > 3s |
| System | Error rate | < 0.5% | > 2% |
| System | Uptime | 99.9% | < 99.5% |
| Cache | Hit rate | > 70% | < 50% |
| LLM | Time to first token (TTFT) | < 2s | > 5s |
| LLM | Daily API cost | < $10 | > $20 |
| Legal | Confidence score avg | > 0.8 | < 0.6 |

### Privacy Guidelines

- Never log full user query text — use hashed identifiers.
- Mask PII in Sentry breadcrumbs with `before_send` hook.
- Log query length and category, not content.

### Cost Projection

| Stage | MAU | Monthly Cost |
|-------|----:|-------------|
| MVP | 0-1K | $0 |
| Growth | 1-10K | ~$46 (Sentry $26 + BetterStack $20) |
| Scale | 10K+ | ~$100-200 |

## Consequences

### Easier
- Sentry provides unified error tracking for both FastAPI and Next.js with minimal setup (~4 hours).
- structlog produces JSON logs that integrate directly with Loki, Sentry, and OpenTelemetry.
- OpenTelemetry is vendor-neutral (CNCF standard) — can switch backends without code changes.
- Prometheus + Grafana are industry standard with extensive community dashboards.
- LLM cost tracking via custom Prometheus metrics prevents budget overruns.
- Total MVP cost is $0/month using free tiers.

### Harder
- Self-hosted Prometheus + Grafana + Loki requires Docker Compose setup and maintenance.
- OpenTelemetry auto-instrumentation adds slight overhead to request processing.
- Multiple tools to learn (Sentry, Grafana, PromQL, LogQL) vs single vendor (Datadog).
- Alert tuning requires production traffic data — initial thresholds will need adjustment.
- Sentry free tier has limited event quota (5K errors/month) — may need paid tier at scale.
