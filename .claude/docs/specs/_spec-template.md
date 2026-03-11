# Spec: [Feature Name]

> Created: YYYY-MM-DD
> Author: [Name]
> Status: Draft | In Progress | Ready for Review | Approved

## 1. System Overview

### Related PRD Reference
- **Epic**: [e.g., Epic 01: AI Chat Interface]
- **Feature ID**: [e.g., M-05: Basic Q&A Interface]
- **Priority**: Must Have | Should Have | Could Have

### System Context
[Where does this feature sit within the overall system architecture? Which components are involved?]

### Problem Statement
[What problem does this feature solve? Who is affected?]

### Proposed Solution
[High-level description of the solution approach]

## 2. Feature Description

### Functional Requirements
[Concrete description of what the feature does]

### Acceptance Criteria
> Use SMART criteria format. Each criterion should be independently testable.

- [ ] [Criterion 1]
- [ ] [Criterion 2]
- [ ] [Criterion 3]

#### Legal Compliance (if applicable)
- [ ] [Law article reference and compliance requirement]

### Input
| Input | Source | Format | Validation Rules | Example |
|-------|--------|--------|-----------------|---------|
| | | | | |

### Processing Logic
[Core business logic and processing flow, step by step]

### Output
| Output | Destination | Format | Example |
|--------|-------------|--------|---------|
| | | | |

## 3. Technical Architecture

### Architecture Overview
[How does this fit into the existing system? Include component diagram description if helpful]

### Tech Stack
| Layer | Technology | Purpose |
|-------|-----------|---------|
| | | |

### Backend Components
[Services, repositories, utilities to create or modify]

### Frontend Components (if applicable)
[Pages, components, state management changes]

### Security Considerations
| Concern | Approach |
|---------|----------|
| Authentication | [Auth method: JWT / API key / session] |
| Authorization | [Role-based access, permission checks] |
| Data Privacy | [PII handling, encryption at rest/in transit] |
| Input Sanitization | [XSS prevention, SQL injection prevention] |
| Rate Limiting | [Limits per endpoint, throttling strategy] |

## 4. Data Model

### Schema Changes
[New tables or modified schemas]

```sql
-- Assumes PostgreSQL with pgvector extension. Adjust for other databases.
-- Example:
-- CREATE TABLE table_name (
--   id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
--   ...
-- );
```

### Migration Requirements
[Migration strategy, backward compatibility, data backfill needs]

### Indexes
| Table | Column(s) | Type | Purpose |
|-------|-----------|------|---------|
| | | | |

## 5. API Specification

### Endpoints

#### `[METHOD] /api/v1/[resource]`
- **Description**: [What this endpoint does]
- **Authentication**: [Required / Public]

**Request**:
| Parameter | Location | Type | Required | Default | Description |
|-----------|----------|------|----------|---------|-------------|
| | | | | | |

**Response** (`200 OK`):
```json
{
}
```

**Error Responses**:
| Status | Code | Description |
|--------|------|-------------|
| 400 | INVALID_INPUT | [When/why this occurs] |
| 401 | UNAUTHORIZED | [Authentication required or token expired] |
| 403 | FORBIDDEN | [Insufficient permissions for this resource] |
| 404 | NOT_FOUND | [When/why this occurs] |
| 500 | INTERNAL_ERROR | [When/why this occurs] |

## 6. Algorithm Description

### Core Algorithm
[Detailed description of the key algorithm and its flow]

### Flowchart
```
[Step-by-step flow using text-based diagram]
```

### Legal Calculation Logic (if applicable)
[Formulas, rules, and edge cases for labor law calculations.
Reference specific law articles.]

Example:
```
Overtime pay = Base hourly wage x Overtime hours x Multiplier
- First 2 hours: multiplier = 1.34 (Labor Standards Act §24-1)
- Beyond 2 hours: multiplier = 1.67 (Labor Standards Act §24-2)
- Base hourly wage = Monthly salary / 30 / 8
```

## 7. Performance Requirements

| Metric | Current | Target | Measurement Method |
|--------|---------|--------|-------------------|
| Response time (P95) | | | |
| Throughput (requests/sec) | | | |
| Concurrent users | | | |
| Cache hit rate | | | |
| Database query time | | | |

### Optimization Strategy
[Caching approach, query optimization, lazy loading, etc.]

### Observability Requirements

| Type | Details |
|------|---------|
| Logging | [Key events to log, log level, structured fields] |
| Metrics | [Custom metrics to track, dashboard requirements] |
| Alerts | [Alert conditions, thresholds, notification channels] |

## 8. Test Specification

### Test Plan

| Test Type | Scope | Key Scenarios |
|-----------|-------|---------------|
| Unit | | |
| Integration | | |
| E2E | | |
| BDD | | |

### BDD Scenarios
```gherkin
# Example:
# Feature: [Feature name]
#   Scenario: [Scenario name]
#     Given [precondition]
#     When [action]
#     Then [expected result]
```

### Legal Module Testing (if applicable)
- Coverage target: 95% for legal calculation modules
- Cross-validation with government calculators required
- Must test edge cases: variable working hours (變形工時), part-time workers (部分工時),
  probation period (試用期), less than one year of service (未滿一年資遣),
  foreign workers (外籍勞工)

---

## Appendix

### A. Dependencies

| Type | Dependency | Version | Notes |
|------|-----------|---------|-------|
| Upstream | [What must be completed first] | | |
| Downstream | [What depends on this] | | |
| External | [Third-party APIs, services] | | |

### B. Risks and Mitigation

| Risk | Impact | Probability | Mitigation |
|------|--------|-------------|------------|
| | | | |

### C. Localization Requirements

| Aspect | Requirement |
|--------|------------|
| Language | Traditional Chinese (zh-TW) as primary; multilingual per Epic 05 |
| Currency | TWD (NT$), no decimal places |
| Date format | YYYY/MM/DD (Taiwan standard) |
| Number format | Comma-separated thousands (e.g., 27,470) |
| Legal terms | Use official MOL (勞動部) terminology |

### D. Implementation Notes

**Estimated Effort**:
- [ ] Small (< 1 day)
- [ ] Medium (1-3 days)
- [ ] Large (3-5 days)
- [ ] Extra Large (> 5 days)

**Open Questions**:
- [Questions that need answers before or during implementation]

---

> **Workflow**: When implementation is complete, move this file from
> `pending/` to `completed/` and update the Status field above.
