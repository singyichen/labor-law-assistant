---
name: code-review-checklist
description: Generate customized code review checklists for Labor Law Assistant project. Creates comprehensive checklists covering general quality, Python/FastAPI best practices, security, BDD testing, and legal calculation accuracy. Use when establishing review standards or creating PR templates.
---

You are a code review process specialist. Generate thorough, actionable checklists tailored to the Labor Law Assistant project.

## Instructions

When the user requests a checklist via `$ARGUMENTS`:

1. **Identify** the review context (general, legal module, API, BDD tests)
2. **Generate** comprehensive checklist items
3. **Organize** by category (code quality, security, testing, legal)
4. **Include** acceptance criteria for each item
5. **Provide** examples and references

## Output Format

```markdown
## Code Review Checklist

### Checklist Metadata
- **Project**: Labor Law Assistant
- **Review Type**: [General / Legal Module / API Endpoint / BDD Test / PR Review]
- **Target Audience**: [Reviewer / Developer / Legal Reviewer]
- **Last Updated**: [Date]
- **Version**: 1.0

---

## Quick Reference

### Critical Items (Must Check)
- [ ] Legal calculations reference correct law articles
- [ ] No critical security vulnerabilities (OWASP Top 10)
- [ ] Input validation on all user inputs
- [ ] Test coverage ≥95% for legal modules
- [ ] Legal team sign-off for formula changes

### High Priority Items (Should Check)
- [ ] Type hints on all functions
- [ ] Docstrings with examples
- [ ] Error handling comprehensive
- [ ] No code duplication
- [ ] Performance optimizations where needed

---

## Detailed Checklist

### 1. Code Quality & Style

#### 1.1 Naming Conventions
- [ ] **snake_case** for variables and functions
  - Example: `calculate_overtime_pay` not `calculateOvertimePay`
  - Check: No camelCase in Python code
  - Exception: Class names use PascalCase

- [ ] **No single-letter variables** (except loop counters)
  - ❌ Bad: `def calc(x, y): return x * y`
  - ✅ Good: `def calculate_pay(hours: Decimal, rate: Decimal) -> Decimal`
  - Allowed: `for i in range(10)`, `for x, y in coordinates`

- [ ] **Descriptive names** that reveal intent
  - [ ] Function names are verbs: `calculate_`, `validate_`, `format_`
  - [ ] Variable names are nouns: `overtime_hours`, `base_rate`
  - [ ] Boolean variables: `is_`, `has_`, `can_`: `is_holiday`, `has_overtime`
  - [ ] Constants: `UPPER_SNAKE_CASE`: `MAX_OVERTIME_HOURS = 80`

- [ ] **Consistent terminology** with domain
  - [ ] Use Taiwan labor law terms: "overtime pay" not "extra pay"
  - [ ] Consistent across codebase: not mixing "employee" and "worker"

**Verification**:
```bash
# Run linter
ruff check . --select N  # Naming conventions
```

---

#### 1.2 Function Design
- [ ] **Single Responsibility Principle**: Each function does one thing
  - ❌ Bad: Function that validates, calculates, and formats
  - ✅ Good: Separate validation, calculation, formatting functions

- [ ] **Cyclomatic Complexity ≤ 10**
  - [ ] Check with: `radon cc -s -a app/`
  - [ ] If > 10, extract helper functions or use lookup tables
  - [ ] Nested if/else ≤ 3 levels deep

- [ ] **Function length ≤ 50 lines**
  - [ ] If longer, consider extracting helper functions
  - [ ] One level of abstraction per function

- [ ] **Pure functions** where possible (no side effects)
  - [ ] Calculation functions don't modify global state
  - [ ] Same inputs always produce same outputs
  - [ ] Example: `calculate_overtime(hours, rate)` doesn't update database

**Example**:
```python
# ❌ Too complex (complexity = 15)
def calculate_leave(employee: dict) -> dict:
    if employee["type"] == "full_time":
        if employee["years"] >= 1:
            if employee["years"] < 3:
                # ... 10 more levels

# ✅ Simplified (complexity = 3)
def calculate_leave(employee: Employee) -> LeaveEntitlement:
    """Calculate leave per Article 38."""
    _validate_employee(employee)
    
    if employee.is_full_time:
        return _calculate_full_time_leave(employee)
    else:
        return _calculate_part_time_leave(employee)
```

---

#### 1.3 Code Duplication (DRY Principle)
- [ ] **No copy-pasted code blocks**
  - [ ] Check for duplicate logic in multiple places
  - [ ] Extract common code into utility functions
  - [ ] Duplication ≤ 5% (check with: `radon raw -s app/`)

- [ ] **Shared constants** in config files
  - [ ] No magic numbers in code
  - [ ] Constants defined at module/class level
  - [ ] Example: `MAX_OVERTIME_HOURS`, `OVERTIME_RATE_TIER1`

**Check**:
```bash
# Find duplicate code
radon raw -s app/ | grep "Duplicate"
```

---

#### 1.4 Indentation & Formatting
- [ ] **4 spaces** for indentation (no tabs)
  - [ ] Check `.editorconfig` settings
  - [ ] Run: `ruff format --check .`

- [ ] **Line length ≤ 100 characters**
  - [ ] Break long lines appropriately
  - [ ] Use parentheses for line continuation

- [ ] **Blank lines** for readability
  - [ ] 2 blank lines between top-level functions/classes
  - [ ] 1 blank line between methods in a class

**Verification**:
```bash
# Auto-format code
ruff format .
```

---

### 2. Type Hints & Documentation

#### 2.1 Type Hints
- [ ] **All function parameters** have type hints
  - [ ] Required: `def calculate(hours: Decimal, rate: Decimal) -> Decimal`
  - [ ] Not allowed: `def calculate(hours, rate)`

- [ ] **Return types** specified
  - [ ] Even for `None`: `def log_event(...) -> None`
  - [ ] Use `| None` for optional returns: `def find_user(...) -> User | None`

- [ ] **Complex types** properly annotated
  - [ ] Use `from typing import` for generics
  - [ ] Example: `list[Employee]`, `dict[str, Any]`, `Optional[Decimal]`
  - [ ] Use `TypeAlias` for complex types

- [ ] **Type hint coverage ≥ 95%**
  - [ ] Check with: `mypy --strict app/`
  - [ ] No `Any` unless absolutely necessary

**Example**:
```python
from decimal import Decimal
from typing import TypeAlias

HourlyRate: TypeAlias = Decimal
Hours: TypeAlias = Decimal

def calculate_overtime(
    hours: Hours,
    base_rate: HourlyRate,
    overtime_type: OvertimeType = OvertimeType.WEEKDAY
) -> Decimal:
    """Calculate overtime pay."""
    ...
```

**Verification**:
```bash
# Type checking
mypy app/ --strict
```

---

#### 2.2 Docstrings
- [ ] **All public functions** have docstrings
  - [ ] Include: Purpose, Args, Returns, Raises
  - [ ] Use Google or NumPy docstring style
  - [ ] Reference law articles for legal functions

- [ ] **Docstring format**:
  ```python
  def calculate_overtime(hours: Decimal, base_rate: Decimal) -> Decimal:
      """
      Calculate overtime pay per Labor Standards Act Article 24.
      
      Implements tiered overtime rates:
      - First 2 hours: base_rate × 1.34
      - Hours 3-4: base_rate × 1.67
      - Hours 5+: base_rate × 1.67
      
      Args:
          hours: Overtime hours worked (must be ≥ 0)
          base_rate: Hourly base rate (monthly_salary / 240)
      
      Returns:
          Decimal: Total overtime pay, rounded to nearest dollar
      
      Raises:
          ValidationError: If hours < 0 or base_rate <= 0
      
      Example:
          >>> calculate_overtime(Decimal("8"), Decimal("200"))
          Decimal("2540")
      
      References:
          - Labor Standards Act Article 24 (Overtime Pay)
          - Ministry of Labor Directive No. 1030131932 (2014)
      """
  ```

- [ ] **Class docstrings** describe purpose and usage
- [ ] **Module docstrings** at file top
- [ ] **Complex algorithms** have explanation comments

**Verification**:
```bash
# Check docstring coverage
interrogate app/ -v
```

---

### 3. Security

#### 3.1 Input Validation
- [ ] **All user inputs validated** before processing
  - [ ] Use Pydantic models for API requests
  - [ ] Field validators for business rules
  - [ ] Range checks (min/max values)

- [ ] **Validate data types**
  - [ ] Reject invalid types (string when expecting number)
  - [ ] Example: `hours: Decimal = Field(..., ge=0, le=100)`

- [ ] **Sanitize string inputs**
  - [ ] Strip whitespace: `name.strip()`
  - [ ] Escape special characters for display
  - [ ] No raw HTML rendering

**Example**:
```python
from pydantic import BaseModel, Field, validator

class OvertimeRequest(BaseModel):
    hours: Decimal = Field(..., ge=0, le=80, description="Overtime hours")
    base_rate: Decimal = Field(..., gt=0, lt=10000, description="Hourly rate")
    date: datetime = Field(..., description="Work date")
    
    @validator("hours")
    def hours_must_be_reasonable(cls, v):
        if v > Decimal("80"):
            raise ValueError("Monthly overtime cannot exceed 80 hours per law")
        return v
    
    @validator("date")
    def date_not_in_future(cls, v):
        if v > datetime.now():
            raise ValueError("Date cannot be in the future")
        return v
```

---

#### 3.2 OWASP Top 10
- [ ] **A03: Injection**
  - [ ] Use parameterized queries (SQLAlchemy ORM, not raw SQL)
  - [ ] No f-string SQL: ❌ `f"SELECT * FROM users WHERE id={user_id}"`
  - [ ] No `eval()` or `exec()` on user input

- [ ] **A01: Broken Access Control**
  - [ ] Verify user has permission for requested action
  - [ ] Check ownership: user can only access their own data
  - [ ] Example: `if calculation.user_id != current_user.id: raise Forbidden`

- [ ] **A02: Cryptographic Failures**
  - [ ] No hardcoded secrets (API keys, passwords)
  - [ ] Use environment variables: `os.getenv("DB_PASSWORD")`
  - [ ] Sensitive data encrypted at rest and in transit

- [ ] **A07: Authentication & Authorization**
  - [ ] Endpoints require authentication where appropriate
  - [ ] Use JWT tokens or session-based auth
  - [ ] Password hashing with bcrypt (cost ≥ 12)

- [ ] **A05: Security Misconfiguration**
  - [ ] Debug mode OFF in production: `DEBUG = False`
  - [ ] CORS configured appropriately (not `allow_origins=["*"]`)
  - [ ] Security headers enabled (HSTS, CSP, X-Frame-Options)

**Verification**:
```bash
# Security scan
bandit -r app/
safety check
```

---

#### 3.3 Error Handling & Logging
- [ ] **No sensitive data in error messages**
  - [ ] ❌ Bad: `"Authentication failed for user@example.com with password abc123"`
  - [ ] ✅ Good: `"Authentication failed"`

- [ ] **No sensitive data in logs**
  - [ ] Mask PII: `logger.info(f"User {user.id} logged in")` (not email)
  - [ ] Redact passwords, tokens in log output

- [ ] **Audit logging** for sensitive operations
  - [ ] Log all legal calculations with user, timestamp, inputs
  - [ ] Log authentication events (login, logout, failed attempts)
  - [ ] Log data modifications (create, update, delete)

**Example**:
```python
# Good error handling
try:
    result = calculate_overtime(hours, rate)
except ValidationError as e:
    logger.warning(f"Validation failed for user {user.id}: {e}")
    raise HTTPException(status_code=400, detail="Invalid input")
except Exception as e:
    logger.error(f"Calculation error for user {user.id}: {type(e).__name__}")
    raise HTTPException(status_code=500, detail="Internal server error")
```

---

### 4. Performance

#### 4.1 Database Queries
- [ ] **No N+1 query problems**
  - [ ] Use `joinedload()` or `selectinload()` for relationships
  - [ ] Batch queries instead of loops
  - [ ] Example: `db.query(Employee).options(joinedload(Employee.leaves)).all()`

- [ ] **Database indexes** for frequently queried fields
  - [ ] Index foreign keys
  - [ ] Index fields in WHERE clauses
  - [ ] Composite indexes for multi-column queries

- [ ] **Query optimization**
  - [ ] Select only needed columns: `.with_entities(User.id, User.name)`
  - [ ] Use pagination for large result sets
  - [ ] Add query timeout limits

**Check**:
```python
# Enable SQL logging to detect N+1
import logging
logging.getLogger('sqlalchemy.engine').setLevel(logging.INFO)
```

---

#### 4.2 Algorithmic Efficiency
- [ ] **Appropriate data structures**
  - [ ] Use `set` for membership checks (not `list`)
  - [ ] Use `dict` for key-value lookups (not linear search)
  - [ ] Example: `if user_id in user_set` (O(1) vs O(n))

- [ ] **Avoid unnecessary computations**
  - [ ] Cache expensive calculations
  - [ ] Move invariant calculations outside loops
  - [ ] Use lazy evaluation where appropriate

- [ ] **List comprehensions** over loops where appropriate
  - [ ] ✅ `results = [calc(x) for x in data]`
  - [ ] ❌ `results = []; for x in data: results.append(calc(x))`

**Example**:
```python
# ❌ Inefficient (O(n²))
def find_duplicates(items: list[str]) -> list[str]:
    duplicates = []
    for item in items:
        if items.count(item) > 1:  # Scans entire list each time
            duplicates.append(item)
    return duplicates

# ✅ Efficient (O(n))
def find_duplicates(items: list[str]) -> list[str]:
    counts = Counter(items)
    return [item for item, count in counts.items() if count > 1]
```

---

#### 4.3 Caching
- [ ] **Cache static/rarely-changed data**
  - [ ] Law articles, holiday calendars
  - [ ] Configuration values
  - [ ] Use Redis or in-memory cache

- [ ] **Cache invalidation strategy**
  - [ ] TTL for time-based expiration
  - [ ] Event-based invalidation for data changes
  - [ ] Example: Invalidate holiday cache when calendar updated

**Example**:
```python
from functools import lru_cache

@lru_cache(maxsize=128)
def get_law_article(article_id: str) -> LawArticle:
    """Cache law articles (rarely change)."""
    return db.query(LawArticle).filter_by(id=article_id).first()
```

---

### 5. Testing

#### 5.1 Test Coverage
- [ ] **Legal modules: ≥95% coverage**
  - [ ] All calculation functions fully tested
  - [ ] All edge cases covered (0, negative, boundary)
  - [ ] All error paths tested

- [ ] **Other modules: ≥80% coverage**
  - [ ] API endpoints
  - [ ] Service layer
  - [ ] Utility functions

- [ ] **Branch coverage** ≥90%
  - [ ] All if/else branches tested
  - [ ] All exception handlers tested

**Verification**:
```bash
# Generate coverage report
pytest --cov=app --cov-report=html --cov-report=term
# Check: app/calculators/overtime.py: 95%
```

---

#### 5.2 Unit Tests
- [ ] **Test each function independently**
  - [ ] Mock external dependencies (database, APIs)
  - [ ] Use `pytest.fixture` for test data
  - [ ] Parametrize tests for multiple inputs

- [ ] **Test naming convention**: `test_<function>_<scenario>_<expected>`
  - [ ] Example: `test_calculate_overtime_with_2_hours_returns_536`
  - [ ] Clear description of what's being tested

- [ ] **Edge cases tested**
  - [ ] Zero values: `calculate_overtime(0, 200)`
  - [ ] Negative values: Should raise ValidationError
  - [ ] Boundary values: Exactly at tier boundaries (2h, 4h)
  - [ ] Maximum values: `calculate_overtime(80, 1000)`

- [ ] **Error cases tested**
  - [ ] Invalid inputs raise appropriate exceptions
  - [ ] Error messages are helpful

**Example**:
```python
import pytest
from decimal import Decimal

class TestOvertimeCalculation:
    """Test overtime pay calculation per Article 24."""
    
    @pytest.mark.parametrize("hours,rate,expected", [
        (Decimal("0"), Decimal("200"), Decimal("0")),
        (Decimal("1"), Decimal("200"), Decimal("268")),
        (Decimal("2"), Decimal("200"), Decimal("536")),
        (Decimal("4"), Decimal("200"), Decimal("1204")),
        (Decimal("8"), Decimal("200"), Decimal("2540")),
    ])
    def test_tiered_overtime_calculation(self, hours, rate, expected):
        """Test overtime calculation with various hour amounts."""
        assert calculate_overtime(hours, rate) == expected
    
    def test_negative_hours_raises_validation_error(self):
        """Test that negative hours raises ValidationError."""
        with pytest.raises(ValidationError, match="Hours must be >= 0"):
            calculate_overtime(Decimal("-1"), Decimal("200"))
    
    def test_zero_rate_raises_validation_error(self):
        """Test that zero or negative rate raises ValidationError."""
        with pytest.raises(ValidationError, match="Rate must be > 0"):
            calculate_overtime(Decimal("8"), Decimal("0"))
```

---

#### 5.3 Integration Tests
- [ ] **API endpoint tests**
  - [ ] Test full request/response cycle
  - [ ] Test authentication/authorization
  - [ ] Test error responses (400, 401, 403, 404, 500)

- [ ] **Database integration**
  - [ ] Use test database (not production)
  - [ ] Test transactions and rollbacks
  - [ ] Test database constraints

**Example**:
```python
from fastapi.testclient import TestClient

def test_calculate_overtime_endpoint_success(client: TestClient):
    """Test /calculate/overtime endpoint with valid data."""
    response = client.post(
        "/api/v1/calculate/overtime",
        json={"hours": 8, "base_rate": 200}
    )
    assert response.status_code == 200
    assert response.json()["total"] == 2540

def test_calculate_overtime_endpoint_invalid_hours(client: TestClient):
    """Test endpoint returns 400 for invalid hours."""
    response = client.post(
        "/api/v1/calculate/overtime",
        json={"hours": -1, "base_rate": 200}
    )
    assert response.status_code == 400
    assert "hours" in response.json()["detail"].lower()
```

---

#### 5.4 BDD Tests
- [ ] **Gherkin scenarios** for user-facing features
  - [ ] Feature files in `features/` directory
  - [ ] Scenarios cover happy paths and error paths
  - [ ] Scenarios use business language (not technical terms)

- [ ] **Step definitions** implement scenarios
  - [ ] Steps are reusable across scenarios
  - [ ] Steps use Given/When/Then pattern
  - [ ] Steps test real application behavior (not mocked)

**Example**:
```gherkin
# features/overtime_calculation.feature
Feature: Overtime Pay Calculation
  As an employee
  I want to calculate my overtime pay
  So that I know my expected compensation

  Scenario: Calculate weekday overtime with 8 hours
    Given an employee with base hourly rate of NT$200
    When they work 8 hours of weekday overtime
    Then the overtime pay should be NT$2,540
    And the calculation breakdown should show tiered rates

  Scenario: Reject negative overtime hours
    Given an employee with base hourly rate of NT$200
    When they attempt to calculate overtime with -1 hours
    Then the system should show an error "Hours must be non-negative"
```

---

#### 5.5 Legal Calculation Tests
- [ ] **Cross-validation with government tools**
  - [ ] Test cases match Ministry of Labor calculator
  - [ ] Document test cases from official sources
  - [ ] Automated comparison where possible

- [ ] **Law article references in tests**
  - [ ] Test docstrings cite specific articles
  - [ ] Test names indicate law provision
  - [ ] Example: `test_article_24_tier1_overtime_rate`

- [ ] **Test data from real scenarios**
  - [ ] Use actual salary amounts from Taiwan
  - [ ] Use realistic work hour scenarios
  - [ ] Cover edge cases from legal guidance

**Example**:
```python
def test_overtime_matches_government_calculator():
    """
    Verify overtime calculation matches Ministry of Labor calculator.
    
    Test cases extracted from:
    https://labweb.mol.gov.tw/calculator/
    (Accessed: 2024-02-01)
    """
    government_test_cases = [
        # (hours, base_rate, expected) from government calculator
        (Decimal("2"), Decimal("183"), Decimal("490.44")),
        (Decimal("4"), Decimal("183"), Decimal("1101.66")),
        (Decimal("8"), Decimal("183"), Decimal("2324.10")),
    ]
    
    for hours, rate, expected in government_test_cases:
        result = calculate_overtime(hours, rate)
        assert result == expected, f"Mismatch for {hours}h at NT${rate}/hr"
```

---

### 6. Legal Compliance

#### 6.1 Law Article References
- [ ] **All calculations reference law articles** in docstrings
  - [ ] Article number: "Labor Standards Act Article 24"
  - [ ] Section if applicable: "Article 24 Section 1"
  - [ ] Year of last amendment: "Article 24 (2019 amendment)"

- [ ] **References are current** (2024 amendments)
  - [ ] Check Ministry of Labor website for updates
  - [ ] Update references when laws change
  - [ ] Document amendment history in comments

- [ ] **Link to official sources**
  - [ ] Ministry of Labor website
  - [ ] Legal database (Laws & Regulations Database)

**Example**:
```python
def calculate_overtime(hours: Decimal, base_rate: Decimal) -> Decimal:
    """
    Calculate overtime pay per Labor Standards Act Article 24.
    
    Legal References:
        - Labor Standards Act Article 24 (勞動基準法第24條)
          https://law.moj.gov.tw/LawClass/LawAll.aspx?pcode=N0030001
          Last amended: 2019-05-15
        
        - Ministry of Labor Directive No. 1030131932 (2014-03-05)
          Clarification on overtime rate calculation method
    
    Calculation Method (Article 24):
        - Weekday overtime first 2 hours: base_rate × 4/3 (1.34)
        - Weekday overtime hours 3-4: base_rate × 5/3 (1.67)
        - Weekday overtime hours 5+: base_rate × 5/3 (1.67)
    """
```

---

#### 6.2 Calculation Accuracy
- [ ] **Formulas match law exactly**
  - [ ] Overtime rates: 1.34x (4/3), 1.67x (5/3), 2.0x
  - [ ] Annual leave days per tenure (Article 38 schedule)
  - [ ] Severance pay formula (Article 17)

- [ ] **Rounding follows legal guidance**
  - [ ] Overtime pay: Round to nearest dollar (standard practice)
  - [ ] Leave days: No rounding (must be exact)
  - [ ] Document rounding rules in code

- [ ] **Handle edge cases per law**
  - [ ] Pro-rated calculations for partial months
  - [ ] Leap year handling
  - [ ] Public holiday make-up days (2024 amendment)

**Example**:
```python
def calculate_overtime_tier1(hours: Decimal, base_rate: Decimal) -> Decimal:
    """
    Calculate first 2 hours of overtime at 4/3 rate per Article 24.
    
    Article 24 Section 1: "For work on a regular workday beyond the
    regular working hours, wages shall be paid at a rate no less than
    4/3 of the hourly wage for the first two hours..."
    
    Formula: hours × base_rate × (4/3)
    Exact multiplier: 1.333... (using Decimal for precision)
    """
    # Use exact fraction, not float approximation
    TIER1_RATE = Decimal("4") / Decimal("3")  # Exactly 4/3
    return min(hours, Decimal("2")) * base_rate * TIER1_RATE
```

---

#### 6.3 Disclaimers & Warnings
- [ ] **Disclaimer on all calculation results**
  - [ ] "This is an estimate. Consult legal professional for advice."
  - [ ] Displayed prominently on result pages
  - [ ] Cannot be dismissed or hidden

- [ ] **Warnings for edge cases**
  - [ ] "This scenario may have special provisions. Verify with MOL."
  - [ ] Example: Foreign workers, special industries

- [ ] **Version/date of law shown**
  - [ ] "Based on Labor Standards Act as of 2024-01-01"
  - [ ] Alert users if law recently changed

**Example**:
```python
class CalculationResult(BaseModel):
    """Result of legal calculation with mandatory disclaimer."""
    
    amount: Decimal
    breakdown: dict[str, Decimal]
    legal_basis: str  # "Labor Standards Act Article 24 (2019 amendment)"
    
    disclaimer: str = (
        "This calculation is for reference only and does not constitute "
        "legal advice. Actual amounts may vary based on employment contract "
        "and specific circumstances. Please consult with the Ministry of "
        "Labor or a legal professional for authoritative guidance."
    )
    
    calculated_at: datetime = Field(default_factory=datetime.now)
    law_version_date: str = "2024-01-01"  # Last law amendment date
```

---

### 7. API Design (FastAPI)

#### 7.1 Request/Response Models
- [ ] **Pydantic models for all endpoints**
  - [ ] Request body: `class OvertimeRequest(BaseModel)`
  - [ ] Response body: `class OvertimeResponse(BaseModel)`
  - [ ] No raw `dict` as input/output

- [ ] **Field validation**
  - [ ] Use `Field()` for constraints: `hours: Decimal = Field(ge=0, le=100)`
  - [ ] Custom validators for business rules
  - [ ] Descriptive field names and documentation

- [ ] **Proper HTTP status codes**
  - [ ] 200: Success
  - [ ] 201: Created
  - [ ] 400: Bad Request (validation error)
  - [ ] 401: Unauthorized
  - [ ] 403: Forbidden
  - [ ] 404: Not Found
  - [ ] 500: Internal Server Error

**Example**:
```python
from pydantic import BaseModel, Field
from decimal import Decimal

class OvertimeRequest(BaseModel):
    """Request to calculate overtime pay."""
    
    hours: Decimal = Field(
        ...,
        ge=0,
        le=80,
        description="Overtime hours worked (max 80/month per law)"
    )
    base_rate: Decimal = Field(
        ...,
        gt=0,
        description="Hourly base rate (monthly_salary / 240)"
    )
    overtime_type: OvertimeType = Field(
        default=OvertimeType.WEEKDAY,
        description="Type of overtime (weekday/holiday)"
    )

class OvertimeResponse(BaseModel):
    """Overtime calculation result."""
    
    total: Decimal = Field(description="Total overtime pay")
    breakdown: dict[str, Decimal] = Field(description="Pay by tier")
    legal_basis: str
    disclaimer: str
```

---

#### 7.2 Error Handling
- [ ] **Consistent error response format**
  - [ ] Use `HTTPException` with appropriate status codes
  - [ ] Include error code and message
  - [ ] Include request_id for tracing

- [ ] **Helpful error messages**
  - [ ] Specify which field failed validation
  - [ ] Explain why it failed
  - [ ] Suggest how to fix it

**Example**:
```python
from fastapi import HTTPException, status

@router.post("/calculate/overtime")
def calculate_overtime_endpoint(
    request: OvertimeRequest,
    current_user: User = Depends(get_current_user)
) -> OvertimeResponse:
    """Calculate overtime pay."""
    try:
        result = overtime_service.calculate(request, user=current_user)
        return result
    except ValidationError as e:
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail={
                "error_code": "VALIDATION_ERROR",
                "message": str(e),
                "fields": e.errors()
            }
        )
    except Exception as e:
        logger.error(f"Calculation error: {e}", exc_info=True)
        raise HTTPException(
            status_code=status.HTTP_500_INTERNAL_SERVER_ERROR,
            detail="Internal server error"
        )
```

---

#### 7.3 API Documentation
- [ ] **OpenAPI docs complete**
  - [ ] Operation summaries and descriptions
  - [ ] Request/response examples
  - [ ] Error response documentation

- [ ] **Endpoint descriptions**
  - [ ] What the endpoint does
  - [ ] Who can use it (auth requirements)
  - [ ] Rate limits if applicable

**Example**:
```python
@router.post(
    "/calculate/overtime",
    response_model=OvertimeResponse,
    summary="Calculate overtime pay",
    description="""
    Calculate overtime pay according to Taiwan Labor Standards Act Article 24.
    
    Supports weekday and holiday overtime with tiered rate calculation.
    Results include legal basis and mandatory disclaimer.
    
    **Rate Limits**: 100 requests per minute per user
    **Authentication**: Required
    """,
    responses={
        200: {"description": "Calculation successful"},
        400: {"description": "Invalid input (validation error)"},
        401: {"description": "Authentication required"},
        500: {"description": "Server error"}
    },
    tags=["calculations"]
)
def calculate_overtime(request: OvertimeRequest) -> OvertimeResponse:
    """Calculate overtime pay."""
    ...
```

---

### 8. Project-Specific Standards

#### 8.1 Language Usage
- [ ] **Code and comments in English**
  - [ ] Function names, variable names, comments: English
  - [ ] User-facing strings: Can be Chinese
  - [ ] No mixing: Not `計算overtime_pay()`

- [ ] **Technical terms in English**
  - [ ] Even when chatting in Chinese, use English for technical terms
  - [ ] Example: "需要增加 P-value 的計算" (use "P-value", not translation)

**Example**:
```python
# ✅ Good: English code, Chinese strings
def calculate_overtime(hours: Decimal) -> Decimal:
    """Calculate overtime pay per Labor Standards Act."""
    if hours <= 0:
        raise ValidationError("工時必須大於零")  # User-facing: Chinese OK
    return hours * RATE

# ❌ Bad: Mixed language
def 計算_overtime(小時: Decimal) -> Decimal:
    """計算 overtime pay"""  # Mixed language in docstring
```

---

#### 8.2 BDD Test Organization
- [ ] **Feature files** in `features/` directory
  - [ ] One feature per file
  - [ ] Descriptive feature names
  - [ ] Business-focused scenarios

- [ ] **Step definitions** in `tests/bdd/steps/`
  - [ ] Organized by domain (overtime, leave, etc.)
  - [ ] Reusable steps across scenarios
  - [ ] Clear, descriptive step names

- [ ] **Test data** in fixtures or config files
  - [ ] Not hardcoded in step definitions
  - [ ] Easy to update when laws change

---

#### 8.3 Git Commit Standards
- [ ] **Conventional Commits format**
  - [ ] `type(scope): description`
  - [ ] Types: `feat`, `fix`, `docs`, `test`, `refactor`, `chore`
  - [ ] Example: `feat(overtime): add tiered rate calculation`

- [ ] **Descriptive commit messages**
  - [ ] Explain **why**, not just **what**
  - [ ] Reference issue numbers if applicable
  - [ ] Example: `fix(calc): correct Article 24 rate (fixes #123)`

- [ ] **Atomic commits**
  - [ ] One logical change per commit
  - [ ] Don't mix unrelated changes

---

## Specialized Checklists

### Legal Module Review Checklist

When reviewing files in `app/calculators/` or legal logic:

- [ ] **Law article reference** in docstring
- [ ] **Exact formula** matches law (not approximation)
- [ ] **Test coverage ≥95%** for this module
- [ ] **Cross-validation** with government tool
- [ ] **Legal team sign-off** obtained
- [ ] **Disclaimer** included in response
- [ ] **All edge cases** from law documented and tested
- [ ] **Amendment history** tracked in comments
- [ ] **Rounding rules** documented and correct
- [ ] **Unit tests reference** law articles in docstrings

---

### API Endpoint Review Checklist

When reviewing FastAPI endpoint code:

- [ ] **Pydantic models** for request/response (not `dict`)
- [ ] **Field validation** with constraints
- [ ] **Authentication** required (if not public endpoint)
- [ ] **Authorization** checked (user can access resource)
- [ ] **Rate limiting** applied (if applicable)
- [ ] **Error handling** comprehensive (try/except)
- [ ] **Logging** for audit trail
- [ ] **OpenAPI docs** complete (summary, description, examples)
- [ ] **Integration tests** for endpoint
- [ ] **Proper HTTP status codes** (200, 400, 401, 404, 500)

---

### Database Model Review Checklist

When reviewing SQLAlchemy models:

- [ ] **Type hints** on all columns
- [ ] **Constraints** defined (unique, not null, check)
- [ ] **Indexes** on foreign keys and frequently queried fields
- [ ] **Relationships** defined with appropriate `lazy` loading
- [ ] **Migration file** created (via Alembic)
- [ ] **Backward compatible** (no breaking changes to existing data)
- [ ] **Timestamps** (`created_at`, `updated_at`) included
- [ ] **Soft delete** considered (if applicable)

---

### BDD Test Review Checklist

When reviewing Gherkin features and step definitions:

- [ ] **Business language** in scenarios (not technical jargon)
- [ ] **Given/When/Then** structure followed
- [ ] **Scenarios cover** happy path and error paths
- [ ] **Step definitions** implement actual behavior (not mocked)
- [ ] **Reusable steps** across scenarios
- [ ] **Test data** in fixtures (not hardcoded in steps)
- [ ] **Clear scenario names** describing user goal
- [ ] **Tags** for organization (@overtime, @leave, @smoke)

---

## Quick Reference Card

### Must-Fix (Blockers)
❌ Legal calculation errors
❌ Critical security vulnerabilities
❌ No input validation on user data
❌ Test failures in CI/CD
❌ Missing type hints on public APIs

### Should-Fix (Before Merge)
⚠️ Cyclomatic complexity > 10
⚠️ Missing docstrings on public functions
⚠️ Code duplication > 5%
⚠️ Test coverage < 80% (< 95% for legal modules)
⚠️ Medium security issues

### Nice-to-Have (Post-Merge)
💡 Add more examples to docstrings
💡 Improve variable names
💡 Extract magic numbers to constants
💡 Add performance optimizations

---

## Verification Commands

```bash
# Code Quality
ruff check .                          # Linting
ruff format --check .                 # Formatting
radon cc -s -a app/                   # Cyclomatic complexity
radon raw -s app/                     # Code metrics

# Type Checking
mypy app/ --strict                    # Type hints
interrogate app/ -v                   # Docstring coverage

# Security
bandit -r app/                        # Security scan
safety check                          # Dependency vulnerabilities
pip-audit                             # Alternative dependency scanner

# Testing
pytest --cov=app --cov-report=html    # Test coverage
pytest -v tests/                      # Run all tests
pytest tests/bdd/                     # Run BDD tests

# Performance
python -m cProfile app/main.py        # Profile code

# Dependencies
pip list --outdated                   # Check outdated packages
```

---

## Review Process

1. **Automated Checks** (CI/CD)
   - Linting, formatting, type checking
   - Security scans
   - Unit tests
   - Coverage thresholds

2. **Manual Review** (Developer)
   - Code quality and design
   - Business logic correctness
   - Test adequacy
   - Documentation

3. **Legal Review** (Legal Team)
   - Formula accuracy
   - Law article references
   - Compliance verification

4. **Approval**
   - All automated checks pass
   - 2+ developer approvals
   - Legal approval (for calculation changes)

---
```

## Example Usage

**General Checklist**:
Input: `/code-review-checklist`
Output: [Full comprehensive checklist as shown above]

**Legal Module Checklist**:
Input: `/code-review-checklist legal`
Output: [Legal Module specialized checklist]

**API Endpoint Checklist**:
Input: `/code-review-checklist api`
Output: [API Endpoint specialized checklist]

**BDD Test Checklist**:
Input: `/code-review-checklist bdd`
Output: [BDD Test specialized checklist]
