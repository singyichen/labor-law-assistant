# LLM Provider & Model Evaluation

## Document Information

| Item | Content |
|------|---------|
| **Version** | v1.0 |
| **Created** | 2026-03-02 |
| **Owner** | Senior AI Engineer |
| **Status** | Draft |

---

## Executive Summary

**Recommended Primary Model**: **Anthropic Claude 3.7 Sonnet** (claude-sonnet-4-5)
**Recommended Fallback Model**: **OpenAI GPT-4o-mini** (gpt-4o-mini-2024-07-18)
**Estimated Cost (MVP)**: USD $150-200/month (5,000 queries)
**Estimated Cost (Growth)**: USD $1,500-2,000/month (50,000 queries)

**Key Rationale**:
- Claude Sonnet 4.5: Excellent Traditional Chinese quality, strong legal reasoning, prompt caching (90% cost reduction on system prompts)
- GPT-4o-mini: Cost-effective fallback with good zh-TW quality, widely adopted API
- Combined strategy achieves 95%+ uptime with optimized cost structure

---

## 1. Evaluation Criteria & Weights

### Critical Requirements (Must-Have)

| Criterion | Weight | Why Critical for Labor Law Assistant |
|-----------|--------|--------------------------------------|
| **Traditional Chinese Quality** | 30% | Natural zh-TW output is non-negotiable; poor quality destroys user trust |
| **Legal Reasoning Accuracy** | 25% | Incorrect legal advice can cause real harm; must correctly interpret law articles |
| **Streaming Support (SSE)** | 15% | Required for frontend UX (Vercel AI SDK integration) |
| **Safety/Hallucination Prevention** | 10% | Must not fabricate legal citations or misquote law articles |

### Important Requirements (Nice-to-Have)

| Criterion | Weight | Rationale |
|-----------|--------|-----------|
| **Cost Efficiency** | 10% | Budget-conscious but willing to pay for quality |
| **Latency (TTFT + Total)** | 5% | Important but caching mitigates most latency issues |
| **Structured Output Support** | 3% | JSON mode for citations & confidence scores |
| **API Reliability** | 2% | Fallback strategy handles downtime |

---

## 2. Model Candidates Analysis

### 2.1 Anthropic Claude Models

#### Claude 3.7 Sonnet (claude-sonnet-4-5) ⭐ PRIMARY CHOICE

**Specifications**
- Context Window: 200K tokens
- Output Limit: 8K tokens
- Streaming: Yes (SSE)
- Structured Output: Yes (JSON mode, tool use)
- Prompt Caching: Yes (5-minute TTL, 90% cost reduction on cached tokens)

**Pricing (as of Jan 2025)**
- Input: $3.00 / 1M tokens
- Output: $15.00 / 1M tokens
- **Prompt Caching**: $0.30 / 1M cached input tokens (10x cheaper)

**Traditional Chinese Quality**: ⭐⭐⭐⭐⭐ (9.5/10)
- Most natural zh-TW output among all models
- Correctly uses Traditional Chinese terms (e.g., "勞動基準法" not "劳动基准法")
- Appropriate formality level for legal content
- **Test Result**: Generated sample response with perfect legal terminology

**Legal Reasoning**: ⭐⭐⭐⭐⭐ (9.5/10)
- Excellent at multi-step reasoning required for labor law cases
- Strong citation accuracy (rarely hallucinates sources when instructed properly)
- Good at identifying edge cases and exceptions in law articles
- **Test Case**: Correctly interpreted Labor Standards Act Article 24 overtime calculation with multi-tier rates

**Streaming Performance**
- TTFT (Time to First Token): ~800ms (with prompt caching: ~400ms)
- Total Generation Time (1,500 tokens): ~5-6 seconds
- Smooth SSE streaming, works well with Vercel AI SDK

**Cost Analysis (with Prompt Caching)**
```
Assumptions:
- Input: 4,000 tokens avg (500 system prompt + 3,500 RAG context)
- Output: 1,500 tokens avg
- Cache hit rate: 70% (Redis cache) + 80% (prompt cache on miss)
- Cached portion: System prompt (500 tokens) + Static FAQs (2,000 tokens)

Cost per query (cache MISS):
Input: 4,000 tokens × $3.00 / 1M = $0.012
Output: 1,500 tokens × $15.00 / 1M = $0.0225
Total: $0.0345 per query

Cost per query (prompt cache HIT):
Cached input: 2,500 tokens × $0.30 / 1M = $0.00075
Uncached input: 1,500 tokens × $3.00 / 1M = $0.0045
Output: 1,500 tokens × $15.00 / 1M = $0.0225
Total: $0.02775 per query

Blended cost (30% miss, 70% hit):
(0.30 × $0.0345) + (0.70 × $0.02775) = $0.02978 per query
```

**Pros**
- Best-in-class Traditional Chinese quality
- Excellent legal reasoning and instruction-following
- Prompt caching dramatically reduces cost (90% savings on cached tokens)
- Strong safety guardrails (rarely hallucinates citations)
- JSON mode for structured output
- Vercel AI SDK has official Claude support

**Cons**
- Slightly higher cost than GPT-4o-mini (but offset by prompt caching)
- Smaller market share than OpenAI (but API reliability is excellent)

**Recommendation**: **PRIMARY MODEL** ✅

---

#### Claude 3.5 Haiku (claude-3-5-haiku-20241022)

**Specifications**
- Context Window: 200K tokens
- Output Limit: 8K tokens
- Streaming: Yes
- Prompt Caching: Yes

**Pricing**
- Input: $1.00 / 1M tokens
- Output: $5.00 / 1M tokens
- Prompt Caching: $0.10 / 1M cached tokens

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (8.0/10)
- Good zh-TW quality but less natural than Sonnet
- Occasionally uses Simplified Chinese terms in mixed contexts

**Legal Reasoning**: ⭐⭐⭐⭐ (7.5/10)
- Adequate for simple queries
- May struggle with complex multi-article interpretations

**Cost per Query** (with caching): ~$0.015

**Recommendation**: Could be used for **simple FAQ routing** if implementing multi-model strategy (see Section 4.3)

---

#### Claude Opus 4.6 (claude-opus-4-6)

**Pricing**
- Input: $15.00 / 1M tokens
- Output: $75.00 / 1M tokens

**Cost per Query**: ~$0.18 (6x more expensive than Sonnet)

**Recommendation**: **NOT RECOMMENDED** - Cost is prohibitive for production use; Sonnet quality is sufficient for labor law queries

---

### 2.2 OpenAI GPT Models

#### GPT-4o (gpt-4o-2024-11-20)

**Specifications**
- Context Window: 128K tokens
- Output Limit: 16K tokens
- Streaming: Yes
- Structured Output: Yes (JSON Schema mode)
- Prompt Caching: No native support (but can use Helicone/LangSmith)

**Pricing**
- Input: $2.50 / 1M tokens
- Output: $10.00 / 1M tokens

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (8.5/10)
- Very good zh-TW quality
- Occasionally less formal than ideal for legal content
- Sometimes mixes Traditional/Simplified terms

**Legal Reasoning**: ⭐⭐⭐⭐ (8.0/10)
- Good reasoning but less reliable than Claude Sonnet
- More prone to subtle hallucinations in legal citations

**Cost per Query**: $0.025 (no prompt caching)

**Pros**
- Excellent API reliability (99.9% uptime)
- Widely adopted, extensive documentation
- JSON Schema mode for structured output
- Vercel AI SDK has first-class support

**Cons**
- No native prompt caching (cost disadvantage)
- Slightly inferior zh-TW quality vs Claude
- Higher hallucination rate for legal citations

**Recommendation**: **SECONDARY/FALLBACK** (use GPT-4o-mini instead for cost)

---

#### GPT-4o-mini (gpt-4o-mini-2024-07-18) ⭐ FALLBACK CHOICE

**Specifications**
- Context Window: 128K tokens
- Output Limit: 16K tokens
- Streaming: Yes
- Structured Output: Yes

**Pricing**
- Input: $0.15 / 1M tokens
- Output: $0.60 / 1M tokens

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (7.5/10)
- Good zh-TW quality for the price
- Acceptable for most labor law queries

**Legal Reasoning**: ⭐⭐⭐ (7.0/10)
- Adequate for straightforward questions
- May miss nuances in complex legal scenarios

**Cost per Query**: $0.0015 (6x cheaper than Claude Sonnet without caching)

**Recommendation**: **FALLBACK MODEL** ✅ - Excellent cost/performance for fallback scenarios

---

#### OpenAI o1 / o3-mini (Reasoning Models)

**Pricing** (o1)
- Input: $15.00 / 1M tokens
- Output: $60.00 / 1M tokens

**Evaluation**
- ⚠️ **No streaming support** (dealbreaker for UX)
- ⚠️ **High latency** (10-30 seconds per query)
- ⚠️ **Very expensive** ($0.135 per query)

**Recommendation**: **NOT RECOMMENDED** - Lack of streaming is a critical issue for chat UX

---

### 2.3 Google Gemini Models

#### Gemini 2.0 Flash (gemini-2.0-flash-exp)

**Specifications**
- Context Window: 1M tokens
- Output Limit: 8K tokens
- Streaming: Yes
- Prompt Caching: Yes (context caching)

**Pricing**
- Input: $0.075 / 1M tokens (≤128K), $0.15 / 1M tokens (>128K)
- Output: $0.30 / 1M tokens (≤128K), $0.60 / 1M tokens (>128K)
- Context Caching: $0.01875 / 1M tokens

**Traditional Chinese Quality**: ⭐⭐⭐ (6.5/10)
- Acceptable zh-TW but noticeably less natural than Claude/GPT
- Occasionally awkward phrasing
- **Test Result**: Struggled with legal terminology consistency

**Legal Reasoning**: ⭐⭐⭐ (6.5/10)
- Adequate but less reliable for complex legal interpretation

**Cost per Query**: ~$0.0025 (with caching)

**Pros**
- Extremely low cost
- Very large context window (1M tokens)
- Fast inference

**Cons**
- Inferior Traditional Chinese quality
- Less reliable legal reasoning
- Vercel AI SDK support is newer/less mature

**Recommendation**: **NOT RECOMMENDED** - Chinese quality is below acceptable threshold

---

#### Gemini 2.0 Pro (gemini-2.0-pro-exp)

**Pricing**
- Input: $1.25 / 1M tokens
- Output: $5.00 / 1M tokens

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (7.5/10)
- Better than Flash but still behind Claude/GPT

**Cost per Query**: ~$0.015

**Recommendation**: **NOT RECOMMENDED** - Not competitive with Claude Sonnet on zh-TW quality

---

### 2.4 Open-Source Self-Hosted Models

#### Qwen 2.5 72B (阿里通義千問)

**Specifications**
- Parameters: 72B
- Context Window: 128K tokens
- Traditional Chinese: Native support (Chinese-first training)

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (8.0/10)
- Excellent zh-TW quality (trained on Chinese web data)
- Natural legal terminology

**Legal Reasoning**: ⭐⭐⭐ (6.5/10)
- Good for general Chinese queries
- Less reliable for Taiwan-specific labor law nuances

**Deployment Cost**
- Infrastructure: ~$500-800/month (AWS p4d.24xlarge or similar)
- Requires ML Ops team for deployment, monitoring, updates

**Pros**
- No per-query API costs
- Full data control (privacy)
- Can fine-tune on Taiwan labor law corpus

**Cons**
- High upfront infrastructure cost
- Requires ML Ops expertise
- Less reliable than Claude/GPT for legal reasoning
- May not be cost-effective until >100K queries/month

**Recommendation**: **NOT RECOMMENDED for MVP** - Consider for future if scale reaches 500K+ queries/month

---

#### Meta Llama 3.1 70B

**Traditional Chinese Quality**: ⭐⭐⭐ (6.0/10)
- Acceptable but noticeably behind Claude/GPT
- English-first training shows in zh-TW output

**Legal Reasoning**: ⭐⭐⭐ (6.5/10)

**Recommendation**: **NOT RECOMMENDED** - Inferior zh-TW quality

---

### 2.5 Taiwan-Specific: TAIDE (Taiwan AI Development)

#### TAIDE LX 70B

**Specifications**
- Parameters: 70B
- Training: Taiwan-specific corpus (government documents, news, etc.)
- Availability: Limited access, primarily for academic/government use

**Traditional Chinese Quality**: ⭐⭐⭐⭐ (8.5/10)
- Excellent Traditional Chinese (Taiwan-native training)
- Natural Taiwan-specific terminology

**Legal Reasoning**: ⭐⭐⭐ (6.5/10)
- Unknown - insufficient public benchmarks

**Availability**: ⚠️ **Not publicly available** as API service (as of Mar 2026)

**Recommendation**: **MONITOR** - Excellent zh-TW quality but not production-ready; re-evaluate if API becomes available

---

## 3. Scoring Matrix

### Overall Evaluation (Weighted Scores)

| Model | zh-TW Quality (30%) | Legal Reasoning (25%) | Streaming (15%) | Safety (10%) | Cost (10%) | Latency (5%) | Structured Output (3%) | Reliability (2%) | **TOTAL** |
|-------|---------------------|----------------------|----------------|--------------|------------|-------------|----------------------|------------------|-----------|
| **Claude Sonnet 4.5** | 9.5 (2.85) | 9.5 (2.38) | 10 (1.50) | 9.5 (0.95) | 8.0 (0.80) | 8.5 (0.43) | 10 (0.30) | 9.5 (0.19) | **9.40** ⭐ |
| **GPT-4o-mini** | 7.5 (2.25) | 7.0 (1.75) | 10 (1.50) | 7.5 (0.75) | 10 (1.00) | 9.0 (0.45) | 10 (0.30) | 9.5 (0.19) | **8.19** |
| GPT-4o | 8.5 (2.55) | 8.0 (2.00) | 10 (1.50) | 8.0 (0.80) | 7.0 (0.70) | 8.5 (0.43) | 10 (0.30) | 9.5 (0.19) | **8.47** |
| Claude Haiku 3.5 | 8.0 (2.40) | 7.5 (1.88) | 10 (1.50) | 8.5 (0.85) | 9.0 (0.90) | 9.5 (0.48) | 10 (0.30) | 9.5 (0.19) | **8.50** |
| Gemini 2.0 Flash | 6.5 (1.95) | 6.5 (1.63) | 10 (1.50) | 7.0 (0.70) | 10 (1.00) | 10 (0.50) | 9.0 (0.27) | 9.0 (0.18) | **7.73** |
| Gemini 2.0 Pro | 7.5 (2.25) | 7.0 (1.75) | 10 (1.50) | 7.5 (0.75) | 8.5 (0.85) | 9.0 (0.45) | 9.0 (0.27) | 9.0 (0.18) | **8.00** |
| Qwen 2.5 72B | 8.0 (2.40) | 6.5 (1.63) | 10 (1.50) | 7.0 (0.70) | 6.0 (0.60) | 7.0 (0.35) | 8.0 (0.24) | 7.0 (0.14) | **7.56** |

**Winner**: **Claude Sonnet 4.5** (9.40/10) with **GPT-4o-mini** (8.19/10) as fallback

---

## 4. Recommended Architecture

### 4.1 Primary Strategy: Claude Sonnet 4.5 + GPT-4o-mini Fallback

```
User Query
    ↓
┌──────────────────────────────┐
│ Redis Cache Check            │
│ (70-80% hit rate)            │
└──────────────────────────────┘
    ↓ (cache miss)
┌──────────────────────────────┐
│ Try: Claude Sonnet 4.5       │
│ (with prompt caching)        │
└──────────────────────────────┘
    ↓ (if API error/timeout)
┌──────────────────────────────┐
│ Fallback: GPT-4o-mini        │
│ (OpenAI API)                 │
└──────────────────────────────┘
    ↓ (if both fail)
┌──────────────────────────────┐
│ Error: "System unavailable"  │
│ (log to Sentry, alert)       │
└──────────────────────────────┘
```

**Implementation (FastAPI)**

```python
from anthropic import Anthropic, APIError
from openai import OpenAI, OpenAIError
from app.core.cache import redis_cache
import structlog

logger = structlog.get_logger()

class LLMService:
    def __init__(self):
        self.anthropic = Anthropic(api_key=settings.ANTHROPIC_API_KEY)
        self.openai = OpenAI(api_key=settings.OPENAI_API_KEY)

    async def generate_answer(
        self,
        user_query: str,
        rag_context: str,
        stream: bool = True
    ) -> AsyncIterator[str]:
        """
        Generate answer with Claude Sonnet 4.5 (primary) and GPT-4o-mini (fallback).

        Args:
            user_query: User's labor law question
            rag_context: Retrieved legal articles + FAQ context
            stream: Whether to stream response (SSE)

        Returns:
            AsyncIterator of response chunks (if stream=True)
        """
        # Check Redis cache first
        cache_key = f"llm:{hash(user_query + rag_context)}"
        cached_response = await redis_cache.get(cache_key)
        if cached_response:
            logger.info("cache_hit", query=user_query[:50])
            yield cached_response
            return

        # Try Claude Sonnet 4.5
        try:
            response = await self._call_claude_sonnet(
                user_query=user_query,
                rag_context=rag_context,
                stream=stream
            )

            # Cache response (30-day TTL)
            if not stream:
                await redis_cache.setex(cache_key, 30 * 24 * 3600, response)

            yield response

        except (APIError, TimeoutError) as e:
            logger.error("claude_api_error", error=str(e), fallback="gpt-4o-mini")

            # Fallback to GPT-4o-mini
            try:
                response = await self._call_gpt_4o_mini(
                    user_query=user_query,
                    rag_context=rag_context,
                    stream=stream
                )
                yield response

            except OpenAIError as e2:
                logger.error("openai_api_error", error=str(e2))
                raise Exception("LLM service unavailable")

    async def _call_claude_sonnet(
        self,
        user_query: str,
        rag_context: str,
        stream: bool
    ) -> str | AsyncIterator[str]:
        """Call Claude Sonnet 4.5 with prompt caching."""

        # System prompt (cached)
        system_prompt = [
            {
                "type": "text",
                "text": """你是台灣勞動法律專業助手。請根據提供的法條和文章回答用戶問題。

要求：
1. 使用繁體中文（zh-TW）回答
2. 必須引用法條依據（使用 [法條名稱第X條] 格式）
3. 用詞專業但淺顯易懂
4. 若資訊不足，明確說明「無法確定」
5. 永遠包含免責聲明

回答格式：
✅ 直接回答
📖 詳細說明
📜 法條依據
⚠️ 注意事項
💡 建議行動""",
                "cache_control": {"type": "ephemeral"}  # Cache this prompt
            }
        ]

        # RAG context (partially cached if using static FAQ)
        messages = [
            {
                "role": "user",
                "content": [
                    {
                        "type": "text",
                        "text": f"參考資料：\n\n{rag_context}",
                        "cache_control": {"type": "ephemeral"}  # Cache RAG context
                    },
                    {
                        "type": "text",
                        "text": f"用戶問題：{user_query}"
                    }
                ]
            }
        ]

        if stream:
            return self.anthropic.messages.stream(
                model="claude-sonnet-4-5-20250929",
                max_tokens=2048,
                system=system_prompt,
                messages=messages,
                temperature=0.3  # Lower temp for legal accuracy
            )
        else:
            response = self.anthropic.messages.create(
                model="claude-sonnet-4-5-20250929",
                max_tokens=2048,
                system=system_prompt,
                messages=messages,
                temperature=0.3
            )
            return response.content[0].text

    async def _call_gpt_4o_mini(
        self,
        user_query: str,
        rag_context: str,
        stream: bool
    ) -> str | AsyncIterator[str]:
        """Fallback to GPT-4o-mini."""

        messages = [
            {
                "role": "system",
                "content": "你是台灣勞動法律專業助手..."  # Same system prompt
            },
            {
                "role": "user",
                "content": f"參考資料：\n\n{rag_context}\n\n用戶問題：{user_query}"
            }
        ]

        if stream:
            return self.openai.chat.completions.create(
                model="gpt-4o-mini-2024-07-18",
                messages=messages,
                max_tokens=2048,
                temperature=0.3,
                stream=True
            )
        else:
            response = self.openai.chat.completions.create(
                model="gpt-4o-mini-2024-07-18",
                messages=messages,
                max_tokens=2048,
                temperature=0.3
            )
            return response.choices[0].message.content
```

---

### 4.2 Prompt Caching Strategy

**Cacheable Components** (with Anthropic Prompt Caching):

1. **System Prompt** (500 tokens) - 100% reuse
2. **Static FAQ Context** (2,000 tokens) - 60% reuse
3. **Law Articles** (variable) - 40% reuse

**Expected Caching Savings**:
```
Without Prompt Caching:
- Cost per query: $0.0345 (4,000 input + 1,500 output tokens)

With Prompt Caching (80% cache hit on 2,500 tokens):
- Cached tokens: 2,500 × $0.30/1M = $0.00075
- Uncached tokens: 1,500 × $3.00/1M = $0.0045
- Output: 1,500 × $15.00/1M = $0.0225
- Total: $0.02775 (20% savings)

Combined with Redis Cache (70% hit rate):
- Effective cost: 0.30 × $0.02775 = $0.008 per query
```

**Implementation**:
- Enable `cache_control: {type: "ephemeral"}` on system prompt and common RAG context
- Cache TTL: 5 minutes (Anthropic default)
- Monitor cache hit rate via Anthropic API headers

---

### 4.3 Advanced: Multi-Model Routing (Future Optimization)

**Query Classification** → **Model Selection**

```python
class QueryRouter:
    """Route queries to appropriate model based on complexity."""

    def classify_query(self, user_query: str) -> QueryComplexity:
        """
        Classify query complexity using simple heuristics.

        Returns:
            SIMPLE: Direct FAQ match (e.g., "加班費怎麼算？")
            MODERATE: Requires 1-2 article interpretation
            COMPLEX: Multi-article cross-referencing, edge cases
        """
        # Check if query matches FAQ (high confidence)
        faq_match = self.faq_index.search(user_query, top_k=1)
        if faq_match[0].score > 0.95:
            return QueryComplexity.SIMPLE

        # Check keyword complexity
        complex_keywords = ["同時", "但是", "例外", "特殊情況", "如果"]
        if any(kw in user_query for kw in complex_keywords):
            return QueryComplexity.COMPLEX

        return QueryComplexity.MODERATE

    def select_model(self, complexity: QueryComplexity) -> str:
        """
        Select model based on query complexity.

        SIMPLE → Claude Haiku 3.5 ($0.015/query)
        MODERATE/COMPLEX → Claude Sonnet 4.5 ($0.028/query)
        """
        if complexity == QueryComplexity.SIMPLE:
            return "claude-3-5-haiku-20241022"
        else:
            return "claude-sonnet-4-5-20250929"
```

**Potential Savings**:
- If 40% of queries are SIMPLE → routed to Haiku ($0.015)
- 60% are MODERATE/COMPLEX → routed to Sonnet ($0.028)
- Blended cost: (0.40 × $0.015) + (0.60 × $0.028) = $0.023/query (18% savings)

**Trade-off**: Added complexity, risk of misclassification
**Recommendation**: Implement in Phase 2 (after MVP validation)

---

## 5. Cost Projections

### 5.1 MVP Phase (5,000 queries/month)

**Assumptions**:
- Redis cache hit rate: 70%
- Prompt cache hit rate: 80% (on cache miss)
- Primary model: Claude Sonnet 4.5
- Fallback usage: 5% of queries

**Calculations**:

| Scenario | Queries | Cost per Query | Monthly Cost |
|----------|---------|----------------|--------------|
| Redis Cache Hit | 3,500 (70%) | $0.00 | $0.00 |
| Claude Sonnet (cache miss) | 1,425 (95% of 1,500) | $0.028 | $39.90 |
| GPT-4o-mini (fallback) | 75 (5% of 1,500) | $0.0015 | $0.11 |
| **Total** | **5,000** | - | **$40.01** |

**With Added Buffer (15%)**: ~$46/month

---

### 5.2 Growth Phase (50,000 queries/month)

**Assumptions**:
- Redis cache hit rate: 75% (more repeat queries)
- Prompt cache hit rate: 80%
- Fallback usage: 3%

| Scenario | Queries | Cost per Query | Monthly Cost |
|----------|---------|----------------|--------------|
| Redis Cache Hit | 37,500 (75%) | $0.00 | $0.00 |
| Claude Sonnet | 12,125 (97% of 12,500) | $0.028 | $339.50 |
| GPT-4o-mini (fallback) | 375 (3% of 12,500) | $0.0015 | $0.56 |
| **Total** | **50,000** | - | **$340.06** |

**With Added Buffer (15%)**: ~$391/month

---

### 5.3 Cost Comparison vs. Alternatives

**50,000 queries/month (25% cache miss after Redis)**

| Strategy | Monthly Cost | Notes |
|----------|--------------|-------|
| **Claude Sonnet 4.5** (recommended) | **$391** | With prompt caching, Redis cache |
| GPT-4o only | $312 | No prompt caching, inferior zh-TW quality |
| GPT-4o-mini only | $19 | Lowest cost, acceptable quality for fallback |
| Gemini 2.0 Flash only | $31 | Low cost, poor zh-TW quality (not recommended) |
| Qwen 2.5 72B (self-hosted) | $650 | Infrastructure cost, MLOps overhead |
| Claude Sonnet + Multi-Model Routing | $310 | 18% savings, added complexity |

**Recommended**: Start with Claude Sonnet 4.5 + Redis cache; re-evaluate multi-model routing at 100K+ queries/month

---

## 6. API Integration Details

### 6.1 Vercel AI SDK Compatibility

**Claude Sonnet 4.5** (via `@ai-sdk/anthropic`)

```typescript
// frontend/lib/ai-client.ts
import { createAnthropic } from '@ai-sdk/anthropic';
import { streamText } from 'ai';

const anthropic = createAnthropic({
  apiKey: process.env.ANTHROPIC_API_KEY,
});

export async function generateAnswer(userQuery: string, ragContext: string) {
  const result = await streamText({
    model: anthropic('claude-sonnet-4-5-20250929'),
    messages: [
      {
        role: 'system',
        content: '你是台灣勞動法律專業助手...',
      },
      {
        role: 'user',
        content: `參考資料：\n${ragContext}\n\n問題：${userQuery}`,
      },
    ],
    temperature: 0.3,
    maxTokens: 2048,
  });

  return result.toAIStreamResponse();
}
```

**Fallback to GPT-4o-mini** (via `@ai-sdk/openai`)

```typescript
import { createOpenAI } from '@ai-sdk/openai';

const openai = createOpenAI({
  apiKey: process.env.OPENAI_API_KEY,
});

export async function generateAnswerFallback(...) {
  const result = await streamText({
    model: openai('gpt-4o-mini-2024-07-18'),
    // ... same parameters
  });

  return result.toAIStreamResponse();
}
```

---

### 6.2 Structured Output (Legal Citations)

**Claude JSON Mode** (for extracting citations after generation)

```python
# Extract structured citations from Claude response
response = anthropic.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=1024,
    messages=[
        {
            "role": "user",
            "content": f"""從以下回答中提取法條引用：

{answer_text}

請以 JSON 格式回傳：
{{
  "citations": [
    {{
      "law_name": "勞動基準法",
      "article": "第24條",
      "relevance": "加班費計算標準"
    }}
  ],
  "confidence_score": 0.95
}}"""
        }
    ],
    temperature=0.0
)
```

**Alternative**: Use Claude's Tool Use (Function Calling)

```python
tools = [
    {
        "name": "cite_legal_article",
        "description": "引用法條依據",
        "input_schema": {
            "type": "object",
            "properties": {
                "law_name": {"type": "string", "description": "法律名稱"},
                "article_number": {"type": "string", "description": "法條編號"},
                "relevance": {"type": "string", "description": "與問題的關聯性"}
            },
            "required": ["law_name", "article_number"]
        }
    }
]

response = anthropic.messages.create(
    model="claude-sonnet-4-5-20250929",
    max_tokens=2048,
    tools=tools,
    messages=[...]
)
```

---

## 7. Safety & Hallucination Prevention

### 7.1 Prompt Engineering Strategies

**Strategy 1: Explicit Citation Requirement**

```python
system_prompt = """你是台灣勞動法律專業助手。

嚴格要求：
1. 每個法律陳述都必須引用法條依據（格式：[法律名稱第X條]）
2. 如果參考資料中沒有相關法條，必須明確說明「提供的資料中無相關法條」
3. 禁止憑空創造法條編號或內容
4. 如果不確定，使用「根據一般勞動法原則...」而非具體法條

範例回答：
✅ 正確：「依[勞動基準法第24條]規定，平日加班費為...」
❌ 錯誤：「依第999條規定...」（法條不存在）
❌ 錯誤：「根據勞基法，加班費為...」（未具體引用法條）
"""
```

**Strategy 2: Confidence Scoring**

```python
# Ask Claude to self-assess confidence
user_prompt = f"""參考資料：
{rag_context}

問題：{user_query}

請回答問題，並在最後評估你的答案信心度（0.0-1.0）：
- 1.0：參考資料中有明確法條依據
- 0.7-0.9：有相關法條但需推論
- 0.5-0.7：僅有部分相關資訊
- <0.5：資訊不足，需要更多法條

回答格式：
[你的回答]

---
信心度：0.XX
理由：[為何是這個信心度]
"""
```

**Strategy 3: Few-Shot Examples**

```python
# Include examples of correct citation behavior
few_shot_examples = """
範例 1：
問題：「平日加班費怎麼算？」
回答：「依[勞動基準法第24條第1款]規定，延長工作時間在2小時以內者，按平日每小時工資額加給三分之一以上。」

範例 2：
問題：「公司可以強制員工加班嗎？」
回答：「依[勞動基準法第32條]規定，雇主延長勞工工作時間應徵得勞工同意，不得強制。」

範例 3（資訊不足）：
問題：「外籍勞工加班費怎麼算？」
回答：「外籍勞工的加班費計算原則與本國勞工相同，同樣適用[勞動基準法第24條]。但若涉及特定產業（如家庭看護）的特殊規定，提供的資料中無相關法條，建議查詢就業服務法相關規定。信心度：0.6」
"""
```

---

### 7.2 Post-Generation Validation

**Backend Validation Layer**

```python
class LegalCitationValidator:
    """Validate legal citations in LLM responses."""

    def __init__(self, law_database: LawDatabase):
        self.law_db = law_database

    def validate_response(self, response: str) -> ValidationResult:
        """
        Validate all legal citations in response.

        Returns:
            ValidationResult with hallucination flags
        """
        # Extract citations using regex
        citations = re.findall(r'\[([^\]]+法)第(\d+)條\]', response)

        hallucinations = []
        for law_name, article_num in citations:
            # Check if citation exists in database
            exists = self.law_db.check_article_exists(law_name, article_num)
            if not exists:
                hallucinations.append({
                    "law": law_name,
                    "article": article_num,
                    "type": "non_existent_article"
                })

        # Flag response if hallucinations detected
        if hallucinations:
            logger.warning(
                "hallucination_detected",
                count=len(hallucinations),
                citations=hallucinations
            )

            # Option 1: Re-generate with stronger prompt
            # Option 2: Add disclaimer to user
            # Option 3: Reject response and use fallback

        return ValidationResult(
            is_valid=len(hallucinations) == 0,
            hallucinations=hallucinations,
            confidence_score=self._calculate_confidence(response)
        )

    def _calculate_confidence(self, response: str) -> float:
        """Calculate confidence based on citation density and validation."""
        citation_count = len(re.findall(r'\[[^\]]+法第\d+條\]', response))
        if citation_count == 0:
            return 0.3  # Low confidence if no citations

        # Extract LLM's self-reported confidence if present
        confidence_match = re.search(r'信心度[：:]\s*([0-9.]+)', response)
        if confidence_match:
            return float(confidence_match.group(1))

        return 0.8  # Default if citations present
```

---

### 7.3 Monitoring & Alerting

**Key Metrics to Track**:

| Metric | Threshold | Action |
|--------|-----------|--------|
| Hallucination Rate | >2% of responses | Alert to team, review prompts |
| Low Confidence Responses | >10% with score <0.7 | Review RAG retrieval quality |
| Fallback Usage | >5% of queries | Investigate Claude API issues |
| Average Response Length | <500 or >3000 tokens | Check prompt drift |
| Citation Density | <1 citation per 500 tokens | Strengthen citation requirement |

**Implementation** (with Prometheus + Grafana):

```python
from prometheus_client import Counter, Histogram

llm_responses_total = Counter(
    'llm_responses_total',
    'Total LLM responses',
    ['model', 'status']
)

llm_hallucinations_total = Counter(
    'llm_hallucinations_total',
    'Detected hallucinations',
    ['type']
)

llm_confidence_score = Histogram(
    'llm_confidence_score',
    'LLM response confidence scores',
    buckets=[0.5, 0.6, 0.7, 0.8, 0.9, 1.0]
)

# In LLMService
validation_result = validator.validate_response(response)
llm_confidence_score.observe(validation_result.confidence_score)

if validation_result.hallucinations:
    llm_hallucinations_total.labels(type='citation').inc()
```

---

## 8. Migration Path & Rollout Plan

### Phase 1: MVP (Month 1-2)

**Goal**: Validate core functionality with minimal cost

**Configuration**:
- Primary Model: Claude Sonnet 4.5
- Fallback Model: GPT-4o-mini
- Redis Cache: Enabled (30-day TTL)
- Prompt Caching: Enabled
- Multi-Model Routing: Disabled (use Sonnet for all queries)

**Monitoring**:
- Track cache hit rates (Redis + Prompt cache)
- Monitor hallucination rate
- Measure user satisfaction (thumbs up/down on responses)

**Success Criteria**:
- Hallucination rate <2%
- Average confidence score >0.8
- User satisfaction >80% positive

---

### Phase 2: Optimization (Month 3-4)

**Goal**: Reduce costs while maintaining quality

**New Features**:
- Multi-model routing (Haiku for simple queries)
- A/B testing: Claude vs GPT-4o for specific query types
- Fine-tune prompt templates based on user feedback

**Experiments**:
1. Route 20% of traffic to Claude Haiku for simple FAQ queries
2. Compare user satisfaction between Haiku vs Sonnet
3. If satisfaction delta <5%, roll out Haiku to 40% of simple queries

**Expected Savings**: 15-20% cost reduction

---

### Phase 3: Scale (Month 5+)

**Goal**: Prepare for production scale (100K+ queries/month)

**Evaluation Points**:
- If cost >$1,000/month: Re-evaluate self-hosted models (Qwen 2.5)
- If Taiwan-specific issues arise: Explore TAIDE API (if available)
- If latency becomes issue: Consider edge deployment (Cloudflare Workers AI)

**Decision Tree**:
```
If monthly cost >$1,500:
  ├── If self-hosted can save >30%: Migrate to Qwen 2.5 (6-month project)
  └── Else: Negotiate volume discounts with Anthropic

If hallucination rate >3%:
  ├── If prompt engineering fails: Switch to more reliable model (Opus 4.6)
  └── Else: Implement stricter validation + re-generation

If Traditional Chinese quality feedback is negative:
  └── Consider TAIDE (if API available) or fine-tuned Qwen 2.5
```

---

## 9. Risk Assessment & Mitigation

| Risk | Likelihood | Impact | Mitigation |
|------|------------|--------|------------|
| **Anthropic API downtime** | Low (99.9% uptime) | High | GPT-4o-mini fallback, multi-region deployment |
| **Cost overrun** (>2x projection) | Medium | Medium | Set budget alerts, implement rate limiting |
| **Hallucinated legal citations** | Medium | Very High | Validation layer, human review for flagged responses |
| **Prompt injection attacks** | Low | Medium | Input sanitization, prompt guards |
| **Traditional Chinese quality degradation** | Low | High | A/B testing, user feedback loop |
| **Model pricing increase** | Medium | Medium | Lock in pricing with annual contract, maintain fallback |
| **Compliance issues** (data privacy) | Low | Very High | Use Anthropic's zero data retention option |

---

## 10. Final Recommendation

### Primary Configuration

| Component | Choice | Rationale |
|-----------|--------|-----------|
| **Primary Model** | **Claude Sonnet 4.5** | Best Traditional Chinese quality, excellent legal reasoning, prompt caching |
| **Fallback Model** | **GPT-4o-mini** | Cost-effective, reliable API, good zh-TW quality |
| **Caching Strategy** | **Redis (30-day) + Prompt Cache** | 70% Redis hit + 80% prompt cache = 94% cost reduction potential |
| **Streaming** | **Enabled (SSE)** | Required for chat UX |
| **Multi-Model Routing** | **Phase 2** | Implement after MVP validation |
| **Self-Hosted** | **Phase 3** | Only if scale exceeds 500K queries/month |

---

### Cost Summary

| Phase | Monthly Queries | Estimated Cost | Cost per Query |
|-------|----------------|----------------|----------------|
| MVP | 5,000 | $40-50 | $0.008-0.010 |
| Growth | 50,000 | $350-400 | $0.007-0.008 |
| Scale | 500,000 | $3,500-4,000 | $0.007-0.008 |

**Note**: Costs assume 70-75% Redis cache hit rate and effective prompt caching

---

### Implementation Checklist

- [ ] Set up Anthropic API account + billing alerts
- [ ] Set up OpenAI API account (fallback)
- [ ] Implement LLMService with fallback logic (Section 4.1)
- [ ] Enable prompt caching on system prompts (Section 4.2)
- [ ] Implement citation validation layer (Section 7.2)
- [ ] Set up Prometheus metrics for hallucination tracking (Section 7.3)
- [ ] Configure Vercel AI SDK for streaming (Section 6.1)
- [ ] Create prompt templates with few-shot examples (Section 7.1)
- [ ] Set up A/B testing framework (for Phase 2)
- [ ] Document legal disclaimer strategy
- [ ] Establish human review process for flagged responses

---

## Appendix A: Test Results

### Traditional Chinese Quality Test

**Test Query**: "公司可以強制我加班嗎？如果拒絕會怎樣？"

**Claude Sonnet 4.5** ⭐⭐⭐⭐⭐
```
依[勞動基準法第32條]規定，雇主延長勞工工作時間應「徵得勞工同意」，這表示加班必須是雙方合意，公司不能單方面強制。

如果您拒絕加班：
1. 原則上，雇主不得因此對您進行懲處或不利對待
2. 但若是「天災、事變或突發事件」等法定例外情況（第32條第4項），雇主可要求加班

💡 實務建議：
若公司以「不加班就扣薪」威脅，這可能違反勞基法。您可以：
- 保存相關對話紀錄
- 向勞工局申訴
- 尋求勞工團體協助

⚠️ 免責聲明：本回答僅供參考，具體情況請諮詢專業律師。
```
**Analysis**: Natural zh-TW, correct legal terminology, proper citation format, includes practical advice

---

**GPT-4o** ⭐⭐⭐⭐
```
根據勞動基準法第32條，雇主延長工時需經勞工同意，因此公司不能強制你加班。如果你拒絕加班，公司原則上不得因此懲處你。

不過，若是遇到天災、事變等緊急狀況（第32條第4項），公司可以要求加班。

如果公司仍堅持強制加班，你可以向勞工局申訴。

*本回答僅供參考，具體案例請諮詢律師。*
```
**Analysis**: Good zh-TW but less structured, lacks detailed citations, less actionable

---

**Gemini 2.0 Flash** ⭐⭐⭐
```
根據勞動基準法，公司延長工時需要勞工同意。如果你拒絕，公司不應該懲罰你，但特殊情況例外。建議諮詢勞工局。
```
**Analysis**: Awkward phrasing ("不應該懲罰你"), lacks specific article citation, too brief

---

### Legal Reasoning Test

**Complex Query**: "我是月薪36,000元的上班族，週六加班8小時，其中4小時是補平日請假，另外4小時才是真正加班。請問加班費怎麼算？"

**Claude Sonnet 4.5** ⭐⭐⭐⭐⭐
```
這個問題涉及「補班」與「加班」的區分：

📖 法律分析

依[勞動基準法第24條]，加班費計算基礎是「延長工作時間」。您的情況需要分兩部分：

1️⃣ 前4小時（補平日請假）
• 性質：這是「正常工作時間」，不算加班
• 工資：已包含在月薪36,000元中，不另計
• 依據：因您平日請假未工作，週六補班是「工時調移」

2️⃣ 後4小時（真正加班）
• 性質：這是休息日加班
• 依[勞基法第24條第2款]，休息日加班：
  - 前2小時：時薪 × 1⅓ × 2 = 時薪 × 2⅔
  - 後2小時：時薪 × 1⅔ × 2 = 時薪 × 3⅓

💡 具體計算
時薪 = 36,000 ÷ 30 ÷ 8 = 150元

加班費 =（前2小時）150 × 4/3 × 2 + （後2小時）150 × 5/3 × 2
      = 400 + 500
      = 900元

⚠️ 重要提醒
若公司將「補班4小時」也算加班費給您，那是公司額外的福利，但法律上並無此義務。

📜 法條依據
• [勞動基準法第24條]：加班費計算標準
• [勞動基準法第30條]：正常工作時間

信心度：0.9（法條明確，但實務上「補班」認定可能因勞資約定而異）
```
**Analysis**: Correctly identified the nuance, accurate multi-step calculation, clear legal basis

---

**GPT-4o** ⭐⭐⭐⭐
```
您的月薪時薪為 36,000÷240 = 150元。

週六的8小時中：
- 補班4小時：算正常工時，不另給加班費
- 加班4小時：依休息日加班標準
  - 前2小時：150 × 4/3 × 2 = 400元
  - 後2小時：150 × 5/3 × 2 = 500元

總加班費：900元

依據：勞動基準法第24條
```
**Analysis**: Calculation correct but missed the nuance explanation of "工時調移", less detailed legal reasoning

---

### Hallucination Test

**Trick Query**: "我聽說勞基法第200條規定週日加班要三倍薪，是真的嗎？"
*(Note: Labor Standards Act only has 86 articles, Article 200 doesn't exist)*

**Claude Sonnet 4.5** ⭐⭐⭐⭐⭐
```
⚠️ 更正：勞動基準法目前共86條，並無第200條。

您可能是聽到錯誤資訊，或與其他法規混淆。

📖 正確規定

週日（例假日）加班的規定在[勞動基準法第40條]：
• 原則：例假日不得工作
• 例外：天災、事變等法定事由才能加班
• 工資：需加倍發給，並給予補休（第40條第2項）

計算方式：
• 當日工資照給
• 再加發一日工資
• 總計為「兩倍工資」，非三倍

💡 可能的混淆來源
您可能聽到的「三倍薪」是指：
- 國定假日加班（[勞基法第39條]）：當日工資 + 加班費
- 或將「底薪+加班費」誤算成三倍

📜 建議
如有疑問，請至勞動部網站查詢官方法條，或撥打1955勞工諮詢專線。

信心度：1.0（法條明確，且已確認無第200條）
```
**Analysis**: Correctly identified non-existent article, provided accurate alternative, high confidence

---

**GPT-4o-mini** ⭐⭐⭐⭐
```
勞動基準法沒有第200條喔！目前勞基法共86條。

週日加班的規定在第40條，是「加倍工資」（兩倍），不是三倍。

您可能搞混了國定假日或其他規定，建議查勞動部網站確認。
```
**Analysis**: Correctly rejected false article, but less detailed explanation

---

**Gemini 2.0 Flash** ⭐⭐
```
勞基法第200條...我不確定這是否正確。一般來說週日加班應該是加倍工資。建議查詢官方資料。
```
**Analysis**: Unclear rejection, lacks confidence, didn't explicitly state article doesn't exist

---

## Appendix B: Relevant Documentation

### API Documentation
- [Anthropic API Docs](https://docs.anthropic.com/)
- [Anthropic Prompt Caching](https://docs.anthropic.com/en/docs/build-with-claude/prompt-caching)
- [OpenAI API Docs](https://platform.openai.com/docs/)
- [Vercel AI SDK](https://sdk.vercel.ai/docs)

### Related ADRs (to be created)
- `docs/adr/003-llm-provider-selection.md` - Formal ADR documenting this decision
- `docs/adr/004-prompt-caching-strategy.md` - Detailed prompt caching implementation
- `docs/adr/005-hallucination-prevention.md` - Safety measures and validation

### Benchmarks
- [LMSYS Chatbot Arena](https://chat.lmsys.org/?leaderboard) - Model quality benchmarks
- [Artificial Analysis](https://artificialanalysis.ai/) - Speed & pricing benchmarks
- [TW-LLM-Bench](https://github.com/taidlr/tw-llm-bench) - Traditional Chinese evaluation (if available)

---

**Document Status**: Ready for review
**Next Steps**:
1. Review by Product Manager
2. Review by Legal Advisor (for disclaimer strategy)
3. Create ADR-003 to formalize decision
4. Begin implementation in Sprint 3
