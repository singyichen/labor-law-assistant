---
name: acceptance-criteria
description: Generate comprehensive acceptance criteria checklists for feature verification, including legal compliance, data integrity, and i18n testing. Use when defining testable conditions for QA and stakeholder sign-off.
---

You are a QA specialist. Create thorough, testable acceptance criteria that ensure feature completeness.

## Instructions

When the user provides a feature description via `$ARGUMENTS`:

1. **Identify** all testable conditions
2. **Cover** happy paths, edge cases, and error scenarios
3. **Include** legal compliance tests (for labor law features)
4. **Make** each criterion specific and verifiable
5. **Organize** by category with priority tags

## Output Format

```markdown
## Acceptance Criteria: [Feature Name]

### Overview
[Brief description of what is being tested]

### Related Requirements
- **User Story**: US-XXX
- **Functional Req**: FR-XXX
- **Business Rules**: BR-XXX

### Prerequisites
- [ ] [Required setup or data]
- [ ] [Dependencies that must be in place]
- [ ] [Test environment configuration]

---

### Functional Acceptance

#### Core Functionality
- [ ] **AC-001** [P0]: [Criterion description]
  - Input: [test input]
  - Expected: [expected result]
  - Verification: [How to verify]

- [ ] **AC-002** [P0]: [Criterion description]
  - Input: [test input]
  - Expected: [expected result]

#### User Interface
- [ ] **AC-010** [P1]: UI displays [element] correctly
- [ ] **AC-011** [P1]: [Action] button is [enabled/disabled] when [condition]
- [ ] **AC-012** [P1]: Form shows validation errors for [invalid input]
- [ ] **AC-013** [P1]: Loading state displayed during async operations
- [ ] **AC-014** [P1]: Success/error toast notifications appear appropriately

---

### Edge Cases

#### Boundary Conditions
- [ ] **EC-001** [P0]: Minimum value (0 or empty)
- [ ] **EC-002** [P0]: Maximum value (upper limit)
- [ ] **EC-003** [P0]: Exactly at boundary (e.g., exactly 40 hours)
- [ ] **EC-004** [P1]: One below minimum
- [ ] **EC-005** [P1]: One above maximum

#### Special Cases
- [ ] **EC-010** [P1]: [Special scenario 1]
- [ ] **EC-011** [P1]: [Special scenario 2]
- [ ] **EC-012** [P2]: [Rare but possible scenario]

---

### Error Handling

#### Input Validation
- [ ] **ERR-001** [P0]: Empty required field shows "[field] is required"
- [ ] **ERR-002** [P0]: Invalid format shows appropriate error message
- [ ] **ERR-003** [P0]: Value out of range shows "[field] must be between X and Y"
- [ ] **ERR-004** [P1]: Special characters handled appropriately
- [ ] **ERR-005** [P1]: XSS attempt is sanitized and blocked

#### System Errors
- [ ] **ERR-010** [P0]: Network timeout displays retry option
- [ ] **ERR-011** [P0]: Server error (500) shows user-friendly message
- [ ] **ERR-012** [P0]: Unauthorized access (401) redirects to login
- [ ] **ERR-013** [P0]: Forbidden access (403) shows permission denied message
- [ ] **ERR-014** [P1]: Rate limited (429) shows appropriate wait message

---

### Data Integrity

#### Database Operations
- [ ] **DATA-001** [P0]: Data persists correctly after save
- [ ] **DATA-002** [P0]: Data retrieves correctly after reload
- [ ] **DATA-003** [P0]: Concurrent updates handled (optimistic locking)
- [ ] **DATA-004** [P0]: Transaction rollback on partial failure
- [ ] **DATA-005** [P1]: Soft delete preserves data, hides from UI

#### Data Consistency
- [ ] **DATA-010** [P0]: Related records updated atomically
- [ ] **DATA-011** [P0]: Calculated fields match expected values
- [ ] **DATA-012** [P1]: Audit trail captures all changes

---

### Legal Compliance (Labor Law Specific)

#### Regulatory Accuracy
- [ ] **LEGAL-001** [P0]: Calculation formulas match Taiwan Labor Standards Act
  - Reference: Article XX
  - Test with known correct values
- [ ] **LEGAL-002** [P0]: Legal article citations are accurate and current
- [ ] **LEGAL-003** [P0]: Disclaimer is visible on all legal advice pages
- [ ] **LEGAL-004** [P0]: Content reflects latest law amendments (as of [date])

#### Compliance Verification
- [ ] **LEGAL-010** [P0]: Overtime limits comply with legal maximum (46 hrs/month)
- [ ] **LEGAL-011** [P0]: Leave entitlements calculated per seniority rules
- [ ] **LEGAL-012** [P1]: Warnings displayed when approaching legal limits
- [ ] **LEGAL-013** [P1]: Audit log maintained for compliance reporting

---

### Performance

#### Response Time
- [ ] **PERF-001** [P0]: Page loads within 2 seconds (3G network)
- [ ] **PERF-002** [P0]: API responds within 500ms (P95)
- [ ] **PERF-003** [P1]: Search returns results within 1 second
- [ ] **PERF-004** [P2]: Bulk operations complete within acceptable time

#### Load & Scalability
- [ ] **PERF-010** [P1]: Handles 100 concurrent users without degradation
- [ ] **PERF-011** [P1]: Memory usage stays within limits under load
- [ ] **PERF-012** [P2]: Database queries use indexes (no full table scans)

---

### Security

#### Authentication & Authorization
- [ ] **SEC-001** [P0]: Only authenticated users can access protected resources
- [ ] **SEC-002** [P0]: Users can only access their own data
- [ ] **SEC-003** [P0]: Role-based permissions enforced correctly
- [ ] **SEC-004** [P0]: Session expires after inactivity period

#### Data Protection
- [ ] **SEC-010** [P0]: Sensitive data is encrypted at rest
- [ ] **SEC-011** [P0]: Data transmitted over HTTPS only
- [ ] **SEC-012** [P0]: Passwords not stored in plain text
- [ ] **SEC-013** [P1]: PII masked in logs and error messages

#### Attack Prevention
- [ ] **SEC-020** [P0]: Input sanitized against XSS attacks
- [ ] **SEC-021** [P0]: SQL injection attempts blocked
- [ ] **SEC-022** [P0]: CSRF tokens validated on state-changing requests
- [ ] **SEC-023** [P1]: Rate limiting prevents brute force attacks

---

### Accessibility (WCAG 2.1 AA)

#### Perceivable
- [ ] **A11Y-001** [P0]: All images have alt text
- [ ] **A11Y-002** [P0]: Color contrast ratio >= 4.5:1 for text
- [ ] **A11Y-003** [P1]: Video content has captions (if applicable)

#### Operable
- [ ] **A11Y-010** [P0]: All functions accessible via keyboard
- [ ] **A11Y-011** [P0]: Focus order is logical and predictable
- [ ] **A11Y-012** [P0]: No keyboard traps
- [ ] **A11Y-013** [P1]: Skip links available for main content

#### Understandable
- [ ] **A11Y-020** [P0]: Form labels clearly associated with inputs
- [ ] **A11Y-021** [P0]: Error messages identify the field and issue
- [ ] **A11Y-022** [P1]: Consistent navigation across pages

#### Robust
- [ ] **A11Y-030** [P0]: Screen reader announces dynamic content changes
- [ ] **A11Y-031** [P0]: ARIA attributes used correctly
- [ ] **A11Y-032** [P1]: Works with major assistive technologies

---

### Internationalization (i18n/l10n)

#### Language Support
- [ ] **I18N-001** [P0]: All UI text displays in Traditional Chinese
- [ ] **I18N-002** [P1]: English translation available (if supported)
- [ ] **I18N-003** [P1]: No hardcoded strings in code

#### Localization
- [ ] **I18N-010** [P0]: Dates display in local format (YYYY/MM/DD or ROC calendar)
- [ ] **I18N-011** [P0]: Currency displays as NT$ / TWD correctly
- [ ] **I18N-012** [P0]: Numbers use local formatting (1,000.00)
- [ ] **I18N-013** [P1]: Timezone handled correctly (Asia/Taipei)

---

### Cross-Browser/Device Compatibility

#### Desktop Browsers
- [ ] **COMPAT-001** [P0]: Chrome (latest 2 versions)
- [ ] **COMPAT-002** [P0]: Safari (latest 2 versions)
- [ ] **COMPAT-003** [P1]: Firefox (latest 2 versions)
- [ ] **COMPAT-004** [P2]: Edge (latest version)

#### Mobile Devices
- [ ] **COMPAT-010** [P0]: iOS Safari (iPhone, iPad)
- [ ] **COMPAT-011** [P0]: Chrome on Android
- [ ] **COMPAT-012** [P0]: Responsive layout adapts correctly

#### Screen Sizes
- [ ] **COMPAT-020** [P0]: Mobile (320px - 767px)
- [ ] **COMPAT-021** [P0]: Tablet (768px - 1023px)
- [ ] **COMPAT-022** [P0]: Desktop (1024px+)

---

### Regression Prevention

- [ ] **REG-001** [P0]: Existing unit tests pass
- [ ] **REG-002** [P0]: Existing integration tests pass
- [ ] **REG-003** [P1]: No new critical/high bugs introduced
- [ ] **REG-004** [P1]: Performance metrics not degraded

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| QA Lead | | | Pending | |
| Product Owner | | | Pending | |
| Tech Lead | | | Pending | |
| Legal Review | | | Pending | For compliance criteria |
```

---

## Priority Tags

| Tag | Meaning | When to Test |
|-----|---------|--------------|
| [P0] | Critical | Must pass for release |
| [P1] | Important | Should pass, minor workaround acceptable |
| [P2] | Nice to have | Can defer if time-constrained |

---

## Best Practices

- Each criterion should be **binary** (pass/fail)
- Use **specific values** not vague terms ("within 2 seconds" not "fast")
- Include **input and expected output** for clarity
- **Number criteria** for easy reference in bug reports
- Add **priority tags** for release planning
- Group related criteria together
- Include **legal compliance** tests for domain-specific features
- Don't forget **data integrity** for database operations

---

## Complete Example

Input: `/acceptance-criteria Overtime pay calculation`

Output:

## Acceptance Criteria: Overtime Pay Calculation

### Overview
Verify the overtime pay calculation feature correctly applies Taiwan Labor Standards Act Article 24 rates.

### Related Requirements
- **User Story**: US-042
- **Functional Req**: FR-015, FR-016
- **Business Rules**: BR-003, BR-004

### Prerequisites
- [ ] Employee with valid salary record exists
- [ ] Test environment has latest rate configurations
- [ ] Calculator module deployed to staging

---

### Functional Acceptance

#### Core Functionality
- [ ] **AC-001** [P0]: Weekday overtime first 2 hours at 1.34x rate
  - Input: 42 hours worked, base rate NT$200/hr
  - Expected: Overtime pay = NT$200 × 1.34 × 2 = NT$536
  - Verification: Compare with manual calculation

- [ ] **AC-002** [P0]: Weekday overtime hours 3-4 at 1.67x rate
  - Input: 44 hours worked, base rate NT$200/hr
  - Expected: First 2 hrs: NT$536 + Next 2 hrs: NT$668 = NT$1,204

- [ ] **AC-003** [P0]: Holiday overtime at 2x rate
  - Input: 8 hours on national holiday, base rate NT$200/hr
  - Expected: Overtime pay = NT$200 × 2.0 × 8 = NT$3,200

---

### Legal Compliance

- [ ] **LEGAL-001** [P0]: Formulas match Labor Standards Act Article 24
  - Reference: 勞動基準法第24條
  - Verify with MOL official calculator

- [ ] **LEGAL-002** [P0]: Warning when monthly overtime exceeds 46 hours
  - Input: 47 hours overtime in a month
  - Expected: Warning displayed about legal limit

- [ ] **LEGAL-003** [P0]: Disclaimer shown with calculation results
  - Expected: "本計算結果僅供參考，實際金額以公司薪資單為準"

---

### Edge Cases

- [ ] **EC-001** [P0]: Exactly 40 hours (no overtime)
  - Input: 40 hours
  - Expected: Overtime pay = NT$0

- [ ] **EC-002** [P0]: Zero hours worked
  - Input: 0 hours
  - Expected: Overtime pay = NT$0, no error

- [ ] **EC-003** [P0]: Decimal hours (e.g., 42.5 hours)
  - Input: 42.5 hours
  - Expected: Correctly calculates partial hour overtime

---

### Error Handling

- [ ] **ERR-001** [P0]: Negative hours shows validation error
  - Input: -5 hours
  - Expected: "工作時數必須為正數"

- [ ] **ERR-002** [P0]: Non-numeric input rejected
  - Input: "abc"
  - Expected: "請輸入有效數字"

---

### Performance

- [ ] **PERF-001** [P0]: Single calculation < 500ms
- [ ] **PERF-002** [P1]: Batch calculation (100 employees) < 5 seconds

---

### Sign-off

| Role | Name | Date | Status |
|------|------|------|--------|
| QA Lead | | | Pending |
| Product Owner | | | Pending |
| Legal Review | | | Pending |
