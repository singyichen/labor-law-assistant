# Epic 06: Calculation Tools

## Overview

Practical calculation tools that provide immediate, tangible value to users. This epic covers the overtime pay calculator, annual leave calculator, and severance pay calculator. These tools complement the AI Q&A by providing exact numerical results that users can verify and act upon.

## Feature List

| Feature ID | Name | Priority | Description |
|---|---|---|---|
| S-03 | Calculation Tools | Should Have | Overtime pay, annual leave, and severance pay calculators |

---

## Scope (Should Have)

### S-03: Calculation Tools

**User Story**
> As a worker, I want to calculate my exact overtime pay, annual leave days, and severance pay amounts, so that I can verify what my employer owes me with concrete numbers.

---

### S-03a: Overtime Pay Calculator

**User Story**
> As a worker, I want to input my monthly salary and overtime hours, so that I can see exactly how much overtime pay I should receive.

**Acceptance Criteria**
- [ ] Input fields: monthly salary, overtime hours (weekday), overtime hours (rest day), overtime hours (national holiday)
- [ ] Calculate hourly rate from monthly salary (monthly salary / 30 / 8)
- [ ] Apply correct multipliers per Labor Standards Act Article 24:
  - Weekday: first 2 hours at 1.34x, hours 3-4 at 1.67x
  - Rest day: first 2 hours at 1.34x, hours 3-8 at 1.67x, hours 9-12 at 2.67x
  - National holiday: 1x additional + multipliers for hours worked
- [ ] Display calculation breakdown step-by-step (not just the final number)
- [ ] Show the legal basis (article number + relevant text) alongside each calculation step
- [ ] Results formatted as currency (NT$) with thousand separators
- [ ] "Copy result" button for sharing
- [ ] "Ask AI about this" button to continue into chat with calculator context
- [ ] Input validation: salary must be >= minimum wage, hours must be reasonable (0-100)
- [ ] Handle edge cases: part-time workers, variable-hour contracts
- [ ] Show disclaimer: "This calculation assumes standard employment. Special industries may have different rules."

**UI Mockup**
```
+---------------------------------------------+
| Overtime Pay Calculator                      |
+---------------------------------------------+
|                                              |
| Monthly Salary: [NT$ 30,000      ]           |
|                                              |
| Weekday Overtime:                            |
| First 2 hours:  [4  ] hours this month      |
| Hours 3-4:      [2  ] hours this month      |
|                                              |
| Rest Day Overtime:                           |
| Hours worked:   [8  ] hours this month       |
|                                              |
| [Calculate]                                  |
|                                              |
| === Results ===                              |
|                                              |
| Hourly rate: NT$ 125                         |
| (30,000 / 30 / 8 = 125)                     |
|                                              |
| Weekday overtime (first 2hr):                |
|   125 x 1.34 x 4 = NT$ 670                  |
|   (LSA Art. 24, Para. 1)                     |
|                                              |
| Weekday overtime (hr 3-4):                   |
|   125 x 1.67 x 2 = NT$ 418                  |
|   (LSA Art. 24, Para. 1)                     |
|                                              |
| Rest day overtime:                           |
|   125 x 1.34 x 2 = NT$ 335                  |
|   125 x 1.67 x 6 = NT$ 1,253               |
|   (LSA Art. 24, Para. 2)                     |
|                                              |
| TOTAL: NT$ 2,676                             |
|                                              |
| [Copy Result] [Ask AI About This]            |
+---------------------------------------------+
```

---

### S-03b: Annual Leave Calculator

**User Story**
> As a worker, I want to input my years of service, so that I can see exactly how many annual leave days I'm entitled to.

**Acceptance Criteria**
- [ ] Input fields: employment start date (or years of service)
- [ ] Calculate annual leave days per Labor Standards Act Article 38:
  - 6 months to 1 year: 3 days
  - 1-2 years: 7 days
  - 2-3 years: 10 days
  - 3-5 years: 14 days each year
  - 5-10 years: 15 days each year
  - 10+ years: 15 days + 1 day per additional year (max 30)
- [ ] Show calculation basis and legal reference
- [ ] Display in a visual timeline if possible (years of service -> leave days progression)
- [ ] Handle partial-year scenarios (pro-rated leave for year-based calculation)
- [ ] Option to choose calculation method: anniversary year vs. calendar year
- [ ] Show unused leave compensation: daily wage x unused days
- [ ] Show disclaimer about special leave types not covered (sick leave, marriage leave, etc.)

---

### S-03c: Severance Pay Calculator

**User Story**
> As a worker who has been laid off, I want to calculate my severance pay based on my salary and years of service, so that I can verify I receive the correct amount.

**Acceptance Criteria**
- [ ] Input fields: average monthly salary (last 6 months), employment start date, termination date, pension system (old/new)
- [ ] Calculate based on applicable system:
  - New system (Labor Pension Act): 0.5 months' average salary per year of service
  - Old system (Labor Standards Act): 1 month's average salary per year of service
  - Mixed: calculate proportionally based on transition date
- [ ] Display calculation breakdown with legal references
- [ ] Handle partial-year service (pro-rated)
- [ ] Include information about pension account balance (new system)
- [ ] Show maximum severance cap if applicable
- [ ] Explain difference between voluntary resignation (no severance) and involuntary termination
- [ ] Show conditions under which severance is required (Art. 11, 13, 14, 20 of LSA)
- [ ] "What if my employer refuses to pay?" action link -> Chat with AI

---

## Shared Requirements (All Calculators)

- [ ] All calculators are accessible without login
- [ ] All calculators meet WCAG 2.1 AA accessibility standards
- [ ] All calculations are performed client-side (privacy: no server data sent for basic calculations)
- [ ] All calculators show relevant legal articles alongside results
- [ ] All results are shareable (generate a link or copy formatted text)
- [ ] All calculators work offline after initial page load (PWA)
- [ ] All input fields have proper input validation with helpful error messages
- [ ] All calculators have a "Reset" button to clear inputs
- [ ] Mobile-responsive design with large touch targets
- [ ] Calculator inputs and results are NOT stored server-side (privacy)

---

## Technical Dependencies

| Dependency | Component | Notes |
|------------|-----------|-------|
| Next.js 15 | Frontend | Calculator pages with App Router |
| React Hook Form / Zod | Frontend | Form validation for calculator inputs |
| shadcn/ui | Frontend | UI components (input, button, card) |
| Tailwind CSS | Frontend | Responsive styling |
| date-fns | Frontend | Date calculations (years of service, etc.) |
| Intl.NumberFormat | Browser API | Currency formatting (NT$) |

## Related ADRs

- [ADR-004: Next.js as Frontend](../../adr/004-frontend-nextjs.md) - Frontend framework for calculator pages
- [ADR-009: Authentication Strategy](../../adr/009-authentication-strategy.md) - Calculators work without login (anonymous)
