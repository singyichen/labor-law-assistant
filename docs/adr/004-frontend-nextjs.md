# ADR-004: Use Next.js as Frontend Framework

**Status**: Accepted
**Date**: 2025-02-13

## Context

The project needs a frontend framework to build the user-facing interface for a Taiwan labor law query assistant. The backend is built with FastAPI (Python), exposing RESTful APIs with planned SSE/WebSocket support for streaming LLM responses.

Key product requirements:
- Chat interface with streaming responses (similar to ChatGPT).
- Legal article citations with clickable source references.
- Conversation history management.
- Confidence indicator (high/medium/low) for answers.
- Responsive design (desktop + mobile).
- Primarily Traditional Chinese.

Four candidates were evaluated:

### Next.js (App Router)
- React-based with SSR/SSG/CSR flexibility.
- Vercel AI SDK provides native streaming support.
- API Routes can proxy FastAPI (BFF pattern), avoiding CORS issues.
- Largest ecosystem for chat UI components (shadcn/ui, react-markdown).

### React + Vite (SPA)
- Lightest weight, simplest deployment.
- Full React ecosystem access.
- No SSR — poor SEO for marketing/landing pages.
- Requires direct CORS configuration with FastAPI.

### Nuxt.js
- Vue-based with excellent SSR/SSG support.
- Vue chat UI ecosystem is smaller than React.
- WebSocket/SSE support requires extra configuration.

### Remix
- React-based with strong data loading patterns.
- Smaller ecosystem and community compared to Next.js.
- Streaming support requires manual configuration.

## Decision

Use **Next.js 15 (App Router)** with the following stack:

| Layer | Technology |
|-------|-----------|
| Framework | Next.js 15 (App Router) |
| Language | TypeScript (strict mode) |
| Package Manager | pnpm |
| UI Framework | shadcn/ui + Tailwind CSS |
| State Management | TanStack Query (server state) + Zustand (client state) |
| Chat/Streaming | Vercel AI SDK + react-markdown |
| Form Validation | React Hook Form + Zod |
| i18n | next-intl |
| Testing | Vitest + Playwright |
| Linting | ESLint + Prettier |

## Consequences

### Easier
- Vercel AI SDK provides out-of-the-box SSE streaming hooks, directly compatible with FastAPI streaming endpoints.
- API Routes act as a BFF (Backend for Frontend) proxy, eliminating CORS complexity.
- shadcn/ui offers customizable chat UI components built on Tailwind CSS.
- SSG for marketing pages + CSR for chat interface — SEO where needed, SPA where needed.
- TypeScript strict mode ensures type safety across the frontend.
- Large React/Next.js community in Taiwan — easier to find developers for future maintenance.
- TanStack Query handles API caching, retry, and invalidation for conversation history.

### Harder
- App Router has a steep learning curve (Server Components, Server Actions, RSC patterns).
- Next.js standalone Docker builds are more complex than static SPA deployment.
- Requires Node.js runtime in production (unlike a static SPA).
- Two package managers in the monorepo (uv for backend, pnpm for frontend).
- Vercel deployment is optimal but creates vendor dependency; self-hosting requires extra configuration.

## Referenced by

- [PRD README.md](../prd/README.md) — Appendix B Technology Stack
- [Epic 01: Chat Interface](../prd/epics/01-chat-interface.md) — Technical Dependencies
- [Epic 04: Action Guide & Emergency](../prd/epics/04-action-guide-emergency.md) — Related ADRs
- [Epic 05: Accessibility & i18n](../prd/epics/05-accessibility-i18n.md) — Related ADRs, i18n routing
- [Epic 06: Calculation Tools](../prd/epics/06-calculation-tools.md) — Related ADRs
- [Wireframes](../design/wireframes.md) — Cross-References
- [Testing Strategy](../testing/testing-strategy.md) — ADR References
