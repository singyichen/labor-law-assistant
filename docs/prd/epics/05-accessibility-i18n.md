# Epic 05: Accessibility & Internationalization

## Overview

The inclusive design layer ensuring the Labor Law Assistant is usable by all Taiwan workers, regardless of physical ability, device, or language. This epic covers mobile-first responsive design, WCAG 2.1 AA accessibility compliance, and multilingual support for foreign workers.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| M-11 | Mobile-First Design | Must Have | Mobile-First responsive web design |
| M-12 | Accessibility Basics | Must Have | WCAG 2.1 AA compliance |
| S-01 | Multi-language Support | Should Have | Vietnamese, Indonesian, Thai, Filipino |

---

## MVP Scope (Must Have)

### M-11: Mobile-First Design

**User Story**
> As a worker who primarily uses a mobile phone, I want the system to work perfectly on my phone, so that I can query labor law information anytime, anywhere.

**Acceptance Criteria**
- [ ] Mobile-first CSS approach (design for mobile, enhance for desktop)
- [ ] Responsive breakpoints: 375px (mobile), 768px (tablet), 1024px (laptop), 1280px (desktop)
- [ ] All interactive elements have minimum 44x44px touch targets
- [ ] Single-column layout on mobile, multi-column on desktop
- [ ] Navigation collapses to hamburger menu on mobile
- [ ] Chat input is fixed at bottom of viewport on mobile
- [ ] No horizontal scrolling at any viewport width
- [ ] Images and diagrams are responsive (max-width: 100%)
- [ ] Font sizes are readable without zooming (minimum 16px body text)
- [ ] Test on: iPhone SE, iPhone 15, Samsung Galaxy S23, iPad
- [ ] Lighthouse mobile performance score >= 90
- [ ] First Contentful Paint < 2 seconds on 3G connection
- [ ] Support PWA manifest (installable on home screen)
- [ ] Offline fallback page for no-connectivity scenarios

**Responsive Layout Strategy**
| Viewport | Layout | Navigation | Chat Input |
|----------|--------|------------|------------|
| < 640px (mobile) | Single column, full width | Hamburger menu | Fixed bottom bar |
| 768px (tablet) | Single column, centered (720px) | Side panel (collapsible) | Fixed bottom bar |
| 1024px+ (desktop) | Two-column (sidebar + main) | Persistent sidebar | Inline at bottom of chat |

---

### M-12: Accessibility Basics

**User Story**
> As a visually impaired user, I want to use the system with my screen reader, so that I can access labor law information independently.

**Acceptance Criteria**

**Perceivable**
- [ ] All images have descriptive alt text
- [ ] All form inputs have associated labels
- [ ] Color is never the sole means of conveying information
- [ ] Text contrast ratio >= 4.5:1 (normal text), >= 3:1 (large text)
- [ ] High contrast mode toggle available
- [ ] Text is scalable to 200% without loss of functionality
- [ ] All non-text content has text alternatives

**Operable**
- [ ] Full keyboard navigation (Tab, Shift+Tab, Enter, Escape, Arrow keys)
- [ ] Visible focus indicators on all interactive elements
- [ ] Skip-to-content link at the top of every page
- [ ] No keyboard traps
- [ ] No time-limited interactions
- [ ] Focus management for dynamic content (chat messages, modals)
- [ ] Escape key closes modals and overlays

**Understandable**
- [ ] Page language declared in HTML lang attribute (zh-TW)
- [ ] Consistent navigation across all pages
- [ ] Form validation errors clearly described with suggestions
- [ ] Labels and instructions provided for user input
- [ ] Plain language used (see Appendix G content strategy)

**Robust**
- [ ] Valid, semantic HTML5 (header, main, nav, article, section, footer)
- [ ] ARIA landmarks for major page sections
- [ ] ARIA live regions for dynamic updates (chat messages, notifications)
- [ ] Compatible with: NVDA (Windows), JAWS (Windows), VoiceOver (macOS/iOS), TalkBack (Android)
- [ ] All interactive components use appropriate ARIA roles
- [ ] Tested with axe-core automated accessibility checker (0 critical issues)

**Accessibility Testing Plan**
| Test Type | Tool | Frequency | Target |
|-----------|------|-----------|--------|
| Automated scan | axe-core + Lighthouse | Every PR | 0 critical, 0 serious |
| Screen reader | VoiceOver, NVDA | Weekly (during development) | All flows navigable |
| Keyboard-only | Manual testing | Every feature | Full functionality |
| Color contrast | Colour Contrast Analyser | Design phase | >= 4.5:1 |
| Zoom | Browser zoom 200% | Every feature | No loss of functionality |

---

## Extended Scope (Should Have)

### S-01: Multi-language Support

**User Story**
> As a Vietnamese worker in Taiwan, I want to use the system in my native language, so that I can understand labor law information despite the language barrier.

**Acceptance Criteria**
- [ ] Language selector accessible from every page (top navigation)
- [ ] Supported languages (Phase 2): Vietnamese, Indonesian, Thai, Filipino
- [ ] UI text (buttons, labels, navigation) fully translated
- [ ] AI responses generated in the selected language
- [ ] Legal article citations shown in both original Chinese and translated version
- [ ] Disclaimer translated into all supported languages
- [ ] Emergency resources display language-specific hotline info (1955 supports multilingual)
- [ ] Language preference persisted in session/cookie
- [ ] Fallback to Traditional Chinese if translation is unavailable
- [ ] RTL layout not required (no RTL languages in scope)

**i18n Architecture**
| Layer | Approach | Library |
|-------|----------|---------|
| UI text | Static translation files (JSON) | next-intl or react-i18next |
| AI responses | LLM generates in target language | Claude Sonnet 4.5 multilingual |
| Legal citations | Pre-translated + machine translated | Human review required |
| URL structure | `/[locale]/...` path prefix | Next.js i18n routing |

**Translation Priority**
| Language | Target Users | Estimated Translation Effort | Timeline |
|------|---------|---------|------|
| Traditional Chinese | All local users | Baseline (done) | MVP |
| Simplified Chinese | Lower literacy users | Rewrite (not machine translate) | MVP |
| Vietnamese | ~230K workers | Professional + review | V2 |
| Indonesian | ~260K workers | Professional + review | V2 |
| Thai | ~70K workers | Professional + review | V2 |
| Filipino | ~150K workers | Professional + review | V2 |
| English | Other foreign nationals | In-house | V3 |

**Translation Quality Process**
1. Professional human translation (native speaker with legal domain knowledge)
2. Review by bilingual labor rights advocate
3. User testing with target language speakers (5 users per language)
4. Continuous feedback loop for improvement

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| Next.js 15 App Router | Frontend | i18n routing, SSR for SEO |
| next-intl or react-i18next | Frontend | Static translation management |
| Tailwind CSS | Frontend | Responsive design, utility-first CSS |
| shadcn/ui | Frontend | Accessible component library (ARIA built-in) |
| axe-core | Testing | Automated accessibility testing |
| Playwright | Testing | Cross-browser accessibility testing |
| Lighthouse CI | CI/CD | Performance and accessibility scoring per PR |

## Related ADRs

- [ADR-004: Next.js as Frontend](../../adr/004-frontend-nextjs.md) - App Router, i18n routing
- [ADR-008: LLM Provider](../../adr/008-llm-provider.md) - Multilingual response generation
- [ADR-010: Deployment Infrastructure](../../adr/010-deployment-infrastructure.md) - Vercel global CDN for APAC performance
