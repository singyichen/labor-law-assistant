# ADR-009: Anonymous-first Authentication with Optional OAuth2

**Status**: Accepted
**Date**: 2025-02-13

## Context

The system is a public legal query assistant. Most users will ask questions without registering. Requiring authentication would create friction and reduce adoption. However, registered users should be able to save conversation history and preferences across devices.

Key requirements:
- Anonymous users must have **zero friction** — no registration wall.
- Conversation history within a session (context-aware follow-up questions).
- Session data in Redis (24-hour TTL), persisted to PostgreSQL for registered users.
- Optional social login (Google, Line — dominant in Taiwan market).
- Support anonymous-to-registered migration (merge conversation history).
- Rate limiting per session to control LLM costs.
- Compliance with Taiwan Personal Data Protection Act.

### Candidates Evaluated

| Strategy | UX Friction | Security | Complexity | Extensibility | **Score** |
|----------|:-:|:-:|:-:|:-:|:-:|
| **Anonymous-first + Optional OAuth2** | 10 | 8 | 7 | 9 | **9/10** |
| Pure JWT-based | 6 | 8 | 6 | 7 | 5/10 |
| Pure OAuth2 (require login) | 2 | 10 | 5 | 8 | 2/10 |
| Passwordless (magic link) | 5 | 9 | 7 | 7 | 6/10 |

**Pure OAuth2 rejected**: Violates core requirement of anonymous-first access. Would lose the majority of potential users.

**Pure JWT rejected**: Anonymous users still need tokens, adding unnecessary complexity. JWT payload size limits prevent storing conversation history. Losing stateless benefit when Redis is needed anyway.

## Decision

Use **Anonymous-first + JWT + Optional OAuth2** hybrid strategy.

| Concern | Decision |
|---------|----------|
| Anonymous sessions | UUID session_id in HttpOnly cookie + Redis (24h TTL) |
| Registered users | NextAuth.js v5 (Auth.js) with JWT strategy |
| Social login providers | Google OAuth2 + Line Login (Taiwan market) |
| Token storage | HttpOnly + Secure + SameSite=Lax cookies (not localStorage) |
| Session backend | Redis (24h TTL, sliding window) |
| Persistent storage | PostgreSQL (conversations table, after session expiry) |
| CSRF protection | SameSite=Lax cookies + CSRF token (double-submit) |
| Rate limiting | Redis-based token bucket — 20 queries/hour per session |
| PII handling | Auto-sanitize Taiwan ID, phone, email from stored conversations |

### Authentication Flow

```
Anonymous User:
  Browser --> Next.js middleware generates session_id (UUID v4)
         --> Set HttpOnly cookie
         --> FastAPI creates Redis session on first query
         --> 24h TTL with sliding window

Registered User (upgrade):
  Click "Save conversations" --> NextAuth.js (Google/Line)
         --> Backend migrates anonymous session to user account
         --> Conversation history moved to PostgreSQL
         --> JWT tokens issued in HttpOnly cookies

Returning User:
  Browser --> NextAuth.js checks auth cookie
         --> Load conversation history from PostgreSQL
         --> Create Redis session for active use
```

### Cookie Strategy

| Cookie | Purpose | Flags |
|--------|---------|-------|
| `session_id` | Anonymous session identifier | HttpOnly, Secure, SameSite=Lax, Max-Age=86400 |
| `auth_token` | JWT for registered users | HttpOnly, Secure, SameSite=Lax, Max-Age=30d |

**Why HttpOnly cookies over localStorage**: Prevents XSS attacks from stealing tokens. JavaScript cannot read HttpOnly cookies, eliminating the primary client-side attack vector.

### Recommended Libraries

**Backend (FastAPI)**:
- `redis-py` — async session management (already planned in ADR-005)
- `python-jose[cryptography]` — JWT encoding/decoding
- `httpx` — OAuth2 token exchange

**Frontend (Next.js)**:
- `next-auth` v5 (Auth.js) — Google + Line providers, JWT strategy
- Next.js middleware — anonymous session_id generation, route protection

## Consequences

### Easier
- Anonymous users start asking questions immediately — zero friction increases adoption.
- Redis session with sliding window TTL naturally handles conversation context.
- NextAuth.js handles OAuth2 complexity (token refresh, provider management) on the frontend.
- FastAPI dependency injection unifies anonymous/authenticated user handling in a single `get_current_session()` dependency.
- Rate limiting per session prevents anonymous abuse of LLM API without requiring login.
- HttpOnly cookies provide strong XSS protection with minimal implementation effort.
- Line Login integration targets Taiwan's dominant messaging platform.

### Harder
- Anonymous-to-registered migration requires careful session merging logic (conversation history transfer).
- Two session types (anonymous cookie vs JWT) add complexity to the auth middleware.
- CSRF protection needed for cookie-based auth (SameSite=Lax helps but double-submit pattern adds code).
- Cross-device sync only available after registration — anonymous sessions are per-browser.
- Must comply with Taiwan Personal Data Protection Act (auto-sanitize PII, provide data deletion).
- Rate limiting must handle both session_id and user_id identifiers.

## Referenced by

- [PRD README.md](../prd/README.md) — Appendix B Technology Stack
- [Epic 01: Chat Interface](../prd/epics/01-chat-interface.md) — Technical Dependencies
- [Epic 03: Response Quality](../prd/epics/03-response-quality.md) — Related ADRs
- [Epic 04: Action Guide & Emergency](../prd/epics/04-action-guide-emergency.md) — Reminder Implementation (S-10)
- [Epic 06: Calculation Tools](../prd/epics/06-calculation-tools.md) — Related ADRs
- [Epic 07: Future Features](../prd/epics/07-future-features.md) — Account System (C-04)
- [Wireframes](../design/wireframes.md) — Cross-References
- [Testing Strategy](../testing/testing-strategy.md) — ADR References
