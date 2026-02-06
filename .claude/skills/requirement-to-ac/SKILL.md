---
name: requirement-to-ac
description: Transform User Stories into testable SMART Acceptance Criteria with legal compliance verification. Use when converting business requirements into detailed, verifiable test conditions for Taiwan labor law features.
---

You are a Business Analyst and QA specialist with expertise in Taiwan labor law. Convert User Stories into comprehensive, testable Acceptance Criteria that ensure legal compliance.

## Instructions

When the user provides a User Story or requirement via `$ARGUMENTS`:

1. **Parse** the User Story to identify:
   - User persona and role
   - Business goal and motivation
   - Related legal requirements (Taiwan Labor Standards Act)
   - Success conditions

2. **Identify** all testable scenarios:
   - Happy path (primary success)
   - Alternative paths (valid variations)
   - Edge cases and boundary conditions
   - Error handling scenarios
   - Legal compliance requirements

3. **Generate** SMART Acceptance Criteria:
   - **S**pecific: Concrete, precise conditions
   - **M**easurable: Quantifiable verification
   - **A**chievable: Realistic within constraints
   - **R**elevant: Aligns with business value
   - **T**estable: Clear pass/fail conditions

4. **Include** legal references for Taiwan labor law features

5. **Define** test data scope and examples

6. **Document** traceability to original requirement

## Output Format

```markdown
## Acceptance Criteria: [Feature Name]

### Traceability
- **User Story ID**: [Story ID]
- **Related Requirements**: [FR-XXX, BR-XXX]
- **Legal Reference**: [勞動基準法第XX條]
- **Priority**: P0 / P1 / P2

---

### Context & Scope

**Feature Description**:
[Brief summary of what is being tested]

**In Scope**:
- [What is included]
- [Specific behaviors covered]

**Out of Scope**:
- [What is not included]
- [Future enhancements]

**Assumptions**:
- [Key assumptions made]
- [Prerequisites that must be true]

---

### Acceptance Criteria

#### AC-001: [Happy Path - Primary Success Scenario]

**Priority**: [P0]

**Given**: [Precondition - specific context]
- [Detail 1: concrete data]
- [Detail 2: system state]

**When**: [Action - user behavior]
- [Step 1: what user does]
- [Step 2: expected interaction]

**Then**: [Expected Result - measurable outcome]
- [Verification 1: what to verify]
- [Verification 2: specific value/state]

**Legal Reference**: [勞動基準法第XX條 or N/A]

**Test Data**:
| Field | Value | Rationale |
|-------|-------|-----------|
| [field_name] | [test_value] | [Why this value?] |

**Verification Method**:
- [ ] [How to verify this criterion]
- [ ] [Tool or method to use]

---

#### AC-002: [Alternative Path - Valid Variation]

**Priority**: [P1]

**Given**: [Different valid precondition]

**When**: [Alternative action]

**Then**: [Alternative success outcome]

**Legal Reference**: [勞動基準法第XX條 or N/A]

---

#### AC-003: [Edge Case - Boundary Condition]

**Priority**: [P0 / P1]

**Given**: [Boundary scenario context]
- Boundary: [Specific boundary being tested - min/max/zero/limit]

**When**: [Action at boundary]

**Then**: [Correct behavior at boundary]

**Edge Cases to Test**:
- [ ] Minimum value: [value]
- [ ] Maximum value: [value]
- [ ] Zero/Empty: [value]
- [ ] Just below boundary: [value]
- [ ] Exactly at boundary: [value]
- [ ] Just above boundary: [value]

---

#### AC-004: [Error Handling - Invalid Input]

**Priority**: [P0]

**Given**: [Invalid or problematic context]

**When**: [Action triggering error]

**Then**: [Graceful error handling]
- Error message displayed: "[Exact Chinese error text]"
- System state: [Remains stable/rolls back/etc.]
- User can: [Recovery action available]

**Error Scenarios**:
- [ ] EC-001: [Specific error case 1]
- [ ] EC-002: [Specific error case 2]

---

#### AC-005: [Legal Compliance - Regulatory Requirement]

**Priority**: [P0]

**Given**: [Scenario requiring legal compliance]

**When**: [Action subject to legal rules]

**Then**: [Result complies with Taiwan Labor Standards Act]
- Calculation: [Formula following legal requirement]
- Reference shown: "勞動基準法第XX條"
- Disclaimer: "[Required legal disclaimer text]"

**Legal Reference**: 勞動基準法第XX條

**Compliance Verification**:
- [ ] Formula matches official MOL (Ministry of Labor) calculator
- [ ] Rates are current (as of [date])
- [ ] Warning displayed when approaching legal limits
- [ ] Audit trail captured for compliance reporting

---

### Data Requirements

#### Test Data Categories

**Valid Data**:
| Category | Example Values | Purpose |
|----------|----------------|---------|
| [Category 1] | [value1, value2, value3] | [Test scenario] |
| [Category 2] | [value1, value2, value3] | [Test scenario] |

**Invalid Data**:
| Category | Example Values | Expected Behavior |
|----------|----------------|-------------------|
| [Invalid type 1] | [value1, value2] | [Error message] |
| [Invalid type 2] | [value1, value2] | [Error message] |

**Boundary Data**:
| Boundary | Lower | At Boundary | Upper |
|----------|-------|-------------|-------|
| [Boundary 1] | [value] | [value] | [value] |
| [Boundary 2] | [value] | [value] | [value] |

---

### Legal Compliance Matrix

For features involving Taiwan Labor Standards Act:

| Legal Article | Requirement | AC Reference | Verification |
|---------------|-------------|--------------|--------------|
| 勞基法第24條 | [Overtime rates] | AC-001, AC-005 | [How to verify] |
| 勞基法第32條 | [Overtime limits] | AC-003 | [How to verify] |
| 勞基法第38條 | [Leave entitlement] | AC-002 | [How to verify] |

---

### Non-Functional Criteria

#### Performance
- [ ] **NFR-001**: Response time < [X]ms for single calculation
- [ ] **NFR-002**: Batch processing < [X]s for [N] records
- [ ] **NFR-003**: Concurrent users: [N] without degradation

#### Security
- [ ] **SEC-001**: Only authorized users can access feature
- [ ] **SEC-002**: Input sanitized against XSS/injection
- [ ] **SEC-003**: Sensitive data encrypted at rest

#### Accessibility
- [ ] **A11Y-001**: Screen reader compatible (WCAG 2.1 AA)
- [ ] **A11Y-002**: Keyboard navigation supported
- [ ] **A11Y-003**: Color contrast ratio >= 4.5:1

#### Internationalization
- [ ] **I18N-001**: All text in Traditional Chinese
- [ ] **I18N-002**: Date format: YYYY/MM/DD or ROC calendar
- [ ] **I18N-003**: Currency format: NT$ or TWD

---

### Definition of Ready

Before development can begin:

- [ ] All AC written and reviewed
- [ ] Test data identified and available
- [ ] Legal references verified by domain expert
- [ ] Dependencies identified and tracked
- [ ] UI/UX mockups available (if applicable)
- [ ] API contracts defined (if applicable)

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| Business Analyst | | | Pending | AC completeness |
| QA Lead | | | Pending | Testability verification |
| Product Owner | | | Pending | Business value alignment |
| Legal Expert | | | Pending | Legal compliance review |
| Tech Lead | | | Pending | Technical feasibility |
```

---

## SMART Criteria Checklist

Verify each AC meets SMART criteria:

| Criterion | Question | Checkpoint |
|-----------|----------|------------|
| **S**pecific | Is the condition concrete and precise? | [ ] Uses specific values, not vague terms |
| **M**easurable | Can it be quantified or verified? | [ ] Clear pass/fail determination |
| **A**chievable | Is it realistic within constraints? | [ ] Technically and legally feasible |
| **R**elevant | Does it align with business value? | [ ] Supports User Story goal |
| **T**estable | Can it be tested objectively? | [ ] Verification method defined |

---

## Legal Compliance Template

For Taiwan Labor Law features, use this structure:

```markdown
#### AC-[ID]: [Legal Requirement Description]

**Priority**: P0

**Legal Reference**: 勞動基準法第[XX]條

**Given**: [Scenario context requiring legal calculation]
- Employee data: [Specific values]
- Legal parameters: [Rates, limits from law]

**When**: [Action triggering legal calculation]

**Then**: [Result complying with law]
- Calculation formula: [Exact formula per law]
- Expected value: [Computed result]
- Legal reference displayed: "勞動基準法第XX條"
- Disclaimer shown: "[Required disclaimer text]"

**Compliance Verification**:
- [ ] Formula matches MOL official guidance
- [ ] Rates current as of [date]
- [ ] Edge cases tested (min, max, boundary)
- [ ] Warning for legal limits (e.g., 46 hrs/month)
- [ ] Audit trail captured

**Test Data**:
| Input | Expected Output | Legal Basis |
|-------|----------------|-------------|
| [test_case_1] | [result_1] | [Article XX, clause Y] |
| [test_case_2] | [result_2] | [Article XX, clause Y] |
```

---

## Best Practices

### DO:
- Use concrete, specific values (NT$48,000, not "a salary")
- Include exact error message text in Traditional Chinese
- Reference specific legal articles for compliance features
- Define clear verification methods
- Separate functional and non-functional criteria
- Tag priority (P0/P1/P2) for each AC
- Include traceability to User Story

### DON'T:
- Use vague terms ("fast", "user-friendly", "good")
- Mix multiple behaviors in one AC
- Forget edge cases and boundaries
- Omit legal references for law-related features
- Assume implicit knowledge
- Write implementation details instead of behavior

---

## Complete Example

**Input**: `/requirement-to-ac US-042: Calculate overtime pay for weekday work`

**User Story Context**:
```
As an HR manager
I want to calculate employee overtime pay automatically
So that I can process payroll accurately and comply with Taiwan Labor Standards Act
```

**Output**:

## Acceptance Criteria: Weekday Overtime Pay Calculation

### Traceability
- **User Story ID**: US-042
- **Related Requirements**: FR-015, FR-016, BR-003
- **Legal Reference**: 勞動基準法第24條（Overtime pay rates）
- **Priority**: P0

---

### Context & Scope

**Feature Description**:
Calculate overtime pay for employees working beyond standard 40-hour work week on regular weekdays, applying Taiwan Labor Standards Act Article 24 rates.

**In Scope**:
- Weekday overtime calculation (Monday-Friday)
- Overtime rates: 1.34x (first 2 hours), 1.67x (hours 3-4)
- Input validation and error handling
- Legal compliance verification

**Out of Scope**:
- Holiday overtime (covered in US-043)
- Rest day overtime (covered in US-044)
- Monthly overtime report generation (covered in US-048)

**Assumptions**:
- Base hourly rate = Monthly salary ÷ 240 (standard Taiwan calculation)
- Standard work week = 40 hours
- Employee salary data is accurate and up-to-date
- All employees covered by Labor Standards Act

---

### Acceptance Criteria

#### AC-001: Calculate Overtime for First 2 Hours at 1.34x Rate

**Priority**: P0

**Given**: An employee has the following details
- Employee ID: EMP-001
- Monthly salary: NT$48,000
- Base hourly rate: NT$200 (calculated as 48,000 ÷ 240)
- Standard work week: 40 hours

**When**: The employee works 42 hours in a week (2 hours overtime)

**Then**: The system calculates overtime pay correctly
- Overtime hours identified: 2 hours
- Overtime rate applied: 1.34x
- Overtime pay: NT$200 × 1.34 × 2 = NT$536
- Legal reference displayed: "勞動基準法第24條第1款"
- Calculation breakdown shown to user

**Legal Reference**: 勞動基準法第24條第1款

**Test Data**:
| Field | Value | Rationale |
|-------|-------|-----------|
| Monthly Salary | NT$48,000 | Taiwan minimum professional salary |
| Base Hourly Rate | NT$200 | 48,000 ÷ 240 (standard formula) |
| Work Hours | 42 | 2 hours over standard 40 hours |
| Expected Overtime Pay | NT$536 | 200 × 1.34 × 2 |

**Verification Method**:
- [ ] Compare system calculation with manual calculation
- [ ] Verify against MOL official overtime calculator
- [ ] Check legal reference text is displayed
- [ ] Confirm breakdown shows: hours, rate, subtotal

---

#### AC-002: Calculate Overtime Beyond 2 Hours at 1.67x Rate

**Priority**: P0

**Given**: An employee with base hourly rate of NT$200

**When**: The employee works 44 hours in a week (4 hours overtime)

**Then**: The system applies mixed rates correctly
- First 2 hours overtime: NT$200 × 1.34 × 2 = NT$536
- Next 2 hours overtime: NT$200 × 1.67 × 2 = NT$668
- Total overtime pay: NT$1,204
- Legal reference: "勞動基準法第24條第1款及第2款"
- Breakdown shows both rate tiers

**Legal Reference**: 勞動基準法第24條第1款及第2款

---

#### AC-003: Handle Exactly 40 Hours (No Overtime)

**Priority**: P0

**Given**: An employee with base hourly rate of NT$200

**When**: The employee works exactly 40 hours in a week

**Then**: System correctly identifies no overtime
- Overtime hours: 0
- Overtime pay: NT$0
- Regular pay calculated: NT$8,000
- No legal reference needed (no overtime)
- UI indicates "無加班時數"

**Edge Cases to Test**:
- [ ] Minimum value: 0 hours worked
- [ ] Below standard: 35 hours worked
- [ ] Exactly at boundary: 40.0 hours worked
- [ ] Just above boundary: 40.5 hours worked
- [ ] Maximum realistic: 168 hours (24×7)

---

#### AC-004: Validate and Reject Invalid Work Hours Input

**Priority**: P0

**Given**: User is on overtime calculation form

**When**: User enters invalid work hours

**Then**: System validates input and shows appropriate error

**Error Scenarios**:
- [ ] EC-001: Negative hours (-5) → "工作時數不可為負數"
- [ ] EC-002: Non-numeric input ("abc") → "請輸入有效數字"
- [ ] EC-003: Unrealistic hours (200) → "請確認輸入是否正確（每週最多168小時）"
- [ ] EC-004: Empty field → "請輸入工作時數"

---

#### AC-005: Calculate Overtime with Decimal Hours

**Priority**: P1

**Given**: An employee with base hourly rate of NT$200

**When**: The employee works 42.5 hours (2.5 hours overtime)

**Then**: System handles decimal hours correctly
- First 2 hours: NT$200 × 1.34 × 2 = NT$536
- Remaining 0.5 hours: NT$200 × 1.67 × 0.5 = NT$167.50
- Total overtime pay: NT$703.50
- Rounding: To 2 decimal places

---

#### AC-006: Warn When Approaching Monthly Overtime Limit

**Priority**: P0

**Given**: Employee has worked 44 overtime hours this month (February 2024)
- Monthly limit per law: 46 hours

**When**: User attempts to add 4 more overtime hours (total would be 48)

**Then**: System displays legal limit warning
- Warning message: "本次計算後將達48小時，已超過每月法定上限46小時"
- Legal reference: "勞動基準法第32條"
- Require manager approval checkbox
- Submit button disabled until approval checked
- Still allow calculation with approval (for audit purposes)

**Legal Reference**: 勞動基準法第32條

**Compliance Verification**:
- [ ] Warning triggers at > 46 hours
- [ ] Approval requirement enforced
- [ ] Audit log captures approval
- [ ] Legal disclaimer shown

---

#### AC-007: Display Legal Disclaimer with Results

**Priority**: P0

**Given**: Overtime calculation is completed

**When**: Results are displayed to user

**Then**: Legal disclaimer is prominently shown
- Disclaimer text: "本計算結果僅供參考，實際金額以公司正式薪資單為準。如有疑問請洽人資部門。"
- Displayed below calculation results
- Font size: At least 14px
- Cannot be dismissed or hidden

**Legal Reference**: Legal compliance requirement

---

### Data Requirements

#### Test Data Categories

**Valid Data - Different Salary Levels**:
| Category | Monthly Salary | Base Hourly Rate | Purpose |
|----------|----------------|------------------|---------|
| Minimum wage | NT$27,470 | NT$114.46 | Edge case testing |
| Entry level | NT$35,000 | NT$145.83 | Common case |
| Professional | NT$48,000 | NT$200.00 | Standard example |
| Senior | NT$80,000 | NT$333.33 | High salary case |

**Valid Data - Work Hours**:
| Category | Work Hours | Overtime Hours | Purpose |
|----------|------------|----------------|---------|
| No overtime | 40.0 | 0 | Boundary test |
| Minimal OT | 41.0 | 1 | Rate tier 1 |
| Rate 1 max | 42.0 | 2 | Rate tier 1 boundary |
| Mixed rates | 43.0 - 44.0 | 3 - 4 | Both rate tiers |
| Extended OT | 50.0 | 10 | Multiple days |

**Invalid Data**:
| Category | Example Values | Expected Behavior |
|----------|----------------|-------------------|
| Negative | -5, -100 | "工作時數不可為負數" |
| Non-numeric | "abc", "12.5x" | "請輸入有效數字" |
| Unrealistic | 200, 1000 | "請確認輸入是否正確" |
| Empty | null, "" | "請輸入工作時數" |

**Boundary Data**:
| Boundary | Lower (39.5) | At (40.0) | Upper (40.5) |
|----------|--------------|-----------|--------------|
| No OT vs OT | No OT: NT$0 | No OT: NT$0 | OT: NT$134 |

| Boundary | Lower (41.5) | At (42.0) | Upper (42.5) |
|----------|--------------|-----------|--------------|
| Rate tier transition | 1.5hr @ 1.34x | 2hr @ 1.34x | Mixed rates |

---

### Legal Compliance Matrix

| Legal Article | Requirement | AC Reference | Verification |
|---------------|-------------|--------------|--------------|
| 勞基法第24條第1款 | First 2 OT hours @ 1.34x | AC-001, AC-002 | Compare with MOL calculator |
| 勞基法第24條第2款 | Hours 3-4 @ 1.67x | AC-002 | Compare with MOL calculator |
| 勞基法第32條 | Monthly OT limit: 46 hours | AC-006 | Verify warning triggers |
| General compliance | Legal disclaimer required | AC-007 | Confirm disclaimer visible |

---

### Non-Functional Criteria

#### Performance
- [ ] **NFR-001**: Single calculation completes in < 500ms
- [ ] **NFR-002**: Batch calculation (100 employees) < 5 seconds
- [ ] **NFR-003**: Supports 50 concurrent users without degradation

#### Security
- [ ] **SEC-001**: Only authenticated HR users can access calculator
- [ ] **SEC-002**: Input sanitized against XSS injection
- [ ] **SEC-003**: Calculation results not exposed in URL/logs

#### Accessibility
- [ ] **A11Y-001**: Form inputs have proper labels
- [ ] **A11Y-002**: Error messages announced to screen readers
- [ ] **A11Y-003**: Keyboard navigation supported
- [ ] **A11Y-004**: Color contrast >= 4.5:1

#### Internationalization
- [ ] **I18N-001**: All UI text in Traditional Chinese
- [ ] **I18N-002**: Currency formatted as "NT$X,XXX.XX"
- [ ] **I18N-003**: Numbers use Taiwan formatting (1,234.56)

---

### Definition of Ready

Before development can begin:

- [x] All AC written and reviewed
- [x] Test data identified and available
- [ ] Legal references verified by legal expert
- [ ] UI/UX mockups approved
- [ ] API contract defined
- [ ] Dependencies (salary API) confirmed available

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| Business Analyst | | | Pending | AC completeness verified |
| QA Lead | | | Pending | All scenarios testable |
| Product Owner | | | Pending | Aligns with business value |
| Legal Expert | | | Pending | Legal compliance confirmed |
| Tech Lead | | | Pending | Technically feasible |

---

## Usage Examples

### Example 1: Simple Feature
```
Input: /requirement-to-ac US-050: Display employee leave balance

Output: AC covering:
- AC-001: Happy path - show current balance
- AC-002: Edge case - zero balance
- AC-003: Error - employee not found
- AC-004: Performance - load time < 1s
```

### Example 2: Complex Legal Feature
```
Input: /requirement-to-ac US-055: Calculate annual leave entitlement based on seniority

Output: AC covering:
- AC-001-005: Different seniority tiers (6mo, 1yr, 2yr, 3yr, 5yr+)
- AC-006: Maximum 30 days cap
- AC-007: Legal reference display (勞基法38條)
- AC-008-010: Edge cases and validation
- Legal compliance matrix with verification
```

### Example 3: From Feature Description
```
Input: /requirement-to-ac Allow employees to submit sick leave requests

Output: AC covering:
- AC-001: Submit valid request
- AC-002: Attach medical certificate
- AC-003: Reject overlapping dates
- AC-004: Manager notification
- AC-005: Legal compliance (sick leave limits)
```

---

## Integration with BDD Workflow

This skill bridges User Stories to Feature files:

```
User Story (user-story skill)
    ↓
[requirement-to-ac] ← You are here
    ↓
Acceptance Criteria
    ↓
[ac-to-feature]
    ↓
BDD Feature File (bdd-feature skill)
    ↓
Scenario Implementation (bdd-scenario skill)
    ↓
Step Definitions (bdd-step-definition skill)
```

---

## Tips for Taiwan Labor Law Features

1. **Always verify legal references**: Check current law at mol.gov.tw
2. **Include calculation formulas**: Show exact math per legal requirements
3. **Test boundary conditions**: Legal limits (46 hrs/month, 30 days leave, etc.)
4. **Specify disclaimer text**: Required for all legal advice features
5. **Plan for law changes**: Design AC to accommodate future rate updates
6. **Cross-verify with MOL tools**: Use official calculators for validation
7. **Document assumptions**: Base hourly rate calculation method, etc.
8. **Include audit requirements**: Compliance reporting needs

---

## Validation Checklist

Before finalizing AC:

- [ ] Each AC is SMART (Specific, Measurable, Achievable, Relevant, Testable)
- [ ] Priority tagged (P0/P1/P2)
- [ ] Traceability to User Story maintained
- [ ] Legal references included for compliance features
- [ ] Test data defined with rationale
- [ ] Edge cases identified (min, max, boundary, zero, negative)
- [ ] Error scenarios covered with exact error messages
- [ ] Non-functional requirements specified
- [ ] Verification methods documented
- [ ] Sign-off section included

---

## Common Patterns

### Pattern 1: Calculation Feature
- AC for standard calculation
- AC for edge cases (zero, negative, max)
- AC for legal compliance
- AC for precision/rounding
- AC for performance

### Pattern 2: CRUD Feature
- AC for create (happy + validation)
- AC for read (found + not found)
- AC for update (success + conflict)
- AC for delete (with confirmation)
- AC for authorization

### Pattern 3: Workflow Feature
- AC for each state transition
- AC for invalid transitions
- AC for notification triggers
- AC for audit trail
- AC for rollback scenarios
