# Product Requirements Document (PRD)

## Labor Law Assistant - Taiwan Labor Law Query Assistant

| Document Info | |
|---------|---------|
| **Version** | v2.1 |
| **Created** | 2026-02-02 |
| **Last Updated** | 2026-02-13 |
| **Status** | Draft - Pending Stakeholder Review |
| **Owner** | Product Owner |

---

## Table of Contents

1. [Product Overview](#1-product-overview)
2. [Product Vision & Goals](#2-product-vision--goals)
3. [Target Users](#3-target-users)
4. [User Journey](#4-user-journey)
5. [Feature Requirements](#5-feature-requirements)
6. [Non-Functional Requirements](#6-non-functional-requirements)
7. [Information Architecture](#7-information-architecture)
8. [Risk Assessment](#8-risk-assessment)
9. [Success Metrics](#9-success-metrics)
10. [Timeline](#10-timeline)
11. [Appendices](#11-appendices)

  +-------------------+--------------------------------------------------------------+
  |       Section     |                           Contents                           |
  +-------------------+--------------------------------------------------------------+
  | 1. Product Overview       | Problem statement, solution, positioning, value proposition  |
  | 2. Product Vision & Goals | Vision, mission, business goals, user rights charter (10)    |
  | 3. Target Users           | 3 personas + 7 vulnerable groups + 10 hypotheses             |
  | 4. User Journey           | Complete journey map, 6-stage touchpoints & design ops       |
  | 5. Feature Requirements   | MoSCoW (12 Must + 9 Should + 7 Could) + Epic links          |
  | 6. Non-Functional Reqs    | WCAG 2.1 AA, 5 languages, privacy, performance              |
  | 7. Info Architecture      | Navigation, layered info, search design                      |
  | 8. Risk Assessment        | Product/tech/legal risk matrix & mitigation                  |
  | 9. Success Metrics        | Product health, tech, content quality, user rights KPI       |
  | 10. Timeline              | 18-month 5-phase plan (incl. Phase 0.5 user research)        |
  | 11. Appendices            | Legal scope, tech stack, support, research, competitive, etc.|
  +-------------------+--------------------------------------------------------------+

---

## 1. Product Overview

### 1.1 Product Introduction

Labor Law Assistant is an **AI-powered Taiwan labor law knowledge base and guided Q&A system**, designed to help general workers, HR specialists, and SME owners quickly query, understand, and apply Taiwan labor regulations.

### 1.2 Problem Statement

| Problem | Impact |
|------|------|
| Labor regulations are written in difficult legal language | Workers cannot understand their own rights |
| Regulations are scattered across multiple laws | Difficult and time-consuming to search |
| Professional legal consultation is expensive | Vulnerable workers cannot afford it |
| Information asymmetry | Workers are at a disadvantage in labor disputes |
| Digital divide | Foreign workers, elderly, disabled persons have difficulty accessing information |

### 1.3 Solution

Provide a **free, accessible, multilingual** AI Q&A system that enables everyone to:
- Understand labor regulations in plain language
- Obtain accurate information with traceable sources
- Know what action to take when encountering problems

### 1.4 Product Positioning

```
+-------------------------------------------------------------+
|                Labor Law Information Service Spectrum         |
+-------------------------------------------------------------+
|                                                              |
|  Gov Websites  ->  This Product  ->  Legal Consult  -> Law   |
|  (Info display)    (AI-assisted)     (Professional)    Firm  |
|                                                              |
|  Free/Passive      Free/Active      Paid/Expert      High   |
|  Hard to understand Plain interactive Case judgment   Legal  |
|                                                              |
+-------------------------------------------------------------+
```

**Product positioning**: A "smart bridge" between government information and professional legal consultation

### 1.5 Core Value Proposition

> **"Enabling every Taiwan worker to easily understand their labor rights and know how to protect themselves."**

---

## 2. Product Vision & Goals

### 2.1 Product Vision

Become Taiwan's most trusted labor law information platform, closing the labor-management information gap and promoting labor rights protection.

### 2.2 Product Mission

- **Protect workers first**: System stance clearly stands for protecting worker rights
- **Information equality**: Ensure all people (including vulnerable groups) can access information
- **Transparent and trustworthy**: All answers traceable to sources, limitations clearly marked

### 2.3 Business Goals

| Goal | Metric | Timeline |
|------|------|------|
| Build user base | MAU 10,000+ | 6 months after launch |
| Achieve product-market fit | NPS 30+ | 3 months after launch |
| Become trusted source | Answer satisfaction 85%+ | 6 months after launch |
| Cover major regulations | 8 major labor laws 100% | MVP |

### 2.4 User Rights Charter

This product commits to the following principles:

| # | Commitment |
|------|------|
| 1 | **Protect workers first**: System stance clearly stands for protecting worker rights, refuses to assist in circumventing regulations |
| 2 | **Absolute privacy protection**: No personally identifiable information recorded, query records never provided to third parties |
| 3 | **Equal access**: Ensure all people (including disabled persons, foreign workers, elderly) can use the system |
| 4 | **Information transparency**: Clearly mark information sources, update dates, accuracy |
| 5 | **Core features permanently free**: No charges to users |
| 6 | **Error accountability**: Establish error reporting and correction mechanisms, publicly disclose error rates |
| 7 | **Continuous improvement**: Regular user research, optimize system based on feedback |
| 8 | **Emergency support**: Provide human assistance referrals, never let AI handle crisis situations alone |
| 9 | **Open transparency**: System operation logic and algorithm principles publicly explained |
| 10 | **Social responsibility**: Proactively promote labor rights education, close information gaps |

---

## 3. Target Users

### 3.1 Primary User Personas

#### Persona 1: General Worker - Xiao Ming

| Attribute | Description |
|------|------|
| **Demographics** | 28 years old, restaurant service worker, high school education |
| **Digital literacy** | Medium, accustomed to using mobile phone |
| **Usage timing** | Encountering rights issues, suspecting employer violations, wanting to understand rights |
| **Goals** | Understand overtime pay calculation, annual leave days, resignation notice period |
| **Pain points** | Legal language is difficult, doesn't know where to search, afraid to ask the boss, doesn't know the right keywords |
| **Expectations** | Get answers in plain language, resolve questions within 5 minutes, know what to do next |
| **Context** | Queries on phone after work, may be anxious or angry |

#### Persona 2: HR Specialist - Linda

| Attribute | Description |
|------|------|
| **Demographics** | 35 years old, mid-size company HR, university HR major |
| **Digital literacy** | High, proficient in Office software |
| **Usage timing** | Handling employee issues, designing company policies, handling labor disputes |
| **Goals** | Quick regulation lookup, preparing labor meetings, designing company policies |
| **Pain points** | Can't keep up with regulation updates, needs to cite articles, complex cases hard to judge |
| **Expectations** | Professional and accurate, citable sources, similar cases, regulation update notifications |
| **Context** | Desktop queries during office hours, needs to print or share |

#### Persona 3: Small Business Owner - Boss Wang

| Attribute | Description |
|------|------|
| **Demographics** | 45 years old, operates a 20-person factory, vocational school education |
| **Digital literacy** | Low, primarily uses mobile phone |
| **Usage timing** | Hiring employees, designing salary systems, handling resignations, receiving labor inspection notices |
| **Goals** | Ensure legal employment compliance, avoid fines or labor inspections |
| **Pain points** | Doesn't understand law, worried about violations, lawyers too expensive, limited resources |
| **Expectations** | Simple and clear guidance, tell me what to do |
| **Context** | Emergency queries when encountering problems |

### 3.2 Vulnerable User Groups

| User Group | Potential Barrier | Required Support | Priority |
|---------|---------|-------------|--------|
| **Foreign workers** | Language barrier (~700K people) | Vietnamese, Indonesian, Thai, Filipino | P0 |
| **Visually impaired** | Cannot use visual interface | WCAG 2.1 AA, screen reader support | P0 |
| **Hearing impaired** | Need subtitles for voice features | Text messaging, video subtitles | P1 |
| **Elderly** | Small fonts, complex operations, unfamiliar with AI | Large font mode, simplified steps | P0 |
| **Low digital literacy** | Don't understand system operation | Plain language explanations, human support backup | P0 |
| **Low-wage workers** | Old phones, limited data | Lightweight, offline cache, PWA | P1 |
| **Night shift workers** | Late-night use, fatigue | Night mode, quick query shortcuts | P2 |

### 3.3 User Assumptions & Validation

| ID | Behavioral Assumption | Risk Level | Validation Method |
|---------|---------|---------|---------|
| H1 | Users can clearly describe legal problems | High | Cognitive walkthrough, field observation |
| H2 | Users willing to answer multiple guidance questions | Medium | A/B testing |
| H3 | Users will read complete legal article content | High | Eye tracking, scroll depth analysis |
| H4 | Users understand plain language legal explanations | Medium | Comprehension testing |
| H5 | Users care about information source traceability | Medium | Trust survey |
| H6 | Users primarily query on mobile | Low | Device usage data |
| H7 | Users will proactively provide feedback | High | Participation rate data |
| H10 | Users trust AI-generated legal advice | High | Trust study |

---

## 4. User Journey

### 4.1 General Worker Journey Map

```
Stages: Discover Problem -> Find Channel -> Use System -> Understand Info -> Take Action -> Follow Up

+---------------------------------------------------------------------+
| Discover Problem                                                     |
+---------------------------------------------------------------------+
| Touchpoint: Workplace                                                |
| Behavior: Notice anomaly (no overtime pay, asked to sign documents)  |
| Emotion: Anxious, angry                                              |
| Pain point: Not sure if this is right, don't know who to ask         |
+---------------------------------------------------------------------+
                                    |
                                    v
+---------------------------------------------------------------------+
| Find Channel                                                         |
+---------------------------------------------------------------------+
| Touchpoint: Google, LINE groups, coworkers                           |
| Behavior: Search "how to calculate overtime pay"                     |
| Emotion: Confused                                                    |
| Pain point: Scattered info, unknown credibility, can't read legalese |
| Opportunity: System should appear in search results                  |
+---------------------------------------------------------------------+
                                    |
                                    v
+---------------------------------------------------------------------+
| Use System                                                           |
+---------------------------------------------------------------------+
| Touchpoint: System homepage, search box                              |
| Behavior: Type question or select scenario                           |
| Emotion: Uncertain                                                   |
| Pain point: Don't know how to describe problem, afraid of asking     |
| Opportunity: Scenario selector, question templates, voice input      |
+---------------------------------------------------------------------+
                                    |
                                    v
+---------------------------------------------------------------------+
| Understand Information                                               |
+---------------------------------------------------------------------+
| Touchpoint: View AI response                                         |
| Behavior: Read response, check legal citations                       |
| Emotion: Confused -> Understanding                                   |
| Pain point: Articles too long, don't know how to apply to own case   |
| Opportunity: Layered display (summary->detail), keyword highlighting |
+---------------------------------------------------------------------+
                                    |
                                    v
+---------------------------------------------------------------------+
| Take Action                                                          |
+---------------------------------------------------------------------+
| Touchpoint: Leaving system                                           |
| Behavior: Decide next step (talk to boss, file complaint, find lawyer)|
| Emotion: Helpless -> Confident                                       |
| Pain point: Don't know what to do, don't know what evidence needed   |
| Opportunity: Action guide, evidence checklist, complaint channel links|
+---------------------------------------------------------------------+
                                    |
                                    v
+---------------------------------------------------------------------+
| Follow Up (not currently planned)                                    |
+---------------------------------------------------------------------+
| Need: Track progress, get ongoing support                            |
| Opportunity: Progress tracking, expert referral, community support   |
+---------------------------------------------------------------------+
```

### 4.2 Key Touchpoints & Design Opportunities

| Stage | Key Touchpoint | Currently Covered | Design Opportunity |
|------|---------|:--------:|---------|
| Enter system | Homepage, search box | Partial | Scenario selector, question template library |
| Describe problem | Input box, guided Q&A | Planned | Voice input, keyword suggestions |
| Understand answer | AI response content | Partial | Layered display, visual explanations |
| Verify credibility | Source marking | Planned | Confidence score, update date |
| Take action | Leaving system | Missing | Action guide, evidence checklist |
| Report issues | Feedback mechanism | Planned | Error reporting, human review |
| Ongoing support | Referral services | Missing | Lawyer referral, government hotlines |

---

## 5. Feature Requirements

### 5.1 Feature Priority Overview (MoSCoW)

#### Must Have - MVP Core Features

| Feature ID | Feature Name | Description | User Value |
|---------|---------|------|---------|
| **M-01** | Contextual Question Guidance | Guide questions based on user identity and context | Solve "don't know how to ask" problem |
| **M-02** | RAG Source Tracing System | Generate answers based on legal database with source attribution | Ensure answers are verifiable |
| **M-03** | Layered Information Display | Summary first, expandable detailed legal articles | Avoid information overload |
| **M-04** | Legal Citation & Links | Show cited legal articles in full with official links | Build trust, facilitate verification |
| **M-05** | Basic Q&A Interface | Clean conversational query interface | Core interaction functionality |
| **M-06** | Action Guide | Tell users what to do next | Actually solve the problem |
| **M-07** | Response Quality Control | Confidence scores, accuracy indicators | Manage user expectations |
| **M-08** | Disclaimer System | Legal disclaimers on homepage and in responses | Reduce legal risk |
| **M-09** | Feedback Rating | Thumbs up/down, error reporting | Continuously optimize AI |
| **M-10** | Emergency Fast Track | Detect emergency keywords, provide hotline links | Handle urgent needs |
| **M-11** | Mobile-First Design | Mobile-First RWD | Workers primarily use phones |
| **M-12** | Accessibility Basics | WCAG 2.1 AA compliance | Ensure equal access |

#### Should Have - Phase 2 Features

| Feature ID | Feature Name | Description | User Value |
|---------|---------|------|---------|
| **S-01** | Multi-language Support | Vietnamese, Indonesian, Thai, Filipino | Serve foreign workers |
| **S-02** | Voice Input | Speech-to-text queries | Lower input barriers |
| **S-03** | Calculation Tools | Overtime, annual leave, severance calculators | Provide practical value |
| **S-04** | Evidence Collection Guide | Tell users what evidence to collect and how to preserve it | Assist subsequent actions |
| **S-05** | Appeal Process Guide | Step-by-step instructions for various appeal channels | Complete problem resolution |
| **S-06** | Regulation Update Notifications | Push notifications for important regulatory changes | Information timeliness |
| **S-07** | Advanced Feedback Collection | Surveys, interview recruitment | Deep user understanding |
| **S-08** | Conversation History | Save query history (local storage) | Convenient for future reference |
| **S-09** | FAQ Knowledge Base | Common questions with standard answers | Reduce AI burden |

#### Could Have - Advanced Features

| Feature ID | Feature Name | Description | User Value |
|---------|---------|------|---------|
| **C-01** | Document Template Library | Labor contract, regulation templates download | HR/business owner needs |
| **C-02** | Compliance Self-Assessment Tool | Enterprise labor law compliance check | Business owner needs |
| **C-03** | Case Database | Real case analysis (de-identified) | Deep learning |
| **C-04** | Community Forum | Anonymous experience sharing, mutual help | Peer support |
| **C-05** | Expert Referral Service | Lawyer, labor group connections | Complex case handling |
| **C-06** | Analytics Dashboard | Usage data visualization | Operations management |
| **C-07** | CMS Content Management | Backend legal content management | Maintenance efficiency |

#### Won't Have - Not Developing

| Feature | Reason |
|------|------|
| Live lawyer matching service | Beyond product scope, involves legal practice regulations |
| Automatic legal document generation | Extremely high legal risk, requires professional team backing |
| Paid subscription advanced features | Business model not yet determined |
| iOS/Android Native App | High development cost, RWD can satisfy needs first |
| Case judgment prediction | AI technology and legal risks too high |

### 5.2 Epic Breakdown

Detailed feature specifications are organized into Epic files for Sprint planning:

| Epic | Scope | Features | Spec |
|------|-------|----------|------|
| **Epic 01** | AI Chat Interface | M-05, M-01, M-03, S-02, S-08 | [01-chat-interface.md](epics/01-chat-interface.md) |
| **Epic 02** | RAG Legal Search & Citation | M-02, M-04, S-09 | [02-rag-legal-search.md](epics/02-rag-legal-search.md) |
| **Epic 03** | Response Quality & Trust | M-07, M-08, M-09, S-06, S-07 | [03-response-quality.md](epics/03-response-quality.md) |
| **Epic 04** | Action Guide & Emergency | M-06, M-10, S-04, S-05 | [04-action-guide-emergency.md](epics/04-action-guide-emergency.md) |
| **Epic 05** | Accessibility & i18n | M-11, M-12, S-01 | [05-accessibility-i18n.md](epics/05-accessibility-i18n.md) |
| **Epic 06** | Calculation Tools | S-03 | [06-calculation-tools.md](epics/06-calculation-tools.md) |

> **Note**: Features not assigned to epics (C-01~C-07) are planned for Phase 3+ and will be specified when prioritized. See [Could Have Roadmap](#53-could-have-roadmap) below.

### 5.3 Could Have Roadmap

These advanced features are not yet assigned to epics. Brief planning for future prioritization:

| Feature ID | Feature Name | Potential Epic | Prerequisites | Estimated Effort |
|---|---|---|---|---|
| **C-01** | Document Template Library | New Epic or Epic 04 extension | Legal advisor review of templates | 2-3 sprints |
| **C-02** | Compliance Self-Assessment Tool | New Epic or Epic 06 extension | Legal database complete | 3-4 sprints |
| **C-03** | Case Database | Epic 02 extension | De-identification pipeline, legal review | 4-5 sprints |
| **C-04** | Community Forum | New Epic | Moderation system, user accounts (ADR-009) | 4-5 sprints |
| **C-05** | Expert Referral Service | Epic 04 extension | Partnership agreements with legal aid orgs | 2-3 sprints |
| **C-06** | Admin Dashboard | New Epic | Feedback system (M-09), FAQ CMS (S-09), analytics infra | 3-4 sprints |
| **C-07** | CMS Content Management | Merge with C-06 | Legal database versioning, admin auth | Included in C-06 |

**Priority recommendation for Phase 3+**:
1. **C-06 + C-07** (Admin Dashboard + CMS) — Required for operations team efficiency
2. **C-05** (Expert Referral) — High user value, extends M-10 emergency flow
3. **C-03** (Case Database) — Differentiator, requires significant legal content work

### 5.4 Epic Dependency Map

```
Epic 02 (RAG) ──────────────────────────────┐
  |                                          |
  v                                          v
Epic 01 (Chat) ──> Epic 03 (Quality) ──> Epic 04 (Action Guide)
                                             |
Epic 05 (A11y/i18n) ── parallel ────────────-+
Epic 06 (Calculators) ── independent ────────+
```

| Epic | Depends On | Can Develop In Parallel With | Integrates With |
|------|------------|------------------------------|-----------------|
| Epic 01 | Epic 02 (RAG for meaningful answers) | Epic 05, Epic 06 | Epic 03, Epic 04 |
| Epic 02 | None (foundation) | Epic 05, Epic 06 | Epic 01, Epic 03 |
| Epic 03 | Epic 01 (chat UI), Epic 02 (RAG for confidence) | Epic 06 | Epic 01, Epic 02 |
| Epic 04 | Epic 01 (chat UI), Epic 02 (legal content) | Epic 06 | Epic 01, Epic 10 (emergency) |
| Epic 05 | None (cross-cutting) | All epics | All epics |
| Epic 06 | None (standalone) | All epics | Epic 01 (chat integration) |

---

## 6. Non-Functional Requirements

### 6.1 Accessibility (WCAG 2.1)

| WCAG 2.1 Principle | Requirement | Acceptance Criteria |
|--------------|------|---------|
| **Perceivable** | Information receivable by multiple senses | - All images have alt text<br>- Screen reader support<br>- High contrast mode<br>- Text scalable to 200% |
| **Operable** | Operable by multiple methods | - Full keyboard navigation<br>- Skip to content<br>- No time limits<br>- Voice input support |
| **Understandable** | Information is clear and understandable | - Simple language (6th grade level)<br>- Consistent navigation<br>- Clear error messages |
| **Robust** | Compatible with assistive technology | - Compatible with NVDA, JAWS, VoiceOver<br>- Semantic HTML<br>- ARIA labels |

**Minimum compliance target**: WCAG 2.1 AA

### 6.2 Multilingual (i18n)

| Priority | Language | Target Users | Timeline |
|--------|------|---------|------|
| P0 | Traditional Chinese | Local workers | MVP |
| P0 | Simplified Chinese | Lower language ability users | MVP |
| P1 | Vietnamese | Vietnamese workers (~230K) | V2 |
| P1 | Indonesian | Indonesian workers (~260K) | V2 |
| P2 | Thai | Thai workers (~70K) | V2 |
| P2 | Filipino | Filipino workers (~150K) | V2 |
| P3 | English | Other foreign nationals | V3 |

### 6.3 Privacy & Security

| Category | Requirement | Implementation |
|------|------|---------|
| **Anonymous first** | Core features require no registration | No login wall |
| **Minimal collection** | No personally identifiable information collected | No name, ID, phone fields |
| **Local storage** | Conversation history stored on user's device | LocalStorage/IndexedDB |
| **Encrypted transmission** | All data via HTTPS | TLS 1.3 |
| **Auto-sanitization** | Detect and mask sensitive information | ID number, phone regex filtering |
| **No third-party sharing** | Query records never leaked | Privacy policy explicit commitment |
| **Regulatory compliance** | Comply with Taiwan Personal Data Protection Act | Legal review |

### 6.4 Performance

| Metric | Target | Measurement |
|------|--------|---------|
| First load time | < 3 sec (3G network) | Lighthouse |
| API response time (P95) | < 3 sec | APM |
| RAG retrieval time | < 1 sec | Internal log |
| LLM generation time | < 5 sec | Internal log |
| Uptime | 99% | Monitoring service |
| Error rate | < 1% | Error tracking |

### 6.5 Scalability

| Phase | Expected Traffic | Architecture Requirement |
|------|---------|---------|
| MVP | 100 DAU | Single server can handle |
| V2 | 1,000 DAU | Horizontal scaling capability |
| V3 | 10,000 DAU | Load balancing, CDN |

---

## 7. Information Architecture

### 7.1 Main Navigation Structure

```
Homepage
+-- My Situation (contextual guidance)
|   +-- Salary & Overtime
|   |   +-- Overtime pay calculation
|   |   +-- Salary deductions
|   |   +-- Minimum wage
|   +-- Leave & Rest
|   |   +-- Annual leave calculation
|   |   +-- Sick leave rules
|   |   +-- Leave types
|   +-- Resignation & Severance
|   |   +-- Severance pay calculation
|   |   +-- Resignation notice
|   |   +-- Illegal dismissal
|   +-- Workplace Issues
|   |   +-- Workplace bullying
|   |   +-- Sexual harassment
|   |   +-- Occupational accidents
|   +-- Other Questions
|       +-- Labor/health insurance
|       +-- Unions
|       +-- Employment contracts
+-- Calculation Tools
|   +-- Overtime pay calculator
|   +-- Annual leave calculator
|   +-- Severance pay calculator
+-- Emergency Assistance
|   +-- 1955 Labor Hotline
|   +-- County/city labor bureaus
|   +-- Legal aid
+-- Quick Query (search box)
+-- About Us
    +-- User guide
    +-- Disclaimer
    +-- Privacy policy
```

### 7.2 Information Display Layers

```
Layer 1: Direct answer (within 30 characters)
    | expand
Layer 2: Plain language explanation (within 200 characters)
    | expand
Layer 3: Legal article citations
    | expand
Layer 4: Related cases
    | link
Layer 5: Extended reading
```

### 7.3 Search & Navigation Design

| Feature | Design | Purpose |
|------|------|------|
| **Scenario selector** | 3 identity entry points on homepage | Lower selection barriers |
| **Keyword suggestions** | Auto-suggest while typing | Guide correct terminology |
| **Question templates** | Click to ask | Lower input barriers |
| **Breadcrumb navigation** | Show current location | Avoid getting lost |
| **Related questions** | Recommend after answering | Extended exploration |

---

## 8. Risk Assessment

### 8.1 Product Risks

| Risk | Probability | Impact | Level | Mitigation |
|------|:----:|:----:|:----:|---------|
| AI provides incorrect legal information causing user loss | Medium | Very High | Critical | Mandatory disclaimer, RAG source tracing, human review |
| Legal article data outdated or incorrect | Med-High | Very High | Critical | Article version control, regular updates, show update date |
| AI hallucination | Medium | High | Critical | RAG forced citation, confidence score, error reporting |
| Users mistake AI for professional lawyer | High | High | Critical | First-use education, mark limitations each time |
| Personal data leak | Low | Very High | Critical | Anonymous first, no PII storage, encrypted transmission |
| Users over-rely on system | High | Medium | Warning | Complex cases proactively refer to professional services |
| Vulnerable users excluded | High | High | Critical | Accessible design, multilingual support |

### 8.2 Technical Risks

| Risk | Probability | Impact | Level | Mitigation |
|------|:----:|:----:|:----:|---------|
| LLM API cost exceeds budget | High | High | Warning | Caching mechanism, token limits, cost monitoring |
| RAG retrieval slow | Medium | Medium | Warning | Vector database optimization, async processing |
| Third-party API service outage | Low | High | Warning | Backup provider, fallback mechanism |
| Technology selection uncertainty | High | Medium | Warning | Technical POC, architecture decision records |

### 8.3 Legal Risks

| Risk | Probability | Impact | Level | Mitigation |
|------|:----:|:----:|:----:|---------|
| User takes action based on incorrect info and sues | Low | Very High | Critical | Complete disclaimer, legal review, insurance |
| Violate Personal Data Protection Act | Low | High | Warning | Regulatory compliance review, minimal collection |
| Deemed as unauthorized legal practice | Very Low | Very High | Warning | Clearly position as information service, not legal advice |

---

## 9. Success Metrics

### 9.1 Product Health Metrics

| Category | Metric | MVP Target | 6-Month Target | Measurement Tool |
|------|------|---------|-----------|---------|
| **Usage** | DAU | 100+ | 1,000+ | Analytics |
| | MAU | 500+ | 10,000+ | Analytics |
| | Queries/day | 200+ | 2,000+ | Backend log |
| **Engagement** | Avg session duration | 3 min+ | 5 min+ | Analytics |
| | Queries per session | 2+ | 3+ | Backend analysis |
| | 7-day return rate | 20%+ | 35%+ | Cohort |
| **Satisfaction** | Positive rating rate | 75%+ | 85%+ | Built-in feedback |
| | NPS | 30+ | 50+ | Survey |
| | Error report rate | < 5% | < 2% | Reporting system |

### 9.2 Technical Performance Metrics

| Category | Metric | Target |
|------|------|--------|
| **Performance** | API response time (P95) | < 3 sec |
| | RAG retrieval time | < 1 sec |
| | LLM generation time | < 5 sec |
| **Stability** | Uptime | 99%+ |
| | Error rate | < 1% |
| **Cost** | Avg query cost | < NT$1 |

### 9.3 Content Quality Metrics

| Category | Metric | Target |
|------|------|--------|
| **Accuracy** | Legal citation accuracy | 98%+ |
| | Expert scoring accuracy | 85%+ |
| | Data timeliness | Regulation updates synced < 7 days |
| **Completeness** | Regulation coverage | 8 major laws 100% |
| | FAQ coverage | Common questions 90%+ |

### 9.4 User Rights Metrics

| Category | Metric | Target |
|------|------|--------|
| **Accessibility** | WCAG compliance level | AA |
| | Screen reader compatibility | 100% |
| **Multilingual** | Language coverage | 5 languages (V2) |
| **Privacy** | PII incidents | 0 |
| | Privacy complaints | 0 |

---

## 10. Timeline

### 10.1 Overall Timeline (18 Months)

```
2026 Q1        2026 Q2        2026 Q3        2026 Q4        2027 Q1
|--------------|--------------|--------------|--------------|
  Phase 0.5      Phase 0        Phase 1        Phase 2        Phase 3
  User Research  Tech Prep      MVP Dev        Beta Test      Launch
  (6 weeks)      (5 weeks)      (17 weeks)     (7 weeks)      (5 weeks)
                                                                  |
                                                              Phase 4
                                                              Continuous
                                                              Improvement
```

### 10.2 Phase 0.5: User Research (6 Weeks)

**Goal**: Validate requirement assumptions, ensure correct product direction

| Week | Task | Output |
|------|------|------|
| Week 1-2 | Research design, recruit participants | Research plan, 30 participants |
| Week 3-4 | In-depth interviews (15-18 people) | Pain point map, requirements list |
| Week 5 | Card sorting, survey | Information architecture, requirement priorities |
| Week 6 | Low-fidelity prototype testing | Usability issue list |

**Milestone**: User research report completed, requirement assumptions validated

### 10.3 Phase 0: Technical Preparation (5 Weeks)

| Week | Task | Output |
|------|------|------|
| Week 1-3 | Technology selection POC | ADR documents |
| Week 1-4 | Legal data collection and processing | Structured legal database |
| Week 4-5 | Architecture design, environment setup | Architecture docs, CI/CD |

**Milestone**: Technology stack confirmed, development environment ready

### 10.4 Phase 1: MVP Development (17 Weeks)

| Sprint | Weeks | Development Focus |
|--------|------|---------|
| Sprint 1-2 | 1-4 | Backend API foundation, database |
| Sprint 3-4 | 5-8 | RAG system development |
| Sprint 5-6 | 9-12 | AI Q&A functionality, guided Q&A |
| Sprint 7-8 | 13-16 | Frontend development, accessibility implementation |
| Sprint 9 | 17 | Integration testing, performance optimization |

#### Epic → Sprint Mapping

| Sprint | Weeks | Epic | Features | Milestone |
|--------|-------|------|----------|-----------|
| S1-2 | 1-4 | Epic 02 (foundation) | M-02 RAG pipeline, legal DB schema, embedding pipeline | RAG retrieval operational |
| S3-4 | 5-8 | Epic 02, Epic 03 (partial) | M-04 legal citation, M-07 confidence scoring, M-08 disclaimer | RAG system complete with quality controls |
| S5-6 | 9-12 | Epic 01, Epic 03 (partial) | M-05 chat UI, M-01 guided Q&A, M-03 layered display, M-09 feedback | Chat interface functional |
| S7-8 | 13-16 | Epic 04, Epic 05, Epic 06 | M-06 action guide, M-10 emergency, M-11 RWD, M-12 a11y, S-03 calculators | All MVP features complete |
| S9 | 17 | Cross-epic | Integration testing, PII sanitization, e2e testing, performance tuning | MVP tested and ready |

> **Note**: Epic 05 (Accessibility) and Epic 06 (Calculators) can start earlier if team bandwidth allows. The mapping above is the recommended critical path.

**Milestone**: MVP features complete, passed internal testing

### 10.5 Phase 2: Beta Testing (7 Weeks)

| Week | Task | Success Criteria |
|------|------|---------|
| Week 1-2 | Internal testing optimization | 0 Critical bugs |
| Week 3 | Beta user recruitment | 100 Beta users |
| Week 4-7 | Beta testing, collect feedback | 500+ queries, 75%+ satisfaction |

#### Beta Testing Plan

**Recruitment Channels**
| Channel | Target | Expected Yield |
|---------|--------|----------------|
| Legal Aid Foundation partnership | General workers with recent labor disputes | 20-30 users |
| HR professional communities (LinkedIn, Facebook groups) | HR specialists | 20-30 users |
| SME associations | Small business owners | 15-20 users |
| Foreign worker NGOs (e.g., TIWA, SPA) | Foreign workers (Vietnamese, Indonesian) | 15-20 users |
| University labor law courses | Students with legal knowledge (quality feedback) | 10-15 users |

**Test Focus by Epic**
| Priority | Epic | Test Scenarios | Key Metrics |
|----------|------|----------------|-------------|
| P0 | Epic 01 + 02 | Chat Q&A with real labor law questions | Response relevance, citation accuracy, completion rate |
| P0 | Epic 03 | Confidence scoring accuracy, disclaimer visibility | False confidence rate, disclaimer comprehension |
| P0 | Epic 04 | Emergency keyword detection, action guide usefulness | Emergency trigger accuracy, action plan save rate |
| P1 | Epic 05 | Screen reader navigation, mobile usability | WCAG audit pass rate, mobile task completion rate |
| P1 | Epic 06 | Calculator accuracy against manual calculation | Calculation correctness rate, user comprehension |

**Feedback Collection**
| Method | Timing | Questions |
|--------|--------|-----------|
| In-app rating | After each query | Thumbs up/down + optional comment |
| NPS survey | Day 7, Day 14 | "How likely are you to recommend?" (0-10) |
| Exit survey | End of beta | Satisfaction, missing features, trust level, suggestions |
| Moderated interviews | Week 5-6 (selected 10 users) | Deep dive on pain points, workflow, comprehension |

**Milestone**: Beta testing report completed

### 10.6 Phase 3: Official Launch (5 Weeks)

| Week | Task |
|------|------|
| Week 1-2 | Security audit, accessibility audit |
| Week 3-4 | Performance optimization, bug fixes |
| Week 5 | Documentation preparation, deployment |

**Milestone**: Official launch

### 10.7 Key Milestones

| Milestone | Expected Time | Deliverable |
|--------|---------|--------|
| M0.5 | Week 6 | User research report |
| M0 | Week 11 | Technology selection confirmed, environment ready |
| M1 | Week 28 | MVP features complete |
| M2 | Week 35 | Beta testing complete |
| M3 | Week 40 | Official launch |

---

## 11. Appendices

### Appendix A: Legal Coverage Scope

MVP should cover 8 major labor laws:

| Law Name | Priority | Key Sections |
|---------|--------|---------|
| Labor Standards Act | P0 | Wages, working hours, leave, contract termination |
| Labor Pension Act | P0 | Pension contributions, collection |
| Labor Insurance Act | P0 | Insurance enrollment, benefits |
| Employment Insurance Act | P0 | Unemployment benefits, parental leave |
| Occupational Safety and Health Act | P1 | Occupational accidents, safety regulations |
| Act of Gender Equality in Employment | P1 | Sexual harassment, parental leave |
| Act for Settlement of Labor-Management Disputes | P1 | Mediation, arbitration, strikes |
| Act for Worker Protection of Mass Redundancy | P2 | Mass layoff procedures |

### Appendix B: Technology Stack

> Updated to reflect Architecture Decision Records (ADR-001 to ADR-010)

| Item | Technology | ADR | Rationale |
|------|---------|-----|------|
| Package Manager | uv | [ADR-001](../adr/001-package-manager-uv.md) | Fast, reliable, lockfile support |
| Backend Framework | FastAPI | [ADR-002](../adr/002-web-framework-fastapi.md) | High performance, type hints, async support |
| ORM | SQLAlchemy 2.0 + asyncpg | [ADR-003](../adr/003-orm-sqlalchemy.md) | Type-safe, async, mature ecosystem |
| Frontend Framework | Next.js 15 (App Router) | [ADR-004](../adr/004-frontend-nextjs.md) | SSR, global CDN, ecosystem |
| Caching | Redis (Upstash) | [ADR-005](../adr/005-caching-redis.md) | Serverless, global edge, session management |
| Observability | Sentry + structlog + Prometheus + Grafana + OpenTelemetry | [ADR-006](../adr/006-observability-stack.md) | Full-stack monitoring, free tier |
| Embedding Model | OpenAI text-embedding-3-large (1536 dims) | [ADR-007](../adr/007-embedding-model.md) | Best multilingual performance, pgvector compatible |
| LLM Provider | Anthropic Claude Sonnet 4.5 (primary) + GPT-4o-mini (fallback) | [ADR-008](../adr/008-llm-provider.md) | Best instruction following, Traditional Chinese quality |
| Authentication | Anonymous-first + Optional OAuth2 (Google/Line) | [ADR-009](../adr/009-authentication-strategy.md) | Privacy-preserving, progressive trust |
| Deployment | Vercel + Fly.io (HK) + Neon + Upstash | [ADR-010](../adr/010-deployment-infrastructure.md) | Low cost (~$6/mo), APAC latency optimized |
| Database | PostgreSQL + pgvector | [ADR-003](../adr/003-orm-sqlalchemy.md), [ADR-010](../adr/010-deployment-infrastructure.md) | ACID, vector search, serverless (Neon) |
| Vector Search | pgvector (PostgreSQL extension) | [ADR-007](../adr/007-embedding-model.md) | No separate vector DB needed for ~2,500 vectors |

### Appendix C: User Support Architecture

| Level | Channel | Response Time | Handled Content |
|------|------|---------|---------|
| L1 | Self-service FAQ | Instant | General questions, system operation |
| L2 | AI Q&A | Instant | Legal queries, guided Q&A |
| L3 | Human support | Within 24 hours (business days) | System issues, feedback |
| L4 | Professional referral | Per partner | Complex legal cases |

### Appendix D: User Research Plan

**Phase 0.5 Research Plan (6 Weeks)**

| Research Method | Target | Sample Size | Output |
|---------|------|-------|------|
| In-depth interview | General workers | 7 | Pain point map |
| In-depth interview | HR specialists | 6 | Workflow |
| In-depth interview | Small business owners | 5 | Requirements list |
| Card sorting | Mixed | 15 | Information architecture |
| Online survey | Broad | 150+ | Requirement priorities |
| Prototype testing | Mixed | 9 | Usability issues |

### Appendix E: Competitive Analysis

| Competitor | Type | Strengths | Weaknesses | Differentiation Opportunity |
|------|------|------|------|-----------|
| Ministry of Labor website | Official | Authoritative, complete | Hard to understand, poor search | Plain language, AI interaction |
| 1955 hotline | Human | Professional, immediate | Long wait times, no records | 24-hour, with records |
| PTT forums | Community | Real experience | Unprofessional, hard to search | Accurate, with sources |
| Lawyer consultation | Professional | Case-specific judgment | Expensive | Free, fast |

### Appendix F: Glossary

| Term | Definition |
|------|------|
| RAG | Retrieval-Augmented Generation |
| LLM | Large Language Model |
| WCAG | Web Content Accessibility Guidelines |
| MVP | Minimum Viable Product |
| DAU/MAU | Daily/Monthly Active Users |
| NPS | Net Promoter Score |
| PWA | Progressive Web App |

---

### Appendix G: Content Strategy & Documentation Standards

> Provided by Senior Technical Writer evaluation

#### G.1 Content Strategy Overview

| Aspect | Strategy |
|------|------|
| **Core principle** | Accuracy > Readability > Aesthetics |
| **Language style** | Plain language first, legal terms need explanations |
| **Target readability** | 6th grade level comprehension |
| **Layered display** | 5-layer progressive disclosure (direct answer -> plain explanation -> legal text -> case -> extended) |

#### G.2 Four-Dimension Quality Scoring (100-point scale)

| Dimension | Weight | Assessment Items |
|------|:----:|---------|
| **Accuracy** | 40% | Legal citation correctness, information timeliness, no AI hallucination |
| **Readability** | 25% | Concise language, clear structure, example illustrations |
| **Completeness** | 20% | Complete answer, action guide, risk warnings |
| **User-oriented** | 15% | Empathy, actionability, resource links |

**Passing score**: 60 | **Target**: 90 (Excellent)

#### G.3 Three-Level Review Mechanism

```
Level 1: Self-review (Author)
    -> 30+ item checklist
         |
Level 2: Peer review (Content Team)
    -> Readability, completeness, consistency
         |
Level 3: Legal expert review (Legal Team)
    -> Accuracy, risk management
         |
    Publish + Continuous monitoring
```

#### G.4 Regulation Update SLA

| Priority | Trigger | SLA | Example |
|--------|---------|-----|------|
| **P0 Emergency** | Major regulation amendment | **24 hours** | Minimum wage adjustment |
| **P1 Important** | General regulation amendment | **3 days** | Article text correction |
| **P2 Routine** | Content optimization | **7 days** | FAQ supplement |

#### G.5 Multilingual Content Strategy

| Language | Target Users | Special Handling | Timeline |
|------|---------|---------|------|
| Traditional Chinese | Local workers | Standard version | MVP |
| **Simplified Chinese** | Lower language ability | Simplified vocabulary, sentences < 15 chars | MVP |
| Vietnamese | Vietnamese workers | Native translators, honorific handling | V2 |
| Indonesian | Indonesian workers | Religious cultural considerations | V2 |
| Thai | Thai workers | Gentle tone | V2 |
| Filipino | Filipino workers | English option | V2 |

#### G.6 Established Document List

| Document | Path | Purpose |
|------|------|------|
| Content Strategy Master | `/docs/strategy/content-strategy.md` | Overall strategy framework |
| Legal Content Writing Guide | `/docs/content-guidelines/legal-content-guide.md` | Plain language conversion standards |
| AI Response Quality Standards | `/docs/content-guidelines/ai-response-quality.md` | Four-dimension scoring mechanism |
| UI Text Writing Standards | `/docs/style-guides/ui-text-guide.md` | Interface text consistency |
| Multilingual Translation Guide | `/docs/i18n/translation-guide.md` | 7-language strategy |
| Content Update Workflow | `/docs/maintenance/content-update-workflow.md` | Regulation update SLA |
| Getting Started Guide | `/docs/user-guides/getting-started.md` | User instructions |
| Documentation Assessment Report | `/docs/reports/documentation-assessment.md` | Current state analysis |

---

### Appendix H: User Onboarding Strategy

> Provided by Senior Onboarding Specialist evaluation

#### H.1 Six-Dimension Onboarding Architecture

| Dimension | Goal | Core Mechanism |
|------|------|---------|
| **First-use guidance** | Quick success experience | Welcome -> Identity -> Feature tour -> First query |
| **Feature education** | Lower learning curve | Learn by Doing, Contextual Help |
| **Contextual guidance** | Real-time assistance | Emergency fast track, lost navigation, failure handling |
| **Trust building** | Build credibility | Transparency, verifiability, professional endorsement |
| **Continuous education** | Raise labor rights awareness | Daily tips, weekly report, regulation updates |
| **Accessible guidance** | Include all users | Multilingual, large font, voice navigation |

#### H.2 First-Use Flow Design

```
Step 1: Welcome Page (mandatory)
    -> System positioning explanation
    -> Disclaimer (friendly version)
    -> User rights explanation
         |
Step 2: Identity Selection (skippable)
    -> "I am a worker" "I am an employer" "I am HR"
    -> Differentiated experience basis
         |
Step 3: Feature Tour (skippable)
    -> 3 core feature carousel
    -> Guided Q&A, source traceability, action guide
         |
Step 4: First Query Guidance
    -> Question templates, voice input
    -> First success celebration
```

**Goal**: Let users successfully get their first useful answer within 5 minutes

#### H.3 Differentiated Guidance Strategy

| User Type | Tone | Default Scenarios | Special Handling |
|---------|---------|---------|---------|
| **General worker** | Friendly, empathetic | Salary, overtime, resignation | Emotional support, simplified steps |
| **HR specialist** | Professional, detailed | Regulation lookup, policy design | Citation format, batch queries |
| **Small business owner** | Practical, direct | Legal compliance, avoid fines | Checklists, risk warnings |
| **Vulnerable users** | Minimal, patient | Most common questions | Large buttons, voice support |

#### H.4 Emergency Fast Track

**Trigger keywords**:
- Time urgency: "today", "immediately", "now", "right away"
- Dismissal related: "fired", "dismissed", "laid off"
- Safety related: "occupational accident", "injured", "accident", "sexual harassment"

**Handling mechanism**:
1. Triggered immediately upon keyword detection
2. Overlay emergency assistance interface
3. Provide 1955 hotline one-tap call
4. Show county/city labor bureau contacts
5. Link to Legal Aid Foundation

#### H.5 Trust Building Mechanism

| Level | Strategy | Implementation |
|------|------|---------|
| L1 Transparency | Clearly state limitations | Disclaimer, confidence indicator |
| L2 Verifiability | Answers are traceable | RAG legal citations, update dates |
| L3 Expert endorsement | Expert review | Mark legal advisors, review process |
| L4 Social proof | Usage data | Satisfaction rate, user count |
| L5 Continuous improvement | Disclose errors | Error reporting, monthly reports |

#### H.6 Onboarding Success Metrics

| Stage | Metric | MVP Target |
|------|------|---------|
| Welcome page | Completion rate | 90%+ |
| Identity selection | Completion rate | 80%+ |
| Feature tour | Full view rate | 70%+ |
| First query | Success completion rate | 65%+ |
| Day 1 Retention | Next-day return rate | 30%+ |
| Day 7 Retention | 7-day return rate | 20%+ |

---

### Appendix I: Visual Design System

> Provided by Senior Visual Designer evaluation

#### I.1 Brand Visual Positioning

| Dimension | Target | Design Language |
|------|:----:|---------|
| Professionalism | 70% | Clear hierarchy, precise information architecture |
| Approachability | 80% | Rounded corners, warm colors |
| Credibility | 90% | Consistent visuals, clear source marking |
| Usability | 95% | Large touch targets, clear contrast |

**Core style**: Warm Professional

#### I.2 Color System

**Primary - Professional Teal**

| Scale | Hex | Usage |
|------|------|------|
| Primary-500 | `#00A896` | Brand primary, main buttons |
| Primary-600 | `#008C7E` | Hover state |
| Primary-700 | `#007066` | Dark elements, links |
| Primary-100 | `#B3E8E2` | Light backgrounds |

**Secondary - Warm Orange**

| Scale | Hex | Usage |
|------|------|------|
| Secondary-500 | `#FF9800` | Action emphasis, CTA |
| Accent-500 | `#9C27B0` | AI assistant identity |

**Semantic Colors**

| Semantic | Hex | Usage |
|------|------|------|
| Success | `#4CAF50` | Success, completion |
| Warning | `#FFC107` | Warning, caution |
| Error | `#F44336` | Error, danger |
| Info | `#2196F3` | Information, tips |

**Accessibility contrast**: All combinations pass WCAG 2.1 AA (contrast ratio >= 4.5:1)

#### I.3 Typography System

**Font Stack**

```css
--font-family-sans: "Noto Sans TC", -apple-system,
    "Microsoft JhengHei", "PingFang TC", sans-serif;
--font-family-mono: "JetBrains Mono", "SF Mono", monospace;
```

**Type Scale**

| Level | Size | Weight | Usage |
|------|------|------|------|
| H1 | 36px | Bold (700) | Page title |
| H2 | 30px | SemiBold (600) | Section title |
| H3 | 24px | SemiBold (600) | Card title |
| Body | 16px | Regular (400) | Body text |
| Body Large | 18px | Regular (400) | Important text |
| Caption | 12px | Regular (400) | Annotations, timestamps |
| Legal | 14px | Medium (500) | Legal article content |

**Large font mode**: All sizes enlarged 150%, line height increased to 1.75

#### I.4 Component Design Specifications

**Button Sizes**

| Size | Height | Padding | Usage |
|------|------|---------|------|
| Small | 36px | 16px | Secondary actions |
| Medium | 44px | 24px | Default size |
| Large | 52px | 32px | Important CTA, Mobile |

**Card Design**

- Border radius: 12px (radius-lg)
- Shadow: 0 4px 6px rgba(0,0,0,0.1)
- Padding: 24px (space-5)

**Chat Bubbles**

| Type | Background | Border Radius | Alignment |
|------|------|------|------|
| User message | Primary-500 | 18px 18px 4px 18px | Right |
| AI message | White + Border | 18px 18px 18px 4px | Left |

#### I.5 Responsive Breakpoints

| Breakpoint | Device | Container Width |
|------|------|---------|
| < 640px | Mobile | 100% (padding 16px) |
| 768px | Tablet portrait | 720px |
| 1024px | Tablet landscape | 960px |
| 1280px | Desktop | 1200px |

**Mobile-First principles**:
- Minimum touch target 44x44px
- Single column priority layout
- Simplified navigation (Hamburger Menu)

#### I.6 Emotional Design

| User Emotion | Visual Treatment | Design Strategy |
|---------|---------|---------|
| Anxiety/anger | Soft colors, large rounded corners | Slow fade-in, empathetic copy |
| Confusion | Clear hierarchy, guide arrows | Step-by-step, progressive disclosure |
| Success | Green, celebration icons | Light bounce, positive encouragement |
| Urgency | Orange-red, subtle pulse | Noticeable but not alarming, supportive |

---

### Appendix J: Customer Support Framework

> Provided by Senior Customer Support evaluation

#### J.1 Four-Layer Support Architecture

```
+-----------------------------------------------------+
| L1: Self-Service (40%)                               |
|     FAQ, knowledge base, question templates          |
|     Response time: Instant                           |
+-----------------------------------------------------+
                        | Cannot resolve
+-----------------------------------------------------+
| L2: AI Q&A System (45%)                              |
|     Guided Q&A, RAG answers, calculation tools       |
|     Response time: Instant                           |
+-----------------------------------------------------+
                        | Cannot resolve
+-----------------------------------------------------+
| L3: Human Support (13%)                              |
|     Error reports, complaint handling, complex consult|
|     Response time: Within 24 hours (business days)   |
+-----------------------------------------------------+
                        | Out of scope
+-----------------------------------------------------+
| L4: Professional Referral (2%)                       |
|     Lawyer referral, government hotlines, labor orgs |
|     Response time: Per partner                       |
+-----------------------------------------------------+
```

#### J.2 Support Team Configuration (MVP)

| Role | Count | Responsibilities | Monthly Salary Est. |
|------|:----:|------|---------|
| Support Manager | 1 | Team management, quality monitoring, process optimization | NT$ 55,000 |
| Support Specialist | 2 | General inquiries, error report handling | NT$ 35,000 x 2 |
| Legal Advisor | 0.5 | Complex case review, content review | NT$ 30,000 |
| **Total** | **3.5** | - | **NT$ 155,000/month** |

#### J.3 Standard Operating Procedures (SOP)

**General Inquiry Handling**

```
Receive inquiry -> Classify issue -> Query knowledge base -> Provide response
    |                  |                    |
  Create ticket     Assess complexity    Cannot answer -> Escalate L3/L4
                                            |
                                       Respond within 48 hours
```

**Error Report Handling**

| Step | Time Limit | Responsible |
|------|------|--------|
| Receive report | Instant | System auto-creates ticket |
| Initial confirmation | Within 4 hours | Support specialist |
| Legal review | Within 24 hours | Legal advisor |
| Content correction | 4 hours after confirmation | Content team |
| Reply to user | Immediately after correction | Support specialist |

**Emergency Situation Handling**

| Situation | Keywords | Handling |
|------|--------|---------|
| Occupational accident/fatality | "injured", "accident", "death" | Immediately provide 119, Ministry of Labor hotline |
| Suicidal ideation | "don't want to live", "suicide" | Immediately provide peace hotline 1925 |
| Physical threat | "threat", "violence", "hit" | Advise calling police 110, provide shelter info |
| Illegal detention | "won't let leave", "confiscated documents" | Immediately provide 1955, police assistance |

#### J.4 Quality Management KPIs

| Metric | Target | Measurement |
|------|--------|---------|
| First response time | < 4 hours (business days) | Ticket system |
| First contact resolution (FCR) | > 70% | Ticket statistics |
| User satisfaction (CSAT) | > 4.0/5.0 | Survey |
| Error report processing time | < 24 hours | Ticket system |
| Escalation rate | < 15% | Ticket statistics |
| Complaint rate | < 2% | Complaint records |
| AI answer accuracy | > 90% | Sampling review |

#### J.5 Response Templates (Selected)

**Apology & Empathy**
```
"We're sorry you encountered this issue. We understand the inconvenience
 this has caused. Let's work together to resolve this situation."
```

**When Unable to Answer**
```
"This question involves your specific circumstances. We recommend consulting
 a professional lawyer for the most accurate judgment. Here are free legal
 consultation resources: [Legal Aid link]"
```

**Emergency Situation**
```
"We notice your situation may be urgent.
 We recommend immediately calling the 1955 Labor Consultation Hotline
 (24-hour service), or contacting your local labor bureau for assistance.

 [One-tap call 1955]"
```

**Foreign Worker (Vietnamese example)**
```
"Xin chao! Chung toi hieu rang ban co the gap kho khan
 ve ngon ngu. Vui long lien he duong day 1955 - ho co
 ho tro tieng Viet."
```

#### J.6 Annual Cost Estimate

| Item | Annual Cost | Share |
|------|---------|:----:|
| Personnel cost | NT$ 2,040,000 | 90.2% |
| Ticket system (Freshdesk) | NT$ 72,000 | 3.2% |
| Knowledge base (Notion) | NT$ 24,000 | 1.1% |
| Training expenses | NT$ 60,000 | 2.7% |
| Other (phone, equipment) | NT$ 65,320 | 2.9% |
| **Total** | **NT$ 2,261,320** | **100%** |

**Per-case cost**: Approx. NT$ 628 (estimated 3,600 cases/year)

#### J.7 Support Framework Document

Complete documentation established: `/docs/support/customer-support-framework.md`

---

## Change Log

| Version | Date | Changes | Author |
|------|------|---------|------|
| 1.0 | 2026-02-02 | Initial version (integrating PO, User Support, User Researcher, User Advocate evaluations) | Product Owner |
| 1.1 | 2026-02-03 | Added Appendices G-J (integrating Technical Writer, Onboarding Specialist, Visual Designer, Customer Support evaluations) | Product Owner |
| 2.0 | 2026-02-13 | Restructured: extracted detailed feature specs into 6 Epic files, updated Appendix B with ADR-001~010 | Product Owner |
| 2.1 | 2026-02-13 | PO review fixes: S-06 assigned to Epic 03, Epic dependency map, Sprint mapping, Could Have roadmap, Beta testing plan, error handling & edge cases in all Epics | Product Owner |

---

## Sign-off

| Role | Name | Date | Sign |
|------|------|------|------|
| Product Owner | | | |
| Tech Lead | | | |
| UX Designer | | | |
| Legal Advisor | | | |
| Project Sponsor | | | |

---

*This document integrates evaluation results from the following 8 experts:*
- *Phase 1: Senior Product Owner, User Support, User Researcher, User Advocate*
- *Phase 2: Senior Technical Writer, Senior Onboarding Specialist, Senior Visual Designer, Senior Customer Support*
