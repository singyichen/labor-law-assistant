---
name: pr-review
description: Comprehensive Pull Request review for Labor Law Assistant. Evaluates PR description, scope, breaking changes, test status, and provides structured feedback. Includes approve/request changes recommendation. Use before merging PRs.
---

You are a Pull Request reviewer with expertise in code quality, git workflows, and Taiwan labor law compliance.

## Instructions

When the user requests PR review via `$ARGUMENTS`:

1. **Analyze** PR metadata (title, description, files changed)
2. **Evaluate** scope and impact of changes
3. **Verify** tests and CI/CD status
4. **Check** breaking changes and migration needs
5. **Review** code quality using code-review checklist
6. **Recommend** approval status with specific feedback

## Output Format

```markdown
## Pull Request Review

### PR Metadata
- **PR Number**: #XXX
- **Title**: [PR Title]
- **Author**: @username
- **Target Branch**: main
- **Source Branch**: feature/overtime-calculation
- **Status**: Open / Draft / Ready for Review
- **Created**: YYYY-MM-DD
- **Last Updated**: YYYY-MM-DD HH:MM

---

### PR Summary

**Changes Overview**:
- **Files Changed**: X files
- **Lines Added**: +XXX
- **Lines Deleted**: -XXX
- **Commits**: X commits

**Component Impact**:
| Component | Files | Impact | Risk |
|-----------|-------|--------|------|
| Legal Calculations | 3 | High | 🔴 High |
| API Endpoints | 2 | Medium | 🟡 Medium |
| Database Models | 1 | Low | 🟢 Low |
| Tests | 8 | - | - |
| Documentation | 2 | - | - |

---

### Description Quality Assessment

**Completeness**: 🟢 Excellent / 🟡 Good / 🟠 Needs Improvement / 🔴 Insufficient

#### Required Elements
- [x] **What**: Clear description of changes
- [x] **Why**: Rationale and business context
- [x] **How**: Implementation approach
- [ ] **Testing**: Test plan and coverage (❌ Missing)
- [x] **Screenshots**: For UI changes (N/A - backend only)
- [x] **Breaking Changes**: Documented migration steps
- [x] **Issue Link**: References #123

#### Suggested Improvements
1. Add test coverage summary (current: X%, target: Y%)
2. Include performance impact assessment
3. Add rollback procedure

**Updated Description Template**:
```markdown
## What
Implement tiered overtime rate calculation per Labor Standards Act Article 24.

## Why
Current implementation uses flat 1.25x rate, violating Article 24 which requires:
- First 2 hours: 1.34x
- Hours 3-4: 1.67x
- Hours 5+: 1.67x

Fixes #123 - Critical legal compliance issue

## How
- Refactored `calculate_overtime()` to use tiered rates
- Added constants for legal multipliers (4/3, 5/3)
- Implemented tier calculation logic
- Added comprehensive tests (15 test cases)

## Testing
- ✅ Unit tests: 95% coverage (target: 95%)
- ✅ Integration tests: All passing
- ✅ Cross-validated with MOL calculator: 100% match
- ✅ BDD scenarios: 3 new scenarios added

## Breaking Changes
⚠️ **API Response Format Changed**

**Old Response**:
\`\`\`json
{"total": 2000}
\`\`\`

**New Response**:
\`\`\`json
{
  "total": 2540,
  "breakdown": {
    "tier1": 536,
    "tier2": 668,
    "tier3": 1336
  },
  "legal_basis": "Labor Standards Act Article 24"
}
\`\`\`

**Migration**: Update API clients to handle new response format. Old `total` field still present for backward compatibility until v3.0.

## Rollback Plan
If issues arise:
1. Revert commit abc123f
2. Redeploy previous version (v2.1.0)
3. No database migration needed (calculation only)
```

---

### Scope Analysis

**Change Scope**: 🟢 Focused / 🟡 Moderate / 🔴 Too Large

**Assessment**: 🟢 **Focused and Well-Scoped**
- Single feature: Overtime calculation fix
- Related changes: Tests, docs, API response
- No unrelated changes mixed in

**Concerns**: None

**If Scope Too Large** (N/A for this PR):
- [ ] Consider splitting into multiple PRs
- [ ] Separate refactoring from feature changes
- [ ] Move unrelated changes to separate PR

---

### Breaking Changes Analysis

**Breaking Changes Present**: ⚠️ Yes (API Response Format)

| Change | Type | Impact | Migration Required |
|--------|------|--------|-------------------|
| API response format | API Contract | Medium | Update API clients |
| Calculation logic | Backend | High | Re-run historical calculations |

#### Impact Assessment

**Affected Systems**:
- Frontend: Must update to handle new response format
- Mobile App: Must update API client
- External Integrations: Email notification to partners

**Backward Compatibility**:
✅ Old `total` field preserved (deprecated, remove in v3.0)
⚠️ New clients should use `breakdown` field

**Migration Steps** (for consumers):
```javascript
// Old code
const total = response.total;

// New code (backward compatible)
const total = response.total;
const breakdown = response.breakdown || {}; // Optional for now

// Recommended new code
const { total, breakdown, legal_basis } = response;
```

**Rollout Plan**:
1. Deploy backend with backward-compatible response
2. Update frontend to use new format (1 week)
3. Update mobile app (2 weeks)
4. Notify external partners (1 month notice)
5. Remove `total`-only response in v3.0 (3 months)

---

### Code Quality Review

#### Summary
| Category | Status | Issues | Critical | High | Medium | Low |
|----------|--------|--------|----------|------|--------|-----|
| Code Quality | 🟢 | 2 | 0 | 0 | 1 | 1 |
| Security | 🟢 | 0 | 0 | 0 | 0 | 0 |
| Performance | 🟢 | 1 | 0 | 0 | 1 | 0 |
| Legal Accuracy | 🟢 | 0 | 0 | 0 | 0 | 0 |
| Testing | 🟡 | 3 | 0 | 1 | 2 | 0 |

**Overall Code Quality**: 🟢 Good

#### Issues Found

**[MEDIUM] Test coverage below target**
- File: `app/api/endpoints/calculator.py`
- Current: 85%, Target: 90%
- Missing: Error response tests (400, 500)
- Action: Add integration tests for error paths

**[MEDIUM] Performance: No caching for law articles**
- File: `app/services/law_reference.py:45`
- Impact: Database query on every calculation
- Recommendation: Add `@lru_cache` for static law articles

**[LOW] Minor: Magic number in code**
- File: `app/calculators/overtime.py:78`
- Current: `if hours > 80:`
- Recommendation: Extract to constant `MAX_MONTHLY_OVERTIME = 80`

**Detailed Review**: See inline comments on PR

---

### Testing Review

#### Test Coverage

| Module | Coverage | Target | Status | Delta |
|--------|----------|--------|--------|-------|
| `calculators/overtime.py` | 95% | 95% | ✅ | +10% |
| `api/endpoints.py` | 85% | 90% | ⚠️ | +5% |
| `services/validation.py` | 100% | 95% | ✅ | +8% |
| **Overall** | **91%** | **90%** | ✅ | **+7%** |

**Test Quality**:
✅ Edge cases covered (0, negative, boundary)
✅ Error handling tested
✅ Cross-validation with government tool
⚠️ Missing integration tests for error responses

#### CI/CD Status

| Check | Status | Details |
|-------|--------|---------|
| Unit Tests | ✅ Passed | 156/156 tests passed |
| Integration Tests | ✅ Passed | 42/42 tests passed |
| BDD Tests | ✅ Passed | 15/15 scenarios passed |
| Linting (Ruff) | ✅ Passed | No issues |
| Type Checking (MyPy) | ✅ Passed | 100% type coverage |
| Security Scan (Bandit) | ✅ Passed | No vulnerabilities |
| Coverage Check | ⚠️ Warning | 91% (target: 90%, ideal: 95%) |

**Build Artifacts**:
- Coverage Report: [link]
- Test Results: [link]
- Security Report: [link]

---

### Legal Compliance Review

**Legal Review Status**: ⏳ Pending Legal Team Approval

#### Compliance Checklist
- [x] Law article references in code
- [x] Formulas match legal requirements
- [x] Cross-validated with government calculator (100% match)
- [x] Disclaimer included in response
- [x] Test cases from official sources
- [ ] Legal team sign-off (⏳ Waiting)

#### Legal Accuracy Verification

| Calculation | Law Reference | Status | Verified By |
|-------------|---------------|--------|-------------|
| Tier 1 Rate (1.34x) | Article 24 §1 | ✅ Correct | Auto-test vs MOL |
| Tier 2 Rate (1.67x) | Article 24 §2 | ✅ Correct | Auto-test vs MOL |
| Tier 3 Rate (1.67x) | Article 24 §2 | ✅ Correct | Auto-test vs MOL |

**Cross-Validation Results**:
```
Test Cases from Ministry of Labor Calculator:
✅ 2 hours @ NT$200/hr = NT$536 (match)
✅ 4 hours @ NT$200/hr = NT$1,204 (match)
✅ 8 hours @ NT$200/hr = NT$2,540 (match)
✅ 2 hours @ NT$183/hr = NT$490.44 (match)

100% match rate (4/4 test cases)
```

**Legal Team Review**:
- Assigned to: @legal-reviewer
- Status: In Progress
- ETA: 2024-02-05

---

### Security Review

**Security Status**: 🟢 No Issues Found

#### Security Checklist
- [x] No hardcoded secrets
- [x] Input validation present (Pydantic models)
- [x] SQL injection protected (ORM used)
- [x] Authentication/authorization unchanged
- [x] No new dependencies with CVEs
- [x] Error messages don't leak sensitive info
- [x] Audit logging in place

**Dependency Changes**: None

**Security Scan Results**: ✅ All passed

---

### Performance Review

**Performance Impact**: 🟢 Minimal / 🟡 Moderate / 🔴 Significant

**Assessment**: 🟢 Minimal Impact

#### Performance Metrics

| Metric | Before | After | Change | Status |
|--------|--------|-------|--------|--------|
| Avg Response Time | 45ms | 47ms | +2ms | ✅ |
| P95 Response Time | 120ms | 125ms | +5ms | ✅ |
| Database Queries | 2 | 2 | 0 | ✅ |
| Memory Usage | 45MB | 45MB | 0 | ✅ |

**Analysis**:
- Slight increase in calculation time due to tiered logic
- Well within acceptable range (< 10% increase)
- No new database queries introduced
- No memory leaks detected

**Load Test Results**: ✅ Passed (1000 req/s sustained)

---

### Database Changes

**Database Migration**: ❌ Not Required

**Schema Changes**: None

**Data Migration**: ⚠️ Recommended (Historical Data)

**Recommendation**:
Consider re-calculating historical overtime records with correct formula:
```sql
-- Identify affected records
SELECT id, hours, old_total, new_total
FROM calculations
WHERE type = 'overtime'
  AND created_at >= '2024-01-15'
  AND old_total != new_total;

-- Estimate: ~5,000 records need recalculation
```

**Action Items**:
- [ ] Create migration script for historical data
- [ ] Schedule maintenance window
- [ ] Communicate to affected users

---

### Documentation Review

**Documentation Status**: 🟢 Complete

#### Documentation Updated
- [x] Code docstrings
- [x] API documentation (OpenAPI)
- [x] README updated
- [x] CHANGELOG updated
- [x] Migration guide (for breaking changes)
- [ ] User guide (⏳ Pending PM review)

#### Documentation Quality
✅ Docstrings include law article references
✅ API examples updated
✅ Breaking changes clearly documented
⚠️ User-facing documentation pending

---

### Dependencies Review

**New Dependencies**: None

**Updated Dependencies**: None

**Dependency Health**: ✅ All dependencies up-to-date, no CVEs

---

### Git Hygiene

**Commit Quality**: 🟢 Good / 🟡 Acceptable / 🔴 Needs Cleanup

#### Commit Analysis
- **Total Commits**: 4
- **Commit Message Format**: ✅ Follows Conventional Commits
- **Atomic Commits**: ✅ Each commit is focused
- **Commit History**: ✅ Clean, linear

#### Commits
1. `feat(calc): implement tiered overtime rates per Article 24`
2. `test(calc): add comprehensive tests for overtime tiers`
3. `docs(api): update API docs for new response format`
4. `fix(calc): correct rounding for tier 2 calculations`

**Issues**: None

**If Cleanup Needed** (N/A):
- [ ] Squash fixup commits
- [ ] Rewrite commit messages
- [ ] Rebase onto main

---

### Risk Assessment

**Overall Risk Level**: 🟡 Medium

| Risk Category | Level | Mitigation |
|---------------|-------|------------|
| Legal Compliance | 🟢 Low | Cross-validated, legal review pending |
| Breaking Changes | 🟡 Medium | Backward-compatible response, migration plan |
| Performance | 🟢 Low | Minimal impact, load tested |
| Security | 🟢 Low | No new vulnerabilities |
| Data Integrity | 🟡 Medium | Historical data needs recalculation |

**Mitigation Plan**:
1. ✅ Backward-compatible API response
2. ⏳ Legal team approval before merge
3. ⏳ Historical data migration script
4. ✅ Rollback plan documented

---

### Review Comments

#### Inline Code Comments

**📝 Comment 1** (app/calculators/overtime.py:78)
```python
if hours > 80:  # ❓ Magic number
    raise ValidationError("Overtime hours cannot exceed 80")
```
**Suggestion**: Extract to constant
```python
MAX_MONTHLY_OVERTIME_HOURS = 80  # Per Labor Standards Act

if hours > MAX_MONTHLY_OVERTIME_HOURS:
    raise ValidationError(
        f"Overtime hours cannot exceed {MAX_MONTHLY_OVERTIME_HOURS} per month"
    )
```
**Priority**: Low

---

**📝 Comment 2** (app/api/endpoints/calculator.py:123)
```python
@router.post("/calculate/overtime")
def calculate_overtime(request: OvertimeRequest):
    result = service.calculate(request)
    return result
```
**Suggestion**: Add error handling and logging
```python
@router.post("/calculate/overtime")
def calculate_overtime(
    request: OvertimeRequest,
    current_user: User = Depends(get_current_user)
):
    try:
        logger.info(f"Overtime calculation requested by user {current_user.id}")
        result = service.calculate(request, user=current_user)
        logger.info(f"Calculation successful: {result.total}")
        return result
    except ValidationError as e:
        logger.warning(f"Validation error: {e}")
        raise HTTPException(status_code=400, detail=str(e))
    except Exception as e:
        logger.error(f"Calculation error: {e}", exc_info=True)
        raise HTTPException(status_code=500, detail="Internal server error")
```
**Priority**: Medium

---

**✅ Positive Comment** (app/calculators/overtime.py:45-67)
```python
def calculate_overtime(hours: Decimal, base_rate: Decimal) -> Decimal:
    """
    Calculate overtime pay per Labor Standards Act Article 24.
    
    Formula (Article 24):
    - First 2 hours: base_rate × 4/3 (1.34)
    ...
    """
```
**Feedback**: Excellent docstring with clear law references and examples. This is exactly what we want for legal calculation modules! 🎉

---

### Reviewer Checklist

#### Pre-Approval Checklist
- [x] Code follows project style guide (CLAUDE.md)
- [x] All tests passing
- [x] Test coverage meets targets (≥90% overall, ≥95% legal modules)
- [x] No security vulnerabilities
- [x] No unintended breaking changes
- [x] Documentation updated
- [x] Commit history clean
- [ ] Legal team approval (⏳ Pending)
- [ ] Error handling tests added (⚠️ Medium priority)

#### Approval Criteria Met
- ✅ Code quality: Excellent
- ✅ Tests: Comprehensive (minor improvements needed)
- ✅ Security: No issues
- ⏳ Legal: Awaiting sign-off
- ✅ Documentation: Complete
- ✅ Performance: Acceptable

---

### Recommendation

**Decision**: ⚠️ **APPROVE WITH COMMENTS**

**Rationale**:
This PR addresses a critical legal compliance issue with a well-designed solution. The code quality is high, tests are comprehensive, and breaking changes are managed appropriately with backward compatibility.

**Required Before Merge**:
1. ⏳ **Legal team approval** (highest priority)
2. ⚠️ **Add error handling tests** for API endpoints (medium priority)
3. 💡 **Extract magic numbers** to constants (low priority, can be follow-up)

**Optional Improvements** (can be separate PR):
- Add caching for law article lookups
- Create historical data migration script
- Improve user-facing documentation

**Estimated Time to Address**: 1-2 days (waiting for legal review)

**Merge Plan**:
1. Wait for legal team approval
2. Developer addresses error handling tests
3. Final review and approval
4. Merge to main
5. Deploy to staging for smoke tests
6. Deploy to production (with monitoring)
7. Schedule historical data recalculation

---

### Action Items

#### For Author (@developer)
- [ ] Add integration tests for error responses (400, 500)
- [ ] Extract `MAX_MONTHLY_OVERTIME_HOURS` constant
- [ ] Add error handling and logging to endpoint
- [ ] Wait for legal team approval

#### For Legal Team (@legal-reviewer)
- [ ] Review calculation formulas against Labor Standards Act
- [ ] Verify cross-validation test cases
- [ ] Approve or request changes

#### For PM (@product-manager)
- [ ] Review user-facing documentation
- [ ] Plan historical data migration communication
- [ ] Schedule deployment

#### For DevOps (@devops)
- [ ] Prepare production deployment checklist
- [ ] Set up monitoring for new response format
- [ ] Plan rollback procedure

---

### Timeline

| Milestone | Owner | Status | ETA |
|-----------|-------|--------|-----|
| Code review complete | Reviewer | ✅ Done | 2024-02-04 |
| Legal review | Legal Team | ⏳ In Progress | 2024-02-05 |
| Address review comments | Developer | 🔴 Not Started | 2024-02-06 |
| Final approval | Tech Lead | ⏳ Pending | 2024-02-06 |
| Merge to main | Developer | ⏳ Pending | 2024-02-06 |
| Deploy to staging | DevOps | ⏳ Pending | 2024-02-06 |
| Deploy to production | DevOps | ⏳ Pending | 2024-02-07 |

**Target Merge Date**: 2024-02-06
**Target Production Date**: 2024-02-07

---

### Review Metadata

**Reviewer**: @senior-developer
**Review Date**: 2024-02-04 14:30
**Time Spent**: 45 minutes
**Review Type**: Full Code Review
**Review Scope**: All changed files (15 files)

**Follow-up**: Schedule post-deployment review meeting to discuss lessons learned.

---
```

## PR Review Guidelines

### Review Priorities

1. **Legal Compliance** (Highest)
   - Calculation accuracy
   - Law article references
   - Legal team approval

2. **Breaking Changes**
   - Impact assessment
   - Migration plan
   - Backward compatibility

3. **Security**
   - No new vulnerabilities
   - Input validation
   - Dependency health

4. **Tests**
   - Coverage targets met
   - Quality of tests
   - CI/CD passing

5. **Code Quality**
   - Readability
   - Maintainability
   - Follows standards

### Review Sizes

| Size | Files | Lines | Review Time | Recommendation |
|------|-------|-------|-------------|----------------|
| Small | 1-5 | < 200 | 15-30 min | ✅ Ideal |
| Medium | 6-15 | 200-500 | 30-60 min | ✅ Good |
| Large | 16-30 | 500-1000 | 1-2 hours | ⚠️ Consider splitting |
| Huge | 30+ | 1000+ | 2+ hours | 🔴 Split required |

### Approval Criteria

| Status | Criteria |
|--------|----------|
| ✅ **Approve** | No blocking issues, all checks pass, ready to merge |
| ⚠️ **Approve with Comments** | Minor issues that can be addressed post-merge or in follow-up PR |
| 🔴 **Request Changes** | Blocking issues must be fixed before merge |
| 💬 **Comment** | Questions or suggestions, not blocking |

---

## Best Practices

- **Be Constructive**: Suggest improvements, don't just point out problems
- **Be Specific**: Include code examples in feedback
- **Prioritize Issues**: Mark critical vs. nice-to-have
- **Recognize Good Work**: Comment on well-written code
- **Focus on Impact**: Legal compliance and security first
- **Consider Context**: Understand the "why" behind changes
- **Timely Reviews**: Respond within 24 hours
- **Ask Questions**: Clarify unclear changes

---

## Example Usage

Input: `/pr-review #123`
Output: [Full PR review as shown above]

Input: `/pr-review --quick`
Output: [Quick summary with approve/reject recommendation]
