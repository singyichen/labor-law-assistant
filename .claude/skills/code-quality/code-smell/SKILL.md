---
name: code-smell
description: Detect code smells and anti-patterns in Python code. Identifies common issues like Long Method, God Class, Feature Envy, Duplicate Code, and provides refactoring suggestions with examples. Use for technical debt assessment and code quality improvement.
---

You are a code quality specialist. Detect code smells, anti-patterns, and technical debt with specific refactoring recommendations.

## Instructions

When the user requests code smell detection via `$ARGUMENTS`:

1. **Analyze** code for common smells and anti-patterns
2. **Identify** severity and impact of each smell
3. **Classify** by smell category (Bloaters, OOP Abusers, Change Preventers, etc.)
4. **Provide** specific refactoring recommendations with code examples
5. **Assess** technical debt and priority

## Output Format

```markdown
## Code Smell Report

### Summary
- **Files Analyzed**: X
- **Total Smells Found**: X
- **Critical**: X (Must fix)
- **High**: X (Should fix soon)
- **Medium**: X (Consider fixing)
- **Low**: X (Nice to have)

**Overall Code Health**: 🟢 Healthy / 🟡 Needs Attention / 🔴 Critical Issues

**Technical Debt Score**: X/100 (lower is better)
- Code Smells: X points
- Complexity: X points
- Duplication: X points
- Coverage Gaps: X points

---

## Code Smells by Category

### 1. Bloaters

These are code elements that have grown too large or complex.

---

#### [SMELL-001] Long Method 🔴 Critical
**File**: `app/services/leave_calculator.py:78-145`
**Severity**: 🔴 Critical
**Category**: Bloater

**Issue Description**:
Function is 68 lines long with cyclomatic complexity of 18. Extremely difficult to understand, test, and maintain.

**Current Code** (abbreviated):
```python
def calculate_leave_entitlement(employee_data: dict) -> dict:
    """Calculate leave entitlement - THIS FUNCTION IS TOO LONG!"""
    # Line 78-82: Input validation
    if not employee_data:
        raise ValueError("Employee data required")
    if "type" not in employee_data:
        raise ValueError("Employee type required")
    
    # Line 83-90: Full-time calculation
    if employee_data["type"] == "full_time":
        if employee_data["years"] >= 1:
            if employee_data["years"] < 3:
                days = 3
            elif employee_data["years"] < 5:
                days = 7
            # ... 15 more elif branches
    
    # Line 91-100: Part-time calculation
    elif employee_data["type"] == "part_time":
        # ... another 10 lines
    
    # Line 101-110: Special cases
    if employee_data.get("is_disabled"):
        # ... special handling
    
    # Line 111-120: Formatting result
    result = {
        "annual_days": days,
        "sick_days": sick,
        "personal_days": personal,
        # ... 10 more fields
    }
    
    # Line 121-145: Logging and audit
    logger.info(f"Calculated leave for {employee_data}")
    # ... more logging
    
    return result
```

**Problems**:
1. **Multiple Responsibilities**: Validation, calculation, formatting, logging
2. **High Complexity**: 18 decision points (threshold: 10)
3. **Hard to Test**: Need 18+ test cases for full coverage
4. **Hard to Read**: Can't understand logic without reading all 68 lines
5. **Violates SRP**: Does too many things

**Refactoring Strategy**: Extract Method

**Refactored Code**:
```python
from dataclasses import dataclass
from decimal import Decimal

@dataclass
class LeaveEntitlement:
    """Leave entitlement result."""
    annual_days: Decimal
    sick_days: Decimal
    personal_days: Decimal
    basis: str

def calculate_leave_entitlement(employee: Employee) -> LeaveEntitlement:
    """
    Calculate leave entitlement per Labor Standards Act Article 38.
    
    This is now the orchestrator - delegates to specialized functions.
    """
    _validate_employee(employee)
    
    if employee.is_full_time:
        annual_days = _calculate_full_time_annual_leave(employee)
    else:
        annual_days = _calculate_part_time_annual_leave(employee)
    
    sick_days = _calculate_sick_leave(employee)
    personal_days = _calculate_personal_leave(employee)
    
    _log_calculation(employee, annual_days)
    
    return LeaveEntitlement(
        annual_days=annual_days,
        sick_days=sick_days,
        personal_days=personal_days,
        basis=f"Article 38 (Tenure: {employee.tenure_years} years)"
    )

def _validate_employee(employee: Employee) -> None:
    """Validate employee data."""
    if employee.tenure_years < 0:
        raise ValidationError("Tenure cannot be negative")

def _calculate_full_time_annual_leave(employee: Employee) -> Decimal:
    """Calculate annual leave for full-time employees per Article 38."""
    # Use lookup table instead of nested if/else
    tenure = employee.tenure_years
    
    if tenure < 0.5:
        return Decimal("0")
    
    # Direct lookup for common cases
    ANNUAL_LEAVE_BY_TENURE = {
        0.5: Decimal("3"),   # 6 months
        1: Decimal("3"),     # 1 year
        2: Decimal("7"),     # 2 years
        3: Decimal("10"),    # 3 years
        5: Decimal("14"),    # 5 years
        10: Decimal("15"),   # 10 years
    }
    
    # Find appropriate tier
    for years_threshold in sorted(ANNUAL_LEAVE_BY_TENURE.keys(), reverse=True):
        if tenure >= years_threshold:
            return ANNUAL_LEAVE_BY_TENURE[years_threshold]
    
    return Decimal("0")

def _calculate_sick_leave(employee: Employee) -> Decimal:
    """Calculate sick leave days."""
    # Simple, focused function
    return Decimal("30")  # Standard sick leave

def _log_calculation(employee: Employee, days: Decimal) -> None:
    """Log leave calculation for audit trail."""
    logger.info(
        "Leave calculated",
        extra={
            "employee_id": employee.id,
            "annual_days": str(days),
            "tenure_years": employee.tenure_years
        }
    )
```

**Benefits**:
- Main function reduced from 68 to 20 lines
- Complexity reduced from 18 to 3
- Each function has single responsibility
- Easy to test (can test each function independently)
- Easy to understand (clear function names reveal intent)

**Priority**: 🔴 Critical - Fix immediately

---

#### [SMELL-002] Large Class (God Class) 🟠 High
**File**: `app/services/calculator_service.py:1-450`
**Severity**: 🟠 High
**Category**: Bloater

**Issue Description**:
`CalculatorService` class has 450 lines with 25 methods, handling overtime, leave, severance, and more. This is a "God Class" that knows and does too much.

**Current Structure**:
```python
class CalculatorService:
    """Handles ALL calculations - TOO MANY RESPONSIBILITIES!"""
    
    # Overtime methods (100 lines)
    def calculate_overtime(self, ...): ...
    def validate_overtime_input(self, ...): ...
    def format_overtime_result(self, ...): ...
    def get_overtime_law_article(self, ...): ...
    
    # Leave methods (100 lines)
    def calculate_annual_leave(self, ...): ...
    def calculate_sick_leave(self, ...): ...
    def validate_leave_input(self, ...): ...
    
    # Severance methods (100 lines)
    def calculate_severance(self, ...): ...
    def validate_severance_input(self, ...): ...
    
    # Shared utilities (150 lines)
    def validate_employee(self, ...): ...
    def format_currency(self, ...): ...
    def log_calculation(self, ...): ...
    # ... 20 more methods
```

**Problems**:
1. **Too Many Responsibilities**: Handles 5+ different calculation types
2. **Hard to Maintain**: Changes to overtime affect entire file
3. **Hard to Test**: Need to mock entire service for each test
4. **Poor Cohesion**: Methods don't relate to each other
5. **Violates SRP**: Single Responsibility Principle violated

**Refactoring Strategy**: Extract Class

**Refactored Code**:
```python
# Separate calculator classes by domain

class OvertimeCalculator:
    """Calculate overtime pay per Labor Standards Act Article 24."""
    
    def calculate(self, request: OvertimeRequest) -> OvertimeResult:
        self._validate(request)
        amount = self._calculate_amount(request)
        return self._format_result(amount, request)
    
    def _validate(self, request: OvertimeRequest) -> None:
        if request.hours < 0:
            raise ValidationError("Hours must be >= 0")
    
    def _calculate_amount(self, request: OvertimeRequest) -> Decimal:
        # Focused on overtime calculation only
        ...
    
    def _format_result(self, amount: Decimal, request: OvertimeRequest) -> OvertimeResult:
        ...

class LeaveCalculator:
    """Calculate leave entitlement per Labor Standards Act Article 38."""
    
    def calculate(self, employee: Employee) -> LeaveEntitlement:
        ...

class SeveranceCalculator:
    """Calculate severance pay per Labor Standards Act Article 17."""
    
    def calculate(self, employee: Employee) -> SeveranceResult:
        ...

# Shared utilities in separate module
# app/utils/validation.py
def validate_employee(employee: Employee) -> None:
    """Shared employee validation."""
    ...

# app/utils/formatting.py
def format_currency(amount: Decimal) -> str:
    """Format as Taiwan currency."""
    return f"NT${amount:,.0f}"
```

**Benefits**:
- Each class focuses on one calculation type
- Easier to understand (100 lines vs 450 lines)
- Easier to test (can test each calculator independently)
- Better cohesion (related methods grouped together)
- Easier to extend (add new calculator without affecting others)

**Priority**: 🟠 High - Refactor in next sprint

---

#### [SMELL-003] Long Parameter List 🟡 Medium
**File**: `app/calculators/overtime.py:23`
**Severity**: 🟡 Medium
**Category**: Bloater

**Issue Description**:
Function has 8 parameters, difficult to call and remember parameter order.

**Current Code**:
```python
def calculate_overtime(
    hours: Decimal,
    base_rate: Decimal,
    overtime_type: str,
    is_holiday: bool,
    has_meal_break: bool,
    shift_differential: Decimal,
    employee_id: str,
    calculation_date: datetime
) -> Decimal:
    """Too many parameters - hard to call!"""
    ...

# Calling code is confusing
result = calculate_overtime(
    Decimal("8"),
    Decimal("200"),
    "weekday",
    False,
    True,
    Decimal("0"),
    "emp_123",
    datetime.now()
)  # What does each parameter mean?
```

**Problems**:
1. **Hard to Remember**: What's the order? What does each parameter mean?
2. **Error-Prone**: Easy to swap parameters (all Decimals look the same)
3. **Hard to Extend**: Adding new parameter affects all callers
4. **Poor Readability**: Can't tell what values mean without looking at signature

**Refactoring Strategy**: Introduce Parameter Object

**Refactored Code**:
```python
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from enum import Enum

class OvertimeType(str, Enum):
    WEEKDAY = "weekday"
    HOLIDAY = "holiday"
    REST_DAY = "rest_day"

@dataclass
class OvertimeCalculationRequest:
    """Request to calculate overtime pay."""
    
    hours: Decimal
    base_rate: Decimal
    overtime_type: OvertimeType = OvertimeType.WEEKDAY
    is_holiday: bool = False
    has_meal_break: bool = True
    shift_differential: Decimal = Decimal("0")
    employee_id: str = ""
    calculation_date: datetime = datetime.now()
    
    def __post_init__(self):
        """Validate on creation."""
        if self.hours < 0:
            raise ValueError("Hours must be >= 0")
        if self.base_rate <= 0:
            raise ValueError("Rate must be > 0")

def calculate_overtime(request: OvertimeCalculationRequest) -> Decimal:
    """Calculate overtime with clear, self-documenting parameter object."""
    # Access parameters by name
    if request.is_holiday:
        return _calculate_holiday_overtime(request)
    else:
        return _calculate_regular_overtime(request)

# Calling code is much clearer
request = OvertimeCalculationRequest(
    hours=Decimal("8"),
    base_rate=Decimal("200"),
    overtime_type=OvertimeType.WEEKDAY,
    is_holiday=False
)
result = calculate_overtime(request)

# Or use named parameters (very clear!)
result = calculate_overtime(
    OvertimeCalculationRequest(
        hours=Decimal("8"),
        base_rate=Decimal("200")
    )
)
```

**Benefits**:
- Self-documenting (field names show meaning)
- Easier to extend (add fields without breaking callers)
- Validation in one place (in dataclass)
- Optional parameters have clear defaults

**Priority**: 🟡 Medium - Consider refactoring

---

### 2. Object-Orientation Abusers

Improper use of OOP principles.

---

#### [SMELL-004] Switch Statements / Type Checking 🟡 Medium
**File**: `app/services/calculation_dispatcher.py:45`
**Severity**: 🟡 Medium
**Category**: OOP Abuser

**Issue Description**:
Using type checks and if/elif chains instead of polymorphism. Violates Open/Closed Principle.

**Current Code**:
```python
def calculate(calculation_type: str, data: dict) -> dict:
    """Dispatch calculation based on type - ANTI-PATTERN!"""
    
    if calculation_type == "overtime":
        return calculate_overtime(data)
    elif calculation_type == "leave":
        return calculate_leave(data)
    elif calculation_type == "severance":
        return calculate_severance(data)
    elif calculation_type == "bonus":
        return calculate_bonus(data)
    elif calculation_type == "pension":
        return calculate_pension(data)
    else:
        raise ValueError(f"Unknown type: {calculation_type}")

# Adding new calculation type requires modifying this function!
```

**Problems**:
1. **Violates Open/Closed**: Must modify function to add new type
2. **Duplicated Logic**: Same pattern repeated elsewhere
3. **Hard to Test**: Need separate test for each branch
4. **Not Extensible**: Can't add types without changing core code

**Refactoring Strategy**: Replace Conditional with Polymorphism

**Refactored Code**:
```python
from abc import ABC, abstractmethod
from typing import Protocol

class Calculator(Protocol):
    """Calculator interface."""
    
    def calculate(self, request: CalculationRequest) -> CalculationResult:
        """Perform calculation."""
        ...

class OvertimeCalculator:
    """Overtime calculator implementation."""
    
    def calculate(self, request: CalculationRequest) -> CalculationResult:
        # Overtime-specific logic
        ...

class LeaveCalculator:
    """Leave calculator implementation."""
    
    def calculate(self, request: CalculationRequest) -> CalculationResult:
        # Leave-specific logic
        ...

class SeveranceCalculator:
    """Severance calculator implementation."""
    
    def calculate(self, request: CalculationRequest) -> CalculationResult:
        # Severance-specific logic
        ...

# Registry pattern for calculator lookup
class CalculatorRegistry:
    """Registry of available calculators."""
    
    def __init__(self):
        self._calculators: dict[str, Calculator] = {}
    
    def register(self, name: str, calculator: Calculator) -> None:
        """Register a calculator."""
        self._calculators[name] = calculator
    
    def get(self, name: str) -> Calculator:
        """Get calculator by name."""
        if name not in self._calculators:
            raise ValueError(f"Unknown calculator: {name}")
        return self._calculators[name]

# Setup
registry = CalculatorRegistry()
registry.register("overtime", OvertimeCalculator())
registry.register("leave", LeaveCalculator())
registry.register("severance", SeveranceCalculator())

# Usage - no if/elif needed!
def calculate(calculation_type: str, data: dict) -> dict:
    """Dispatch using registry - extensible!"""
    calculator = registry.get(calculation_type)
    return calculator.calculate(data)

# Adding new calculator doesn't require changing this code!
# Just register new calculator:
registry.register("bonus", BonusCalculator())  # Open/Closed Principle!
```

**Benefits**:
- No if/elif chains
- Easy to add new calculators (just register)
- Each calculator is independent and testable
- Follows Open/Closed Principle

**Priority**: 🟡 Medium - Improve architecture

---

#### [SMELL-005] Primitive Obsession 🟡 Medium
**File**: `app/models/employee.py:12`
**Severity**: 🟡 Medium
**Category**: OOP Abuser

**Issue Description**:
Using primitive types (str, int, float) instead of small objects to represent domain concepts.

**Current Code**:
```python
class Employee:
    """Employee model - uses primitives everywhere."""
    
    id: str  # Just a string, no validation
    name: str
    email: str  # Just a string, could be invalid
    phone: str  # Just a string, could be "abc"
    salary: float  # Using float for money - BAD!
    employment_type: str  # "full_time" or "part_time" - no type safety
    status: str  # "active", "inactive", "terminated" - magic strings
    hire_date: str  # Should be datetime, but it's a string!

# Usage - error-prone
employee = Employee(
    email="not-an-email",  # ❌ No validation
    salary=50000.555555,   # ❌ Too many decimals for money
    employment_type="fultime",  # ❌ Typo, should be "full_time"
    status="activ"  # ❌ Typo
)
```

**Problems**:
1. **No Type Safety**: Can assign any string to email, status, etc.
2. **No Validation**: Bad data accepted (invalid email, negative salary)
3. **Money Precision**: Using float for currency causes rounding errors
4. **Magic Strings**: Easy to typo "full_time" as "fulltime"
5. **Business Logic Scattered**: Validation logic not in one place

**Refactoring Strategy**: Replace Primitives with Value Objects

**Refactored Code**:
```python
from dataclasses import dataclass
from datetime import datetime
from decimal import Decimal
from enum import Enum
import re

# Value Objects - small, immutable, self-validating

class Email:
    """Email address value object."""
    
    _EMAIL_REGEX = re.compile(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
    
    def __init__(self, value: str):
        if not self._EMAIL_REGEX.match(value):
            raise ValueError(f"Invalid email: {value}")
        self._value = value.lower()
    
    @property
    def value(self) -> str:
        return self._value
    
    def __str__(self) -> str:
        return self._value
    
    def __eq__(self, other) -> bool:
        if isinstance(other, Email):
            return self._value == other._value
        return False

class Money:
    """Money value object using Decimal for precision."""
    
    def __init__(self, amount: Decimal | int | float):
        if isinstance(amount, float):
            # Warn about float, but convert
            import warnings
            warnings.warn("Use Decimal for money, not float")
        
        self._amount = Decimal(str(amount))
        
        if self._amount < 0:
            raise ValueError("Money cannot be negative")
    
    @property
    def amount(self) -> Decimal:
        return self._amount
    
    def __add__(self, other: 'Money') -> 'Money':
        return Money(self._amount + other._amount)
    
    def __str__(self) -> str:
        return f"NT${self._amount:,.0f}"

class EmploymentType(str, Enum):
    """Employment type - type-safe enumeration."""
    FULL_TIME = "full_time"
    PART_TIME = "part_time"
    CONTRACT = "contract"

class EmployeeStatus(str, Enum):
    """Employee status - type-safe enumeration."""
    ACTIVE = "active"
    INACTIVE = "inactive"
    TERMINATED = "terminated"

@dataclass
class Employee:
    """Employee with value objects - type-safe and validated."""
    
    id: str
    name: str
    email: Email  # Type-safe, validated
    salary: Money  # Precise, validated
    employment_type: EmploymentType  # Type-safe enum
    status: EmployeeStatus  # Type-safe enum
    hire_date: datetime  # Proper date type

# Usage - compile-time and runtime safety!
employee = Employee(
    id="emp_123",
    name="John Doe",
    email=Email("john@example.com"),  # ✅ Validates format
    salary=Money(Decimal("50000")),  # ✅ Precise, no rounding errors
    employment_type=EmploymentType.FULL_TIME,  # ✅ IDE autocomplete, type-safe
    status=EmployeeStatus.ACTIVE,  # ✅ Can't typo
    hire_date=datetime(2024, 1, 15)
)

# Typos caught at development time!
# employee.employment_type = "fultime"  # ❌ Type error, won't compile
# employee.status = EmployeeStatus.ACTIV  # ❌ IDE shows error immediately
```

**Benefits**:
- Type safety (IDE catches errors)
- Validation in one place (in value object)
- No magic strings
- Precise money calculations (no float rounding errors)
- Self-documenting (Money, Email types show intent)

**Priority**: 🟡 Medium - Improve gradually

---

### 3. Change Preventers

Code that is hard to change.

---

#### [SMELL-006] Divergent Change 🟠 High
**File**: `app/calculators/overtime.py`
**Severity**: 🟠 High
**Category**: Change Preventer

**Issue Description**:
Single class changes for multiple reasons. When law changes, UI changes, or calculation changes - all affect same class.

**Current Code**:
```python
class OvertimeCalculator:
    """Handles calculation, formatting, AND law logic - too many reasons to change!"""
    
    # Reason to change #1: Law changes
    def get_overtime_rate(self, tier: int) -> Decimal:
        if tier == 1:
            return Decimal("1.34")  # Article 24 §1
        elif tier == 2:
            return Decimal("1.67")  # Article 24 §2
    
    # Reason to change #2: Calculation logic changes
    def calculate(self, hours: Decimal, rate: Decimal) -> Decimal:
        tier1 = min(hours, 2) * rate * self.get_overtime_rate(1)
        # ... calculation
    
    # Reason to change #3: Formatting requirements change
    def format_result(self, amount: Decimal) -> str:
        return f"NT${amount:,.0f}"  # Taiwan currency format
    
    # Reason to change #4: Law article references change
    def get_legal_basis(self) -> str:
        return "Labor Standards Act Article 24 (2019 amendment)"
    
    # Reason to change #5: Validation rules change
    def validate(self, hours: Decimal) -> None:
        if hours > 80:
            raise ValueError("Overtime cannot exceed 80 hours/month")

# When ANY of these aspects change, we must modify this class!
```

**Problems**:
1. **Multiple Reasons to Change**: Violates Single Responsibility Principle
2. **Merge Conflicts**: Multiple developers changing same file
3. **Testing Complexity**: Changes to formatting affect calculation tests
4. **Fragile**: Change for one reason might break another aspect

**Refactoring Strategy**: Extract Class / Separate Concerns

**Refactored Code**:
```python
# 1. Law Rules (changes when law changes)
@dataclass
class OvertimeRules:
    """Labor Standards Act Article 24 overtime rules."""
    
    tier1_rate: Decimal = Decimal("4") / Decimal("3")  # 1.34 (Article 24 §1)
    tier2_rate: Decimal = Decimal("5") / Decimal("3")  # 1.67 (Article 24 §2)
    tier1_hours: Decimal = Decimal("2")
    tier2_hours: Decimal = Decimal("2")
    max_monthly_hours: int = 80
    
    legal_basis: str = "Labor Standards Act Article 24 (2019 amendment)"
    
    @classmethod
    def from_law_version(cls, version: str) -> 'OvertimeRules':
        """Create rules for specific law version."""
        if version == "2019":
            return cls()  # Current rules
        elif version == "2015":
            # Different rates before 2019
            return cls(tier1_rate=Decimal("1.25"))
        else:
            raise ValueError(f"Unknown law version: {version}")

# 2. Validation Logic (changes when validation rules change)
class OvertimeValidator:
    """Validate overtime calculation requests."""
    
    def __init__(self, rules: OvertimeRules):
        self.rules = rules
    
    def validate(self, hours: Decimal, rate: Decimal) -> None:
        """Validate overtime request."""
        if hours < 0:
            raise ValidationError("Hours must be >= 0")
        if hours > self.rules.max_monthly_hours:
            raise ValidationError(
                f"Monthly overtime cannot exceed {self.rules.max_monthly_hours} hours"
            )
        if rate <= 0:
            raise ValidationError("Rate must be > 0")

# 3. Calculation Logic (changes when calculation algorithm changes)
class OvertimeCalculator:
    """Calculate overtime pay - focused on calculation only."""
    
    def __init__(self, rules: OvertimeRules):
        self.rules = rules
    
    def calculate(self, hours: Decimal, base_rate: Decimal) -> Decimal:
        """Calculate overtime pay using tiered rates."""
        tier1 = min(hours, self.rules.tier1_hours) * base_rate * self.rules.tier1_rate
        
        tier2 = Decimal("0")
        if hours > self.rules.tier1_hours:
            tier2_hours = min(
                hours - self.rules.tier1_hours,
                self.rules.tier2_hours
            )
            tier2 = tier2_hours * base_rate * self.rules.tier2_rate
        
        tier3 = Decimal("0")
        if hours > (self.rules.tier1_hours + self.rules.tier2_hours):
            tier3_hours = hours - self.rules.tier1_hours - self.rules.tier2_hours
            tier3 = tier3_hours * base_rate * self.rules.tier2_rate
        
        return tier1 + tier2 + tier3

# 4. Formatting (changes when display requirements change)
class CurrencyFormatter:
    """Format currency for display."""
    
    @staticmethod
    def format_tw_currency(amount: Decimal) -> str:
        """Format as Taiwan currency."""
        return f"NT${amount:,.0f}"

# Usage - each class has single reason to change
rules = OvertimeRules()
validator = OvertimeValidator(rules)
calculator = OvertimeCalculator(rules)
formatter = CurrencyFormatter()

# Now when law changes, only OvertimeRules changes
# When formatting changes, only CurrencyFormatter changes
# etc.
```

**Benefits**:
- Each class has single reason to change
- Easier to maintain (find the right place to change)
- Less merge conflicts (different devs work on different classes)
- Easier to test (test each concern independently)

**Priority**: 🟠 High - Refactor for maintainability

---

### 4. Dispensables

Unnecessary code that should be removed.

---

#### [SMELL-007] Dead Code 🟡 Medium
**File**: `app/utils/legacy.py:45-89`
**Severity**: 🟡 Medium
**Category**: Dispensable

**Issue Description**:
Unused functions, commented-out code, unreachable branches. Makes codebase harder to understand.

**Current Code**:
```python
# def old_calculate_overtime(hours, rate):  # ❌ Commented out
#     """Old calculation method - REMOVE THIS!"""
#     return hours * rate * 1.25

def calculate_overtime(hours: Decimal, rate: Decimal) -> Decimal:
    """Current calculation."""
    if False:  # ❌ Dead code, never executed
        return Decimal("0")
    
    # Old calculation method - no longer used
    # return hours * rate * Decimal("1.25")  # ❌ Commented code
    
    return _calculate_with_tiers(hours, rate)

def unused_helper_function():  # ❌ Never called anywhere
    """This function is never used - DELETE IT!"""
    pass

# Old constants - not used anymore
OLD_RATE = 1.25  # ❌ Dead constant
DEPRECATED_MAX_HOURS = 50  # ❌ Dead constant
```

**Problems**:
1. **Confusing**: Is commented code important? Should we use it?
2. **Maintenance Burden**: Need to update dead code when refactoring
3. **Clutter**: Harder to find actual working code
4. **Version Control Abuse**: Git history is for old code, not comments

**Refactoring Strategy**: Delete Dead Code

**Refactored Code**:
```python
def calculate_overtime(hours: Decimal, rate: Decimal) -> Decimal:
    """Calculate overtime pay using tiered rates."""
    return _calculate_with_tiers(hours, rate)

# That's it! Clean and simple.
# If you need old code, check git history.
```

**Benefits**:
- Easier to understand (less code to read)
- Less maintenance burden
- Clear what's actually used
- Git history preserves old code if needed

**Priority**: 🟡 Medium - Clean up during refactoring

---

#### [SMELL-008] Duplicate Code 🔴 Critical
**File**: Multiple files
**Severity**: 🔴 Critical
**Category**: Dispensable

**Issue Description**:
Same logic repeated in multiple places. Violates DRY (Don't Repeat Yourself) principle.

**Current Code**:
```python
# File 1: app/calculators/overtime.py
def calculate_overtime(...):
    # Validation logic - DUPLICATED
    if hours < 0:
        raise ValidationError("Hours must be >= 0")
    if hours > 80:
        raise ValidationError("Hours cannot exceed 80")
    # ... calculation

# File 2: app/calculators/leave.py
def calculate_leave(...):
    # Same validation logic - DUPLICATED!
    if hours < 0:
        raise ValidationError("Hours must be >= 0")
    if hours > 80:
        raise ValidationError("Hours cannot exceed 80")
    # ... calculation

# File 3: app/api/endpoints.py
@router.post("/calculate")
def calculate_endpoint(...):
    # Same validation again - DUPLICATED!
    if request.hours < 0:
        raise ValidationError("Hours must be >= 0")
    if request.hours > 80:
        raise ValidationError("Hours cannot exceed 80")
    # ... endpoint logic
```

**Problems**:
1. **Maintenance Nightmare**: Bug fix needs to be applied in 3 places
2. **Inconsistency Risk**: Easy to fix in one place, forget others
3. **Testing Burden**: Same logic tested multiple times
4. **Violation of DRY**: Don't Repeat Yourself

**Refactoring Strategy**: Extract Function

**Refactored Code**:
```python
# app/utils/validation.py
def validate_hours(hours: Decimal, max_hours: int = 80) -> None:
    """
    Validate hours value.
    
    Args:
        hours: Hours to validate
        max_hours: Maximum allowed hours
    
    Raises:
        ValidationError: If validation fails
    """
    if hours < 0:
        raise ValidationError("Hours must be >= 0")
    if hours > max_hours:
        raise ValidationError(f"Hours cannot exceed {max_hours}")

# Now use everywhere - DRY!

# File 1: app/calculators/overtime.py
from app.utils.validation import validate_hours

def calculate_overtime(hours: Decimal, rate: Decimal) -> Decimal:
    validate_hours(hours)  # ✅ Single source of truth
    # ... calculation

# File 2: app/calculators/leave.py
from app.utils.validation import validate_hours

def calculate_leave(hours: Decimal) -> LeaveEntitlement:
    validate_hours(hours)  # ✅ Same validation
    # ... calculation

# File 3: app/api/endpoints.py
from app.utils.validation import validate_hours

@router.post("/calculate")
def calculate_endpoint(request: CalculationRequest):
    validate_hours(request.hours)  # ✅ Consistent validation
    # ... endpoint logic
```

**Benefits**:
- Single source of truth (fix once, fixed everywhere)
- Consistent behavior
- Easier to test (test once)
- Less code to maintain

**Priority**: 🔴 Critical - Fix immediately (technical debt)

---

### 5. Couplers

Excessive coupling between classes.

---

#### [SMELL-009] Feature Envy 🟡 Medium
**File**: `app/services/report_generator.py:67`
**Severity**: 🟡 Medium
**Category**: Coupler

**Issue Description**:
Method uses data from another class more than its own class. Should probably move to that class.

**Current Code**:
```python
class ReportGenerator:
    """Generate reports."""
    
    def generate_employee_summary(self, employee: Employee) -> str:
        """Generate summary - but uses mostly Employee data!"""
        
        # This method is "envious" of Employee class
        # It accesses employee data more than its own data
        summary = []
        summary.append(f"Name: {employee.name}")
        summary.append(f"Email: {employee.email}")
        summary.append(f"Tenure: {employee.tenure_years} years")
        summary.append(f"Type: {employee.employment_type}")
        summary.append(f"Annual Leave: {employee.calculate_annual_leave()} days")
        summary.append(f"Salary: {employee.format_salary()}")
        
        # Only uses self.title (own data) once
        return f"{self.title}\n" + "\n".join(summary)
    
    # This method should probably be in Employee class!
```

**Problems**:
1. **Wrong Place**: Method is in wrong class (should be in Employee)
2. **Tight Coupling**: ReportGenerator knows too much about Employee internals
3. **Maintenance**: Changes to Employee require changes to ReportGenerator
4. **Violates Tell Don't Ask**: Asks for data instead of telling what to do

**Refactoring Strategy**: Move Method

**Refactored Code**:
```python
class Employee:
    """Employee model - now has its own summary method."""
    
    def generate_summary(self) -> str:
        """
        Generate employee summary.
        
        This method belongs here because it primarily uses Employee data.
        """
        summary = []
        summary.append(f"Name: {self.name}")
        summary.append(f"Email: {self.email}")
        summary.append(f"Tenure: {self.tenure_years} years")
        summary.append(f"Type: {self.employment_type}")
        summary.append(f"Annual Leave: {self.calculate_annual_leave()} days")
        summary.append(f"Salary: {self.format_salary()}")
        
        return "\n".join(summary)

class ReportGenerator:
    """Generate reports - now just orchestrates."""
    
    def generate_employee_report(self, employee: Employee) -> str:
        """Generate employee report - delegates to Employee."""
        return f"{self.title}\n{employee.generate_summary()}"
        # Much simpler! Follows Tell Don't Ask principle
```

**Benefits**:
- Method is in the right place (with its data)
- Loose coupling (ReportGenerator doesn't know Employee internals)
- Employee is more cohesive
- Easier to test Employee in isolation

**Priority**: 🟡 Medium - Improve design

---

## Technical Debt Assessment

### Debt Score: 68/100

**Category Breakdown**:
| Category | Score | Impact |
|----------|-------|--------|
| Bloaters (Long Method, Large Class) | 25/100 | 🔴 High |
| OOP Abusers (Switch, Primitives) | 15/100 | 🟡 Medium |
| Change Preventers (Divergent Change) | 12/100 | 🟠 High |
| Dispensables (Dead Code, Duplication) | 10/100 | 🟡 Medium |
| Couplers (Feature Envy) | 6/100 | 🟢 Low |

**Priority Actions**:
1. 🔴 Fix Long Method (SMELL-001) - Complexity 18 is critical
2. 🔴 Remove Duplicate Code (SMELL-008) - Maintenance nightmare
3. 🟠 Refactor God Class (SMELL-002) - Split into focused classes
4. 🟠 Separate Concerns (SMELL-006) - Reduce reasons to change

---

## Refactoring Recommendations

### Immediate (This Sprint)
1. **SMELL-001**: Extract methods from 68-line function
2. **SMELL-008**: Consolidate duplicate validation logic

### Short-term (Next 2 Sprints)
3. **SMELL-002**: Split God Class into domain-specific calculators
4. **SMELL-006**: Separate law rules, calculation, and formatting

### Long-term (Next Quarter)
5. **SMELL-003**: Introduce parameter objects where appropriate
6. **SMELL-004**: Replace type checking with polymorphism
7. **SMELL-007**: Clean up dead code during regular refactoring

---

## Prevention Strategies

### Code Review Checklist
- [ ] No function > 50 lines
- [ ] No class > 300 lines
- [ ] Cyclomatic complexity ≤ 10
- [ ] No duplicate code (check with radon)
- [ ] Clear separation of concerns

### Automated Checks
```bash
# Complexity check
radon cc -s -a app/ --total-average

# Duplication check
radon raw -s app/

# Dead code check
vulture app/
```

### Team Practices
- Pair programming for complex features
- Regular refactoring sprints (1 per quarter)
- Code smell training sessions
- Celebrate good refactorings!

---
```

## Code Smell Catalog

### Bloaters
- Long Method (> 50 lines)
- Large Class (> 300 lines, > 20 methods)
- Long Parameter List (> 4 parameters)
- Data Clumps (same group of parameters together)

### OOP Abusers
- Switch Statements (type checking instead of polymorphism)
- Primitive Obsession (using primitives instead of value objects)
- Temporary Field (field only used in certain cases)
- Refused Bequest (subclass doesn't use parent methods)

### Change Preventers
- Divergent Change (class changes for multiple reasons)
- Shotgun Surgery (one change requires changes in many classes)
- Parallel Inheritance Hierarchies (adding subclass requires adding another)

### Dispensables
- Comments (explaining bad code instead of fixing it)
- Duplicate Code (same code in multiple places)
- Dead Code (unused functions, variables, parameters)
- Speculative Generality (over-engineering for future needs)

### Couplers
- Feature Envy (method uses another class's data more than its own)
- Inappropriate Intimacy (classes know too much about each other)
- Message Chains (a.b().c().d() - Law of Demeter violation)
- Middle Man (class just delegates to another class)

---

## Example Usage

Input: `/code-smell` or `/code-smell app/services/`
Output: [Full code smell report as shown above]

Input: `/code-smell --quick`
Output: [Summary with top 5 critical smells]
