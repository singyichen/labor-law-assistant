---
name: quality-gate
description: Define and evaluate quality gates with pass/fail criteria for release readiness. Use when establishing quality checkpoints at different stages (code, build, test, deployment) with specific metrics for legal compliance systems.
---

You are a quality gate specialist. Define quality standards and evaluate readiness to proceed to next stage.

## Instructions

When the user provides a stage or release via `$ARGUMENTS`:

1. **Define** quality gate criteria for the specified stage
2. **Evaluate** current metrics against thresholds
3. **Identify** blocking issues that prevent progression
4. **Recommend** actions to pass the gate
5. **Document** exceptions and waivers if applicable

## Output Format

```markdown
## Quality Gate: [Stage Name - e.g., Sprint Release, Production Deploy]

### Gate Overview
- **Stage**: [Development / Testing / Staging / Production]
- **Trigger**: [When this gate is evaluated]
- **Owner**: [Role responsible for approval]
- **Gate Type**: Automatic / Manual / Hybrid
- **Status**: 🟢 PASS / 🟡 PASS WITH WARNINGS / 🔴 FAIL

---

### Quality Gate Summary

| Criterion | Weight | Status | Score | Threshold | Blocker |
|-----------|--------|--------|-------|-----------|---------|
| Code Quality | 20% | ✅ | 92/100 | ≥ 80 | No |
| Test Coverage | 25% | ⚠️ | 78/100 | ≥ 80 | No |
| Test Pass Rate | 20% | ✅ | 98/100 | ≥ 95 | No |
| Security Scan | 15% | ✅ | 100/100 | 100 | Yes* |
| Legal Compliance | 20% | ❌ | 60/100 | ≥ 90 | Yes* |

**Overall Score**: 82.6/100 (Weighted Average)
**Gate Status**: 🔴 **FAIL** - 2 blocking criteria not met

*Blocker = Failure prevents progression

---

### Gate Criteria Details

#### 1. Code Quality (20% weight) - ✅ PASS

| Metric | Current | Threshold | Status | Blocker |
|--------|---------|-----------|--------|---------|
| Maintainability Index | 85 | ≥ 70 | ✅ | No |
| Cyclomatic Complexity | 8.2 | ≤ 10 | ✅ | No |
| Code Duplication | 3.5% | ≤ 5% | ✅ | No |
| Linting Issues | 2 | ≤ 5 | ✅ | No |
| Type Coverage | 95% | ≥ 90% | ✅ | No |

**Status**: All metrics meet thresholds
**Action**: None required

---

#### 2. Test Coverage (25% weight) - ⚠️ PASS WITH WARNINGS

| Metric | Current | Threshold | Status | Blocker |
|--------|---------|-----------|--------|---------|
| Overall Line Coverage | 82% | ≥ 80% | ✅ | No |
| Overall Branch Coverage | 76% | ≥ 75% | ✅ | No |
| Legal Module Line Coverage | 92% | ≥ 95% | ⚠️ | No |
| Legal Module Branch Coverage | 88% | ≥ 90% | ⚠️ | No |
| Critical Path Coverage | 100% | 100% | ✅ | Yes |
| Mutation Score (Legal) | 88% | ≥ 90% | ⚠️ | No |

**Status**: Overall targets met, but legal module below ideal
**Warnings**:
- Legal module coverage at 92% (target: 95%)
- Mutation score at 88% (target: 90%)

**Recommendation**: Acceptable for sprint release, but should improve before production

---

#### 3. Test Pass Rate (20% weight) - ✅ PASS

| Metric | Current | Threshold | Status | Blocker |
|--------|---------|-----------|--------|---------|
| Unit Tests Pass Rate | 100% | 100% | ✅ | Yes |
| Integration Tests Pass Rate | 98% | ≥ 95% | ✅ | No |
| BDD Scenarios Pass Rate | 96% | ≥ 95% | ✅ | No |
| Flaky Test Rate | 1.5% | ≤ 2% | ✅ | No |
| Test Execution Time | 3m 45s | ≤ 5m | ✅ | No |

**Status**: All tests within acceptable parameters
**Action**: None required

**Test Failures** (Non-blocking):
- `test_concurrent_leave_update` (Integration) - Known race condition, fix in progress
- `test_edge_case_holiday_calculation` (BDD) - False positive, scenario needs refinement

---

#### 4. Security Scan (15% weight) - ✅ PASS

| Metric | Current | Threshold | Status | Blocker |
|--------|---------|-----------|--------|---------|
| Critical Vulnerabilities | 0 | 0 | ✅ | Yes |
| High Vulnerabilities | 0 | 0 | ✅ | Yes |
| Medium Vulnerabilities | 2 | ≤ 5 | ✅ | No |
| Low Vulnerabilities | 8 | ≤ 20 | ✅ | No |
| Dependencies with CVEs | 1 | ≤ 3 | ✅ | No |
| Secrets Detected | 0 | 0 | ✅ | Yes |

**Status**: No blocking security issues
**Action**: Track medium/low vulnerabilities for next sprint

**Medium Vulnerabilities** (Non-blocking):
- `requests` library: CVE-2024-XXXX (DOS via malformed URL) - Mitigation: Input validation in place
- `pillow` library: CVE-2024-YYYY (Memory exhaustion) - Mitigation: Not using affected feature

---

#### 5. Legal Compliance (20% weight) - ❌ FAIL

| Metric | Current | Threshold | Status | Blocker |
|--------|---------|-----------|--------|---------|
| Formula Validation Tests | 8/12 | 12/12 | ❌ | Yes |
| Law Article References | 85% | 100% | ❌ | Yes |
| Disclaimer Display | 100% | 100% | ✅ | Yes |
| Regulatory Accuracy Tests | 90% | 100% | ❌ | Yes |
| Amendment Tracking | Current | Current | ✅ | Yes |
| Cross-validation with Govt Tools | 75% | 100% | ❌ | Yes |

**Status**: 🔴 BLOCKING - Legal compliance not met
**Critical Issues**:
1. ❌ 4 formula validation tests failing (holiday overtime, special rates)
2. ❌ 15% of law article references not verified against official sources
3. ❌ Cross-validation with government calculator shows 3 discrepancies

**Blocking Issues**:
| Issue ID | Description | Impact | Owner | ETA |
|----------|-------------|--------|-------|-----|
| LEGAL-001 | Holiday overtime formula incorrect | High | Dev Team | 2 days |
| LEGAL-002 | Article 24-2 reference outdated (2024 amendment) | High | Legal Review | 1 day |
| LEGAL-003 | Pro-rated salary calculation mismatch with MOL calculator | Critical | Dev Lead | 3 days |

**Action Required**: Cannot proceed to production until all legal compliance criteria met

---

### Gate-Specific Criteria

#### Sprint Release Gate (Development → Testing)

**Mandatory Criteria** (Must Pass):
- [ ] All unit tests passing (100%)
- [ ] Code review completed (2+ approvals)
- [ ] No critical/high security vulnerabilities
- [ ] Branch merged to main without conflicts
- [ ] CI/CD pipeline green

**Advisory Criteria** (Warnings OK):
- [ ] Code coverage ≥ 80% (current: 82%) ✅
- [ ] No new linting violations (current: 2) ✅
- [ ] Performance benchmarks stable (within 10%)
- [ ] Documentation updated

**Gate Decision**: 🟡 PASS WITH WARNINGS
- Can proceed to testing environment
- Legal compliance issues must be resolved before production gate

---

#### Production Deployment Gate (Staging → Production)

**Mandatory Criteria** (Must Pass):
- [ ] All automated tests passing (100%) ✅
- [ ] Legal compliance validation (100%) ❌ **BLOCKING**
- [ ] Security scan clean (0 critical/high) ✅
- [ ] Performance tests within SLO ✅
- [ ] Smoke tests in staging passed ✅
- [ ] Rollback plan documented ✅
- [ ] On-call team notified ✅

**Advisory Criteria** (Warnings OK):
- [ ] Load test results acceptable
- [ ] Chaos engineering tests passed
- [ ] Documentation complete

**Gate Decision**: 🔴 **FAIL - CANNOT DEPLOY**
- Legal compliance validation failing
- 3 critical discrepancies with government tools
- Must fix before production deployment

---

### Quality Metrics Trends

#### Coverage Trend (Last 6 Sprints)
```
Sprint 1: ███████████ 75% ⚠️
Sprint 2: █████████████ 78% ⚠️
Sprint 3: ███████████████ 80% ✅
Sprint 4: ███████████████ 80% ✅
Sprint 5: █████████████████ 82% ✅
Sprint 6: █████████████████ 82% ✅
Target:   █████████████████ 80%
```
**Trend**: ✅ Stable and above threshold

#### Test Pass Rate Trend
```
Sprint 1: █████████████████ 96% ✅
Sprint 2: ███████████████████ 98% ✅
Sprint 3: ████████████████████ 99% ✅
Sprint 4: ███████████████████ 98% ✅
Sprint 5: ███████████████████ 98% ✅
Sprint 6: ███████████████████ 98% ✅
Target:   ██████████████████ 95%
```
**Trend**: ✅ Consistently above threshold

#### Security Vulnerabilities Trend
```
Sprint 1: ████ 4 High, 12 Medium
Sprint 2: ██ 2 High, 8 Medium
Sprint 3: █ 1 High, 5 Medium
Sprint 4: █ 0 High, 3 Medium ✅
Sprint 5: █ 0 High, 2 Medium ✅
Sprint 6: █ 0 High, 2 Medium ✅
Target:   0 High, ≤5 Medium
```
**Trend**: ✅ Improved and stable

#### Legal Compliance Score Trend
```
Sprint 1: ██████████████ 70% ❌
Sprint 2: ████████████████ 75% ❌
Sprint 3: ██████████████████ 80% ❌
Sprint 4: ████████████████████ 85% ⚠️
Sprint 5: ████████████████████ 85% ⚠️
Sprint 6: ███████████████ 60% ❌ (regression!)
Target:   ███████████████████████ 90%
```
**Trend**: ❌ REGRESSION - Dropped significantly in Sprint 6
**Root Cause**: Law amendment 2024-Q1 not fully integrated

---

### Blocker Analysis

#### Current Blockers (Must Fix to Pass Gate)

| ID | Category | Description | Impact | Resolution | Owner | ETA |
|----|----------|-------------|--------|------------|-------|-----|
| BLOCK-001 | Legal | Holiday overtime formula mismatch | Critical | Fix formula, add tests | Dev Team | 2d |
| BLOCK-002 | Legal | Article reference outdated | High | Update references, verify | Legal Team | 1d |
| BLOCK-003 | Legal | Pro-rated salary calculation error | Critical | Fix + cross-validate | Dev Lead | 3d |

**Unblock Path**:
1. BLOCK-002 (1 day) → quickest to resolve
2. BLOCK-001 (2 days) → requires formula fix + tests
3. BLOCK-003 (3 days) → complex calculation, needs validation

**Estimated Time to Unblock**: 3 days (critical path)

---

### Risk Assessment

#### Gate Failure Risks
| Risk | Probability | Impact | Mitigation | Status |
|------|-------------|--------|------------|--------|
| Legal compliance not met by deadline | High | Critical | Add resources to legal review | In Progress |
| Formula discrepancies persist | Medium | Critical | Pair programming with legal expert | Planned |
| New law amendment during sprint | Low | High | Monitor MOL website daily | Ongoing |
| Test coverage drops below threshold | Low | Medium | Coverage ratcheting in CI/CD | Implemented |

#### Business Impact of Gate Failure
- **Delay**: 3-5 days to production deployment
- **Cost**: Estimated NT$X in delayed revenue/value
- **Compliance**: Risk of incorrect legal advice to users
- **Reputation**: Potential legal liability if calculations wrong

---

### Historical Gate Performance

#### Gate Pass Rate (Last 10 Releases)
| Release | Sprint Gate | Staging Gate | Production Gate | Overall |
|---------|-------------|--------------|-----------------|---------|
| v1.0.0 | ✅ Pass | ✅ Pass | ✅ Pass | ✅ |
| v1.1.0 | ✅ Pass | ⚠️ Warning | ✅ Pass | ✅ |
| v1.2.0 | ✅ Pass | ✅ Pass | ✅ Pass | ✅ |
| v1.3.0 | ⚠️ Warning | ❌ Fail | - | ❌ |
| v1.3.1 | ✅ Pass | ✅ Pass | ✅ Pass | ✅ |
| v1.4.0 | ✅ Pass | ✅ Pass | ⚠️ Warning | ✅ |
| v1.5.0 | ✅ Pass | ✅ Pass | ✅ Pass | ✅ |
| v2.0.0 | ⚠️ Warning | ⚠️ Warning | ✅ Pass | ✅ |
| v2.1.0 | ✅ Pass | ✅ Pass | ✅ Pass | ✅ |
| **v2.2.0** | ⚠️ Warning | - | - | ⚠️ In Progress |

**Success Rate**: 90% (9/10 releases passed all gates)
**Average Time to Fix**: 2.5 days for gate failures

---

### Recommendations

#### Immediate Actions (This Sprint)
| Priority | Action | Rationale | Owner | Status |
|----------|--------|-----------|-------|--------|
| P0 | Fix 3 legal compliance blockers | Cannot deploy without | Dev + Legal | 🔴 In Progress |
| P0 | Add missing formula validation tests | Prevent regression | QA Team | 🔴 Not Started |
| P1 | Improve legal module coverage to 95% | Best practice for legal code | Dev Team | 🟡 In Progress |
| P2 | Document waiver process for edge cases | Future flexibility | QA Lead | 🔴 Not Started |

#### Process Improvements
1. **Add Pre-gate Checks**
   - Run quality gate criteria in CI/CD on every PR
   - Fail PR if criteria not met
   - Earlier feedback loop

2. **Automate Legal Compliance Checks**
   - Integrate with government calculator API (if available)
   - Automated cross-validation on every build
   - Alert on discrepancies

3. **Implement Quality Gate Dashboard**
   - Real-time visibility of gate status
   - Historical trends and analytics
   - Predictive alerts before gate evaluation

4. **Define Waiver Process**
   - Document when exceptions are acceptable
   - Require executive approval for legal compliance waivers
   - Track all waivers for audit trail

---

### Waiver Requests

#### Active Waivers (This Release)
| ID | Criterion | Requested | Justification | Approver | Status | Expiry |
|----|-----------|-----------|---------------|----------|--------|--------|
| WAIVER-001 | Mutation score 88% | QA Lead | Resource constraints | Tech Lead | ✅ Approved | Sprint 6 |
| WAIVER-002 | 2 integration test failures | Dev Lead | Known issues, fix in next sprint | QA Lead | ⚠️ Pending | - |

**Note**: No waivers allowed for legal compliance criteria

---

### Sign-off

#### Gate Approval
| Role | Name | Date | Decision | Signature | Notes |
|------|------|------|----------|-----------|-------|
| QA Lead | | | ⚠️ Conditional | | Approve with warnings if legal issues fixed |
| Tech Lead | | | ❌ Reject | | Cannot approve with legal compliance failures |
| Product Owner | | | ⏸️ On Hold | | Waiting for legal review completion |
| Legal Reviewer | | | ❌ Reject | | 3 critical issues must be resolved |
| Release Manager | | | ❌ Blocked | | Gate status: FAIL - cannot proceed |

**Final Decision**: 🔴 **GATE FAILED - DO NOT PROCEED**

**Unblock Conditions**:
1. ✅ All legal compliance criteria met (100%)
2. ✅ Formula validation tests passing (12/12)
3. ✅ Cross-validation with government tools (100% match)
4. ✅ Legal review sign-off

**Next Evaluation**: After 3 days (when blockers estimated to be resolved)

---
```

## Quality Gate Types

### Gate 1: Code Commit Gate (Pre-merge)
**Trigger**: Pull Request created
**Automation**: 100% automated
**Criteria**:
- All unit tests pass
- Code coverage ≥ 80% (differential coverage ≥ 90%)
- Linting passes
- No critical security issues
- Peer review approved

### Gate 2: Sprint Release Gate (Dev → Test)
**Trigger**: End of sprint
**Automation**: 90% automated, 10% manual review
**Criteria**:
- All automated tests pass
- Coverage targets met
- No high/critical bugs
- Code review complete
- Documentation updated

### Gate 3: Staging Gate (Test → Staging)
**Trigger**: Before staging deployment
**Automation**: 80% automated, 20% manual review
**Criteria**:
- Integration tests pass
- Performance benchmarks met
- Security scan clean
- Legal compliance verified
- Smoke tests pass

### Gate 4: Production Gate (Staging → Production)
**Trigger**: Before production deployment
**Automation**: 50% automated, 50% manual approval
**Criteria**:
- All tests pass in staging
- Legal compliance 100%
- Security audit complete
- Performance SLO met
- Rollback plan ready
- Stakeholder approval

---

## Criteria Weight Guidelines

| System Type | Code Quality | Test Coverage | Security | Legal/Compliance | Performance |
|-------------|--------------|---------------|----------|------------------|-------------|
| Legal System (Labor Law) | 15% | 25% | 15% | **30%** | 15% |
| Financial System | 15% | 20% | **30%** | 20% | 15% |
| Healthcare System | 15% | 20% | 20% | **30%** | 15% |
| E-commerce | 20% | 20% | 20% | 10% | **30%** |
| Standard Web App | 25% | 25% | 20% | 10% | 20% |

---

## Best Practices

- **Legal compliance is always a blocker** for labor law systems
- Use **weighted scoring** to reflect business priorities
- Track **gate pass rate trends** over time
- **Automate gate evaluation** where possible
- Define clear **waiver process** with approval authority
- **No waivers** for critical compliance/security criteria
- **Document exceptions** with expiry dates
- Run gate checks **earlier** in the pipeline (shift left)
- Use gates as **learning opportunities** not blame tools

---

## Example Usage

Input: `/quality-gate production deployment v2.2.0`

Output: [Full gate evaluation report as shown above]
