# Epic 01: AI Chat Interface

## Overview

The core conversational interaction layer of the Labor Law Assistant. This epic covers the basic Q&A interface, contextual question guidance, layered information display, voice input, and conversation history. Together these features enable users to ask labor law questions naturally and receive structured, understandable answers.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| M-05 | Basic Q&A Interface | Must Have | Clean conversational query interface |
| M-01 | Contextual Question Guidance | Must Have | Guide questions based on user identity and context |
| M-03 | Layered Information Display | Must Have | Summary first, expandable detailed legal articles |
| S-02 | Voice Input | Should Have | Speech-to-text queries |
| S-08 | Conversation History | Should Have | Save query history (local storage) |

---

## MVP Scope (Must Have)

### M-05: Basic Q&A Interface

**User Story**
> As a user, I want a simple chat-like interface to ask labor law questions, so that I can get answers without navigating complex menus.

**Acceptance Criteria**
- [ ] Single-page chat interface with message input area and conversation display
- [ ] Support text input with send button and Enter key submission
- [ ] Display AI responses with streaming text generation (token-by-token)
- [ ] Show typing/loading indicator while AI is generating response
- [ ] Responsive layout that works on mobile (375px+) and desktop
- [ ] Input field auto-focuses on page load
- [ ] Support multi-turn conversation (follow-up questions maintain context)
- [ ] Display timestamps on messages
- [ ] Auto-scroll to latest message

**UI Mockup**
```
+----------------------------------+
|     Labor Law Assistant          |
+----------------------------------+
|                                  |
|  [AI] Welcome! What labor law    |
|  question can I help you with?   |
|                                  |
|       [User] How is overtime     |
|       pay calculated?            |
|                                  |
|  [AI] Overtime pay is calculated |
|  at 1.34x-1.67x hourly rate...  |
|  [Source: Labor Standards Act    |
|   Article 24]                    |
|                                  |
+----------------------------------+
| Type your question...     [Send] |
+----------------------------------+
```

---

### M-01: Contextual Question Guidance

**User Story**
> As a general worker, I want the system to guide me in describing my problem, because I don't know legal terminology and I'm not sure which category my problem falls into.

**Acceptance Criteria**
- [ ] Homepage displays identity selection: "I am a Worker", "I am an Employer", "I am HR"
- [ ] Based on identity, show corresponding common scenarios (salary, leave, resignation, etc.)
- [ ] Each scenario provides 5-10 question templates
- [ ] Users can directly click or modify templates
- [ ] Support free-form input with keyword suggestions
- [ ] Identity selection is optional (can skip directly to free-form input)
- [ ] Question templates are stored in a configurable data source (not hardcoded)
- [ ] Track which templates are most used (for optimization)

**UI Mockup**
```
+---------------------------------+
|      Labor Law Assistant        |
+---------------------------------+
|                                 |
|   I want to understand my       |
|   labor rights. I am...         |
|                                 |
|  +---------+ +---------+       |
|  | Worker  | | Employer|       |
|  +---------+ +---------+       |
|       +---------+              |
|       |   HR    |              |
|       +---------+              |
|                                 |
|  ------- or type directly ----- |
|  +-------------------------+   |
|  | Type your question...   |   |
|  +-------------------------+   |
|                                 |
+---------------------------------+
```

**Scenario Templates (Worker)**
| Scenario | Sample Questions |
|----------|----------------|
| Salary & Overtime | "How is overtime pay calculated?", "Can my employer deduct my salary?", "What is the current minimum wage?" |
| Leave & Rest | "How many annual leave days do I have?", "What are the sick leave rules?", "Can my employer deny my leave request?" |
| Resignation & Severance | "How much is my severance pay?", "How many days notice must I give?", "Can my employer fire me without reason?" |
| Workplace Issues | "What should I do about workplace bullying?", "How do I report sexual harassment?", "I was injured at work, what are my rights?" |

---

### M-03: Layered Information Display

**User Story**
> As a general worker, I want to see a simple answer first and only see detailed legal articles if needed, because too much information will make me give up reading.

**Acceptance Criteria**
- [ ] Layer 1: Direct answer (within 30 characters, heading-level text)
- [ ] Layer 2: Plain language explanation (within 200 characters, readable inline)
- [ ] Layer 3: Legal article citations (expandable/collapsible)
- [ ] Layer 4: Related cases (expandable/collapsible)
- [ ] Layer 5: Extended reading (link list)
- [ ] Each layer displays a "confidence" indicator
- [ ] Response footer shows "data update date"
- [ ] Expand/collapse state persists during the session
- [ ] Smooth expand/collapse animation (< 300ms)

**UI Mockup**
```
+---------------------------------------------+
| Your question: How is overtime pay calculated?|
+---------------------------------------------+
|                                              |
| Direct Answer                                |
| Weekday overtime is 1.34-1.67x hourly rate   |
|                                              |
| Detailed Explanation                         |
| Per the Labor Standards Act, weekday overtime |
| first 2 hours are 1.34x hourly rate,        |
| hours 3-4 are 1.67x...                      |
|                                              |
| > View original legal text                   |
| > View calculation examples                  |
| > Use overtime calculator                    |
|                                              |
| ------------------------------------------- |
| Confidence: High | Updated: 2026-01-15      |
| Warning: This is reference info, not legal   |
| advice                                       |
|                                              |
| [Helpful] [Not Helpful] [Report Error]       |
+---------------------------------------------+
```

---

## Extended Scope (Should Have)

### S-02: Voice Input

**User Story**
> As a user with limited typing ability (elderly, injured, or multitasking), I want to ask questions by speaking, so that I can still use the system without typing.

**Acceptance Criteria**
- [ ] Microphone button in the input area
- [ ] Browser-native Web Speech API for speech-to-text
- [ ] Visual feedback during recording (animation, waveform)
- [ ] Transcribed text appears in input field for review/edit before sending
- [ ] Support Traditional Chinese (zh-TW) speech recognition
- [ ] Graceful fallback if browser doesn't support Web Speech API
- [ ] Clear permission prompt for microphone access
- [ ] Stop recording button and auto-stop after silence (3 seconds)

---

### S-08: Conversation History

**User Story**
> As a returning user, I want to see my previous queries, so that I don't have to re-ask the same questions.

**Acceptance Criteria**
- [ ] Store conversation history in browser LocalStorage/IndexedDB
- [ ] Display history list with query preview and timestamp
- [ ] Click on history item to view full conversation
- [ ] Delete individual history items
- [ ] Clear all history option
- [ ] History persists across browser sessions (same device)
- [ ] Maximum storage limit (e.g., 100 conversations) with oldest auto-purge
- [ ] No server-side storage (privacy-first)
- [ ] Export conversation as text/PDF (optional enhancement)

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| FastAPI WebSocket / SSE | Backend | For streaming AI responses |
| Vercel AI SDK | Frontend | React hooks for chat streaming |
| react-markdown | Frontend | Render markdown in AI responses |
| Web Speech API | Browser | Voice input (S-02) |
| LocalStorage / IndexedDB | Browser | Conversation history (S-08) |
| TanStack Query | Frontend | Server state management for chat |
| Zustand | Frontend | Client state (UI state, active conversation) |

## Related ADRs

- [ADR-002: FastAPI as Web Framework](../../adr/002-web-framework-fastapi.md)
- [ADR-004: Next.js as Frontend Framework](../../adr/004-frontend-nextjs.md)
- [ADR-008: LLM Provider (Claude Sonnet 4.5)](../../adr/008-llm-provider.md)
- [ADR-009: Authentication Strategy](../../adr/009-authentication-strategy.md)
