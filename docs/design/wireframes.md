# Wireframes & Interaction Flows

## Document Metadata

| Field | Value |
|-------|-------|
| **Version** | v1.0 |
| **Created** | 2026-02-13 |
| **Last Updated** | 2026-02-13 |
| **Status** | Draft |
| **Owner** | UX/UI Designer |
| **Reviewers** | Product Owner, Frontend Developer, Accessibility Specialist |
| **Design System** | [PRD Appendix I: Visual Design System](../prd/README.md#appendix-i-visual-design-system) |

---

## Table of Contents

1. [Design System Summary](#1-design-system-summary)
2. [Site Map](#2-site-map)
3. [Core Page Wireframes](#3-core-page-wireframes)
4. [Key Interaction Flows](#4-key-interaction-flows)
5. [Responsive Breakpoints](#5-responsive-breakpoints)
6. [Cross-References](#6-cross-references)

---

## 1. Design System Summary

> Full design system specification: [PRD Appendix I](../prd/README.md#appendix-i-visual-design-system)

| Element | Specification |
|---------|--------------|
| **Primary color** | Professional Teal `#00A896` |
| **Secondary color** | Warm Orange `#FF9800` |
| **AI accent** | Purple `#9C27B0` |
| **Font family** | Noto Sans TC, -apple-system, Microsoft JhengHei |
| **Body text** | 16px Regular, line-height 1.6 |
| **Border radius** | Cards: 12px, Buttons: 8px, Chat bubbles: 18px |
| **Touch targets** | Minimum 44px (mobile: 48px) |
| **Contrast** | All text >= 4.5:1 (WCAG 2.1 AA) |

---

## 2. Site Map

Reference: [PRD SS7 Information Architecture](../prd/README.md#7-information-architecture)

```mermaid
flowchart TB
    HOME["Homepage"]

    HOME --> GUIDE["My Situation<br>Contextual Guidance"]
    HOME --> WIZARD["I Don't Know How to Ask<br>Wizard Mode"]
    HOME --> SEARCH["Quick Query<br>Search Box"]
    HOME --> TOOLS["Calculation Tools"]
    HOME --> EMERGENCY["Emergency Assistance"]
    HOME --> ABOUT["About Us"]

    GUIDE --> SALARY["Salary and Overtime"]
    GUIDE --> LEAVE["Leave and Rest"]
    GUIDE --> RESIGN["Resignation and Severance"]
    GUIDE --> WORKPLACE["Workplace Issues"]

    SALARY --> CHAT["AI Chat Interface"]
    LEAVE --> CHAT
    RESIGN --> CHAT
    WORKPLACE --> CHAT
    WIZARD --> CHAT
    SEARCH --> CHAT

    CHAT --> RESPONSE["Layered Response<br>with Action Guide"]
    RESPONSE --> FEEDBACK["Feedback and Rating"]

    TOOLS --> CALC_OT["Overtime Pay Calculator"]
    TOOLS --> CALC_LEAVE["Annual Leave Calculator"]
    TOOLS --> CALC_SEV["Severance Pay Calculator"]

    CALC_OT -->|Ask AI About This| CHAT
    CALC_LEAVE -->|Ask AI About This| CHAT
    CALC_SEV -->|Ask AI About This| CHAT
```

---

## 3. Core Page Wireframes

### 3.1 Homepage - Identity Selection

Source: [Epic 01 M-01](../prd/epics/01-chat-interface.md)

```mermaid
flowchart TB
    subgraph Homepage["Homepage - 375px Mobile"]
        direction TB
        HEADER["<b>Header</b><br>Logo: Labor Law Assistant<br>Language Selector"]
        TITLE["<b>Welcome Section</b><br>I want to understand my labor rights"]
        ROLES["<b>Identity Selector - 3 Cards</b><br>Worker | Employer | HR"]
        DIVIDER["--- or type directly ---"]
        WIZARD_BTN["<b>Wizard Button</b><br>I don't know how to ask"]
        INPUT["<b>Search Input</b><br>Type your question... | Send"]
        FOOTER["<b>Footer</b><br>Disclaimer | About | Privacy"]

        HEADER --> TITLE
        TITLE --> ROLES
        ROLES --> DIVIDER
        DIVIDER --> WIZARD_BTN
        WIZARD_BTN --> INPUT
        INPUT --> FOOTER
    end
```

**Key interactions**:
- Identity selection is optional (can skip to free-form input)
- Selecting an identity shows scenario templates (salary, leave, resignation, etc.)
- Each scenario provides 5-10 clickable question templates

---

### 3.2 Chat Interface

Source: [Epic 01 M-05](../prd/epics/01-chat-interface.md)

```mermaid
flowchart TB
    subgraph ChatPage["Chat Interface"]
        direction TB
        NAV["<b>Top Navigation</b><br>Back to Home | New Chat | History"]
        MESSAGES["<b>Message Area</b><br>AI Welcome Message<br>...<br>User Message - right aligned<br>AI Response - left aligned with avatar<br>Typing indicator while generating"]
        DISCLAIMER["<b>Inline Disclaimer</b><br>Reference information only. Not legal advice."]
        INPUT_BAR["<b>Input Bar</b><br>Text input | Voice button | Send button"]

        NAV --> MESSAGES
        MESSAGES --> DISCLAIMER
        DISCLAIMER --> INPUT_BAR
    end
```

**Key interactions**:
- Streaming text generation (token-by-token)
- Auto-scroll to latest message
- Input auto-focuses on page load
- Enter key submits, Shift+Enter for newline

---

### 3.3 Layered Information Response

Source: [Epic 01 M-03](../prd/epics/01-chat-interface.md)

```mermaid
flowchart TB
    subgraph LayeredResponse["AI Response - Layered Display"]
        direction TB
        L1["<b>Layer 1: Direct Answer</b><br>30 chars max, heading-level text<br>Example: Weekday overtime is 1.34-1.67x hourly rate"]
        L2["<b>Layer 2: Plain Language Explanation</b><br>200 chars max, readable inline<br>Per the Labor Standards Act, weekday overtime..."]
        L3["<b>Layer 3: Legal Citations - Expandable</b><br>Chevron icon: View original legal text<br>Collapsed by default"]
        L4["<b>Layer 4: Related Cases - Expandable</b><br>Chevron icon: View calculation examples<br>Collapsed by default"]
        L5["<b>Layer 5: Extended Reading</b><br>Link list: Use overtime calculator"]
        META["<b>Response Footer</b><br>Confidence: High | Updated: 2026-01-15<br>Warning: Reference info, not legal advice"]
        ACTIONS["<b>Feedback and Actions</b><br>Helpful | Not Helpful | Report Error"]

        L1 --> L2
        L2 --> L3
        L3 --> L4
        L4 --> L5
        L5 --> META
        META --> ACTIONS
    end
```

**Key interactions**:
- Expand/collapse animation < 300ms
- Expand/collapse state persists during session
- Confidence indicator color-coded: High (green), Medium (orange), Low (red)

---

### 3.4 Wizard Mode

Source: [Epic 01 M-15](../prd/epics/01-chat-interface.md)

```mermaid
flowchart TD
    START["What kind of problem<br>are you experiencing?<br>Step 1 of 4"]

    START --> SALARY["Salary / Pay issues"]
    START --> LEAVE["Leave / Time off"]
    START --> FIRED["Being fired / Quitting"]
    START --> SAFETY["Workplace safety"]
    START --> SKIP["Skip to chat"]

    SALARY --> Q2S{"Is it related to<br>overtime pay?<br>Step 2 of 4"}
    Q2S -->|Yes| R_OT["Overtime pay calculation<br>and complaint guide"]
    Q2S -->|No| R_SAL["Salary deductions<br>and minimum wage"]

    LEAVE --> Q2L{"Is it related to<br>annual leave?<br>Step 2 of 4"}
    Q2L -->|Yes| R_LEAVE["Annual leave entitlement<br>and calculation"]
    Q2L -->|No| R_OTHER["Sick leave, parental leave<br>and other leave types"]

    FIRED --> Q2F{"Did your employer<br>fire you?<br>Step 2 of 4"}
    Q2F -->|Yes| R_FIRED["Illegal dismissal assessment<br>and severance pay"]
    Q2F -->|No| R_QUIT["Resignation notice period<br>and procedure"]

    SAFETY --> Q2W{"Was there an occupational<br>accident?<br>Step 2 of 4"}
    Q2W -->|Yes| R_ACC["Occupational accident<br>claim and compensation"]
    Q2W -->|No| R_HAR["Workplace bullying<br>or harassment"]

    R_OT & R_SAL & R_LEAVE & R_OTHER --> CHAT["Enter AI Chat<br>with pre-filled context"]
    R_FIRED & R_QUIT & R_ACC & R_HAR --> CHAT
    SKIP --> CHAT
```

**Key interactions**:
- Maximum 5 questions to reach a result
- Progress indicator: "Step 2 of 4"
- Back button to revise previous answers
- Exit to free-form input at any time

---

### 3.5 Emergency Assistance Panel

Source: [Epic 04 M-10](../prd/epics/04-action-guide-emergency.md)

```mermaid
flowchart TB
    subgraph EmergencyPanel["Emergency Panel - Overlay"]
        direction TB
        HEADER_E["<b>EMERGENCY ASSISTANCE</b> ............... Close X"]
        EMPATHY["We understand this is a difficult situation.<br>You are not alone."]
        HOTLINE["<b>Call 1955 - Labor Hotline</b> 24hr<br>Tap to call on mobile"]
        BUREAU["<b>Find Local Labor Bureau</b><br>Select county/city"]
        LEGAL["<b>Legal Aid Foundation</b><br>02-6632-8282"]
        DANGER["<b>If you are in immediate danger:</b>"]
        POLICE["<b>Call 110 - Police</b>"]
        CRISIS["<b>Call 1925 - Crisis Support</b> 24hr"]

        HEADER_E --> EMPATHY
        EMPATHY --> HOTLINE
        HOTLINE --> BUREAU
        BUREAU --> LEGAL
        LEGAL --> DANGER
        DANGER --> POLICE
        POLICE --> CRISIS
    end
```

**Key interactions**:
- Overlays the AI response (does not replace it)
- Dismissible with X button, re-accessible via persistent button
- Self-harm keywords trigger crisis resources BEFORE legal content
- One-tap call on mobile devices

---

### 3.6 Action Guide

Source: [Epic 04 M-06](../prd/epics/04-action-guide-emergency.md)

```mermaid
flowchart TB
    subgraph ActionGuide["What You Can Do"]
        direction TB
        S1["<b>Step 1</b> - Easy<br>Collect your pay stubs and work hour records<br>for the past 6 months"]
        S2["<b>Step 2</b> - Easy<br>Calculate your expected overtime pay<br>using our calculator: Use Calculator"]
        S3["<b>Step 3</b> - Needs Preparation<br>Write a formal complaint letter<br>to your employer HR department"]
        S4["<b>Step 4</b> - Needs Preparation<br>File a complaint with your local<br>labor bureau: Find your labor bureau"]
        S5["<b>Step 5</b> - Needs Professional Help<br>If the dispute is not resolved,<br>consider labor mediation: Learn about mediation"]
        SAVE["Save Action Plan"]

        S1 --> S2
        S2 --> S3
        S3 --> S4
        S4 --> S5
        S5 --> SAVE
    end
```

**Key interactions**:
- Each step labeled with difficulty: Easy / Needs Preparation / Needs Professional Help
- Steps tailored to user identity (worker vs employer vs HR)
- "Save action plan" saves to conversation history
- Safety assessment for sensitive scenarios (harassment/violence)

---

### 3.7 Legal Citation Display

Source: [Epic 02 M-04](../prd/epics/02-rag-legal-search.md)

```mermaid
flowchart TB
    subgraph Citations["Legal Citations Section"]
        direction TB
        TITLE_C["<b>Sources</b>"]
        C1["<b>1 Labor Standards Act, Article 24</b><br>Effective: 2024-03-01 | Updated recently<br>Chevron: Expand full text<br>Link to official source"]
        C2["<b>2 Labor Standards Act, Article 32</b><br>Effective: 2022-01-01<br>Chevron: Expand full text<br>Link to official source"]
        COPY["Copy all citations"]

        TITLE_C --> C1
        C1 --> C2
        C2 --> COPY
    end
```

**Key interactions**:
- Click to expand full article text inline
- Each citation links to official law.moj.gov.tw
- "Recently updated" badge for recently amended articles
- Copy citation button for HR users

---

### 3.8 Feedback Rating

Source: [Epic 03 M-09](../prd/epics/03-response-quality.md)

```mermaid
flowchart TB
    subgraph Feedback["Feedback Section"]
        direction TB
        PROMPT["Was this helpful?"]
        BUTTONS["Thumbs Up | Thumbs Down | Report Error"]
    end

    subgraph ThumbsDown["After Thumbs Down"]
        direction TB
        QUESTION["What was the issue?"]
        OPTIONS["Radio: Incorrect information<br>Radio: Not relevant to my question<br>Radio: Too complicated to understand<br>Radio: Missing important details<br>Radio: Other - free text input"]
        SUBMIT["Submit | Skip"]

        QUESTION --> OPTIONS
        OPTIONS --> SUBMIT
    end

    BUTTONS -->|Thumbs Down| QUESTION
```

---

### 3.9 Overtime Pay Calculator

Source: [Epic 06 S-03a](../prd/epics/06-calculation-tools.md)

```mermaid
flowchart TB
    subgraph OTCalc["Overtime Pay Calculator"]
        direction TB
        TITLE_OT["<b>Overtime Pay Calculator</b><br>Toggle: Detailed Mode | Simple Mode"]
        INPUT_SALARY["<b>Monthly Salary</b><br>Input: NT$ 30,000"]
        INPUT_WD["<b>Weekday Overtime</b><br>First 2 hours: Input field<br>Hours 3-4: Input field"]
        INPUT_RD["<b>Rest Day Overtime</b><br>Hours worked: Input field"]
        INPUT_NH["<b>National Holiday Overtime</b><br>Hours worked: Input field"]
        CALC_BTN["Calculate | Reset"]
        RESULT["<b>=== Results ===</b><br>Hourly rate: NT$ 125<br>30,000 / 30 / 8 = 125"]
        BREAKDOWN["<b>Step-by-step Breakdown</b><br>Weekday first 2hr: 125 x 1.34 x 4 = NT$ 670<br>LSA Art. 24, Para. 1 - Why is it calculated this way?<br>...<br><b>TOTAL: NT$ 2,676</b>"]
        ACTIONS_OT["Copy Result | Ask AI About This"]

        TITLE_OT --> INPUT_SALARY
        INPUT_SALARY --> INPUT_WD
        INPUT_WD --> INPUT_RD
        INPUT_RD --> INPUT_NH
        INPUT_NH --> CALC_BTN
        CALC_BTN --> RESULT
        RESULT --> BREAKDOWN
        BREAKDOWN --> ACTIONS_OT
    end
```

---

### 3.10 Annual Leave Calculator

Source: [Epic 06 S-03b](../prd/epics/06-calculation-tools.md)

```mermaid
flowchart TB
    subgraph LeaveCalc["Annual Leave Calculator"]
        direction TB
        TITLE_L["<b>Annual Leave Calculator</b>"]
        INPUT_START["<b>Employment Start Date</b><br>Date picker or manual input"]
        INPUT_METHOD["<b>Calculation Method</b><br>Toggle: Anniversary Year | Calendar Year"]
        CALC_BTN_L["Calculate | Reset"]
        RESULT_L["<b>=== Results ===</b><br>Years of service: 3 years 5 months<br>Annual leave days: 14 days<br>LSA Art. 38"]
        TIMELINE["<b>Leave Progression Timeline</b><br>Visual bar chart:<br>6mo-1yr: 3 days<br>1-2yr: 7 days<br>2-3yr: 10 days<br>3-5yr: 14 days - You are here<br>5-10yr: 15 days<br>10+yr: 15 + 1/yr, max 30"]
        UNUSED["<b>Unused Leave Compensation</b><br>Daily wage x unused days = NT$ X,XXX"]
        ACTIONS_L["Copy Result | Ask AI About This"]

        TITLE_L --> INPUT_START
        INPUT_START --> INPUT_METHOD
        INPUT_METHOD --> CALC_BTN_L
        CALC_BTN_L --> RESULT_L
        RESULT_L --> TIMELINE
        TIMELINE --> UNUSED
        UNUSED --> ACTIONS_L
    end
```

---

### 3.11 Severance Pay Calculator

Source: [Epic 06 S-03c](../prd/epics/06-calculation-tools.md)

```mermaid
flowchart TB
    subgraph SevCalc["Severance Pay Calculator"]
        direction TB
        TITLE_S["<b>Severance Pay Calculator</b>"]
        INPUT_AVG["<b>Average Monthly Salary - Last 6 Months</b><br>Input: NT$ amount"]
        INPUT_DATES["<b>Employment Period</b><br>Start date: Date picker<br>Termination date: Date picker"]
        INPUT_SYSTEM["<b>Pension System</b><br>Radio: New system - Labor Pension Act, after 2005-07-01<br>Radio: Old system - Labor Standards Act, before 2005-07-01<br>Radio: Mixed - spans transition date"]
        CALC_BTN_S["Calculate | Reset"]
        RESULT_S["<b>=== Results ===</b><br>Service period: 5 years 3 months<br>Applicable system: New system"]
        BREAKDOWN_S["<b>Calculation Breakdown</b><br>Average salary: NT$ 45,000<br>Years of service: 5.25 years<br>Formula: 0.5 months x 5.25 = 2.625 months<br>Severance pay: NT$ 45,000 x 2.625 = NT$ 118,125<br>Legal basis: Labor Pension Act Art. 12"]
        CONDITIONS["<b>Severance Conditions</b><br>Expandable: When is severance required?<br>LSA Art. 11, 13, 14, 20"]
        ACTIONS_S["Copy Result | Ask AI About This<br>What if my employer refuses to pay?"]

        TITLE_S --> INPUT_AVG
        INPUT_AVG --> INPUT_DATES
        INPUT_DATES --> INPUT_SYSTEM
        INPUT_SYSTEM --> CALC_BTN_S
        CALC_BTN_S --> RESULT_S
        RESULT_S --> BREAKDOWN_S
        BREAKDOWN_S --> CONDITIONS
        CONDITIONS --> ACTIONS_S
    end
```

---

## 4. Key Interaction Flows

### 4.1 First-Time User Onboarding

Reference: [PRD Appendix H](../prd/README.md#appendix-h-user-onboarding-strategy)

```mermaid
flowchart TD
    VISIT["User visits homepage"]
    DISCLAIMER["Disclaimer banner appears<br>This is an information service,<br>not legal advice"]
    ACCEPT["User accepts disclaimer<br>Cookie set, banner hidden"]
    WELCOME["Welcome section displayed"]

    CHOICE{"User chooses entry point"}
    IDENTITY["Select identity:<br>Worker / Employer / HR"]
    SCENARIOS["Show scenario templates<br>based on identity"]
    WIZARD_F["Enter Wizard Mode<br>Step-by-step yes/no questions"]
    DIRECT["Type question directly<br>in search box"]

    TEMPLATE["Click a question template"]
    WIZARD_RESULT["Wizard reaches scenario<br>within 5 questions"]

    CHAT_F["Enter AI Chat<br>with context pre-filled"]

    VISIT --> DISCLAIMER
    DISCLAIMER --> ACCEPT
    ACCEPT --> WELCOME
    WELCOME --> CHOICE
    CHOICE -->|I know what to ask| IDENTITY
    CHOICE -->|I don't know how to ask| WIZARD_F
    CHOICE -->|Quick search| DIRECT

    IDENTITY --> SCENARIOS
    SCENARIOS --> TEMPLATE
    TEMPLATE --> CHAT_F
    WIZARD_F --> WIZARD_RESULT
    WIZARD_RESULT --> CHAT_F
    DIRECT --> CHAT_F
```

---

### 4.2 Complete Query Flow

Reference: [Epic 01 M-05](../prd/epics/01-chat-interface.md), [Epic 02 M-02](../prd/epics/02-rag-legal-search.md)

```mermaid
flowchart TD
    INPUT_Q["User enters question"]
    PII{"PII detected?<br>M-14"}
    MASK["Mask PII + show notification:<br>We have automatically removed<br>personal information"]
    CLEAN["Clean query"]

    EMERGENCY_CHECK{"Emergency keyword<br>detected? M-10"}
    SHOW_PANEL["Show Emergency Panel<br>overlay - 1955, legal aid, etc."]
    CONTINUE["Continue processing<br>in parallel"]

    RAG["RAG Pipeline<br>Embed query -> pgvector search<br>-> Retrieve relevant articles"]
    RAG_CHECK{"Similarity >= 0.3?"}
    RAG_OK["Include citations<br>in LLM context"]
    RAG_FAIL["Skip RAG, use general knowledge<br>with low confidence warning"]

    LLM["LLM generates response<br>Claude Sonnet 4.5<br>Streaming output"]
    LLM_FAIL{"LLM timeout > 10s?"}
    FALLBACK["Retry with GPT-4o-mini"]

    RESPONSE["Display layered response<br>L1: Direct answer<br>L2: Explanation<br>L3: Citations<br>L4: Cases<br>L5: Links"]
    ACTION["Display action guide<br>M-06"]
    FEEDBACK_F["Show feedback buttons<br>Helpful / Not Helpful / Report Error"]

    INPUT_Q --> PII
    PII -->|Yes| MASK
    PII -->|No| CLEAN
    MASK --> CLEAN
    CLEAN --> EMERGENCY_CHECK
    EMERGENCY_CHECK -->|Yes| SHOW_PANEL
    EMERGENCY_CHECK -->|No| CONTINUE
    SHOW_PANEL --> CONTINUE
    CONTINUE --> RAG
    RAG --> RAG_CHECK
    RAG_CHECK -->|Yes| RAG_OK
    RAG_CHECK -->|No| RAG_FAIL
    RAG_OK --> LLM
    RAG_FAIL --> LLM
    LLM --> LLM_FAIL
    LLM_FAIL -->|Yes| FALLBACK
    LLM_FAIL -->|No| RESPONSE
    FALLBACK --> RESPONSE
    RESPONSE --> ACTION
    ACTION --> FEEDBACK_F
```

---

### 4.3 Emergency Query Flow

Reference: [Epic 04 M-10](../prd/epics/04-action-guide-emergency.md)

```mermaid
flowchart TD
    QUERY["User query received"]
    DETECT{"Keyword detection"}

    DETECT -->|Time urgency:<br>today, immediately, now| PANEL
    DETECT -->|Dismissal:<br>fired, terminated| PANEL
    DETECT -->|Safety:<br>accident, harassment| PANEL
    DETECT -->|Detention:<br>confiscated passport| PANEL
    DETECT -->|Threats:<br>violence, intimidation| PANEL
    DETECT -->|Self-harm:<br>suicide, don't want to live| CRISIS

    CRISIS["IMMEDIATE: Show crisis resources<br>1925 Suicide Prevention Hotline<br>BEFORE any legal content"]
    PANEL["Show Emergency Panel overlay<br>with relevant resources"]
    DISMISS{"User dismisses panel?"}
    PERSIST["Panel closed but<br>persistent button remains"]
    NORMAL["Normal AI response continues<br>processing underneath"]

    CRISIS --> NORMAL
    PANEL --> DISMISS
    DISMISS -->|Yes| PERSIST
    DISMISS -->|No| NORMAL
    PERSIST --> NORMAL
```

---

### 4.4 Calculator Usage Flow

Reference: [Epic 06 S-03](../prd/epics/06-calculation-tools.md)

```mermaid
flowchart TD
    SELECT["User selects calculator<br>Overtime / Annual Leave / Severance"]
    INPUT_DATA["User enters input data"]
    VALIDATE{"Input validation"}
    WARN["Show warning:<br>e.g. salary below minimum wage,<br>overtime exceeds 46hr/month"]
    BLOCK["Block calculation:<br>e.g. future start date"]
    CALC["Calculate result<br>client-side, no server call"]
    DISPLAY["Display step-by-step breakdown<br>with legal references"]
    USER_ACTION{"User action?"}
    COPY["Copy formatted result"]
    ASK_AI["Navigate to AI Chat<br>with calculator context pre-filled"]
    RESET["Clear all inputs"]

    SELECT --> INPUT_DATA
    INPUT_DATA --> VALIDATE
    VALIDATE -->|Warning| WARN
    VALIDATE -->|Error| BLOCK
    VALIDATE -->|Valid| CALC
    WARN --> CALC
    CALC --> DISPLAY
    DISPLAY --> USER_ACTION
    USER_ACTION -->|Copy Result| COPY
    USER_ACTION -->|Ask AI About This| ASK_AI
    USER_ACTION -->|Reset| RESET
    RESET --> INPUT_DATA
```

---

## 5. Responsive Breakpoints

Reference: [PRD Appendix I.5](../prd/README.md#appendix-i-visual-design-system)

| Breakpoint | Width | Layout | Key Adaptations |
|-----------|:-----:|--------|----------------|
| **Mobile** | < 640px | Single column | Full-width cards, bottom input bar, hamburger menu, large touch targets (48px) |
| **Tablet** | 640-1023px | Single column, wider margins | Side-by-side identity cards, expanded input area |
| **Laptop** | 1024-1279px | Two-column optional | Chat + sidebar (history/calculator), visible navigation |
| **Desktop** | >= 1280px | Two-column | Chat (60%) + sidebar (40%), all navigation visible |

**Mobile-first design priorities** (Reference: [Epic 05 M-11](../prd/epics/05-accessibility-i18n.md)):
- All features fully functional at 375px width
- Touch targets minimum 48x48px on mobile
- Bottom-fixed input bar on chat page
- Collapsible navigation for mobile

---

## 6. Cross-References

| Document | Path | Related Content |
|----------|------|----------------|
| PRD SS7: Information Architecture | [`docs/prd/README.md`](../prd/README.md#7-information-architecture) | Site map, navigation structure |
| PRD Appendix H: Onboarding Strategy | [`docs/prd/README.md`](../prd/README.md#appendix-h-user-onboarding-strategy) | First-time user flow, feature tour |
| PRD Appendix I: Visual Design System | [`docs/prd/README.md`](../prd/README.md#appendix-i-visual-design-system) | Colors, typography, components, breakpoints |
| Epic 01: Chat Interface | [`docs/prd/epics/01-chat-interface.md`](../prd/epics/01-chat-interface.md) | M-01, M-03, M-05, M-14, M-15 wireframes |
| Epic 02: RAG Legal Search | [`docs/prd/epics/02-rag-legal-search.md`](../prd/epics/02-rag-legal-search.md) | M-04 citation display |
| Epic 03: Response Quality | [`docs/prd/epics/03-response-quality.md`](../prd/epics/03-response-quality.md) | M-09 feedback UI |
| Epic 04: Action Guide | [`docs/prd/epics/04-action-guide-emergency.md`](../prd/epics/04-action-guide-emergency.md) | M-06, M-10 wireframes |
| Epic 05: Accessibility | [`docs/prd/epics/05-accessibility-i18n.md`](../prd/epics/05-accessibility-i18n.md) | M-11, M-12 responsive + a11y |
| Epic 06: Calculators | [`docs/prd/epics/06-calculation-tools.md`](../prd/epics/06-calculation-tools.md) | S-03a/b/c calculator wireframes |
| Epic 07: Future Features | [`docs/prd/epics/07-future-features.md`](../prd/epics/07-future-features.md) | C-03~C-07 Phase 3+ features |
| ADR-004: Frontend Framework | [`docs/adr/004-frontend-nextjs.md`](../adr/004-frontend-nextjs.md) | Next.js 15, App Router, responsive design |
| ADR-006: Observability Stack | [`docs/adr/006-observability-stack.md`](../adr/006-observability-stack.md) | Sentry error tracking, performance monitoring |
| ADR-009: Authentication Strategy | [`docs/adr/009-authentication-strategy.md`](../adr/009-authentication-strategy.md) | Anonymous-first, optional OAuth2 |
| UI Text Guide | [`docs/style-guides/ui-text-guide.md`](../style-guides/ui-text-guide.md) | Button labels, error messages, tone |
| Mermaid Flowchart Guide | [`docs/style-guides/mermaid-flowchart-guide.md`](../style-guides/mermaid-flowchart-guide.md) | Diagram conventions |
