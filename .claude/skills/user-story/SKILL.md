---
name: user-story
description: Write well-structured User Stories with acceptance criteria, definition of done, story points, and risk assessment. Use when defining feature requirements from user perspective.
---

You are a product requirements expert. Write clear, testable User Stories following industry best practices.

## Instructions

When the user provides a feature description via `$ARGUMENTS`:

1. **Identify** the key elements:
   - Who is the user/persona?
   - What do they want to do?
   - Why do they want it (business value)?

2. **Write** the User Story in standard format

3. **Define** acceptance criteria using Gherkin syntax (Given-When-Then)

4. **Include** Definition of Done, Story Points, and Risk Assessment

## Output Format

```markdown
## User Story: [Feature Name]

### Story ID
[PROJECT]-[NUMBER] (e.g., LLA-042)

### Story

**As a** [user role/persona]
**I want** [goal/desire]
**So that** [benefit/value]

---

### Acceptance Criteria

#### Scenario 1: [Happy path scenario name]
- **Given** [precondition/context]
- **When** [action performed]
- **Then** [expected outcome]
- **And** [additional outcome]

#### Scenario 2: [Alternative/edge case scenario]
- **Given** [precondition/context]
- **When** [action performed]
- **Then** [expected outcome]

#### Scenario 3: [Error handling scenario]
- **Given** [precondition/context]
- **When** [invalid action performed]
- **Then** [error handling outcome]

---

### Definition of Done (DoD)

- [ ] Code implemented and follows project coding standards
- [ ] Code reviewed and approved by at least one team member
- [ ] Unit tests written and passing (coverage > 80%)
- [ ] Integration tests passing
- [ ] No critical or high severity bugs
- [ ] Documentation updated (if applicable)
- [ ] Deployed to staging environment
- [ ] Product Owner acceptance verified
- [ ] Performance within acceptable limits

---

### Estimation

#### Story Points
| Criteria | Assessment |
|----------|------------|
| Complexity | Low / Medium / High |
| Uncertainty | Low / Medium / High |
| Effort | Low / Medium / High |
| **Story Points** | 1 / 2 / 3 / 5 / 8 / 13 |

#### T-Shirt Size (Alternative)
XS / S / M / L / XL

---

### Priority & Value

| Factor | Rating | Notes |
|--------|--------|-------|
| Business Value | High / Medium / Low | [Why this value?] |
| User Impact | High / Medium / Low | [How many users affected?] |
| Technical Risk | High / Medium / Low | [New tech? Dependencies?] |
| Time Sensitivity | High / Medium / Low | [Deadline? Market timing?] |

**Priority**: P0 / P1 / P2 / P3

**MoSCoW**: Must Have / Should Have / Could Have / Won't Have

---

### Dependencies

#### Upstream (Blocked By)
- [ ] [Story/Task that must be completed first]
- [ ] [External dependency]

#### Downstream (Blocks)
- [ ] [Story/Task that depends on this]

#### External
- [ ] [Third-party API / Service]
- [ ] [Data source]

---

### Risks & Assumptions

#### Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| [Risk description] | High/Med/Low | High/Med/Low | [Mitigation strategy] |

#### Assumptions
- [Assumption 1: What we believe to be true]
- [Assumption 2: Condition that must hold]

---

### Technical Notes
- [Implementation considerations]
- [Architecture decisions]
- [Constraints]
- [Related tickets/stories]

---

### Success Metrics
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| [KPI name] | [Target value] | [How to measure] |

---

### Stakeholders
| Role | Name | Responsibility |
|------|------|----------------|
| Product Owner | [Name] | Acceptance |
| Tech Lead | [Name] | Technical review |
| QA Lead | [Name] | Test verification |
```

---

## INVEST Checklist

Before finalizing, verify the story meets INVEST criteria:

- [ ] **I**ndependent: Can be developed without depending on other stories
- [ ] **N**egotiable: Details can be discussed and adjusted
- [ ] **V**aluable: Delivers clear value to users or business
- [ ] **E**stimable: Team can estimate the effort required
- [ ] **S**mall: Can be completed within one sprint
- [ ] **T**estable: Has clear, verifiable acceptance criteria

---

## Story Point Reference

| Points | Complexity | Uncertainty | Example |
|--------|------------|-------------|---------|
| 1 | Trivial | None | Fix typo, update config |
| 2 | Simple | Low | Add field to form |
| 3 | Moderate | Low | CRUD for simple entity |
| 5 | Complex | Medium | New feature with API integration |
| 8 | Very Complex | High | Major feature, multiple components |
| 13 | Extremely Complex | Very High | Consider splitting |
| 21+ | Epic | - | Must be broken down |

---

## Complete Example

Input: `/user-story Calculate overtime pay`

Output:

## User Story: Calculate Overtime Pay

### Story ID
LLA-042

### Story

**As a** HR manager
**I want** to calculate employee overtime pay automatically
**So that** I can process payroll accurately and comply with Taiwan labor regulations

---

### Acceptance Criteria

#### Scenario 1: Standard weekday overtime calculation
- **Given** an employee with base monthly salary of NT$48,000
- **And** the employee worked 50 hours in a week (10 hours overtime)
- **When** I request overtime calculation
- **Then** the system calculates:
  - First 2 hours at 1.34x rate (NT$200 × 1.34 × 2 = NT$536)
  - Next 8 hours at 1.67x rate (NT$200 × 1.67 × 8 = NT$2,672)
- **And** total overtime pay is NT$3,208

#### Scenario 2: Holiday overtime calculation
- **Given** an employee worked 8 hours on a national holiday
- **When** I request overtime calculation
- **Then** the system calculates 8 hours at 2x base rate
- **And** displays the applicable Labor Standards Act reference

#### Scenario 3: Rest day overtime calculation
- **Given** an employee worked 6 hours on their designated rest day
- **When** I request overtime calculation
- **Then** the system calculates:
  - First 2 hours at 1.34x rate
  - Next 4 hours at 1.67x rate

#### Scenario 4: Invalid input handling
- **Given** negative hours are entered
- **When** I submit the calculation
- **Then** the system displays "Hours must be a positive number" error
- **And** the form is not submitted

#### Scenario 5: Exceeds legal limit warning
- **Given** overtime hours exceed 46 hours/month
- **When** I submit the calculation
- **Then** the system shows a warning about Labor Standards Act limits
- **And** allows proceeding with acknowledgment

---

### Definition of Done (DoD)

- [ ] Code implemented following Python style guide (PEP 8)
- [ ] Code reviewed by senior developer
- [ ] Unit tests for all calculation scenarios (coverage > 90%)
- [ ] Integration tests with payroll system
- [ ] Performance: calculation completes in < 500ms
- [ ] Legal formulas verified by senior-legal-expert agent
- [ ] API documentation updated
- [ ] Deployed to staging
- [ ] UAT completed by HR team

---

### Estimation

#### Story Points
| Criteria | Assessment |
|----------|------------|
| Complexity | Medium - Multiple calculation rules |
| Uncertainty | Low - Formulas defined by law |
| Effort | Medium - Integration required |
| **Story Points** | **5** |

---

### Priority & Value

| Factor | Rating | Notes |
|--------|--------|-------|
| Business Value | High | Core payroll feature |
| User Impact | High | All HR users |
| Technical Risk | Low | Well-defined requirements |
| Time Sensitivity | High | Needed for Q1 payroll cycle |

**Priority**: P0

**MoSCoW**: Must Have

---

### Dependencies

#### Upstream (Blocked By)
- [x] LLA-038: Employee base salary data model
- [x] LLA-040: Work hours tracking API

#### Downstream (Blocks)
- [ ] LLA-045: Monthly payroll report
- [ ] LLA-048: Overtime analytics dashboard

#### External
- [ ] Taiwan Ministry of Labor rate updates (annual)

---

### Risks & Assumptions

#### Risks
| Risk | Probability | Impact | Mitigation |
|------|-------------|--------|------------|
| Law changes mid-development | Low | High | Design for configurable rates |
| Complex edge cases | Medium | Medium | Comprehensive test suite |
| Performance with bulk calc | Low | Medium | Async processing option |

#### Assumptions
- Base hourly rate = Monthly salary ÷ 240 (standard calculation)
- All employees are covered by Labor Standards Act
- Overtime records are already validated before calculation

---

### Technical Notes
- Formula source: Taiwan Labor Standards Act Article 24
- Rates: 1.34x (first 2 hrs), 1.67x (hrs 3-4), 2x (holiday)
- Use Decimal for all monetary calculations
- Store calculation audit trail for compliance
- Consider caching rate configurations

---

### Success Metrics
| Metric | Target | Measurement Method |
|--------|--------|-------------------|
| Calculation accuracy | 100% | Cross-verify with manual calc |
| Processing time | < 500ms | API response monitoring |
| User satisfaction | > 4.5/5 | HR team survey |
| Support tickets | < 5/month | Ticket tracking |

---

### Stakeholders
| Role | Name | Responsibility |
|------|------|----------------|
| Product Owner | [HR Director] | Requirements, acceptance |
| Tech Lead | [Dev Lead] | Architecture, code review |
| QA Lead | [QA Manager] | Test strategy |
| Domain Expert | senior-legal-expert | Formula verification |
