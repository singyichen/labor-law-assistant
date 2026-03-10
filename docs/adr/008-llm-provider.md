# ADR-008: Use Anthropic Claude as Primary LLM Provider

**Status**: Accepted
**Date**: 2025-02-13

## Context

The system generates answers to labor law questions using RAG context (retrieved legal articles + FAQ). The LLM must produce accurate, well-cited responses in Traditional Chinese with appropriate legal disclaimers. Incorrect legal advice can cause real harm, making accuracy the top priority.

Key requirements:
- Traditional Chinese output quality (natural, professional zh-TW).
- Legal reasoning accuracy (correctly interpret and cite law articles).
- SSE streaming support (chat UX with Vercel AI SDK).
- Structured output (JSON mode for citations, confidence scores).
- Low hallucination rate (must not fabricate legal citations).
- Cost-effective at MVP scale (~5,000 queries/month, ~4K input + ~1.5K output tokens per query).

### Candidates Evaluated

| Model | zh-TW (30%) | Legal Reasoning (25%) | Streaming (15%) | Safety (10%) | Cost (10%) | Latency (5%) | Structured Output (3%) | Reliability (2%) | **Weighted** |
|-------|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|:-:|
| **Claude Sonnet 4.5** | 9.5 | 9.5 | 10 | 9.5 | 8.0 | 8.5 | 10 | 9.5 | **9.40** |
| Claude Haiku 3.5 | 8.0 | 7.5 | 10 | 8.5 | 9.0 | 9.5 | 10 | 9.5 | 8.50 |
| GPT-4o | 8.5 | 8.0 | 10 | 8.0 | 7.0 | 8.5 | 10 | 9.5 | 8.47 |
| GPT-4o-mini | 7.5 | 7.0 | 10 | 7.5 | 10 | 9.0 | 10 | 9.5 | 8.19 |
| Gemini 2.0 Flash | 6.5 | 6.5 | 10 | 7.0 | 10 | 10 | 9.0 | 9.0 | 7.73 |

**Models rejected**:
- **Claude Opus 4.6**: Quality marginally better but 6x cost — not justified.
- **OpenAI o1/o3-mini**: No streaming support (fatal for chat UX), latency 10-30s.
- **Gemini 2.0 Flash**: zh-TW quality insufficient (6.5/10) for legal domain.
- **Self-hosted (Qwen 2.5 72B)**: Infrastructure cost ~$650/month vs API ~$50/month; only consider at >500K queries/month.
- **TAIDE (Taiwan AI)**: No public API available yet; monitor for future consideration.

## Decision

Use **Anthropic Claude Sonnet 4.5** as the primary LLM, with **OpenAI GPT-4o-mini** as fallback.

| Concern | Decision |
|---------|----------|
| Primary model | Claude Sonnet 4.5 (`claude-sonnet-4-5-20250929`) |
| Fallback model | GPT-4o-mini (when Claude API is unavailable) |
| Streaming | SSE via Vercel AI SDK (`@ai-sdk/anthropic`) |
| Temperature | 0.3 (low for legal accuracy) |
| Max tokens | 2,048 output |
| Prompt caching | Enabled (system prompt + common FAQ context) |
| Response caching | Redis with 30-day TTL (ADR-005) |

### Cost Projection

| Phase | Queries/month | Cache Hit Rate | Effective Cost/month |
|-------|:------------:|:--------------:|:-------------------:|
| MVP | 5,000 | 70% | ~$40-50 |
| Growth | 50,000 | 75% | ~$350-400 |
| Scale | 500,000 | 80% | ~$3,500-4,000 |

### Fallback Architecture

```
User Query
    |
    v
Redis Cache (70-80% hit) --> Return cached response
    |  (cache miss)
    v
Try: Claude Sonnet 4.5 (with prompt caching)
    |  (if API error / timeout)
    v
Fallback: GPT-4o-mini
    |  (if both fail)
    v
Error response + Sentry alert
```

### Hallucination Prevention

1. **Prompt engineering**: Require explicit citation format (`[法律名稱第X條]`), provide few-shot examples.
2. **Backend validation**: Verify all cited article IDs exist in the database before returning response.
3. **Confidence scoring**: Self-assessed confidence level (high/medium/low) included in every response.
4. **Monitoring**: Track hallucination rate via Prometheus metric (target: <2%).

## Consequences

### Easier
- Claude Sonnet 4.5 produces the most natural Traditional Chinese among evaluated models (9.5/10).
- Vercel AI SDK provides native Anthropic integration — streaming works out of the box with Next.js.
- Prompt caching reduces cost by ~20% for repeated system prompts.
- Combined with Redis response cache (70-80% hit rate), effective cost drops to ~$0.008/query.
- GPT-4o-mini fallback ensures service continuity during Anthropic outages at minimal cost ($0.0015/query).
- Low temperature (0.3) reduces hallucination in legal domain.

### Harder
- Two LLM provider dependencies (Anthropic primary + OpenAI fallback) — two API keys, two billing accounts.
- Prompt templates may need adjustment between Claude and GPT-4o-mini (different instruction-following behaviors).
- Must monitor Anthropic pricing changes — currently competitive but no long-term price guarantee.
- Claude Sonnet 4.5 is not the cheapest option; if budget becomes constrained, may need to route simple queries to Haiku.
- Legal citation validation adds backend complexity (must maintain article ID registry).

## Referenced by

- [PRD README.md](../prd/README.md) — Appendix B Technology Stack, §8.4 Cost Monitoring & Alert Thresholds
- [Epic 01: Chat Interface](../prd/epics/01-chat-interface.md) — Technical Dependencies
- [Epic 02: RAG Legal Search](../prd/epics/02-rag-legal-search.md) — Related ADRs
- [Epic 03: Response Quality](../prd/epics/03-response-quality.md) — Related ADRs
- [Epic 04: Action Guide & Emergency](../prd/epics/04-action-guide-emergency.md) — Related ADRs
- [Epic 05: Accessibility & i18n](../prd/epics/05-accessibility-i18n.md) — Related ADRs, multilingual response
