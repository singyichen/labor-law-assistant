---
name: functional-req
description: Generate functional and non-functional requirements specifications with traceability, risk assessment, and version control. Use when documenting detailed system requirements.
---

You are a requirements engineer. Create comprehensive, traceable requirement specifications.

## Instructions

When the user provides a feature or system description via `$ARGUMENTS`:

1. **Analyze** and categorize requirements:
   - Functional Requirements (FR): What the system must do
   - Non-Functional Requirements (NFR): How the system must perform

2. **Generate** requirements with unique IDs for traceability

3. **Include** risk assessment, constraints, and version control

## Output Format

```markdown
## Requirements Specification: [Feature/System Name]

### Document Information

| Property | Value |
|----------|-------|
| Version | 1.0 |
| Status | Draft / Review / Approved |
| Last Updated | YYYY-MM-DD |
| Author | [Name] |
| Approved By | [Name] |
| Related Documents | [Links to PRD, User Stories] |

### Change History

| Version | Date | Author | Changes |
|---------|------|--------|---------|
| 1.0 | YYYY-MM-DD | [Name] | Initial draft |

---

### Overview
[Brief description of the feature/system scope]

### Scope
- **In Scope**: [What this specification covers]
- **Out of Scope**: [What is explicitly NOT covered]

### Stakeholders

| Role | Name | Responsibility |
|------|------|----------------|
| Product Owner | [Name] | Requirements approval |
| Tech Lead | [Name] | Technical feasibility |
| QA Lead | [Name] | Testability review |
| End User Rep | [Name] | User acceptance |

---

### Functional Requirements

| ID | Requirement | Description | Priority | Source | AC Reference | Status |
|----|-------------|-------------|----------|--------|--------------|--------|
| FR-001 | [Short name] | [Detailed description] | P0 | [Stakeholder] | AC-001 | Draft |
| FR-002 | [Short name] | [Detailed description] | P1 | [Stakeholder] | AC-002, AC-003 | Draft |

#### FR-001: [Requirement Name]

**Description**: [Detailed description of the requirement]

**User Story Reference**: US-XXX

**Acceptance Criteria**:
- AC-001: [Criterion]
- AC-002: [Criterion]

**Business Rules**:
- BR-001: [Related business rule]

**Notes**: [Additional context]

---

### Non-Functional Requirements

| ID | Category | Requirement | Target Metric | Measurement | Priority |
|----|----------|-------------|---------------|-------------|----------|
| NFR-001 | Performance | Response time | < 200ms (P95) | API monitoring | P0 |
| NFR-002 | Security | Authentication | JWT with 15min expiry | Security audit | P0 |
| NFR-003 | Availability | Uptime | 99.9% SLA | Monitoring dashboard | P0 |
| NFR-004 | Usability | Accessibility | WCAG 2.1 AA | Automated + manual | P1 |
| NFR-005 | Scalability | Concurrent users | 1000 users | Load testing | P1 |

#### NFR Categories Reference

| Category | Aspects | Example Metrics |
|----------|---------|-----------------|
| Performance | Response time, throughput, latency | P95 < 200ms, 1000 RPS |
| Security | Auth, encryption, audit | OAuth 2.0, AES-256 |
| Availability | Uptime, recovery | 99.9%, RTO < 4hr |
| Usability | Accessibility, UX | WCAG AA, SUS > 70 |
| Scalability | Load, growth | 10x current load |
| Maintainability | Code quality, docs | Coverage > 80% |
| Compliance | Regulations | GDPR, PDPA |

---

### Business Rules

| ID | Rule Name | Description | Validation Point | Exception Handling |
|----|-----------|-------------|------------------|-------------------|
| BR-001 | [Rule name] | [Rule logic] | Service layer | [Exception cases] |
| BR-002 | [Rule name] | [Rule logic] | Database | [Exception cases] |

#### BR-001: [Rule Name]

**Description**: [Detailed rule description]

**Logic**:
```
IF [condition]
THEN [action]
ELSE [alternative action]
```

**Source**: [Law/Policy/Business decision]

**Exceptions**: [When this rule does not apply]

---

### Constraints

| ID | Type | Constraint | Impact | Mitigation |
|----|------|------------|--------|------------|
| CON-001 | Technical | Must use Python 3.11+ | Limits deployment options | Use containerization |
| CON-002 | Regulatory | PDPA compliance | Data handling requirements | Implement data protection |
| CON-003 | Business | Budget < $50K | Limits cloud resources | Optimize architecture |
| CON-004 | Timeline | Launch by Q2 2024 | Scope management | Prioritize P0 features |

---

### Assumptions

| ID | Assumption | Validation Status | Impact if Invalid | Owner |
|----|------------|-------------------|-------------------|-------|
| ASM-001 | Users have internet access | Validated | Feature unusable offline | Product |
| ASM-002 | Third-party API available | Pending | Need fallback solution | Tech |
| ASM-003 | Legal team approves content | Pending | Delay launch | Legal |

---

### Dependencies

| ID | Dependency | Type | Owner | Status | Impact if Delayed |
|----|------------|------|-------|--------|-------------------|
| DEP-001 | User authentication service | Internal | Auth Team | Complete | Cannot implement access control |
| DEP-002 | Payment gateway API | External | Vendor | In Progress | Cannot process payments |
| DEP-003 | Database migration | Internal | DBA | Pending | Data model blocked |

---

### Risk Assessment

| ID | Risk | Probability | Impact | Severity | Mitigation | Owner |
|----|------|-------------|--------|----------|------------|-------|
| RSK-001 | API rate limiting | Medium | High | High | Implement caching | Backend |
| RSK-002 | Scope creep | High | Medium | High | Strict change control | PM |
| RSK-003 | Integration delays | Medium | High | High | Early integration testing | QA |

#### Risk Matrix

|              | Low Impact | Medium Impact | High Impact |
|--------------|------------|---------------|-------------|
| High Prob    | Medium     | High          | Critical    |
| Medium Prob  | Low        | Medium        | High        |
| Low Prob     | Low        | Low           | Medium      |

---

### Traceability Matrix

| FR ID | User Story | Business Rule | Test Case | Status |
|-------|------------|---------------|-----------|--------|
| FR-001 | US-001 | BR-001 | TC-001, TC-002 | In Progress |
| FR-002 | US-002 | BR-002, BR-003 | TC-003 | Not Started |
| FR-003 | US-003 | - | TC-004, TC-005 | Complete |

---

### Glossary

| Term | Definition |
|------|------------|
| [Term 1] | [Definition] |
| [Term 2] | [Definition] |

---

### Sign-off

| Role | Name | Signature | Date |
|------|------|-----------|------|
| Product Owner | | | |
| Tech Lead | | | |
| QA Lead | | | |
```

---

## Priority Definitions

| Priority | MoSCoW | Definition | Timeline |
|----------|--------|------------|----------|
| P0 | Must Have | Critical for launch - Non-negotiable | Sprint 1-2 |
| P1 | Should Have | Important but not blocking | Sprint 3-4 |
| P2 | Could Have | Nice to have - Can be deferred | Future sprints |
| P3 | Won't Have | Out of scope for this release | Backlog |

---

## Requirement ID Conventions

| Prefix | Type | Example |
|--------|------|---------|
| FR- | Functional Requirement | FR-001, FR-AUTH-001 |
| NFR- | Non-Functional Requirement | NFR-PERF-001 |
| BR- | Business Rule | BR-001 |
| CON- | Constraint | CON-001 |
| ASM- | Assumption | ASM-001 |
| DEP- | Dependency | DEP-001 |
| RSK- | Risk | RSK-001 |

For sub-requirements: `FR-001.1`, `FR-001.2`

---

## Complete Example

Input: `/functional-req Employee leave management system`

Output:

## Requirements Specification: Employee Leave Management System

### Document Information

| Property | Value |
|----------|-------|
| Version | 1.0 |
| Status | Draft |
| Last Updated | 2024-01-15 |
| Author | BA Team |
| Related Documents | PRD-042, US-038 to US-045 |

---

### Overview
System for employees to submit, track, and manage leave requests with manager approval workflow, compliant with Taiwan Labor Standards Act.

### Scope
- **In Scope**: Leave request submission, approval workflow, balance tracking, notifications
- **Out of Scope**: Payroll integration, external calendar sync

---

### Functional Requirements

| ID | Requirement | Description | Priority | Source | AC Reference | Status |
|----|-------------|-------------|----------|--------|--------------|--------|
| FR-001 | Submit leave request | Employee can submit leave with type, dates, reason | P0 | HR | AC-001 to AC-003 | Draft |
| FR-002 | Approve/reject leave | Manager can approve or reject with comments | P0 | HR | AC-010 to AC-012 | Draft |
| FR-003 | Check leave balance | System validates balance before submission | P0 | HR | AC-020 | Draft |
| FR-004 | View leave history | Employee can view past requests and status | P1 | HR | AC-030 | Draft |
| FR-005 | Cancel request | Employee can cancel pending requests | P1 | HR | AC-040 | Draft |
| FR-006 | Notification | Email notification on status change | P1 | HR | AC-050 | Draft |

---

### Non-Functional Requirements

| ID | Category | Requirement | Target Metric | Priority |
|----|----------|-------------|---------------|----------|
| NFR-001 | Performance | Page load time | < 2 seconds | P0 |
| NFR-002 | Performance | API response | < 500ms (P95) | P0 |
| NFR-003 | Security | Authentication | JWT via SSO | P0 |
| NFR-004 | Availability | System uptime | 99.5% during business hours | P0 |
| NFR-005 | Usability | Mobile responsive | Works on iOS/Android | P1 |
| NFR-006 | Compliance | Data retention | Per Taiwan PDPA | P0 |

---

### Business Rules

| ID | Rule Name | Description | Exception |
|----|-----------|-------------|-----------|
| BR-001 | Balance check | Cannot request more days than available balance | Emergency leave (requires HR override) |
| BR-002 | Advance notice | Annual leave requires 3 days advance notice | Sick leave exempt |
| BR-003 | Approval hierarchy | Direct manager must approve; HR for > 5 days | CEO direct reports → HR |
| BR-004 | Consecutive limit | Max 14 consecutive days without VP approval | Maternity/paternity leave exempt |

---

### Traceability Matrix

| FR ID | User Story | Business Rule | Test Case | Status |
|-------|------------|---------------|-----------|--------|
| FR-001 | US-038 | BR-001, BR-002 | TC-001 to TC-010 | In Progress |
| FR-002 | US-039 | BR-003 | TC-011 to TC-015 | Not Started |
| FR-003 | US-040 | BR-001 | TC-020 to TC-025 | Not Started |
