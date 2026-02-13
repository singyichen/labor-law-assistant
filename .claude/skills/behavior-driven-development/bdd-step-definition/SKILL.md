---
name: bdd-step-definition
description: Generate pytest-bdd step definitions (Python) that implement feature file scenarios. Use when creating executable test code that maps to Gherkin steps with proper fixtures, assertions, and error handling.
---

You are a test automation engineer specializing in pytest-bdd. Write clean, maintainable step definitions that implement Gherkin scenarios.

## Instructions

When the user provides a feature or scenario via `$ARGUMENTS`:

1. **Analyze** the Gherkin steps that need implementation
2. **Create** step definitions using pytest-bdd decorators
3. **Use** pytest fixtures for setup and teardown
4. **Implement** clear assertions with helpful error messages
5. **Handle** data tables and scenario outlines appropriately
6. **Follow** Python best practices (type hints, docstrings, PEP 8)
7. **Ensure** steps are reusable across scenarios
8. **Add** proper error handling and logging

## File Structure

```
tests/
├── features/
│   ├── overtime/
│   │   └── weekday_overtime.feature
│   └── leave/
│       └── annual_leave.feature
├── step_defs/
│   ├── __init__.py
│   ├── conftest.py                    # Shared fixtures
│   ├── overtime/
│   │   ├── __init__.py
│   │   └── test_weekday_overtime.py   # Step definitions
│   └── leave/
│       ├── __init__.py
│       └── test_annual_leave.py
├── fixtures/
│   ├── __init__.py
│   ├── database.py                    # DB fixtures
│   ├── api_client.py                  # API client fixtures
│   └── test_data.py                   # Test data factories
└── utils/
    ├── __init__.py
    ├── assertions.py                  # Custom assertions
    └── helpers.py                     # Test helpers
```

---

## pytest-bdd Basics

### Step Definition Decorators

```python
from pytest_bdd import scenarios, given, when, then, parsers

# Load all scenarios from feature file
scenarios('../features/overtime/weekday_overtime.feature')

# Basic step definition
@given('an employee exists')
def employee_exists():
    """Create a basic employee."""
    pass

# Step with simple string parameter
@given('an employee with salary of NT$48000')
def employee_with_salary():
    pass

# Step with parsed parameter
@given(parsers.parse('an employee with salary of NT${salary:d}'))
def employee_with_parsed_salary(salary: int):
    """Create employee with specified salary.

    Args:
        salary: Monthly salary in NT$
    """
    pass

# Step with regex parameter
@given(parsers.re(r'an employee "(?P<name>.*)" with salary of NT\$(?P<salary>\d+)'))
def employee_with_name_salary(name: str, salary: str):
    """Create named employee with salary."""
    pass

# Step with table data
@given(parsers.parse('the following employee details'))
def employee_with_details(table):
    """Create employee from table data.

    Args:
        table: pytest-bdd table with employee details
    """
    for row in table:
        # row is a dict: {'field': 'value', ...}
        pass
```

### Parser Types

| Parser | Use Case | Example |
|--------|----------|---------|
| `parsers.parse()` | Simple typed parameters | `parsers.parse('salary of NT${amount:d}')` |
| `parsers.re()` | Complex regex patterns | `parsers.re(r'(?P<count>\d+) employees?')` |
| `parsers.cfparse()` | Custom format converters | `parsers.cfparse('date {date:Date}')` |

### Type Conversions in parsers.parse()

```python
# Built-in types
parsers.parse('value is {number:d}')      # int
parsers.parse('value is {number:f}')      # float
parsers.parse('value is {text:w}')        # word (no spaces)
parsers.parse('value is {text:S}')        # non-whitespace

# Custom converters (define in conftest.py)
@parsers.cfparse.with_pattern(r'\d{4}-\d{2}-\d{2}')
def parse_date(text: str) -> date:
    """Parse ISO date string."""
    return datetime.strptime(text, '%Y-%m-%d').date()
```

---

## Step Definition Patterns

### Pattern 1: Given Steps (Setup/Context)

```python
from pytest_bdd import given, parsers
from decimal import Decimal
from datetime import datetime, date
import pytest

@given('the payroll system is running')
def payroll_system_running(db_session, api_client):
    """Ensure system is ready for tests.

    Args:
        db_session: Database session fixture
        api_client: API client fixture
    """
    # Verify database is accessible
    assert db_session.execute("SELECT 1").scalar() == 1

    # Verify API is responsive
    response = api_client.get('/health')
    assert response.status_code == 200

@given(parsers.parse('an employee "{name}" exists with the following details'))
def employee_with_details(name: str, datatable, employee_factory, db_session):
    """Create employee from data table.

    Args:
        name: Employee name
        datatable: pytest-bdd table with employee details
        employee_factory: Factory fixture for creating employees
        db_session: Database session
    """
    # Convert table to dict
    details = {row['field']: row['value'] for row in datatable}

    # Create employee using factory
    employee = employee_factory.create(
        name=name,
        employee_id=details.get('employee_id'),
        base_salary=Decimal(details.get('base_salary', '0')),
        department=details.get('department'),
        hire_date=datetime.strptime(details['hire_date'], '%Y-%m-%d').date() if 'hire_date' in details else None
    )

    db_session.add(employee)
    db_session.commit()

    return employee

@given(parsers.parse('employee "{name}" has worked for {years:d} years and {months:d} months'))
def employee_tenure(name: str, years: int, months: int, db_session, employee_repo):
    """Set employee tenure.

    Args:
        name: Employee name
        years: Years of service
        months: Additional months
        db_session: Database session
        employee_repo: Employee repository
    """
    employee = employee_repo.get_by_name(name)

    # Calculate hire date based on tenure
    from dateutil.relativedelta import relativedelta
    hire_date = date.today() - relativedelta(years=years, months=months)

    employee.hire_date = hire_date
    db_session.commit()

@given(parsers.parse('employee "{name}" has {hours:f} overtime hours this month'))
def employee_overtime_balance(name: str, hours: float, overtime_service, employee_repo):
    """Set employee's current overtime balance.

    Args:
        name: Employee name
        hours: Overtime hours already accumulated
        overtime_service: Overtime calculation service
        employee_repo: Employee repository
    """
    employee = employee_repo.get_by_name(name)

    # Record overtime hours
    overtime_service.record_overtime(
        employee_id=employee.id,
        hours=Decimal(str(hours)),
        month=date.today().replace(day=1)
    )
```

### Pattern 2: When Steps (Actions)

```python
from pytest_bdd import when, parsers

@when(parsers.parse('I calculate overtime for {hours:f} hours'))
def calculate_overtime(hours: float, overtime_calculator, context):
    """Calculate overtime pay.

    Args:
        hours: Total hours worked
        overtime_calculator: Overtime calculation service
        context: Test context to store result
    """
    try:
        result = overtime_calculator.calculate(total_hours=Decimal(str(hours)))
        context['calculation_result'] = result
        context['calculation_error'] = None
    except Exception as e:
        context['calculation_result'] = None
        context['calculation_error'] = e

@when(parsers.parse('employee "{name}" works {hours:f} hours in week ending "{week_end}"'))
def employee_works_hours(name: str, hours: float, week_end: str, timesheet_service, employee_repo):
    """Record employee work hours.

    Args:
        name: Employee name
        hours: Total hours worked
        week_end: Week ending date (ISO format)
        timesheet_service: Timesheet service
        employee_repo: Employee repository
    """
    employee = employee_repo.get_by_name(name)
    week_end_date = datetime.strptime(week_end, '%Y-%m-%d').date()

    timesheet_service.record_hours(
        employee_id=employee.id,
        hours=Decimal(str(hours)),
        week_ending=week_end_date
    )

@when('I submit the overtime calculation')
def submit_calculation(context, overtime_service):
    """Submit overtime calculation for saving.

    Args:
        context: Test context with calculation result
        overtime_service: Overtime service
    """
    if 'calculation_result' not in context:
        raise ValueError("No calculation result in context. Did you calculate first?")

    try:
        saved_record = overtime_service.save(context['calculation_result'])
        context['saved_record'] = saved_record
        context['save_error'] = None
    except Exception as e:
        context['saved_record'] = None
        context['save_error'] = e

@when(parsers.parse('I attempt to add {hours:f} more overtime hours'))
def attempt_add_overtime(hours: float, context, overtime_service):
    """Attempt to add more overtime hours.

    Args:
        hours: Additional hours to add
        context: Test context
        overtime_service: Overtime service
    """
    try:
        result = overtime_service.add_overtime(
            employee_id=context['employee'].id,
            additional_hours=Decimal(str(hours))
        )
        context['add_result'] = result
        context['add_error'] = None
    except Exception as e:
        context['add_result'] = None
        context['add_error'] = e
```

### Pattern 3: Then Steps (Assertions)

```python
from pytest_bdd import then, parsers
from decimal import Decimal

@then(parsers.parse('the overtime pay should be NT${amount:d}'))
def verify_overtime_pay(amount: int, context):
    """Verify calculated overtime pay.

    Args:
        amount: Expected amount in NT$
        context: Test context with calculation result
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    expected = Decimal(amount)
    actual = result.overtime_pay

    assert actual == expected, (
        f"Overtime pay mismatch: expected NT${expected}, got NT${actual}"
    )

@then(parsers.parse('the overtime pay should be NT${amount:f}'))
def verify_overtime_pay_decimal(amount: float, context):
    """Verify overtime pay with decimal precision.

    Args:
        amount: Expected amount (can be decimal)
        context: Test context
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    expected = Decimal(str(amount))
    actual = result.overtime_pay

    # Allow small rounding differences
    tolerance = Decimal('0.01')
    difference = abs(actual - expected)

    assert difference <= tolerance, (
        f"Overtime pay mismatch: expected NT${expected}, got NT${actual} "
        f"(difference: NT${difference})"
    )

@then('the system should display success message "計算完成"')
def verify_success_message(context):
    """Verify success message displayed.

    Args:
        context: Test context with UI state
    """
    # This would interact with UI or check API response
    assert context.get('message') == '計算完成', \
        f"Expected success message, got: {context.get('message')}"

@then(parsers.parse('the system should reference "{legal_ref}"'))
def verify_legal_reference(legal_ref: str, context):
    """Verify legal reference is included.

    Args:
        legal_ref: Expected legal reference text
        context: Test context
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    assert hasattr(result, 'legal_reference'), "Result has no legal_reference field"
    assert result.legal_reference == legal_ref, (
        f"Legal reference mismatch: expected '{legal_ref}', "
        f"got '{result.legal_reference}'"
    )

@then('the calculation breakdown should show')
def verify_breakdown(datatable, context):
    """Verify calculation breakdown matches table.

    Args:
        datatable: Expected breakdown
        context: Test context
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    expected_breakdown = [
        {
            'description': row['description'],
            'hours': Decimal(row['hours']),
            'rate': row['rate'],
            'amount': Decimal(row['amount'])
        }
        for row in datatable
    ]

    actual_breakdown = result.breakdown

    assert len(actual_breakdown) == len(expected_breakdown), (
        f"Breakdown count mismatch: expected {len(expected_breakdown)}, "
        f"got {len(actual_breakdown)}"
    )

    for i, (expected, actual) in enumerate(zip(expected_breakdown, actual_breakdown)):
        assert actual['description'] == expected['description'], \
            f"Row {i}: description mismatch"
        assert actual['hours'] == expected['hours'], \
            f"Row {i}: hours mismatch"
        assert actual['amount'] == expected['amount'], \
            f"Row {i}: amount mismatch"

@then(parsers.parse('display error message "{error_msg}"'))
def verify_error_message(error_msg: str, context):
    """Verify error message is displayed.

    Args:
        error_msg: Expected error message
        context: Test context
    """
    error = context.get('calculation_error') or context.get('save_error')
    assert error is not None, "Expected error but none occurred"

    actual_message = str(error)
    assert error_msg in actual_message, (
        f"Error message mismatch: expected '{error_msg}' in '{actual_message}'"
    )

@then(parsers.parse('the system should show {level} warning'))
def verify_warning_level(level: str, context):
    """Verify warning level.

    Args:
        level: Warning level (info, warning, critical)
        context: Test context
    """
    warnings = context.get('warnings', [])
    assert len(warnings) > 0, "No warnings found"

    assert any(w.level == level for w in warnings), (
        f"No {level} warning found. Warnings: {[w.level for w in warnings]}"
    )
```

### Pattern 4: Data Table Handling

```python
from pytest_bdd import given, then, parsers

@given('the following employees exist')
def create_multiple_employees(datatable, employee_factory, db_session):
    """Create multiple employees from table.

    Args:
        datatable: Table with employee data
        employee_factory: Factory for creating employees
        db_session: Database session
    """
    employees = []

    for row in datatable:
        employee = employee_factory.create(
            name=row['name'],
            base_salary=Decimal(row['base_salary']),
            department=row['department']
        )
        employees.append(employee)

    db_session.add_all(employees)
    db_session.commit()

    return employees

@then('the overtime breakdown should be')
def verify_complex_breakdown(datatable, context):
    """Verify detailed breakdown table.

    Args:
        datatable: Expected breakdown with multiple columns
        context: Test context
    """
    result = context['calculation_result']

    # Table headers: hour_range, hours, rate, subtotal
    for i, expected_row in enumerate(datatable):
        actual_row = result.breakdown[i]

        assert actual_row.hour_range == expected_row['hour_range']
        assert actual_row.hours == Decimal(expected_row['hours'])
        assert actual_row.rate == expected_row['rate']
        assert actual_row.subtotal == Decimal(expected_row['subtotal'])
```

### Pattern 5: Scenario Outline Support

```python
# Feature file with Scenario Outline
"""
Scenario Outline: Calculate overtime for various hours
  Given an employee with base rate of NT$<base_rate>
  When the employee works <total_hours> hours
  Then the overtime pay should be NT$<expected_pay>

  Examples:
    | base_rate | total_hours | expected_pay |
    | 200       | 41          | 268          |
    | 200       | 42          | 536          |
"""

# Step definitions automatically handle parameterization
@given(parsers.parse('an employee with base rate of NT${rate:d}'))
def employee_with_rate(rate: int, context, employee_factory):
    """Create employee with specified base rate.

    Args:
        rate: Hourly base rate
        context: Test context
        employee_factory: Employee factory
    """
    context['employee'] = employee_factory.create(
        base_hourly_rate=Decimal(rate)
    )

# The same step definition works for all Examples rows
```

---

## Fixtures and Context

### conftest.py - Shared Fixtures

```python
"""Shared pytest fixtures for BDD tests."""
import pytest
from decimal import Decimal
from datetime import date, datetime
from sqlalchemy import create_engine
from sqlalchemy.orm import Session, sessionmaker

from app.database import Base
from app.models import Employee, OvertimeRecord
from app.services import OvertimeCalculator, EmployeeRepository


@pytest.fixture(scope='function')
def db_session():
    """Provide database session with transaction rollback.

    Yields:
        Session: SQLAlchemy session
    """
    # Use in-memory SQLite for tests
    engine = create_engine('sqlite:///:memory:')
    Base.metadata.create_all(engine)

    SessionLocal = sessionmaker(bind=engine)
    session = SessionLocal()

    yield session

    session.rollback()
    session.close()


@pytest.fixture(scope='function')
def context():
    """Provide shared context dictionary for steps.

    Returns:
        dict: Mutable context shared across steps in a scenario
    """
    return {}


@pytest.fixture
def employee_factory(db_session):
    """Factory for creating test employees.

    Args:
        db_session: Database session

    Returns:
        EmployeeFactory: Factory instance
    """
    class EmployeeFactory:
        """Factory for creating test employees."""

        def __init__(self, session: Session):
            """Initialize factory.

            Args:
                session: Database session
            """
            self.session = session
            self._counter = 0

        def create(
            self,
            name: str = None,
            employee_id: str = None,
            base_salary: Decimal = Decimal('48000'),
            base_hourly_rate: Decimal = None,
            department: str = 'Engineering',
            hire_date: date = None
        ) -> Employee:
            """Create employee with defaults.

            Args:
                name: Employee name
                employee_id: Employee ID
                base_salary: Monthly salary
                base_hourly_rate: Hourly rate (overrides salary)
                department: Department name
                hire_date: Hire date

            Returns:
                Employee: Created employee instance
            """
            self._counter += 1

            if name is None:
                name = f'Test Employee {self._counter}'

            if employee_id is None:
                employee_id = f'EMP-{self._counter:03d}'

            if hire_date is None:
                hire_date = date(2020, 1, 1)

            # Calculate hourly rate from salary if not provided
            if base_hourly_rate is None:
                base_hourly_rate = base_salary / Decimal('240')

            employee = Employee(
                employee_id=employee_id,
                name=name,
                base_salary=base_salary,
                base_hourly_rate=base_hourly_rate,
                department=department,
                hire_date=hire_date
            )

            self.session.add(employee)
            self.session.flush()  # Get ID without committing

            return employee

    return EmployeeFactory(db_session)


@pytest.fixture
def overtime_calculator():
    """Provide overtime calculator service.

    Returns:
        OvertimeCalculator: Calculator instance
    """
    return OvertimeCalculator()


@pytest.fixture
def employee_repo(db_session):
    """Provide employee repository.

    Args:
        db_session: Database session

    Returns:
        EmployeeRepository: Repository instance
    """
    return EmployeeRepository(db_session)


@pytest.fixture
def taiwan_labor_law_rates():
    """Provide Taiwan Labor Standards Act overtime rates.

    Returns:
        dict: Overtime rate configuration
    """
    return {
        'weekday_first_2_hours': Decimal('1.34'),
        'weekday_hours_3_4': Decimal('1.67'),
        'holiday': Decimal('2.00'),
        'rest_day_first_2_hours': Decimal('1.34'),
        'rest_day_hours_3_plus': Decimal('1.67'),
        'monthly_limit': Decimal('46')
    }
```

### Custom Assertions

```python
"""Custom assertion helpers for BDD tests."""
from decimal import Decimal
from typing import Any


def assert_decimal_equal(
    actual: Decimal,
    expected: Decimal,
    tolerance: Decimal = Decimal('0.01'),
    message: str = None
) -> None:
    """Assert two decimal values are equal within tolerance.

    Args:
        actual: Actual value
        expected: Expected value
        tolerance: Acceptable difference
        message: Custom error message

    Raises:
        AssertionError: If values differ by more than tolerance
    """
    difference = abs(actual - expected)

    if difference > tolerance:
        error_msg = message or (
            f"Decimal mismatch: expected {expected}, got {actual} "
            f"(difference: {difference}, tolerance: {tolerance})"
        )
        raise AssertionError(error_msg)


def assert_contains_chinese(text: str, expected_phrase: str) -> None:
    """Assert text contains Chinese phrase.

    Args:
        text: Text to search in
        expected_phrase: Phrase to find

    Raises:
        AssertionError: If phrase not found
    """
    if expected_phrase not in text:
        raise AssertionError(
            f"Expected phrase '{expected_phrase}' not found in text: {text}"
        )


def assert_legal_reference(result: Any, article: str) -> None:
    """Assert result contains legal reference.

    Args:
        result: Calculation result
        article: Expected article reference

    Raises:
        AssertionError: If reference missing or incorrect
    """
    if not hasattr(result, 'legal_reference'):
        raise AssertionError("Result has no legal_reference attribute")

    if result.legal_reference != article:
        raise AssertionError(
            f"Legal reference mismatch: expected '{article}', "
            f"got '{result.legal_reference}'"
        )
```

---

## Complete Example

Input: `/bdd-step-definition Implement steps for weekday overtime calculation`

Output:

```python
"""Step definitions for weekday overtime calculation.

This module implements step definitions for the weekday_overtime.feature file,
testing overtime pay calculation according to Taiwan Labor Standards Act Article 24.
"""
from decimal import Decimal
from datetime import date, datetime
import pytest
from pytest_bdd import scenarios, given, when, then, parsers

from app.models import Employee, OvertimeRecord
from app.services import OvertimeCalculator
from app.exceptions import ValidationError


# Load all scenarios from the feature file
scenarios('../features/overtime/weekday_overtime.feature')


# ============================================================================
# Given Steps (Setup/Context)
# ============================================================================

@given('the payroll system is running')
def payroll_system_running(db_session):
    """Ensure payroll system is ready.

    Args:
        db_session: Database session fixture
    """
    # Verify database is accessible
    result = db_session.execute("SELECT 1").scalar()
    assert result == 1, "Database not accessible"


@given('the current calculation uses Taiwan Labor Standards Act rates')
def taiwan_labor_law_rates_configured(taiwan_labor_law_rates, overtime_calculator):
    """Configure overtime calculator with Taiwan labor law rates.

    Args:
        taiwan_labor_law_rates: Fixture with rate configuration
        overtime_calculator: Overtime calculator service
    """
    overtime_calculator.configure_rates(taiwan_labor_law_rates)


@given(parsers.parse('an employee "{name}" exists with the following details'))
def create_employee_with_details(
    name: str,
    datatable,
    employee_factory,
    db_session,
    context
):
    """Create employee from data table.

    Args:
        name: Employee name
        datatable: Table with employee details
        employee_factory: Factory for creating employees
        db_session: Database session
        context: Shared test context
    """
    # Convert table to dict
    details = {row['field']: row['value'] for row in datatable}

    # Create employee
    employee = employee_factory.create(
        name=name,
        employee_id=details.get('employee_id'),
        base_salary=Decimal(details.get('base_salary', '48000')),
        department=details.get('department', 'Engineering')
    )

    db_session.commit()

    # Store in context for other steps
    context['employee'] = employee
    context[f'employee_{name}'] = employee


@given(parsers.parse('employee "{name}" has base hourly rate of NT${rate:d}'))
def set_employee_hourly_rate(name: str, rate: int, context, db_session):
    """Set employee's base hourly rate.

    Args:
        name: Employee name
        rate: Hourly rate in NT$
        context: Test context
        db_session: Database session
    """
    employee = context.get(f'employee_{name}')
    assert employee is not None, f"Employee {name} not found in context"

    employee.base_hourly_rate = Decimal(rate)
    db_session.commit()


@given('the standard work week is 40 hours')
def standard_work_week(overtime_calculator):
    """Configure standard work week hours.

    Args:
        overtime_calculator: Overtime calculator service
    """
    overtime_calculator.standard_weekly_hours = Decimal('40')


@given(parsers.parse('employee "{name}" has worked {hours:f} overtime hours this month'))
def set_employee_monthly_overtime(
    name: str,
    hours: float,
    context,
    db_session
):
    """Set employee's accumulated overtime this month.

    Args:
        name: Employee name
        hours: Overtime hours accumulated
        context: Test context
        db_session: Database session
    """
    employee = context[f'employee_{name}']

    # Create overtime record for current month
    record = OvertimeRecord(
        employee_id=employee.id,
        month=date.today().replace(day=1),
        total_overtime_hours=Decimal(str(hours)),
        created_at=datetime.now()
    )

    db_session.add(record)
    db_session.commit()


# ============================================================================
# When Steps (Actions)
# ============================================================================

@when(parsers.parse('employee "{name}" works {hours:f} hours in week ending "{week_end}"'))
def employee_works_hours(
    name: str,
    hours: float,
    week_end: str,
    context,
    overtime_calculator
):
    """Calculate overtime for employee's work hours.

    Args:
        name: Employee name
        hours: Total hours worked
        week_end: Week ending date (YYYY-MM-DD)
        context: Test context
        overtime_calculator: Overtime calculator
    """
    employee = context[f'employee_{name}']
    week_end_date = datetime.strptime(week_end, '%Y-%m-%d').date()

    try:
        result = overtime_calculator.calculate_weekly_overtime(
            employee=employee,
            total_hours=Decimal(str(hours)),
            week_ending=week_end_date
        )

        context['calculation_result'] = result
        context['calculation_error'] = None
    except Exception as e:
        context['calculation_result'] = None
        context['calculation_error'] = e


@when(parsers.parse('I calculate overtime for {hours:f} hours'))
def calculate_overtime(hours: float, context, overtime_calculator):
    """Calculate overtime for given hours.

    Args:
        hours: Total hours worked
        context: Test context
        overtime_calculator: Overtime calculator
    """
    employee = context.get('employee')

    try:
        result = overtime_calculator.calculate(
            employee=employee,
            total_hours=Decimal(str(hours))
        )

        context['calculation_result'] = result
        context['calculation_error'] = None
    except Exception as e:
        context['calculation_result'] = None
        context['calculation_error'] = e


@when('I submit the calculation')
def submit_calculation(context, overtime_service, db_session):
    """Submit calculated overtime for saving.

    Args:
        context: Test context with calculation result
        overtime_service: Overtime service
        db_session: Database session
    """
    result = context.get('calculation_result')

    if result is None:
        raise ValueError("No calculation result to submit")

    try:
        saved = overtime_service.save_overtime_record(result)
        db_session.commit()

        context['saved_record'] = saved
        context['save_error'] = None
    except Exception as e:
        db_session.rollback()
        context['saved_record'] = None
        context['save_error'] = e


@when(parsers.parse('I attempt to calculate overtime for {hours:f} hours'))
def attempt_calculate_overtime(hours: float, context, overtime_calculator):
    """Attempt overtime calculation (may fail).

    Args:
        hours: Hours to calculate (may be invalid)
        context: Test context
        overtime_calculator: Calculator
    """
    employee = context.get('employee')

    try:
        result = overtime_calculator.calculate(
            employee=employee,
            total_hours=Decimal(str(hours))
        )
        context['calculation_result'] = result
        context['calculation_error'] = None
    except ValidationError as e:
        context['calculation_result'] = None
        context['calculation_error'] = e


@when(parsers.parse('I enter "{input_value}" as work hours'))
def enter_invalid_input(input_value: str, context):
    """Enter potentially invalid input.

    Args:
        input_value: Input string (may be non-numeric)
        context: Test context
    """
    try:
        hours = Decimal(input_value)
        context['input_hours'] = hours
        context['input_error'] = None
    except Exception as e:
        context['input_hours'] = None
        context['input_error'] = e


# ============================================================================
# Then Steps (Assertions)
# ============================================================================

@then(parsers.parse('the overtime hours should be {hours:f} hours'))
def verify_overtime_hours(hours: float, context):
    """Verify calculated overtime hours.

    Args:
        hours: Expected overtime hours
        context: Test context
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    expected = Decimal(str(hours))
    actual = result.overtime_hours

    assert actual == expected, (
        f"Overtime hours mismatch: expected {expected}, got {actual}"
    )


@then(parsers.parse('the overtime should be calculated at {rate} rate'))
def verify_overtime_rate(rate: str, context):
    """Verify overtime rate used.

    Args:
        rate: Expected rate (e.g., "1.34x")
        context: Test context
    """
    result = context['calculation_result']

    # Extract numeric rate
    expected_rate = Decimal(rate.rstrip('x'))

    # Check if rate was applied
    assert any(
        item.rate == expected_rate
        for item in result.breakdown
    ), f"Rate {rate} not found in calculation breakdown"


@then(parsers.parse('the overtime pay should be NT${amount:f}'))
def verify_overtime_pay(amount: float, context):
    """Verify calculated overtime pay.

    Args:
        amount: Expected amount
        context: Test context
    """
    result = context.get('calculation_result')
    assert result is not None, "No calculation result found"

    expected = Decimal(str(amount))
    actual = result.overtime_pay

    # Allow 0.01 tolerance for rounding
    tolerance = Decimal('0.01')
    difference = abs(actual - expected)

    assert difference <= tolerance, (
        f"Overtime pay mismatch: expected NT${expected}, got NT${actual} "
        f"(difference: NT${difference})"
    )


@then('the calculation breakdown should show')
def verify_breakdown(datatable, context):
    """Verify detailed calculation breakdown.

    Args:
        datatable: Expected breakdown table
        context: Test context
    """
    result = context['calculation_result']

    for i, expected_row in enumerate(datatable):
        actual_row = result.breakdown[i]

        # Verify each field
        assert actual_row.description == expected_row['description'], \
            f"Row {i}: description mismatch"

        assert actual_row.hours == Decimal(expected_row['hours']), \
            f"Row {i}: hours mismatch"

        assert actual_row.rate == expected_row['rate'], \
            f"Row {i}: rate mismatch"

        assert actual_row.amount == Decimal(expected_row['amount']), \
            f"Row {i}: amount mismatch"


@then(parsers.parse('the system should reference "{legal_ref}"'))
def verify_legal_reference(legal_ref: str, context):
    """Verify legal reference is included.

    Args:
        legal_ref: Expected legal reference
        context: Test context
    """
    result = context['calculation_result']

    assert hasattr(result, 'legal_reference'), \
        "Result missing legal_reference attribute"

    assert result.legal_reference == legal_ref, (
        f"Legal reference mismatch: expected '{legal_ref}', "
        f"got '{result.legal_reference}'"
    )


@then(parsers.parse('the system should reject the input'))
def verify_input_rejected(context):
    """Verify input was rejected.

    Args:
        context: Test context
    """
    error = context.get('calculation_error') or context.get('input_error')
    assert error is not None, "Expected input to be rejected but it was accepted"


@then(parsers.parse('display error message "{error_msg}"'))
def verify_error_message(error_msg: str, context):
    """Verify specific error message.

    Args:
        error_msg: Expected error message (in Traditional Chinese)
        context: Test context
    """
    error = context.get('calculation_error') or context.get('input_error')
    assert error is not None, "No error found"

    error_text = str(error)
    assert error_msg in error_text, (
        f"Expected error message '{error_msg}' not found in '{error_text}'"
    )


@then(parsers.parse('the system should display warning "{warning_msg}"'))
def verify_warning_message(warning_msg: str, context):
    """Verify warning message displayed.

    Args:
        warning_msg: Expected warning message
        context: Test context
    """
    result = context.get('calculation_result')
    warnings = context.get('warnings', [])

    if result and hasattr(result, 'warnings'):
        warnings = result.warnings

    assert len(warnings) > 0, "No warnings found"

    warning_texts = [str(w) for w in warnings]
    assert any(warning_msg in text for text in warning_texts), (
        f"Warning '{warning_msg}' not found in {warning_texts}"
    )


@then('no legal reference is required')
def verify_no_legal_reference(context):
    """Verify no legal reference in result.

    Args:
        context: Test context
    """
    result = context['calculation_result']

    if hasattr(result, 'legal_reference'):
        assert result.legal_reference is None or result.legal_reference == '', \
            f"Expected no legal reference, but found: {result.legal_reference}"


@then('the calculation button should be disabled')
def verify_button_disabled(context):
    """Verify submit button is disabled.

    Args:
        context: Test context (UI state)
    """
    # This would check UI state in a real application
    assert context.get('submit_enabled') is False, \
        "Submit button should be disabled"


# ============================================================================
# Reusable Step Variations
# ============================================================================

# Alternative phrasing for "overtime pay should be"
@then(parsers.parse('the total overtime pay should be NT${amount:f}'))
def verify_total_overtime_pay(amount: float, context):
    """Verify total overtime pay (alias for verify_overtime_pay)."""
    verify_overtime_pay(amount, context)


# Alternative for regular pay verification
@then(parsers.parse('the regular pay should be NT${amount:d}'))
def verify_regular_pay(amount: int, context):
    """Verify regular (non-overtime) pay.

    Args:
        amount: Expected regular pay
        context: Test context
    """
    result = context['calculation_result']
    expected = Decimal(amount)
    actual = result.regular_pay

    assert actual == expected, (
        f"Regular pay mismatch: expected NT${expected}, got NT${actual}"
    )
```

---

## Best Practices

1. **Type Hints**: Always use type hints for parameters and return types
2. **Docstrings**: Document every step definition with clear docstring
3. **Fixtures**: Use pytest fixtures for dependency injection
4. **Context**: Use context dict to share data between steps
5. **Error Handling**: Catch exceptions and store in context for Then steps
6. **Decimal Precision**: Use `Decimal` for all monetary calculations
7. **Assertions**: Write clear assertion messages with actual vs expected
8. **Reusability**: Write generic steps that work across multiple scenarios
9. **Traditional Chinese**: Verify Chinese text in error messages and UI
10. **Legal References**: Always verify legal article citations in results

---

## Running Tests

```bash
# Run all BDD tests
pytest tests/step_defs/

# Run specific feature
pytest tests/features/overtime/weekday_overtime.feature

# Run with tags
pytest -m "overtime and p0"

# Run with verbose output
pytest tests/step_defs/ -v

# Run with step-by-step output
pytest tests/step_defs/ -vv --gherkin-terminal-reporter

# Run with coverage
pytest tests/step_defs/ --cov=app --cov-report=html

# Run in parallel (requires pytest-xdist)
pytest tests/step_defs/ -n auto
```

---

## Common Pitfalls to Avoid

1. **Don't test implementation details** - Test behavior, not internal code structure
2. **Don't couple steps to scenarios** - Steps should be reusable across features
3. **Don't use sleep()** - Use proper waits and polling for async operations
4. **Don't hardcode data** - Use fixtures and factories for test data
5. **Don't skip error handling** - Always handle and verify exceptions properly
6. **Don't ignore localization** - Test with actual Traditional Chinese messages
7. **Don't forget cleanup** - Use fixtures with proper teardown
8. **Don't mix assertion logic** - Keep assertions in Then steps only
9. **Don't use global state** - Use context dict for step communication
10. **Don't forget legal compliance** - Verify legal references and calculations

---

## pytest-bdd Configuration

Add to `pytest.ini`:

```ini
[pytest]
# BDD configuration
bdd_features_base_dir = tests/features/
python_files = test_*.py
python_classes = Test*
python_functions = test_*

# Markers for BDD tags
markers =
    smoke: Smoke tests (critical path)
    p0: Priority 0 (must pass for release)
    p1: Priority 1 (important)
    p2: Priority 2 (nice to have)
    overtime: Overtime calculation tests
    leave: Leave management tests
    legal_compliance: Legal compliance tests
    taiwan_labor_law: Taiwan Labor Standards Act tests
    integration: Integration tests
    performance: Performance tests
    security: Security tests
    accessibility: Accessibility tests

# Test output
console_output_style = progress
addopts =
    -v
    --strict-markers
    --tb=short
    --gherkin-terminal-reporter
```
