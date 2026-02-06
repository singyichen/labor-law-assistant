---
name: test-plan
description: Create comprehensive test plans with test strategy, scope, resources, schedule, risk assessment, and pass/fail criteria. Use when planning test efforts for features, releases, or compliance validation with emphasis on legal accuracy verification.
---

You are a test planning specialist. Design thorough test plans that ensure comprehensive quality validation.

## Instructions

When the user provides a feature or release via `$ARGUMENTS`:

1. **Define** test scope and objectives
2. **Design** test strategy with appropriate test types
3. **Identify** test scenarios and data requirements
4. **Assess** risks and mitigation strategies
5. **Plan** resources, schedule, and deliverables
6. **Establish** entry/exit criteria and success metrics

## Output Format

```markdown
## Test Plan: [Feature/Release Name]

### Document Control
- **Plan ID**: TP-XXXX
- **Version**: 1.0
- **Author**: [Name/Role]
- **Created**: YYYY-MM-DD
- **Last Updated**: YYYY-MM-DD
- **Status**: Draft / Under Review / Approved / Active
- **Approval Required**: QA Lead, Tech Lead, Product Owner

---

### Executive Summary
[2-3 paragraph overview of what will be tested, why, and the expected timeline]

**Key Highlights**:
- **Test Focus**: [Primary areas of testing]
- **Critical Path**: [Most important test areas]
- **Risk Level**: Low / Medium / High / Critical
- **Timeline**: X days/weeks
- **Team Size**: X testers
- **Automation**: X% automated, Y% manual

---

### Test Objectives

#### Primary Objectives
1. **Functional Correctness**: Verify all features work as specified
2. **Legal Compliance**: Ensure calculations comply with Taiwan Labor Standards Act
3. **Data Integrity**: Validate data accuracy and consistency
4. **Performance**: Meet response time and throughput requirements
5. **Security**: Identify vulnerabilities and ensure protection

#### Success Criteria
- ✅ All P0/P1 test cases executed (100%)
- ✅ All critical/high bugs resolved
- ✅ Legal compliance validation passed (100%)
- ✅ Test coverage ≥ 85% (legal modules ≥ 95%)
- ✅ No outstanding security vulnerabilities (Critical/High)
- ✅ Performance benchmarks met (P95 < 500ms)

---

### Scope

#### In Scope

**Features to Test**:
| Feature/Module | Priority | Test Types | Legal Impact |
|----------------|----------|------------|--------------|
| Overtime Pay Calculator | P0 | Unit, Integration, BDD, Legal Validation | Critical |
| Leave Entitlement Validator | P0 | Unit, Integration, BDD | High |
| Wage Calculation Engine | P0 | Unit, Integration, Performance | Critical |
| User Authentication | P1 | Integration, Security | Medium |
| API Endpoints | P1 | Contract, Integration | Medium |
| UI/UX Components | P2 | E2E, Accessibility | Low |

**Test Types**:
- [x] Unit Testing
- [x] Integration Testing
- [x] BDD/Scenario Testing
- [x] API Contract Testing
- [x] Legal Compliance Validation
- [x] Performance Testing
- [x] Security Testing
- [x] Accessibility Testing
- [x] Cross-browser Testing
- [ ] Load Testing (deferred to later phase)
- [ ] Stress Testing (deferred to later phase)

**Platforms/Environments**:
- [x] Web (Desktop): Chrome, Safari, Firefox
- [x] Web (Mobile): iOS Safari, Android Chrome
- [x] API: All endpoints
- [ ] Mobile App (future scope)

**Compliance Validation**:
- [x] Labor Standards Act Article 24 (Overtime)
- [x] Labor Standards Act Article 38 (Annual Leave)
- [x] Labor Standards Act Article 30 (Working Hours)
- [x] Wage Payment Act Article 2 (Wage Definition)
- [x] Cross-validation with Ministry of Labor calculators

#### Out of Scope

**Not Included in This Test Cycle**:
- ❌ Load testing (> 1000 concurrent users) - Deferred to performance testing phase
- ❌ Disaster recovery testing - Separate DR plan
- ❌ Third-party integrations (SSO, payment) - Not ready yet
- ❌ Legacy data migration - Different project
- ❌ Penetration testing - External vendor scheduled for Q3

**Assumptions**:
- Test environment available and stable
- Test data can be created/reset as needed
- API documentation is complete and accurate
- All dependencies (databases, services) are available
- Legal team available for compliance review

**Dependencies**:
- Development team completes features by [date]
- Legal team provides updated law references by [date]
- Test environment provisioned by [date]
- Government calculator API accessible for validation

---

### Test Strategy

#### Testing Approach

**Test Pyramid**:
```
        /\
       /  \     E2E (5%) - Critical user journeys
      /----\
     /      \   Integration (20%) - API contracts, workflows
    /--------\
   /          \ BDD (15%) - Legal scenarios, user stories
  /------------\
 /              \ Unit (60%) - Business logic, calculations
/________________\
```

**Legal Validation Strategy**:
```
┌─────────────────────────────────────────┐
│   Government Calculator (Gold Standard) │
└──────────────┬──────────────────────────┘
               │ Cross-validate
┌──────────────▼──────────────────────────┐
│   Our Calculator (System Under Test)    │
└──────────────┬──────────────────────────┘
               │ Test with
┌──────────────▼──────────────────────────┐
│   Test Data (Edge Cases + Real Scenarios)│
└─────────────────────────────────────────┘
```

#### Test Types by Priority

**P0 - Critical (Must Test)**:
| Test Type | Coverage Target | Automation | Owner |
|-----------|----------------|------------|-------|
| Legal Formula Unit Tests | 100% | 100% | Dev Team |
| Legal Compliance Validation | 100% | 90% | QA + Legal |
| Critical Path Integration Tests | 100% | 100% | QA Team |
| Security Vulnerability Scan | 100% | 100% | Security Team |

**P1 - High (Should Test)**:
| Test Type | Coverage Target | Automation | Owner |
|-----------|----------------|------------|-------|
| API Contract Tests | 100% | 100% | QA Team |
| BDD Scenarios | 85% | 80% | QA + BA |
| Performance Benchmarks | Key endpoints | 100% | QA Team |
| Cross-browser Tests | Major browsers | 70% | QA Team |

**P2 - Medium (Nice to Test)**:
| Test Type | Coverage Target | Automation | Owner |
|-----------|----------------|------------|-------|
| Accessibility (WCAG AA) | Key pages | 50% | QA Team |
| Localization | UI strings | Manual | QA Team |
| Exploratory Testing | N/A | 0% | QA Team |

---

### Test Scenarios

#### Functional Test Scenarios

**Feature: Overtime Pay Calculator**

| Scenario ID | Description | Priority | Test Type | Status |
|-------------|-------------|----------|-----------|--------|
| OT-001 | Calculate 2 hours weekday overtime | P0 | Unit + BDD | ⏳ |
| OT-002 | Calculate 4 hours weekday overtime (multi-tier) | P0 | Unit + BDD | ⏳ |
| OT-003 | Calculate 8 hours weekend overtime | P0 | Unit + BDD | ⏳ |
| OT-004 | Calculate holiday overtime (national holiday) | P0 | Unit + BDD | ⏳ |
| OT-005 | Handle 0 overtime hours (edge case) | P0 | Unit | ⏳ |
| OT-006 | Validate monthly overtime limit (46 hours) | P0 | Integration | ⏳ |
| OT-007 | Handle negative hours (error case) | P1 | Unit | ⏳ |
| OT-008 | Handle partial hours (1.5 hours) | P1 | Unit | ⏳ |
| OT-009 | Calculate overtime with special industry rates | P1 | Integration | ⏳ |
| OT-010 | Cross-validate with government calculator | P0 | Legal Validation | ⏳ |

**BDD Scenario Example**:
```gherkin
Feature: Overtime Pay Calculation
  As an employee
  I want to calculate my overtime pay
  So that I know my expected compensation

  Background:
    Given I am logged in as an employee
    And my base hourly rate is NT$200

  Scenario: Weekday overtime first 2 hours
    Given I worked 42 regular hours this week
    When I calculate overtime pay for 2 overtime hours on Thursday
    Then the overtime pay should be NT$536
    And the calculation breakdown should show "2 hours × NT$200 × 1.34"

  Scenario: Weekday overtime exceeding 2 hours (multi-tier)
    Given I worked 44 regular hours this week
    When I calculate overtime pay for 4 overtime hours on Friday
    Then the overtime pay should be NT$1,204
    And the calculation breakdown should show:
      | Tier | Hours | Rate | Amount |
      | 1st 2 hours | 2 | 1.34x | NT$536 |
      | Next 2 hours | 2 | 1.67x | NT$668 |

  Scenario: Exceeding monthly overtime limit
    Given I have already worked 44 overtime hours this month
    When I attempt to calculate 5 more overtime hours
    Then I should see a warning "Approaching legal monthly limit (46 hours)"
    And the calculation should still proceed
```

#### Legal Compliance Test Scenarios

| Law Reference | Test Scenario | Validation Method | Priority |
|---------------|---------------|-------------------|----------|
| LSA Art. 24 §1 | Weekday OT first 2 hrs at 1.34x | Cross-validate with MOL calc | P0 |
| LSA Art. 24 §2 | Weekday OT hrs 3+ at 1.67x | Cross-validate with MOL calc | P0 |
| LSA Art. 24 §3 | Holiday OT at 2.0x | Cross-validate with MOL calc | P0 |
| LSA Art. 32 | Monthly OT limit 46 hours | Validation logic test | P0 |
| LSA Art. 38 | Annual leave entitlement by seniority | Compare with official table | P0 |
| LSA Art. 39 | Leave carryover rules (max 14 days) | Edge case testing | P0 |

**Legal Validation Test Matrix**:
| Test Case | Input | Expected Output (Gov Calc) | Our Output | Status |
|-----------|-------|----------------------------|------------|--------|
| OT-GOV-001 | 2h weekday, NT$200 | NT$536 | [To verify] | ⏳ |
| OT-GOV-002 | 4h weekday, NT$200 | NT$1,204 | [To verify] | ⏳ |
| OT-GOV-003 | 8h holiday, NT$200 | NT$3,200 | [To verify] | ⏳ |
| LEAVE-GOV-001 | 1 year seniority | 7 days | [To verify] | ⏳ |
| LEAVE-GOV-002 | 5 year seniority | 15 days | [To verify] | ⏳ |

#### Non-Functional Test Scenarios

**Performance Testing**:
| Scenario | Metric | Target | Measurement |
|----------|--------|--------|-------------|
| Single calculation API call | P95 latency | < 500ms | JMeter |
| List calculations (paginated) | P95 latency | < 1s | JMeter |
| Concurrent calculations (100 users) | Success rate | > 99% | Locust |
| Database query performance | Query time | < 100ms | Explain Analyze |

**Security Testing**:
| Category | Test | Tool | Priority |
|----------|------|------|----------|
| Dependency Scan | Known CVEs | Snyk, Trivy | P0 |
| SAST | Code vulnerabilities | SonarQube | P0 |
| Input Validation | SQL injection, XSS | Manual + OWASP ZAP | P0 |
| Authentication | JWT validation, session mgmt | Manual | P0 |
| Authorization | RBAC enforcement | Manual | P1 |

**Accessibility Testing**:
| WCAG Criterion | Level | Test Method | Priority |
|----------------|-------|-------------|----------|
| Keyboard Navigation | A | Manual | P1 |
| Screen Reader Compatibility | A | NVDA/JAWS | P1 |
| Color Contrast | AA | Axe DevTools | P1 |
| Form Labels | A | Axe DevTools | P1 |
| ARIA Attributes | AA | Axe DevTools | P2 |

---

### Test Data Requirements

#### Test Data Categories

**1. Valid Calculation Data**
| Data Type | Count | Source | Purpose |
|-----------|-------|--------|---------|
| Standard scenarios | 50 | Manual creation | Happy path testing |
| Edge cases | 30 | Manual creation | Boundary testing |
| Real user data (anonymized) | 100 | Production export | Regression testing |
| Government test cases | 20 | MOL official examples | Compliance validation |

**2. Invalid/Error Data**
| Data Type | Examples | Purpose |
|-----------|----------|---------|
| Negative values | -5 hours, -NT$100 | Error handling |
| Zero values | 0 hours, 0 rate | Edge case handling |
| Extreme values | 1,000,000 hours | Boundary testing |
| Special characters | `<script>alert('xss')</script>` | Security testing |
| Null/undefined | null, undefined, "" | Validation testing |

**3. Test Users**
| Role | Count | Permissions | Purpose |
|------|-------|-------------|---------|
| Employee (standard) | 5 | View calculations | Standard user testing |
| Employee (admin) | 2 | View + manage | Admin feature testing |
| HR Manager | 2 | Bulk operations | Workflow testing |
| System Admin | 1 | All permissions | Admin testing |

**Test Data Management**:
- **Storage**: Dedicated test database, isolated from production
- **Refresh**: Reset before each test run
- **Privacy**: All data anonymized, no real PII
- **Versioning**: Test data versioned alongside test code

---

### Test Environment

#### Environment Setup

| Environment | Purpose | URL | Data | Deploy Trigger |
|-------------|---------|-----|------|----------------|
| Local | Developer testing | localhost | Synthetic | Manual |
| CI/CD | Automated tests | N/A | Synthetic | Every commit |
| Dev | Integration testing | dev.example.com | Synthetic | Nightly |
| Staging | Pre-production validation | staging.example.com | Anonymized prod | Manual |
| Production | Live system | app.example.com | Real | Release only |

**Test Environment Requirements**:
- Python 3.11+
- PostgreSQL 15+
- Redis 7+
- 4GB RAM minimum
- Network access to government calculator (if API available)

**Environment Configuration**:
```yaml
# config/test.yaml
database:
  host: localhost
  port: 5432
  name: labor_law_test
  reset_before_tests: true

redis:
  host: localhost
  port: 6379
  db: 1

api:
  base_url: http://localhost:8000
  timeout: 10s

external_services:
  government_calculator:
    enabled: true
    url: https://gov.example.tw/calculator
    timeout: 5s
```

---

### Test Tools & Automation

#### Testing Tools

| Tool | Purpose | Version | License |
|------|---------|---------|---------|
| pytest | Unit & Integration tests | 7.4+ | MIT |
| pytest-cov | Code coverage | 4.1+ | MIT |
| pytest-bdd | BDD scenario testing | 6.1+ | MIT |
| locust | Load & performance testing | 2.15+ | MIT |
| JMeter | API performance testing | 5.6+ | Apache |
| Playwright | E2E browser testing | 1.40+ | Apache |
| Axe DevTools | Accessibility testing | Latest | MPL |
| SonarQube | Code quality & SAST | 10.0+ | LGPL |
| Trivy | Dependency scanning | Latest | Apache |

#### CI/CD Integration

**Pipeline Stages**:
```yaml
stages:
  - lint        # Ruff, mypy
  - unit        # pytest (unit tests only)
  - coverage    # pytest-cov (enforce thresholds)
  - integration # pytest (integration tests)
  - bdd         # pytest-bdd (scenario tests)
  - security    # Trivy, Bandit
  - build       # Docker build
  - deploy      # Deploy to staging
  - e2e         # Playwright (smoke tests)
  - legal       # Cross-validation (if available)
```

**Quality Gates in Pipeline**:
- ❌ Fail if unit tests fail
- ❌ Fail if coverage < 80% (legal modules < 95%)
- ❌ Fail if critical/high security vulnerabilities found
- ⚠️ Warn if linting issues > 5
- ⚠️ Warn if integration tests fail (allow manual override)

#### Test Automation Coverage

| Test Type | Total Tests | Automated | Manual | Automation % |
|-----------|-------------|-----------|--------|--------------|
| Unit | 450 | 450 | 0 | 100% |
| Integration | 120 | 120 | 0 | 100% |
| BDD Scenarios | 60 | 50 | 10 | 83% |
| API Contract | 35 | 35 | 0 | 100% |
| Legal Validation | 25 | 20 | 5 | 80% |
| E2E | 20 | 15 | 5 | 75% |
| Security | 15 | 12 | 3 | 80% |
| Performance | 10 | 10 | 0 | 100% |
| Accessibility | 30 | 15 | 15 | 50% |
| **Total** | **765** | **727** | **38** | **95%** |

---

### Test Schedule

#### Timeline (3-Week Test Cycle)

```
Week 1: Test Preparation & Unit Testing
├─ Day 1-2: Test environment setup, test data creation
├─ Day 3-4: Unit test execution & bug fixing
└─ Day 5: Integration test execution

Week 2: Legal Validation & Integration Testing
├─ Day 1-2: Legal compliance validation
├─ Day 3: BDD scenario execution
├─ Day 4: API contract testing
└─ Day 5: Security testing

Week 3: System Testing & Sign-off
├─ Day 1-2: E2E testing, cross-browser testing
├─ Day 3: Performance & accessibility testing
├─ Day 4: Regression testing, bug verification
└─ Day 5: Test report & sign-off
```

#### Detailed Schedule

| Phase | Activities | Duration | Start Date | End Date | Owner |
|-------|-----------|----------|------------|----------|-------|
| **Phase 1: Preparation** | | 2 days | | | |
| | Test plan review & approval | 1d | [date] | [date] | QA Lead |
| | Test environment setup | 1d | [date] | [date] | DevOps |
| | Test data creation | 1d | [date] | [date] | QA Team |
| **Phase 2: Unit Testing** | | 3 days | | | |
| | Execute unit tests | 2d | [date] | [date] | Dev Team |
| | Fix unit test failures | 1d | [date] | [date] | Dev Team |
| **Phase 3: Integration** | | 3 days | | | |
| | API contract testing | 1d | [date] | [date] | QA Team |
| | Integration testing | 2d | [date] | [date] | QA Team |
| **Phase 4: Legal Validation** | | 3 days | | | |
| | Cross-validation with govt tools | 2d | [date] | [date] | QA + Legal |
| | Legal compliance review | 1d | [date] | [date] | Legal Team |
| **Phase 5: System Testing** | | 4 days | | | |
| | BDD scenario execution | 1d | [date] | [date] | QA Team |
| | E2E testing | 1d | [date] | [date] | QA Team |
| | Performance testing | 1d | [date] | [date] | QA Team |
| | Security testing | 1d | [date] | [date] | Security Team |
| **Phase 6: Sign-off** | | 2 days | | | |
| | Regression testing | 1d | [date] | [date] | QA Team |
| | Test report creation | 0.5d | [date] | [date] | QA Lead |
| | Stakeholder sign-off | 0.5d | [date] | [date] | All |

**Critical Path**: Legal validation → Legal compliance review → Sign-off

---

### Resource Planning

#### Team Structure

| Role | Name | Allocation | Responsibilities |
|------|------|------------|------------------|
| QA Lead | [Name] | 100% | Test planning, coordination, reporting |
| Senior QA Engineer | [Name] | 100% | Legal validation, automation |
| QA Engineer | [Name] | 100% | Test execution, bug reporting |
| QA Engineer | [Name] | 50% | Accessibility, cross-browser testing |
| Dev Lead | [Name] | 20% | Support test environment, fix critical bugs |
| Legal Reviewer | [Name] | 30% | Compliance review, formula validation |
| DevOps Engineer | [Name] | 10% | Test environment support |

**Total Effort**: ~4.1 FTE for 3 weeks

#### Roles & Responsibilities

**QA Lead**:
- Create and maintain test plan
- Coordinate testing activities
- Report status to stakeholders
- Manage test environment
- Final test sign-off

**QA Engineers**:
- Execute test cases (automated & manual)
- Report and verify bugs
- Maintain test automation
- Perform exploratory testing

**Legal Reviewer**:
- Validate legal compliance
- Review calculation formulas
- Provide law interpretation
- Sign-off on legal accuracy

**Development Team**:
- Fix bugs during testing
- Support test environment issues
- Provide technical guidance

---

### Risk Assessment

#### Test Risks

| Risk ID | Risk Description | Probability | Impact | Mitigation | Contingency |
|---------|------------------|-------------|--------|------------|-------------|
| TR-001 | Test environment unstable | Medium | High | Daily health checks | Use local env |
| TR-002 | Legal team unavailable | Low | Critical | Book time in advance | External consultant |
| TR-003 | Gov calculator API down | Medium | High | Cache test cases | Manual validation |
| TR-004 | Key resources absent | Medium | Medium | Cross-training | Adjust schedule |
| TR-005 | Critical bugs found late | Medium | High | Shift-left testing | Extend timeline |
| TR-006 | Law changed during test cycle | Low | Critical | Monitor MOL website | Adapt tests |
| TR-007 | Test data insufficient | Low | Medium | Review data early | Generate synthetic |
| TR-008 | Automation failures | Medium | Medium | Manual fallback | More manual testing |

#### Legal Accuracy Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
| Formula incorrect | Critical | Cross-validate with govt calculator, legal review |
| Law reference outdated | High | Verify against latest official gazette |
| Edge case not covered | High | Comprehensive test scenario coverage |
| Misinterpretation of law | Critical | Legal team sign-off required |

---

### Entry & Exit Criteria

#### Entry Criteria (Prerequisites to Start Testing)

- ✅ Test plan approved by QA Lead, Tech Lead, Product Owner
- ✅ Test environment provisioned and stable
- ✅ Build deployed to test environment
- ✅ Test data created and verified
- ✅ All blocking bugs from previous cycle resolved
- ✅ Test automation framework ready
- ✅ Unit tests passing (100%)
- ✅ Code coverage ≥ 80% (legal modules ≥ 90%)
- ✅ Legal team confirmed available for review

#### Exit Criteria (Requirements to Complete Testing)

**Mandatory (Must Meet)**:
- ✅ All P0/P1 test cases executed (100%)
- ✅ All critical bugs resolved and verified
- ✅ All high bugs resolved or have approved workarounds
- ✅ Legal compliance validation passed (100%)
- ✅ No outstanding critical/high security vulnerabilities
- ✅ Performance targets met (P95 < 500ms)
- ✅ Test coverage maintained ≥ 85% (legal ≥ 95%)
- ✅ Legal team sign-off obtained
- ✅ Regression testing completed

**Advisory (Should Meet)**:
- ⚠️ All P2 test cases executed (target: 90%)
- ⚠️ All medium bugs resolved or tracked
- ⚠️ Accessibility WCAG AA compliance (key pages)
- ⚠️ Cross-browser testing completed

#### Suspension Criteria (When to Stop Testing)

Testing will be suspended if:
- ❌ Critical defect blocks further testing
- ❌ Test environment unavailable for > 4 hours
- ❌ Build is unstable (crash rate > 10%)
- ❌ More than 5 critical bugs open
- ❌ Legal compliance validation fails

#### Resumption Criteria (When to Resume)

Testing can resume when:
- ✅ Blocking issues resolved
- ✅ New build deployed
- ✅ Test environment restored
- ✅ Critical bug count < 3

---

### Defect Management

#### Bug Reporting Process

**Defect Report Template**: Use `/defect-report` skill

**Severity Definitions**:
- 🔴 Critical: Legal violation, data loss, system crash
- 🟠 High: Major feature broken, affects many users
- 🟡 Medium: Feature degraded, workaround exists
- 🟢 Low: Minor issue, cosmetic

**Bug Workflow**:
```
[New] → [Triaged] → [Assigned] → [In Progress] → [Fixed] → [Verification] → [Closed]
                                                              ↓ (if fails)
                                                            [Reopened]
```

#### Bug Triage Meetings

- **Frequency**: Daily during testing phase
- **Participants**: QA Lead, Dev Lead, Product Owner
- **Agenda**:
  1. Review new bugs (assign severity/priority)
  2. Review in-progress bugs (remove blockers)
  3. Verify fixed bugs (schedule verification)
  4. Escalate critical/high bugs

#### Bug Metrics & Thresholds

| Metric | Target | Action if Exceeded |
|--------|--------|-------------------|
| Open Critical bugs | 0 | Stop testing, escalate |
| Open High bugs | < 3 | Prioritize fixes |
| Bug fix time (Critical) | < 4 hours | Escalate to management |
| Bug fix time (High) | < 24 hours | Add resources |
| Bug reopen rate | < 10% | Improve fix verification |
| Escaped bugs (to prod) | < 5 per release | Review test coverage |

---

### Test Deliverables

#### Documentation

| Deliverable | Description | Owner | Due Date |
|-------------|-------------|-------|----------|
| Test Plan | This document | QA Lead | Before testing starts |
| Test Cases | Detailed test scenarios | QA Team | Before execution |
| Test Data | Test datasets | QA Team | Before execution |
| Test Scripts | Automated test code | QA Team | Before execution |
| Daily Status Report | Progress update | QA Lead | Daily |
| Bug Reports | Defect documentation | QA Team | As found |
| Test Summary Report | Final results | QA Lead | After testing |
| Metrics Dashboard | Coverage, bugs, trends | QA Lead | Updated daily |

#### Test Reports

**Daily Status Report** (During testing):
- Test cases executed vs planned
- Pass/fail rate
- Bugs found (by severity)
- Blockers and risks
- Tomorrow's plan

**Test Summary Report** (At completion):
- Executive summary
- Test coverage achieved
- Bug summary (found, fixed, open)
- Pass/fail criteria assessment
- Metrics and trends
- Risks and recommendations
- Sign-off status

---

### Communication Plan

#### Stakeholder Updates

| Stakeholder | Frequency | Channel | Content |
|-------------|-----------|---------|---------|
| Product Owner | Daily | Email + Dashboard | Status, blockers, risks |
| Tech Lead | Daily | Slack | Technical issues, env problems |
| Management | Weekly | Meeting | Summary, risks, timeline |
| Legal Team | As needed | Email + Meeting | Compliance questions, findings |
| Development Team | Daily | Slack | Bugs, questions, clarifications |

#### Status Meeting Schedule

**Daily Standup** (15 min):
- What was tested yesterday
- What will be tested today
- Blockers

**Weekly Status Review** (1 hour):
- Test progress vs plan
- Bug metrics and trends
- Risk review and mitigation
- Upcoming activities

**Test Sign-off Meeting** (1 hour):
- Review exit criteria
- Review test summary report
- Discuss open issues
- Obtain stakeholder approval

---

### Metrics & KPIs

#### Test Execution Metrics

| Metric | Formula | Target | Purpose |
|--------|---------|--------|---------|
| Test Case Execution Rate | (Executed / Planned) × 100% | 100% | Track progress |
| Test Pass Rate | (Passed / Executed) × 100% | ≥ 95% | Quality indicator |
| Defect Detection Rate | Bugs found / Test cases executed | N/A | Effectiveness |
| Defect Density | Bugs found / KLOC | < 10 | Code quality |
| Test Coverage | Lines covered / Total lines × 100% | ≥ 85% | Completeness |

#### Defect Metrics

| Metric | Formula | Target | Purpose |
|--------|---------|--------|---------|
| Defect Removal Efficiency | (Found in test / Total found) × 100% | ≥ 95% | Test effectiveness |
| Defect Fix Rate | Fixed bugs / Total bugs × 100% | ≥ 90% | Dev productivity |
| Defect Reopen Rate | Reopened / Fixed × 100% | < 10% | Fix quality |
| Defect Aging | Days since reported | Critical < 1d | Responsiveness |

#### Test Automation Metrics

| Metric | Target | Current |
|--------|--------|---------|
| Automation Coverage | ≥ 80% | [TBD] |
| Automated Test Pass Rate | ≥ 95% | [TBD] |
| Test Execution Time | < 10 minutes | [TBD] |
| Test Flakiness Rate | < 2% | [TBD] |

---

### Sign-off

#### Approval

| Role | Name | Date | Signature | Status | Comments |
|------|------|------|-----------|--------|----------|
| QA Lead | | | | ⏳ Pending | |
| Tech Lead | | | | ⏳ Pending | |
| Product Owner | | | | ⏳ Pending | |
| Legal Reviewer | | | | ⏳ Pending | |
| Release Manager | | | | ⏳ Pending | |

**Approval Criteria**:
- [ ] Test plan is comprehensive and covers all critical areas
- [ ] Resources and timeline are realistic
- [ ] Entry/exit criteria are clear and measurable
- [ ] Risk mitigation strategies are adequate
- [ ] Legal compliance validation is included

---

### Appendices

#### Appendix A: Test Case Repository
[Link to test case management system]

#### Appendix B: Automation Framework Documentation
[Link to automation docs]

#### Appendix C: Test Data Specifications
[Link to test data documentation]

#### Appendix D: Legal Reference Documents
- Labor Standards Act (latest version)
- Ministry of Labor calculator specifications
- Legal compliance checklist

#### Appendix E: Tool Configuration
- pytest configuration
- CI/CD pipeline configuration
- Test environment setup scripts

---
```

## Test Plan Templates by Context

### Sprint Test Plan (Short, 1-2 weeks)
- Focus on feature testing
- Emphasize unit + integration tests
- Quick legal validation
- Minimal documentation

### Release Test Plan (Medium, 3-4 weeks)
- Comprehensive testing
- Full legal compliance validation
- Performance + security testing
- Detailed documentation

### Compliance Audit Plan (Specialized)
- Legal accuracy focus
- Cross-validation with govt tools
- Edge case coverage
- Legal team collaboration

---

## Best Practices

- **Legal modules require extra scrutiny** - Always include legal validation
- **Define clear entry/exit criteria** - Makes decisions objective
- **Cross-validate with government tools** - Gold standard for legal accuracy
- **Risk-based testing** - Prioritize based on legal/business impact
- **Automate repetitive tests** - Frees QA for exploratory testing
- **Track metrics** - Data-driven decisions
- **Daily communication** - Keep stakeholders informed
- **Legal team involvement** - Essential for compliance validation
- **Test early, test often** - Shift-left approach
- **Document assumptions** - Avoid misunderstandings

---

## Example Usage

Input: `/test-plan Sprint 23 - Overtime calculator enhancements`

Output: [Full test plan as shown above, customized for the specific sprint]
