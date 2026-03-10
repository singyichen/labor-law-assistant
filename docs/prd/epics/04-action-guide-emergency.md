# Epic 04: Action Guide & Emergency Assistance

## Overview

The actionable assistance layer that bridges knowledge to action. This epic covers the action guide (telling users what to do next), the emergency fast track for urgent situations, evidence collection guidance, and appeal process instructions. These features ensure users don't just understand the law but know how to protect themselves.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| M-06 | Action Guide | Must Have | Tell users what to do next |
| M-10 | Emergency Fast Track | Must Have | Detect emergency keywords, provide hotline links |
| S-04 | Evidence Collection Guide | Should Have | Tell users what evidence to collect and how to preserve it |
| S-05 | Appeal Process Guide | Should Have | Step-by-step instructions for various appeal channels |
| S-10 | Post-Action Check-In | Should Have | Optional follow-up reminders, resolution tracking, escalation options |

---

## MVP Scope (Must Have)

### M-06: Action Guide

**User Story**
> As a general worker, I want to know what to do after understanding the legal issue, because just knowing the law doesn't help me protect myself.

**Acceptance Criteria**
- [ ] Each AI response includes a "What you can do" action section
- [ ] Provide 3-5 concrete action steps in sequential order
- [ ] Each step is labeled with difficulty level: Easy / Needs Preparation / Needs Professional Help
- [ ] Include evidence collection checklist when applicable
- [ ] Include relevant channel links (government hotlines, complaint channels)
- [ ] Complex cases proactively suggest consulting a professional lawyer
- [ ] Action steps are tailored to user identity (worker vs employer vs HR)
- [ ] Each action step includes estimated time/effort
- [ ] Provide "Save action plan" button (saves to conversation history)
- [ ] Action steps assess power dynamics: when suggesting "talk to employer," provide safety assessment questions (e.g., "Is it safe to approach your employer directly?")
- [ ] Include "Do NOT take action if you feel unsafe" warnings for harassment/violence scenarios
- [ ] For sensitive scenarios (harassment, illegal detention), prioritize third-party intervention options (labor bureau, NGO, legal aid) over direct employer confrontation

**UI Mockup**
```
+---------------------------------------------+
| What You Can Do                              |
+---------------------------------------------+
|                                              |
| Step 1 [Easy]                                |
| Collect your pay stubs and work hour records |
| for the past 6 months                        |
|                                              |
| Step 2 [Easy]                                |
| Calculate your expected overtime pay using   |
| our calculator: [Use Calculator]             |
|                                              |
| Step 3 [Needs Preparation]                   |
| Write a formal complaint letter to your      |
| employer's HR department                     |
|                                              |
| Step 4 [Needs Preparation]                   |
| File a complaint with your local labor       |
| bureau: [Find your labor bureau]             |
|                                              |
| Step 5 [Needs Professional Help]             |
| If the dispute is not resolved, consider     |
| labor mediation: [Learn about mediation]     |
|                                              |
| [Save Action Plan]                           |
+---------------------------------------------+
```

**Action Templates by Scenario**
| Scenario | Key Actions | Resources |
|----------|------------|-----------|
| Unpaid overtime | Collect evidence -> Calculate amount -> Complain to employer -> File with labor bureau | Pay stubs, work logs, overtime calculator |
| Illegal dismissal | Gather documents -> Understand notice period -> Assess severance -> File complaint | Employment contract, dismissal notice, severance calculator |
| Workplace harassment | Document incidents -> Report to employer -> File with labor bureau -> Seek legal aid | Incident log, witness list, legal aid contacts |
| Occupational accident | Report to employer -> Seek medical care -> File labor insurance claim -> Document damages | Medical records, accident report, insurance forms |

---

### M-10: Emergency Fast Track

**User Story**
> As a worker facing an urgent situation, I want to immediately access help resources, because I may be experiencing illegal treatment right now.

**Acceptance Criteria**
- [ ] System detects emergency keywords in user input
- [ ] Upon detection, display a prominent emergency assistance panel
- [ ] Provide 1955 Labor Consultation Hotline with one-tap call (mobile)
- [ ] Provide county/city labor bureau contact information
- [ ] Provide Legal Aid Foundation link
- [ ] Provide labor rights NGO resources
- [ ] Emergency panel overlays the AI response (not replaces it)
- [ ] Emergency panel can be dismissed but re-accessed via a persistent button
- [ ] Emergency keywords are configurable (admin can add/remove)
- [ ] System still processes the query normally (emergency panel is additional)
- [ ] Track emergency trigger frequency for monitoring
- [ ] Implicit crisis detection: analyze query patterns (e.g., same topic queried > 5 times within 24 hours) and proactively offer support resources
- [ ] Display empathetic message alongside emergency panel: "We understand this is a difficult situation. You are not alone."

**Emergency Trigger Keywords**
| Category | Keywords |
|----------|---------|
| Time urgency | "today", "immediately", "now", "right away", "urgent" |
| Dismissal | "fired", "dismissed", "laid off", "terminated", "lost my job" |
| Safety | "occupational accident", "injured", "accident", "sexual harassment", "assaulted" |
| Detention | "won't let me leave", "confiscated passport", "confiscated documents" |
| Threats | "threatened", "violence", "intimidation" |
| Self-harm | "don't want to live", "suicide" (escalate to crisis resources) |

**Emergency Resources**
| Resource | Contact | Notes |
|----------|---------|-------|
| 1955 Labor Consultation Hotline | 1955 | 24-hour, multilingual |
| Local Labor Bureau | Per county/city | Business hours |
| Legal Aid Foundation | (02)6632-8282 | Free legal consultation |
| 1925 Suicide Prevention Hotline | 1925 | 24-hour, for self-harm signals |
| 110 Police Emergency | 110 | For physical threats |
| 113 Domestic Violence Hotline | 113 | For workplace violence situations |
| 1980 Teacher Chang Hotline | 1980 | Emotional support, stress counseling |

**UI Mockup**
```
+=============================================+
| EMERGENCY ASSISTANCE                    [X] |
|                                             |
| Your situation may be urgent.               |
| Please consider contacting these resources: |
|                                             |
| [Call 1955 - Labor Hotline]  24hr           |
| [Find Local Labor Bureau]                   |
| [Legal Aid Foundation]                      |
|                                             |
| If you are in immediate danger:             |
| [Call 110 - Police]                         |
+=============================================+
```

---

## Extended Scope (Should Have)

### S-04: Evidence Collection Guide

**User Story**
> As a worker preparing to file a complaint, I want to know what evidence I need to collect and how to preserve it, so that my case is well-supported.

**Acceptance Criteria**
- [ ] Provide scenario-specific evidence checklists
- [ ] Each evidence item includes: what to collect, where to find it, how to preserve it
- [ ] Visual checklist format with checkboxes (saveable/printable)
- [ ] Include warnings about evidence that may disappear (e.g., chat messages, CCTV)
- [ ] Provide tips on legal admissibility of evidence
- [ ] Include digital evidence preservation guidance (screenshots, timestamps)
- [ ] Evidence checklist is downloadable as PDF
- [ ] Link relevant evidence items to the specific legal articles they support

**Evidence Checklists by Scenario**
| Scenario | Key Evidence |
|----------|-------------|
| Unpaid wages | Pay stubs, bank transfer records, employment contract, work hour records, attendance records |
| Illegal dismissal | Dismissal notice, employment contract, performance records, communication records |
| Workplace harassment | Incident timeline, witness contacts, chat/email records, medical records (if applicable) |
| Occupational accident | Accident report, medical records, witness statements, workplace photos, insurance records |

---

### S-05: Appeal Process Guide

**User Story**
> As a worker who has decided to take action, I want step-by-step instructions for filing complaints through different channels, so that I can navigate the process confidently.

**Acceptance Criteria**
- [ ] Cover major appeal channels: employer internal, labor bureau, mediation, arbitration, court
- [ ] Each channel includes: eligibility, required documents, timeline, expected outcome, cost
- [ ] Step-by-step flowchart for each appeal process
- [ ] Comparison table of different channels (time, cost, binding force)
- [ ] Include template complaint letters (downloadable)
- [ ] Link to online filing portals where available
- [ ] Show success rate statistics where publicly available
- [ ] Recommend most appropriate channel based on user's situation

**Appeal Channels Comparison**
| Channel | Timeline | Cost | Binding Force | Best For |
|---------|----------|------|---------------|----------|
| Employer Internal | 1-2 weeks | Free | No | Minor issues, good faith employer |
| Labor Bureau Complaint | 2-4 weeks | Free | Administrative order | Clear regulation violations |
| Labor-Management Mediation | 1-3 months | Free | If agreed, legally binding | Negotiable disputes |
| Arbitration | 3-6 months | Low | Legally binding | Complex disputes |
| Court (Labor Court) | 6-12 months | Filing fee | Legally binding | Last resort |

---

### S-10: Post-Action Check-In

**User Story**
> As a worker who has taken action based on the system's guidance, I want optional follow-up support, so that I don't feel abandoned after taking a difficult step.

**Acceptance Criteria**
- [ ] Action guide includes optional "Remind me in X days" feature (3 / 7 / 14 / 30 days)
- [ ] Reminder (browser notification or in-app on next visit) asks: "Have you taken action? Do you need further help?"
- [ ] If user reports "not resolved," system provides escalation options (legal aid, labor union, labor bureau)
- [ ] If user reports "resolved," show positive reinforcement and invite feedback
- [ ] Reminders are opt-in only (never automatic), respecting user privacy
- [ ] Provide "I no longer need reminders" option to stop all follow-ups
- [ ] Include emotional support resources in follow-up messages (1980 Teacher Chang, 1925 hotline)
- [ ] Privacy audit: verify no PII linkage between reminder events and user queries

**Privacy-Preserving Metrics (Two-Tier Architecture)**

| Tier | Storage | Data | Purpose |
|------|---------|------|---------|
| **Tier 1: User-Side** | Browser LocalStorage | Reminder settings (dates, opt-in status), action plan save timestamp, self-reported outcome (resolved/not resolved) | User experience only, NO server transmission |
| **Tier 2: Anonymous Events** | Server-Side Analytics | Event counts only: `action_plan_saved`, `reminder_set`, `followup_completed`, `user_reported_resolved` | Aggregate product metrics |

**Tier 2 Rules**:
- NO user identification (no session ID, no cookie ID attached to events)
- NO query content stored with events
- Events contain only: event type + scenario category (e.g., `overtime`) + timestamp
- Aggregated weekly in Analytics Dashboard (no individual-level drill-down)
- Resolution rate measured via optional anonymous survey (not tracked per user)

> This two-tier design ensures User Rights Charter #2 (absolute privacy protection) while enabling aggregate product metrics in §9.4.
>
> **§9.4 Metric Mapping**: "Action completion rate" uses Tier 2 `action_plan_saved` event count. "Issue resolution rate" uses optional anonymous survey via S-10 reminder banner (opt-in, no user tracking). See [PRD §9.4](../README.md) for targets.

#### Reminder Implementation Approach

**Phase 2 (V2) -- Client-Side Only**:
- Reminder data stored entirely in browser LocalStorage (reminder date, generic reminder type)
- In-app notification: on next visit after reminder date, display a non-intrusive banner: _"You set a reminder X days ago. Have you taken action? [Yes, resolved] [Need more help] [Dismiss]"_
- No server-side tracking of reminder events (100% client-side)
- If user clears browser data, reminders are lost (acceptable trade-off for privacy)

**Future (V3+, Registered Users)**:
- For users who opt into accounts (per [ADR-009](../../adr/009-authentication-strategy.md)): Web Push API browser notifications
- Push notification content: date + generic message only (e.g., "You have a labor law follow-up reminder")
- No query content, no legal topic, no case details included in push payload

**Privacy Constraints**:
- Reminder data never contains query content, legal topics, or any PII
- Reminder content limited to: reminder ID (UUID), set date, trigger date, status (pending/dismissed/actioned)
- No correlation between reminder events and conversation history on the server

**Frequency Capping**: Maximum 1 reminder notification per 7 calendar days per browser session to prevent notification fatigue.

> **Cross-reference**: See [ADR-009: Authentication Strategy](../../adr/009-authentication-strategy.md) for the anonymous-first to optional-registration progression that governs reminder capability tiers.

---

## Error Handling & Edge Cases

| Scenario | Handling | User Message |
|----------|----------|-------------|
| Emergency keyword false positive (e.g., "I was fired up about my project") | Allow dismissal, learn from dismissal patterns | Emergency panel shown with [X] close button |
| Emergency keyword missed (new slang/expression) | Monthly review of undetected emergency queries via feedback data | (No immediate user impact, process improvement) |
| Self-harm keywords detected | Immediately show crisis resources BEFORE legal content | "If you are in distress, please call 1925 (24-hour support line). You are not alone." |
| 1955 hotline is outside business hours | Show hours and alternative: online complaint form | "1955 operates [hours]. You can also file online: [link]" |
| Action guide generation fails (LLM timeout) | Show generic action template for the scenario | "Here are general steps for your situation: [pre-written template]" |
| Evidence checklist PDF generation fails | Offer plain-text alternative | "PDF generation failed. [View as text] [Try again]" |
| User location unknown (can't determine local labor bureau) | Show all 22 county/city labor bureaus with search | "Select your county/city to find your local labor bureau." |
| Appeal process template download fails | Retry, then link to official government templates | "Template unavailable. Visit the official site: [link]" |

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| Claude Sonnet 4.5 | AI/ML | Generate tailored action guides |
| PostgreSQL | Database | Emergency keyword configuration, resource directory |
| Redis (Upstash) | Cache | Cache emergency resource data |
| Next.js | Frontend | Emergency overlay UI, evidence checklist components |
| react-to-pdf | Frontend | PDF export for evidence checklists (S-04) |

## Epic Dependencies

| Relationship | Epic | Reason |
|-------------|------|--------|
| **Depends on** | Epic 01 (Chat Interface) | Action guides are displayed within chat responses |
| **Depends on** | Epic 02 (RAG Legal Search) | Action guides reference legal content from RAG |
| **Integrates with** | Epic 03 (Response Quality) | Emergency panel coexists with confidence/disclaimer UI |
| **Can develop in parallel** | Epic 05 (Accessibility), Epic 06 (Calculators) | No direct dependency |

> **Recommended development order**: Sprint 7-8 after chat UI (Epic 01) and RAG (Epic 02) are functional. M-10 emergency panel can be developed independently of M-06 action guide.

## Related ADRs

- [ADR-004: Next.js as Frontend](../../adr/004-frontend-nextjs.md) - UI for action guides and emergency panel
- [ADR-005: Redis Caching](../../adr/005-caching-redis.md) - Cache emergency resource directory
- [ADR-008: LLM Provider](../../adr/008-llm-provider.md) - Generate contextual action guides
