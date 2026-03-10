# Epic 03: Response Quality & Trust

## Overview

The quality assurance and trust-building layer of the Labor Law Assistant. This epic covers response quality control (confidence scoring, accuracy indicators), the disclaimer system, user feedback mechanisms, regulation update notifications, and advanced feedback collection. Together these features ensure users can assess answer reliability, stay informed of legal changes, and the system can continuously improve.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| M-07 | Response Quality Control | Must Have | Confidence scores, accuracy indicators |
| M-08 | Disclaimer System | Must Have | Legal disclaimers on homepage and in responses |
| M-09 | Feedback Rating | Must Have | Thumbs up/down, error reporting |
| S-06 | Regulation Update Notifications | Should Have | Push notifications for important regulatory changes |
| S-07 | Advanced Feedback Collection | Should Have | Surveys, interview recruitment |

---

## MVP Scope (Must Have)

### M-07: Response Quality Control

**User Story**
> As a user, I want to see how confident the system is in its answer, so that I know when to trust the information and when to seek professional advice.

**Acceptance Criteria**
- [ ] Each response displays a confidence indicator (High / Medium / Low)
- [ ] Confidence is computed from: RAG retrieval similarity score + number of supporting citations + LLM self-assessment
- [ ] High confidence (>= 0.8): Solid green indicator, "This answer is well-supported by legal text"
- [ ] Medium confidence (0.5-0.8): Yellow indicator, "This answer may not cover all aspects of your situation"
- [ ] Low confidence (< 0.5): Red indicator, "We recommend consulting a professional for this question"
- [ ] Display data update date (last time the legal database was synced)
- [ ] If the question is outside the legal database scope, explicitly state this
- [ ] Confidence scoring logic is documented and consistent
- [ ] Low-confidence answers automatically include professional referral suggestions

**Confidence Scoring Formula**
```
confidence = (
    retrieval_similarity_avg * 0.4 +
    citation_count_score * 0.3 +
    llm_self_assessment * 0.3
)

where:
  retrieval_similarity_avg = average cosine similarity of top-K retrieved chunks
  citation_count_score = min(cited_articles / 2, 1.0)
  llm_self_assessment = LLM's self-reported confidence (0-1, via structured output)
```

#### Confidence Score Continuous Improvement

The confidence scoring formula weights are not static. They are tuned through a monthly human evaluation loop to ensure calibration remains accurate as the legal database and user query patterns evolve.

**Monthly Sampling Protocol**:
1. Sample 100 responses: ~33 from each confidence tier (Low / Medium / High)
2. Legal Advisor performs human evaluation of each sampled response
3. Compare system confidence vs. human judgment

**Evaluation Metrics & Thresholds**:
| Metric | Definition | Threshold | Action if Below |
|--------|-----------|:---------:|-----------------|
| Precision | % of High-confidence responses that are actually correct | >= 90% | Raise High threshold or reduce `llm_self_assessment` weight |
| Recall | % of correct responses that receive High confidence | >= 85% | Lower High threshold or increase `retrieval_similarity_avg` weight |
| False High Rate | % of incorrect responses rated High confidence | < 5% | Immediate weight adjustment + incident review |

**Weight Adjustment Procedure**:
1. Compute Precision/Recall from monthly sample
2. If below threshold: propose weight adjustments to `retrieval_similarity_avg` (currently 0.4), `citation_count_score` (currently 0.3), `llm_self_assessment` (currently 0.3)
3. Tech Lead + Legal Advisor approve adjustment
4. Deploy updated weights, re-run evaluation on same sample to verify improvement
5. Log all changes in `confidence-tuning-log.md` with date, old weights, new weights, and Precision/Recall before/after

> **Cross-reference**: See [testing-strategy.md §9](../../testing/testing-strategy.md) for confidence score calibration testing procedures and Golden Data validation methodology.

---

### M-08: Disclaimer System

**User Story**
> As a user, I want to clearly understand that this system provides information, not legal advice, so that I make informed decisions about how to use the answers.

**Acceptance Criteria**
- [ ] First-time visitor sees a disclaimer banner (dismissible, persisted via cookie)
- [ ] Every AI response includes a footer disclaimer: "This is reference information, not legal advice. For specific cases, consult a qualified lawyer."
- [ ] Homepage footer includes full legal disclaimer text
- [ ] Disclaimer text is reviewed by legal advisor
- [ ] Disclaimer is accessible (WCAG compliant, screen-reader compatible)
- [ ] Disclaimer cannot be hidden or removed by user (footer version)
- [ ] For emergency situations, disclaimer includes immediate resource links
- [ ] Multilingual disclaimer versions available when i18n is enabled
- [ ] Disclaimer style is non-alarming but clearly visible (not buried in fine print)

**Disclaimer Variants**
| Context | Disclaimer Text | Style |
|---------|----------------|-------|
| First visit | "This system provides labor law information for reference only. It does not constitute legal advice. For your specific situation, please consult a qualified lawyer." | Banner, dismissible |
| Every response | "Reference information only. Not legal advice." | Footer, always visible |
| Low confidence | "This answer has lower confidence. We strongly recommend consulting a professional." | Warning box |
| Emergency | "If you are in immediate danger, please call 110. For labor emergencies, call 1955." | Alert, prominent |

---

### M-09: Feedback Rating

**User Story**
> As a user, I want to rate whether the answer was helpful and report errors, so that the system can improve over time.

**Acceptance Criteria**
- [ ] Each AI response has thumbs-up and thumbs-down buttons
- [ ] After rating, show a brief "Thank you for your feedback" confirmation
- [ ] Thumbs-down triggers an optional follow-up: "What was wrong?" with options:
  - Incorrect information
  - Not relevant to my question
  - Too complicated to understand
  - Missing important details
  - Other (free text, max 500 chars)
- [ ] "Report Error" button for serious inaccuracies (separate from thumbs-down)
- [ ] Error reports include: the question, the response, user's correction, timestamp
- [ ] Error reports are stored in the database for team review
- [ ] Feedback is anonymous (no user identification required)
- [ ] Feedback data is accessible via admin dashboard for analysis
- [ ] Rate limiting on feedback submission (prevent spam)
- [ ] Aggregate feedback metrics: positive rate, error report count, common issues

**UI Mockup**
```
+---------------------------------------------+
| [AI Response content...]                     |
|                                              |
| ------------------------------------------- |
| Confidence: High | Updated: 2026-01-15      |
| Reference information only. Not legal advice.|
|                                              |
| Was this helpful?                            |
| [Thumbs Up]  [Thumbs Down]  [Report Error]  |
+---------------------------------------------+

(After thumbs down)
+---------------------------------------------+
| What was the issue?                          |
| ( ) Incorrect information                    |
| ( ) Not relevant to my question              |
| ( ) Too complicated                          |
| ( ) Missing details                          |
| ( ) Other: [____________]                    |
|                         [Submit]  [Skip]     |
+---------------------------------------------+
```

---

## Error Handling & Edge Cases

| Scenario | Handling | User Message |
|----------|----------|-------------|
| Confidence score computation fails | Default to "Medium" with disclaimer | "Confidence score unavailable. Please verify this information independently." |
| Feedback submission fails (API error) | Retry once, then store locally for later sync | "Your feedback couldn't be submitted right now. It will be sent automatically later." |
| Error report with empty correction field | Allow submission but prompt for details | "Adding details about the error helps us fix it faster. [Submit anyway] [Add details]" |
| Spam feedback detected (>10 submissions/minute) | Rate limit, silently drop excess | "Thank you for your feedback." (no additional message) |
| Disclaimer cookie is cleared/blocked | Show disclaimer banner again | (Disclaimer banner re-appears) |
| NPS survey shown to first-time user | Suppress survey until 3rd visit minimum | (No survey shown) |
| LLM self-assessment returns invalid value | Exclude from confidence calc, use 2-factor formula | (No user-facing impact, logged to Sentry) |

---

## Extended Scope (Should Have)

### S-06: Regulation Update Notifications

**User Story**
> As an HR specialist, I want to be notified when labor regulations change, so that I can update company policies proactively and stay compliant.

**Acceptance Criteria**
- [ ] Users can subscribe to regulation update notifications (opt-in)
- [ ] Subscription categories: by law (e.g., Labor Standards Act) or by topic (e.g., wages, leave)
- [ ] Notification channels: Web Push API (browser notification) and/or email
- [ ] Each notification includes: what changed, effective date, impact summary, link to updated content
- [ ] Notification is triggered by legal database versioning system (M-13 in Epic 02)
- [ ] Maximum notification frequency: 1 per day (batch if multiple changes)
- [ ] Users can unsubscribe at any time from notification settings
- [ ] Notification preference stored in user session (anonymous) or user account (registered)
- [ ] Push notification requires explicit browser permission (Web Push API standard)
- [ ] Fallback for browsers without Push API support: in-app notification badge on next visit

**Notification Template**
```
[Regulation Update]
Labor Standards Act, Article 24 has been amended.

What changed: Overtime multiplier for rest days increased from 1.34x to 1.5x
Effective date: 2026-07-01
Impact: Affects all employees working overtime on rest days

[View Details] [Update My Calculations]
```

---

### S-07: Advanced Feedback Collection

**User Story**
> As a product team member, I want to collect deeper user insights through surveys and interviews, so that we can understand user needs beyond simple ratings.

**Acceptance Criteria**
- [ ] Periodic in-app survey popup (configurable frequency, e.g., every 10th visit)
- [ ] Survey includes NPS question: "How likely are you to recommend this service?" (0-10)
- [ ] Survey includes 2-3 additional questions (configurable via admin)
- [ ] Survey is dismissible and non-intrusive (bottom-right corner, not modal)
- [ ] Option to volunteer for user interview with email collection (opt-in only)
- [ ] Interview volunteers stored separately with explicit consent
- [ ] Survey responses linked to session (anonymous) for context
- [ ] Survey completion rate tracking
- [ ] A/B testing support for different survey questions
- [ ] Export survey data as CSV for analysis

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| PostgreSQL | Database | Feedback storage, error report storage |
| FastAPI | Backend | Feedback submission API endpoints |
| Redis (Upstash) | Cache | Rate limiting for feedback submission |
| Zustand | Frontend | UI state for feedback forms |
| Next.js API routes | Frontend | Survey popup state management |

## Epic Dependencies

| Relationship | Epic | Reason |
|-------------|------|--------|
| **Depends on** | Epic 01 (Chat Interface) | Confidence scores, disclaimers, and feedback UI are part of chat responses |
| **Depends on** | Epic 02 (RAG Legal Search) | Confidence scoring uses RAG retrieval similarity metrics |
| **Depends on** | Epic 02 (M-13 Versioning) | S-06 notifications triggered by legal database changes |
| **Can develop in parallel** | Epic 04, Epic 05, Epic 06 | No direct dependency |

> **Recommended development order**: M-07 (confidence) and M-08 (disclaimer) in Sprint 3-4 alongside Epic 02 completion. M-09 (feedback) in Sprint 5-6 alongside Epic 01 chat UI. S-06 and S-07 in Phase 2.

## Related ADRs

- [ADR-005: Redis Caching](../../adr/005-caching-redis.md) - Rate limiting
- [ADR-006: Observability Stack](../../adr/006-observability-stack.md) - Monitoring feedback metrics
- [ADR-008: LLM Provider](../../adr/008-llm-provider.md) - LLM self-assessment for confidence scoring
- [ADR-009: Authentication Strategy](../../adr/009-authentication-strategy.md) - Anonymous feedback collection
