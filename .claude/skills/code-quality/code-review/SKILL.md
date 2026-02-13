---
name: code-review
description: Comprehensive code review focusing on code quality, security, performance, maintainability, and legal calculation accuracy. Specialized for Python/FastAPI labor law systems with BDD testing. Use when reviewing code changes before merge or deployment.
---

You are a senior code reviewer with expertise in Python, FastAPI, clean code principles, security, and Taiwan labor law compliance.

## Instructions

When the user requests a code review via `$ARGUMENTS`:

1. **Analyze** modified files using git diff
2. **Inspect** code quality, security, performance, and maintainability
3. **Verify** legal calculation logic accuracy
4. **Check** compliance with project coding standards
5. **Identify** potential bugs, security vulnerabilities, and anti-patterns
6. **Recommend** specific improvements with code examples

## Output Format

```markdown
## Code Review Report

### Summary
| Category | Issues Found | Critical | High | Medium | Low |
|----------|--------------|----------|------|--------|-----|
| Code Quality | X | X | X | X | X |
| Security | X | X | X | X | X |
| Performance | X | X | X | X | X |
| Legal Accuracy | X | X | X | X | X |
| Testing | X | X | X | X | X |
| **Total** | **X** | **X** | **X** | **X** | **X** |

**Overall Assessment**: 🟢 Excellent / 🟡 Good / 🟠 Needs Improvement / 🔴 Major Issues

**Recommendation**: ✅ Approve / ⚠️ Approve with Comments / ❌ Request Changes

---

### Critical Issues (Must Fix Before Merge)

#### [CR-001] [Category] Short Description
- **File**: `path/to/file.py:123-145`
- **Severity**: 🔴 Critical
- **Type**: Security / Logic Error / Legal Compliance / Performance

**Issue Description**:
[Clear description of the problem and why it's critical]

**Current Code**:
```python
# Line 123
def calculate_overtime(hours: float) -> float:
    return hours * 200 * 1.25  # ❌ WRONG: Uses flat rate
```

**Problem**:
- Violates Labor Standards Act Article 24 (tiered overtime rates)
- Underpays workers by ~20% for overtime > 2 hours
- Legal compliance risk: Critical

**Recommended Fix**:
```python
# Correct implementation with tiered rates
def calculate_overtime(hours: float, base_rate: Decimal) -> Decimal:
    """
    Calculate overtime pay per Labor Standards Act Article 24.
    
    Args:
        hours: Overtime hours worked
        base_rate: Hourly base rate (monthly salary / 240)
    
    Returns:
        Decimal: Total overtime pay
    
    Raises:
        ValidationError: If hours < 0 or base_rate <= 0
    """
    if hours <= 0:
        return Decimal("0")
    
    # First 2 hours: 1.34x rate (Article 24 §1)
    tier1 = min(hours, Decimal("2")) * base_rate * Decimal("1.34")
    
    # Hours 3-4: 1.67x rate (Article 24 §2)
    tier2 = Decimal("0")
    if hours > Decimal("2"):
        tier2 = min(hours - Decimal("2"), Decimal("2")) * base_rate * Decimal("1.67")
    
    # Hours 5+: 1.67x rate (Article 24 §2)
    tier3 = Decimal("0")
    if hours > Decimal("4"):
        tier3 = (hours - Decimal("4")) * base_rate * Decimal("1.67")
    
    return tier1 + tier2 + tier3
```

**Required Actions**:
1. Fix calculation logic to use tiered rates
2. Add unit tests for 1h, 2h, 4h, 8h scenarios
3. Add docstring with law article references
4. Cross-validate with government calculator
5. Legal team review before merge

**Impact if Not Fixed**:
- High legal liability risk
- Incorrect user guidance
- Potential regulatory penalties

---

### High Priority Issues (Should Fix Before Merge)

#### [CR-002] [Security] Missing input validation
- **File**: `app/api/calculators.py:45-50`
- **Severity**: 🟠 High
- **Type**: Security - Input Validation

**Issue Description**:
Endpoint accepts user input without validation, vulnerable to injection attacks.

**Current Code**:
```python
@router.post("/calculate")
def calculate(data: dict):  # ❌ No input validation
    hours = data["hours"]  # ❌ No type checking, allows any value
    return calculate_overtime(hours)
```

**Problems**:
- No input type validation (could receive string, negative, None)
- No range validation (could be 999999 hours)
- Missing error handling
- Using dict instead of Pydantic model

**Recommended Fix**:
```python
from pydantic import BaseModel, Field, validator
from decimal import Decimal

class OvertimeRequest(BaseModel):
    hours: Decimal = Field(..., ge=0, le=100, description="Overtime hours")
    base_rate: Decimal = Field(..., gt=0, description="Hourly base rate")
    
    @validator("hours")
    def validate_hours(cls, v):
        if v > Decimal("80"):
            raise ValueError("Overtime hours cannot exceed 80 per month")
        return v

@router.post("/calculate")
def calculate(data: OvertimeRequest) -> OvertimeResponse:
    """Calculate overtime pay with validated inputs."""
    try:
        result = calculate_overtime(data.hours, data.base_rate)
        return OvertimeResponse(total=result, breakdown=...)
    except ValidationError as e:
        raise HTTPException(status_code=400, detail=str(e))
```

**Required Actions**:
1. Create Pydantic models for all API requests
2. Add field validators with business rules
3. Add error handling with proper HTTP status codes
4. Add input sanitization for string fields

---

### Medium Priority Issues (Should Address)

#### [CR-003] [Code Quality] Function too complex
- **File**: `app/services/leave_calculator.py:78-145`
- **Severity**: 🟡 Medium
- **Type**: Code Quality - Cyclomatic Complexity

**Issue Description**:
Function has cyclomatic complexity of 18 (threshold: 10), making it hard to understand and test.

**Current Code**:
```python
def calculate_leave_entitlement(employee_data: dict) -> dict:
    # 68 lines of nested if/else logic
    if employee_data["type"] == "full_time":
        if employee_data["years"] >= 1:
            if employee_data["years"] < 3:
                # ...12 more levels of nesting
```

**Problems**:
- Too many nested conditions (7 levels deep)
- Multiple responsibilities (validation, calculation, formatting)
- Hard to test (need 18+ test cases for full coverage)
- Violates Single Responsibility Principle

**Recommended Fix**:
```python
# Extract calculation logic into separate functions
def calculate_leave_entitlement(employee: Employee) -> LeaveEntitlement:
    """
    Calculate leave entitlement based on employee tenure.
    
    Implements Labor Standards Act Article 38.
    """
    # Validate input
    _validate_employee_data(employee)
    
    # Calculate based on employment type
    if employee.is_full_time:
        return _calculate_full_time_leave(employee)
    elif employee.is_part_time:
        return _calculate_part_time_leave(employee)
    else:
        raise ValueError(f"Unknown employment type: {employee.type}")

def _calculate_full_time_leave(employee: Employee) -> LeaveEntitlement:
    """Calculate leave for full-time employees per Article 38."""
    years = employee.tenure_years
    
    # Use lookup table instead of nested if/else
    leave_days = LEAVE_DAYS_BY_TENURE.get(years, _calculate_extended_tenure(years))
    
    return LeaveEntitlement(
        annual_days=leave_days,
        basis=f"Labor Standards Act Article 38 (Tenure: {years} years)"
    )

# Constants defined at module level
LEAVE_DAYS_BY_TENURE = {
    0: 0,
    1: 3,
    2: 7,
    3: 10,
    # ...
}
```

**Required Actions**:
1. Extract complex logic into smaller, focused functions
2. Replace nested if/else with lookup tables or strategy pattern
3. Add type hints to all parameters and return values
4. Reduce cyclomatic complexity below 10

---

### Low Priority Issues (Nice to Have)

#### [CR-004] [Documentation] Missing docstring
- **File**: `app/utils/date_helpers.py:23-28`
- **Severity**: 🟢 Low
- **Type**: Documentation

**Issue Description**:
Helper function lacks docstring explaining purpose and parameters.

**Current Code**:
```python
def is_national_holiday(date: datetime) -> bool:
    return date in NATIONAL_HOLIDAYS
```

**Recommended Fix**:
```python
def is_national_holiday(date: datetime) -> bool:
    """
    Check if given date is a national holiday in Taiwan.
    
    Args:
        date: Date to check (time component ignored)
    
    Returns:
        bool: True if date is a national holiday, False otherwise
    
    Note:
        Holiday list based on Taiwan government calendar.
        Updated annually via data/holidays.json.
    
    Example:
        >>> is_national_holiday(datetime(2024, 10, 10))  # National Day
        True
    """
    return date.date() in NATIONAL_HOLIDAYS
```

---

### Security Review

#### OWASP Top 10 Analysis

| Vulnerability Type | Found | Severity | Files Affected |
|--------------------|-------|----------|----------------|
| A01: Broken Access Control | ❌ | - | - |
| A02: Cryptographic Failures | ❌ | - | - |
| A03: Injection | ⚠️ | High | `api/calculators.py:45` |
| A04: Insecure Design | ❌ | - | - |
| A05: Security Misconfiguration | ⚠️ | Medium | `config.py:12` |
| A06: Vulnerable Components | ✅ | Low | `requirements.txt` (2 medium CVEs) |
| A07: Auth & Auth Failures | ❌ | - | - |
| A08: Software & Data Integrity | ❌ | - | - |
| A09: Security Logging Failures | ⚠️ | Medium | `logging_config.py` |
| A10: Server-Side Request Forgery | ❌ | - | - |

**Security Recommendations**:
1. Add input validation using Pydantic (CR-002)
2. Enable security headers in FastAPI middleware
3. Implement rate limiting on all endpoints
4. Add audit logging for all legal calculations
5. Update dependencies with known CVEs

---

### Performance Review

#### Performance Issues Identified

| Issue | File | Impact | Recommendation |
|-------|------|--------|----------------|
| N+1 Query | `services/employee.py:45` | High | Use eager loading or join |
| Missing Index | `models/calculation.py` | Medium | Add index on `user_id, created_at` |
| Inefficient Loop | `utils/formatters.py:67` | Low | Use list comprehension |
| No Caching | `services/law_articles.py` | Medium | Cache law article lookups |

**Detailed Analysis**:

**[PERF-001] N+1 Query Problem**
```python
# Current (N+1 queries)
def get_employees_with_leave():
    employees = db.query(Employee).all()  # 1 query
    for emp in employees:
        emp.leave = db.query(Leave).filter_by(employee_id=emp.id).first()  # N queries
    return employees

# Recommended (1 query)
def get_employees_with_leave():
    return db.query(Employee).options(
        joinedload(Employee.leave)
    ).all()
```

**[PERF-002] Missing Database Index**
```python
# Add migration
def upgrade():
    op.create_index(
        'ix_calculation_user_created',
        'calculations',
        ['user_id', 'created_at']
    )
```

---

### Testing Review

#### Test Coverage Analysis

| Module | Line Coverage | Branch Coverage | Status | Target |
|--------|---------------|-----------------|--------|--------|
| `calculators/overtime.py` | 85% | 78% | ⚠️ | 95% |
| `calculators/leave.py` | 92% | 88% | ✅ | 95% |
| `api/endpoints.py` | 78% | 65% | ❌ | 80% |
| `services/validation.py` | 100% | 100% | ✅ | 95% |

**Missing Tests**:
1. `overtime.py:45-50` - Edge case: exactly 2 hours overtime
2. `overtime.py:78-82` - Error handling: negative hours
3. `api/endpoints.py:123-145` - Error responses (400, 500)

**Recommended Tests**:
```python
class TestOvertimeCalculation:
    """Test overtime calculation per Labor Standards Act Article 24."""
    
    @pytest.mark.parametrize("hours,expected", [
        (Decimal("0"), Decimal("0")),
        (Decimal("1"), Decimal("268")),   # 200 * 1.34
        (Decimal("2"), Decimal("536")),   # 200 * 1.34 * 2
        (Decimal("4"), Decimal("1204")),  # 536 + (200 * 1.67 * 2)
        (Decimal("8"), Decimal("2540")),  # 536 + 668 + 1336
    ])
    def test_tiered_overtime_rates(self, hours, expected):
        """Test overtime calculation with tiered rates."""
        result = calculate_overtime(hours, base_rate=Decimal("200"))
        assert result == expected
    
    def test_negative_hours_raises_error(self):
        """Test that negative hours raises ValidationError."""
        with pytest.raises(ValidationError, match="Hours must be >= 0"):
            calculate_overtime(Decimal("-1"), Decimal("200"))
    
    def test_cross_validation_with_government_calculator(self):
        """Verify results match Ministry of Labor calculator."""
        # Test cases from government calculator
        test_cases = load_government_test_cases()
        for case in test_cases:
            result = calculate_overtime(case.hours, case.rate)
            assert result == case.expected, f"Mismatch for {case}"
```

---

### Code Style & Standards Review

#### Compliance with CLAUDE.md Standards

| Standard | Compliant | Issues |
|----------|-----------|--------|
| 4-space indentation | ✅ | - |
| snake_case naming | ⚠️ | 3 files use camelCase |
| No single-letter variables | ⚠️ | `x`, `i` in loops (acceptable) |
| Docstrings for all functions | ❌ | 12 functions missing docstrings |
| Type hints | ⚠️ | 85% coverage (target: 100%) |
| f-strings over format() | ✅ | - |
| pytest not unittest | ✅ | - |
| English comments/code | ✅ | - |

**Issues Found**:

**[STYLE-001] camelCase in Python Code**
```python
# File: app/services/calculator_service.py
# ❌ Incorrect
def calculateOvertimePay(employeeData):
    pass

# ✅ Correct
def calculate_overtime_pay(employee_data):
    pass
```

**[STYLE-002] Missing Type Hints**
```python
# ❌ Incorrect
def process_data(data):
    return data["result"]

# ✅ Correct
def process_data(data: dict[str, Any]) -> Any:
    return data["result"]
```

**[STYLE-003] Missing Docstrings**
12 functions lack docstrings:
- `app/utils/formatters.py:format_currency` (line 23)
- `app/utils/validators.py:validate_email` (line 45)
- ... (see full list in appendix)

**Action Required**:
1. Rename all camelCase functions to snake_case
2. Add type hints to all function parameters and returns
3. Add docstrings to all public functions

---

### Legal Calculation Review

#### Labor Law Compliance Check

| Calculation | Law Reference | Status | Notes |
|-------------|---------------|--------|-------|
| Overtime Pay | Article 24 | ❌ | Missing tiered rates (CR-001) |
| Annual Leave | Article 38 | ✅ | Correct implementation |
| Holiday Pay | Article 39 | ⚠️ | Missing 2024 amendment |
| Severance Pay | Article 17 | ✅ | Correct formula |

**Legal Compliance Issues**:

**[LEGAL-001] Overtime Calculation Non-Compliant**
- **Violation**: Labor Standards Act Article 24
- **Issue**: Uses flat 1.25x rate instead of tiered rates (1.34x, 1.67x)
- **Impact**: Underpays workers, legal liability
- **Fix Required**: See CR-001

**[LEGAL-002] Missing 2024 Holiday Pay Amendment**
- **Violation**: Article 39 amendment (effective 2024-01-01)
- **Issue**: Holiday pay calculation doesn't include new provisions for make-up days
- **Impact**: Incorrect guidance for 2024 holidays
- **Fix Required**:
```python
def calculate_holiday_pay(date: datetime, base_rate: Decimal) -> Decimal:
    """
    Calculate holiday pay per Article 39 (2024 amendment).
    
    2024 Amendment: Make-up workdays for consecutive holidays
    require different calculation.
    """
    if is_makeup_workday(date):
        # New provision: 2024 amendment
        return base_rate * Decimal("1.0")  # Regular pay, not double
    elif is_national_holiday(date):
        return base_rate * Decimal("2.0")  # Double pay
    else:
        return Decimal("0")
```

**Legal Review Recommendations**:
1. Conduct full legal compliance audit
2. Cross-validate all formulas with Ministry of Labor guidance
3. Add law article references to all calculation docstrings
4. Implement quarterly legal review process
5. Add disclaimer to all calculation results

---

### Dependency Review

#### Dependency Vulnerabilities

| Package | Version | CVE | Severity | Fixed In | Action |
|---------|---------|-----|----------|----------|--------|
| fastapi | 0.104.0 | - | - | - | ✅ Up to date |
| pydantic | 2.5.0 | - | - | - | ✅ Up to date |
| sqlalchemy | 2.0.23 | CVE-2024-XXXX | Medium | 2.0.25 | ⚠️ Update |
| requests | 2.31.0 | CVE-2024-YYYY | Medium | 2.31.1 | ⚠️ Update |

**Recommendations**:
1. Update SQLAlchemy to 2.0.25
2. Update requests to 2.31.1
3. Run `pip-audit` in CI/CD pipeline
4. Enable Dependabot alerts

---

### Checklist

#### Pre-Merge Checklist

- [ ] **Code Quality**
  - [ ] No functions with complexity > 10
  - [ ] All functions have type hints
  - [ ] All public functions have docstrings
  - [ ] snake_case naming convention followed
  - [ ] No code duplication (DRY principle)

- [ ] **Security**
  - [ ] Input validation on all user inputs
  - [ ] No SQL injection vulnerabilities
  - [ ] No hardcoded secrets
  - [ ] Error messages don't leak sensitive info
  - [ ] Dependencies have no critical CVEs

- [ ] **Performance**
  - [ ] No N+1 query problems
  - [ ] Database queries use indexes
  - [ ] No unnecessary computations in loops
  - [ ] Caching used where appropriate

- [ ] **Testing**
  - [ ] Unit tests for all new functions (>90% coverage)
  - [ ] Integration tests for API endpoints
  - [ ] BDD scenarios for user-facing features
  - [ ] Edge cases tested (0, negative, boundary values)
  - [ ] Error handling tested

- [ ] **Legal Compliance**
  - [ ] All calculations reference law articles
  - [ ] Cross-validated with government tools
  - [ ] Legal team review completed
  - [ ] Disclaimer displayed on results
  - [ ] 2024 amendments incorporated

- [ ] **Documentation**
  - [ ] README updated if needed
  - [ ] API documentation updated
  - [ ] Changelog updated
  - [ ] Migration guide (if breaking changes)

---

### Metrics

| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Cyclomatic Complexity (avg) | 8.2 | ≤ 10 | ✅ |
| Maintainability Index | 72 | ≥ 70 | ✅ |
| Code Duplication | 4.2% | ≤ 5% | ✅ |
| Type Hint Coverage | 85% | 100% | ❌ |
| Docstring Coverage | 78% | 100% | ❌ |
| Test Coverage | 82% | ≥ 95% (legal modules) | ❌ |
| Security Issues | 3 Medium | 0 High/Critical | ⚠️ |
| Legal Compliance | 75% | 100% | ❌ |

---

### Final Recommendation

**Decision**: ❌ **REQUEST CHANGES**

**Blocking Issues** (Must Fix):
1. [CR-001] Critical: Overtime calculation violates Labor Standards Act
2. [LEGAL-002] High: Missing 2024 holiday pay amendment
3. [CR-002] High: Missing input validation (security risk)

**Must Address Before Re-Review**:
- Fix all Critical and High severity issues
- Add missing tests for legal calculation modules
- Update dependencies with known CVEs
- Legal team sign-off required

**Estimated Time to Fix**: 2-3 days

**Next Steps**:
1. Developer fixes blocking issues
2. Re-run automated tests
3. Legal team review
4. Re-submit for code review

---

### Reviewer Notes

**Reviewed By**: [Reviewer Name]
**Review Date**: [Date]
**Time Spent**: [Duration]
**Review Scope**: [Files/Components reviewed]

**Positive Observations**:
- Good separation of concerns in service layer
- Comprehensive test coverage for validation module
- Clear variable naming throughout

**Areas for Improvement**:
- Legal calculation module needs refactoring
- Security practices need strengthening
- Documentation coverage low

**Follow-up Items**:
- [ ] Schedule legal compliance training for dev team
- [ ] Establish quarterly legal audit process
- [ ] Add automated security scanning to CI/CD
```

## Review Guidelines

### Severity Levels

| Severity | Definition | Response |
|----------|------------|----------|
| 🔴 Critical | Security vulnerability, data loss risk, legal violation | Must fix immediately |
| 🟠 High | Major bug, significant user impact, compliance issue | Should fix before merge |
| 🟡 Medium | Code quality issue, minor bug, technical debt | Should address |
| 🟢 Low | Style issue, minor improvement, nice-to-have | Optional |

### Focus Areas for Labor Law Systems

1. **Legal Accuracy** (Highest Priority)
   - All calculations must reference specific law articles
   - Cross-validation with government tools required
   - Legal team review for all formula changes

2. **Security**
   - Input validation on all user-provided data
   - No SQL injection, XSS vulnerabilities
   - Audit logging for all calculations

3. **Code Quality**
   - Functions focused and testable (complexity ≤ 10)
   - Clear naming, comprehensive documentation
   - Type hints and docstrings mandatory

4. **Testing**
   - Legal modules: ≥95% coverage
   - Other modules: ≥80% coverage
   - Edge cases and error paths tested

### Best Practices

- Focus on **specific, actionable feedback** with code examples
- Prioritize **legal compliance** and **security** over style
- Provide **context and rationale** for each recommendation
- Include **positive feedback** to encourage good practices
- Link to **official documentation** (PEP 8, labor law articles)
- Estimate **effort required** to fix issues
- Suggest **learning resources** for recurring issues

---

## Example Usage

Input: `/code-review` or `/code-review app/calculators/overtime.py`

Output: [Full code review report as shown above]
