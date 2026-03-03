# Epic 02: RAG Legal Search & Citation

## Overview

The retrieval-augmented generation (RAG) engine that powers the Labor Law Assistant's core capability: generating accurate, source-attributed answers from Taiwan's labor law database. This epic covers the RAG source tracing system, legal citation display with official links, and the FAQ knowledge base for common questions.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| M-02 | RAG Source Tracing System | Must Have | Generate answers based on legal database with source attribution |
| M-04 | Legal Citation & Links | Must Have | Show cited legal articles in full with official links |
| M-13 | Legal Database Versioning | Must Have | Version-controlled legal articles with change tracking |
| S-09 | FAQ Knowledge Base | Should Have | Common questions with standard answers |

---

## MVP Scope (Must Have)

### M-02: RAG Source Tracing System

**User Story**
> As a user, I want every AI answer to show which legal articles it's based on, so that I can trust the information and verify it myself.

**Acceptance Criteria**
- [ ] Every AI response includes at least one legal article citation (when applicable)
- [ ] Citations include: law name, article number, relevant paragraph
- [ ] RAG retrieval uses vector similarity search (pgvector) on embedded legal articles
- [ ] Retrieval returns top-K most relevant chunks (K configurable, default 5)
- [ ] Retrieved context is passed to LLM as grounding material
- [ ] LLM is instructed to ONLY cite from retrieved context (no hallucinated citations)
- [ ] Response includes a confidence score based on retrieval similarity and LLM certainty
- [ ] If no relevant legal article is found (below similarity threshold), system clearly states "no applicable regulation found" instead of guessing
- [ ] Citation validation: system cross-checks cited article numbers against the legal database
- [ ] Latency: RAG retrieval completes within 1 second (P95)

**RAG Pipeline Architecture**
```
User Query
    |
    v
Query Embedding (OpenAI text-embedding-3-large)
    |
    v
Vector Search (pgvector, cosine similarity, top-5)
    |
    v
Retrieve Legal Article Chunks
    |
    v
Rerank (optional: cross-encoder)
    |
    v
Context Assembly (retrieved chunks + system prompt)
    |
    v
LLM Generation (Claude Sonnet 4.5)
    |
    v
Citation Extraction & Validation
    |
    v
Structured Response (answer + citations + confidence)
```

**Legal Database Schema (Conceptual)**
| Field | Type | Description |
|-------|------|-------------|
| law_name | string | e.g., "Labor Standards Act" |
| article_number | string | e.g., "Article 24" |
| article_text | text | Full article text |
| effective_date | date | When article took effect |
| last_amended | date | Last amendment date |
| chunk_text | text | Chunked text for embedding |
| embedding | vector(1536) | pgvector embedding |

---

### M-04: Legal Citation & Links

**User Story**
> As a user, I want to see the full text of cited legal articles and have links to the official government source, so that I can read the original law and feel confident in the answer.

**Acceptance Criteria**
- [ ] Each citation is clickable to expand the full article text inline
- [ ] Each citation includes a link to the official Laws & Regulations Database (law.moj.gov.tw)
- [ ] Display the law name, article number, and effective date
- [ ] Highlight the specific paragraph/clause relevant to the user's question
- [ ] Show the last amendment date for each cited article
- [ ] Support multiple citations per response (when answer spans multiple articles)
- [ ] Citations are visually distinct from the AI-generated explanation
- [ ] Copy citation button (for HR users who need to reference in documents)
- [ ] If a cited article has been recently amended, show a "recently updated" badge

**UI Mockup**
```
+---------------------------------------------+
| Sources                                      |
|                                              |
| [1] Labor Standards Act, Article 24          |
|     Effective: 2024-03-01 | Updated recently |
|     > Expand full text                       |
|     [Link to official source]                |
|                                              |
| [2] Labor Standards Act, Article 32          |
|     Effective: 2022-01-01                    |
|     > Expand full text                       |
|     [Link to official source]                |
|                                              |
| [Copy all citations]                         |
+---------------------------------------------+
```

---

### M-13: Legal Database Versioning

**User Story**
> As a system maintainer, I want legal articles to be version-controlled with change tracking, so that users always see current regulations and can be notified of changes.

**Acceptance Criteria**
- [ ] Each legal article stores: current text, effective date, last amendment date, previous versions
- [ ] When a regulation is amended, the old version is archived (not deleted)
- [ ] Amended articles show a "recently updated" badge in citations (within 30 days of amendment)
- [ ] Regulation change detection: periodic crawl of law.moj.gov.tw (weekly) or manual trigger
- [ ] Change detection triggers a review workflow: crawl → diff → legal advisor review → publish
- [ ] Legal advisor can approve/reject changes before they go live
- [ ] After publishing an update, all cached responses citing the changed article are invalidated
- [ ] Change log is publicly accessible: users can see what changed and when
- [ ] All article embeddings are re-generated when article text changes
- [ ] Regulation update SLA: P0 Emergency (24 hours), P1 Important (3 days), P2 Routine (7 days)

**Content Pipeline**
```
law.moj.gov.tw (weekly crawl)
    |
    v
Diff Detection (compare with stored version)
    |
    v
Change Notification (to legal advisor + content team)
    |
    v
Legal Advisor Review & Approval
    |
    v
Database Update + Re-embedding + Cache Invalidation
    |
    v
User Notification (S-06, if subscribed)
```

**FAQ Content Source & Review Process**
| Source | Method | Volume |
|--------|--------|--------|
| Phase 0.5 User Research | Extract top questions from interviews & surveys | 20-30 questions |
| Government FAQ pages | Curate from Ministry of Labor, labor bureaus | 15-20 questions |
| Legal aid case patterns | Anonymized common inquiry types | 10-15 questions |
| Legal advisor creation | Expert-authored for complex topics | 5-10 questions |

All FAQ content must be reviewed by legal advisor before publication.

---

## Error Handling & Edge Cases

| Scenario | Handling | User Message |
|----------|----------|-------------|
| RAG retrieval returns 0 results (similarity < 0.3) | Skip RAG, use LLM general knowledge with low confidence warning | "I couldn't find a specific legal article matching your question. Here's general guidance — please verify with a professional." |
| RAG retrieval is slow (>2s) | Return partial results, continue loading | "Loading relevant legal articles..." (show spinner on citations) |
| RAG retrieval timeout (>5s) | Fall back to FAQ matching, then general LLM | "We're having trouble searching the legal database. Here are some related FAQs..." |
| Cited article has been amended since last sync | Show stale warning | "Note: This article may have been recently amended. Last synced: [date]. [Check official source]" |
| Cited article number doesn't exist in DB | Filter out invalid citation, log error | (Citation silently removed, Sentry alert triggered) |
| Legal database is empty or corrupt | Block all queries, show maintenance page | "System is undergoing maintenance. Please try again later or call 1955." |
| Embedding API failure | Use cached embeddings if available, else error | "Search functionality is temporarily limited. You can browse our FAQ instead." |
| FAQ keyword search returns no matches | Suggest related categories, offer AI chat | "No FAQ matches found. Would you like to ask our AI assistant instead?" |
| User query is in a language not yet supported | Detect language, suggest supported languages | "We currently support Traditional Chinese. Multi-language support is coming soon." |

---

## Extended Scope (Should Have)

### S-09: FAQ Knowledge Base

**User Story**
> As a frequent user, I want to browse common labor law questions and their answers, so that I can quickly find information without waiting for AI generation.

**Acceptance Criteria**
- [ ] Curated FAQ section organized by category (salary, leave, resignation, etc.)
- [ ] Each FAQ has a pre-written, expert-reviewed answer
- [ ] FAQ answers follow the same layered display format (summary + detail + citations)
- [ ] FAQ search with keyword matching
- [ ] FAQ items are served from cache (Redis) for instant response
- [ ] Click on FAQ leads to full answer page (can continue to AI chat from there)
- [ ] FAQ content is managed via a simple admin interface or CMS
- [ ] Track FAQ view counts to identify trending topics
- [ ] FAQ reduces LLM API calls for common questions (cost optimization)
- [ ] Minimum 50 FAQs covering top questions from each legal category at launch

**FAQ Categories**
| Category | Sample Questions | Count |
|----------|-----------------|-------|
| Salary & Overtime | Overtime calculation, minimum wage, salary deductions | 10+ |
| Leave | Annual leave, sick leave, parental leave, menstrual leave | 10+ |
| Resignation & Severance | Severance calculation, notice period, illegal dismissal | 8+ |
| Labor Insurance | Enrollment, benefits, occupational injury | 8+ |
| Workplace Issues | Bullying, harassment, discrimination | 7+ |
| Employment Contracts | Contract types, probation, non-compete | 7+ |
| Risks & Fears | "What if my employer retaliates?", "Is my query anonymous?", "Can I be fired for knowing my rights?", "Will filing a complaint make things worse?" | 5+ |

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| pgvector | Database | Vector similarity search for RAG |
| OpenAI text-embedding-3-large | AI/ML | Embedding model for query and document vectors |
| Claude Sonnet 4.5 | AI/ML | LLM for answer generation |
| Redis (Upstash) | Cache | FAQ cache, embedding cache, LLM response cache |
| PostgreSQL (Neon) | Database | Legal article storage, FAQ storage |
| Alembic | Database | Migrations for legal database schema |
| FastAPI | Backend | API endpoints for search and chat |

## Epic Dependencies

| Relationship | Epic | Reason |
|-------------|------|--------|
| **Depends on** | None | Foundation epic — legal database and RAG pipeline must be built first |
| **Required by** | Epic 01 (Chat Interface) | Chat needs RAG for meaningful answers |
| **Required by** | Epic 03 (Response Quality) | Confidence scoring depends on RAG retrieval metrics |
| **Required by** | Epic 04 (Action Guide) | Action guides reference legal content from RAG |
| **Can develop in parallel** | Epic 05 (Accessibility), Epic 06 (Calculators) | No direct dependency |

> **Recommended development order**: This is the foundation epic. Start in Sprint 1-2 with legal DB schema, embedding pipeline, and basic RAG retrieval. Complete M-04 citations in Sprint 3-4.

## Related ADRs

- [ADR-003: SQLAlchemy 2.0 as ORM](../../adr/003-orm-sqlalchemy.md) - Database access patterns
- [ADR-005: Redis Caching](../../adr/005-caching-redis.md) - Caching strategy for FAQ and LLM responses
- [ADR-007: Embedding Model](../../adr/007-embedding-model.md) - Vector embedding for RAG retrieval
- [ADR-008: LLM Provider](../../adr/008-llm-provider.md) - LLM for answer generation
- [ADR-010: Deployment Infrastructure](../../adr/010-deployment-infrastructure.md) - Neon (database), Upstash (cache)
