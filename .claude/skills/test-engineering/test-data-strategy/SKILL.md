---
name: test-data-strategy
description: Define comprehensive test data management strategy including data generation, categorization, privacy masking, and legal compliance validation. Use when planning test data for features that require accurate legal calculations and privacy protection.
---

You are a test data strategy specialist with expertise in legal compliance testing and data privacy. Design comprehensive test data strategies that ensure thorough testing while protecting sensitive information.

## Instructions

When the user provides a module or feature via `$ARGUMENTS`:

1. **Analyze** test data requirements for the feature
2. **Categorize** data by test type and purpose
3. **Design** data generation strategies (static vs dynamic)
4. **Define** privacy protection rules (Taiwan PDPA compliance)
5. **Establish** validation methods (cross-reference with government tools)
6. **Plan** data versioning aligned with legal amendments

## Output Format

```markdown
## Test Data Strategy: [Module/Feature Name]

### Strategy Overview
- **Module**: [Feature or module name]
- **Priority**: P0 / P1 / P2
- **Legal Relevance**: High / Medium / Low
- **Data Sensitivity**: Contains PII / No PII
- **Validation Required**: Government Tool Cross-check / Formula Verification / None
- **Update Frequency**: Per Legal Amendment / Per Sprint / Stable

---

### Test Data Requirements

#### Data Volume by Test Type
| Test Type | Data Category | Quantity Required | Generation Method | Update Frequency |
|-----------|--------------|-------------------|-------------------|------------------|
| Unit Test | Standard Cases | 50-100 | Fixtures (static) | Per Sprint |
| Unit Test | Boundary Cases | 30-50 | Fixtures (static) | Per Legal Amendment |
| Integration Test | Workflow Scenarios | 20-30 | Factories (dynamic) | Per Sprint |
| BDD Test | User Stories | 15-25 | Feature-specific | Per Feature |
| Legal Validation | Government Cross-check | 10-20 | Official Examples | Per Legal Amendment |
| Performance Test | Load Testing | 1000-10000 | Generated (bulk) | Per Performance Cycle |
| Exploratory Test | Edge Cases | 10-20 | Manual + Fuzzing | Ad-hoc |

**Total Estimated Test Cases**: [Sum] cases
**Total Test Data Records**: [Estimate] records

---

### Data Categories

#### Category 1: Golden Data (Standard Validation Cases)

**Purpose**: Authoritative test cases verified against official sources

| Test ID | Description | Input Data | Expected Output | Legal Reference | Govt Tool Verified |
|---------|-------------|------------|-----------------|-----------------|-------------------|
| GOLD-001 | Standard overtime 2hr | Monthly salary: 48000<br>Regular hours: 40<br>Overtime: 2hr | Overtime pay: 536 | Labor Standards Act Article 24 Section 1 | ✅ Verified 2024-02-10 |
| GOLD-002 | Overtime with rate change | Monthly salary: 48000<br>Regular hours: 40<br>Overtime: 4hr | First 2hr: 536 (1.34x)<br>Next 2hr: 668 (1.67x)<br>Total: 1204 | Labor Standards Act Article 24 | ✅ Verified 2024-02-10 |
| GOLD-003 | Holiday overtime | Monthly salary: 48000<br>Work date: National Holiday<br>Hours: 8 | Overtime pay: 3200 (2.0x) | Labor Standards Act Article 39 | ✅ Verified 2024-02-10 |
| GOLD-004 | Annual leave 2 years | Employment start: 2022-03-01<br>Calculation date: 2024-03-01<br>Tenure: 2 years | Annual leave: 10 days | Labor Standards Act Article 38 | ✅ Verified 2024-02-10 |

**Golden Data Properties**:
- Verified against government calculators
- Updated when legal amendments occur
- Used for regression testing
- Must pass 100% of the time
- Documented with legal references

**Maintenance**:
- Review quarterly or when law changes
- Re-validate with latest government tools
- Document verification date and method
- Track historical changes

---

#### Category 2: Boundary Condition Cases

**Purpose**: Test edge cases and limits

| Boundary Type | Test Case | Input | Expected Behavior | Legal Basis |
|--------------|-----------|-------|-------------------|-------------|
| Minimum Value | Minimum wage worker | Salary: 27470 (2024 min wage) | Calculate correctly at minimum | Basic Wage Act |
| Maximum Value | Monthly overtime limit | Overtime: 46 hours | Warning: At legal limit | Labor Standards Act Article 32 |
| Exceeding Limit | Overtime exceeds limit | Overtime: 48 hours | Error: Requires manager approval | Labor Standards Act Article 32 |
| Zero Value | No overtime | Overtime: 0 hours | Overtime pay: 0 | Normal case |
| Just Below Threshold | 39.5 work hours | Regular: 39.5<br>Overtime: 0 | No overtime calculated | Normal case |
| At Threshold | Exactly 40 hours | Regular: 40<br>Overtime: 0 | No overtime calculated | Boundary |
| Just Above Threshold | 40.5 work hours | Regular: 40<br>Overtime: 0.5 | Overtime: 0.5hr at 1.34x | First overtime unit |
| Transition Point | 42 hour boundary | Regular: 40<br>Overtime: 2 | 2hr at 1.34x rate | Rate change point |
| Seniority Milestone | 6 months tenure | Days: 182 | Annual leave: 3 days | First leave entitlement |
| Maximum Leave | 30 years tenure | Years: 30 | Annual leave: 30 days (cap) | Maximum reached |

**Boundary Testing Strategy**:
- Test at exact boundary
- Test just below boundary (boundary - 1 unit)
- Test just above boundary (boundary + 1 unit)
- Test far beyond boundary (extreme values)

---

#### Category 3: Error Input Cases

**Purpose**: Validate input validation and error handling

| Error Category | Invalid Input | Expected Error | Error Message (繁中) | HTTP Status |
|---------------|---------------|----------------|---------------------|-------------|
| Negative Value | hours: -5 | ValidationError | "工作時數不可為負數" | 400 |
| Non-numeric | hours: "abc" | ValidationError | "請輸入有效數字" | 400 |
| Extremely High | hours: 999999 | ValidationError | "輸入值超出合理範圍" | 400 |
| Missing Required | salary: null | ValidationError | "月薪為必填欄位" | 400 |
| Invalid Date Format | date: "2024/13/45" | ValidationError | "日期格式不正確" | 400 |
| Future Date | start_date: 2099-01-01 | ValidationError | "日期不可為未來日期" | 400 |
| Decimal Precision | salary: 48000.123 | ValidationError | "薪資不可有小數點" | 400 |
| Out of Range ID | employee_id: "X999999999" | NotFoundError | "查無此員工資料" | 404 |

**Error Testing Principles**:
- Every input field should have error test cases
- Error messages must be in Traditional Chinese
- Error messages must be user-friendly (not technical)
- Include proper HTTP status codes
- Log errors for debugging but don't expose internals

---

#### Category 4: Legal Calculation Verification Cases

**Purpose**: Verify calculations match government standards

| Formula Type | Test Scenario | Input Parameters | Manual Calculation | System Output | Government Tool Output | Status |
|-------------|---------------|------------------|-------------------|---------------|----------------------|--------|
| Overtime Rate 1.34x | Weekday first 2hr | Base rate: 200<br>Hours: 1 | 200 × 1.34 = 268 | 268 | 268 ✅ | Pass |
| Overtime Rate 1.67x | Weekday hours 3-4 | Base rate: 200<br>Hours: 1 (3rd hour) | 200 × 1.67 = 334 | 334 | 334 ✅ | Pass |
| Holiday Rate 2.0x | National holiday | Base rate: 200<br>Hours: 8 | 200 × 2.0 × 8 = 3200 | 3200 | 3200 ✅ | Pass |
| Rest Day Calculation | Special rest day rates | Base rate: 200<br>Hours: 6 | Complex multi-tier | 1872 | 1872 ✅ | Pass |
| Pro-rated Salary | Mid-month start | Monthly: 48000<br>Start: 15th<br>Days worked: 16 | 48000 ÷ 30 × 16 = 25600 | 25600 | 25600 ✅ | Pass |
| Annual Leave Years | 5 years tenure | Start: 2019-03-01<br>Date: 2024-03-01 | 5 years = 15 days | 15 days | 15 days ✅ | Pass |

**Validation Process**:
1. Obtain official test cases from MOL (Ministry of Labor)
2. Input same parameters into system
3. Compare results with government calculator
4. Document any discrepancies immediately
5. Update test data when law amendments occur

**Cross-validation Tools**:
- MOL Overtime Calculator: https://calc.mol.gov.tw/
- Annual Leave Calculator: [Government tool URL]
- Test data validation frequency: Every legal amendment + quarterly review

---

### Data Generation Strategies

#### Strategy 1: Static Fixtures (JSON/YAML)

**Use Cases**:
- Golden data (standard validation cases)
- Boundary condition tests
- Regression test baseline

**Example Structure**:
```python
# tests/fixtures/overtime_golden_data.json
{
    "test_cases": [
        {
            "id": "GOLD-001",
            "description": "Standard overtime 2 hours",
            "legal_reference": "Labor Standards Act Article 24 Section 1",
            "verified_date": "2024-02-10",
            "government_tool": "MOL Overtime Calculator",
            "input": {
                "monthly_salary": 48000,
                "regular_hours": 40,
                "overtime_hours": 2,
                "work_date": "2024-02-15",
                "day_type": "weekday"
            },
            "expected_output": {
                "hourly_rate": 200,
                "overtime_pay": 536,
                "overtime_breakdown": [
                    {"hours": 2, "rate_multiplier": 1.34, "subtotal": 536}
                ],
                "total_pay": 48536
            }
        }
    ]
}
```

**Advantages**:
- Version controlled
- Easy to review and update
- Deterministic (same every time)
- Can include legal documentation

**Maintenance**:
- Update when laws change
- Review quarterly
- Keep historical versions for regression

---

#### Strategy 2: Factory Pattern (Dynamic Generation)

**Use Cases**:
- Integration tests with varied data
- Performance testing with bulk data
- Exploratory testing with random combinations

**Example Implementation**:
```python
# tests/factories/employee_factory.py
import factory
from factory import Faker, LazyAttribute
from datetime import datetime, timedelta

class EmployeeFactory(factory.Factory):
    """
    Generate realistic employee test data.
    Complies with Taiwan PDPA by using fake data only.
    """
    class Meta:
        model = Employee

    # Generate fake PII data (PDPA compliant)
    employee_id = factory.Sequence(lambda n: f"EMP{n:06d}")
    name = Faker('name', locale='zh_TW')  # Fake Chinese names
    email = Faker('email')
    phone = LazyAttribute(lambda o: f"09{factory.Faker('random_number', digits=8)}")

    # Employment data
    monthly_salary = Faker('random_int', min=27470, max=200000, step=1000)
    employment_start_date = Faker('date_between', start_date='-5y', end_date='today')
    department = Faker('random_element', elements=['Engineering', 'HR', 'Finance', 'Sales'])
    position = Faker('job')

    # Calculated fields
    @LazyAttribute
    def tenure_years(self):
        delta = datetime.now().date() - self.employment_start_date
        return delta.days // 365

    @LazyAttribute
    def hourly_rate(self):
        # Monthly salary ÷ 240 hours (Taiwan standard)
        return self.monthly_salary / 240

class OvertimeRecordFactory(factory.Factory):
    """
    Generate overtime test records.
    """
    class Meta:
        model = OvertimeRecord

    employee = factory.SubFactory(EmployeeFactory)
    work_date = Faker('date_between', start_date='-30d', end_date='today')
    regular_hours = Faker('random_int', min=0, max=12)
    overtime_hours = Faker('random_int', min=0, max=8)
    day_type = Faker('random_element', elements=['weekday', 'rest_day', 'holiday'])

    @LazyAttribute
    def overtime_pay(self):
        # Calculate based on law
        base_rate = self.employee.hourly_rate
        hours = self.overtime_hours

        if self.day_type == 'holiday':
            return base_rate * 2.0 * hours
        elif hours <= 2:
            return base_rate * 1.34 * hours
        else:
            return (base_rate * 1.34 * 2) + (base_rate * 1.67 * (hours - 2))
```

**Usage Examples**:
```python
# Create single employee
employee = EmployeeFactory()

# Create employee with specific salary
high_earner = EmployeeFactory(monthly_salary=150000)

# Create multiple records
employees = EmployeeFactory.create_batch(100)

# Create overtime scenario
overtime = OvertimeRecordFactory(
    overtime_hours=4,
    day_type='weekday'
)
```

**Advantages**:
- Generate large volumes quickly
- Randomization finds edge cases
- Realistic data distributions
- Easy to customize

---

#### Strategy 3: Property-Based Testing (Hypothesis)

**Use Cases**:
- Find edge cases automatically
- Validate invariants (properties that always hold)
- Fuzz testing with random inputs

**Example Implementation**:
```python
# tests/property_based/test_overtime_properties.py
from hypothesis import given, strategies as st, assume
from hypothesis import settings, Phase
import pytest

class TestOvertimeProperties:
    """
    Property-based tests for overtime calculations.
    These tests define properties that should ALWAYS be true.
    """

    @given(
        monthly_salary=st.integers(min_value=27470, max_value=1000000),
        overtime_hours=st.floats(min_value=0.0, max_value=46.0, allow_nan=False)
    )
    @settings(max_examples=500)
    def test_overtime_pay_never_negative(self, monthly_salary: int, overtime_hours: float):
        """
        Property: Overtime pay must never be negative.
        """
        hourly_rate = monthly_salary / 240
        overtime_pay = calculate_overtime_pay(hourly_rate, overtime_hours)

        assert overtime_pay >= 0, f"Overtime pay was negative: {overtime_pay}"

    @given(
        monthly_salary=st.integers(min_value=27470, max_value=1000000),
        overtime_hours=st.floats(min_value=0.01, max_value=46.0, allow_nan=False)
    )
    @settings(max_examples=500)
    def test_more_hours_means_more_pay(self, monthly_salary: int, overtime_hours: float):
        """
        Property: More overtime hours should always result in equal or higher pay.
        """
        hourly_rate = monthly_salary / 240

        pay_1 = calculate_overtime_pay(hourly_rate, overtime_hours)
        pay_2 = calculate_overtime_pay(hourly_rate, overtime_hours + 1.0)

        assert pay_2 >= pay_1, \
            f"More hours resulted in less pay: {pay_1} -> {pay_2}"

    @given(
        monthly_salary=st.integers(min_value=27470, max_value=1000000),
        overtime_hours=st.floats(min_value=0.0, max_value=2.0, allow_nan=False)
    )
    @settings(max_examples=200)
    def test_first_two_hours_use_correct_rate(self, monthly_salary: int, overtime_hours: float):
        """
        Property: First 2 hours should use 1.34x rate exactly.
        """
        hourly_rate = monthly_salary / 240
        overtime_pay = calculate_overtime_pay(hourly_rate, overtime_hours)

        expected = hourly_rate * 1.34 * overtime_hours
        assert abs(overtime_pay - expected) < 0.01, \
            f"First 2 hours calculation wrong: expected {expected}, got {overtime_pay}"

    @given(
        start_date=st.dates(min_value='2019-01-01', max_value='2024-01-01'),
        calculation_date=st.dates(min_value='2024-01-02', max_value='2030-12-31')
    )
    @settings(max_examples=300)
    def test_annual_leave_never_exceeds_cap(self, start_date, calculation_date):
        """
        Property: Annual leave can never exceed 30 days (legal maximum).
        """
        assume(calculation_date > start_date)  # Ensure valid tenure

        leave_days = calculate_annual_leave(start_date, calculation_date)

        assert leave_days <= 30, \
            f"Annual leave exceeded legal cap of 30 days: {leave_days}"
```

**Advantages**:
- Automatically finds edge cases
- Tests invariants, not specific outputs
- High confidence in correctness
- Explores huge input space

---

#### Strategy 4: Real-world Anonymized Data

**Use Cases**:
- Integration testing with realistic patterns
- Performance testing with production-like data
- User acceptance testing

**Anonymization Rules (Taiwan PDPA Compliance)**:

| Data Type | Original Example | Anonymization Method | Anonymized Example |
|-----------|-----------------|----------------------|-------------------|
| Employee Name | 王小明 | Replace with fake name | 測試員工A |
| National ID | A123456789 | Generate valid format, invalid number | X000000000 |
| Email | wang@company.com | Domain-preserving hash | test_emp001@company.com |
| Phone | 0912-345-678 | Randomize digits, keep format | 0987-654-321 |
| Address | 台北市信義區... | Use generic address | 台北市XX區XX路XX號 |
| Salary | 48000 | Round + add noise | 48000 ± 5% = 45600-50400 |
| Bank Account | 123-456-7890123 | Generate random valid format | 000-000-0000000 |
| Birth Date | 1990-05-15 | Keep month/day, randomize year | 1991-05-15 |

**Anonymization Process**:
```python
# scripts/anonymize_test_data.py
from faker import Faker
import hashlib
import re

fake = Faker('zh_TW')

class DataAnonymizer:
    """
    Anonymize production data for testing.
    Complies with Taiwan Personal Data Protection Act (PDPA).
    """

    def anonymize_employee(self, employee_data: dict) -> dict:
        """
        Anonymize employee personal data while preserving structure.

        Args:
            employee_data: Raw employee data from production

        Returns:
            Anonymized employee data safe for testing

        Dependencies:
            - Faker library for generating fake data
            - Preserves referential integrity via deterministic hashing
        """
        # Deterministic fake name (same ID always gets same fake name)
        seed = int(hashlib.md5(employee_data['id'].encode()).hexdigest()[:8], 16)
        Faker.seed(seed)

        return {
            'id': self._anonymize_id(employee_data['id']),
            'name': fake.name(),
            'email': self._anonymize_email(employee_data['email']),
            'phone': self._anonymize_phone(employee_data['phone']),
            'national_id': self._generate_fake_national_id(),
            'address': '台北市測試區測試路1號',
            'salary': self._add_noise(employee_data['salary'], noise_pct=5),
            'bank_account': self._generate_fake_bank_account(),
            'birth_date': self._anonymize_birth_date(employee_data['birth_date']),
            # Preserve non-PII fields
            'department': employee_data['department'],
            'position': employee_data['position'],
            'employment_start_date': employee_data['employment_start_date'],
        }

    def _anonymize_id(self, original_id: str) -> str:
        """Generate consistent fake ID based on hash."""
        hash_val = hashlib.md5(original_id.encode()).hexdigest()[:8]
        return f"TEST{hash_val.upper()}"

    def _anonymize_email(self, email: str) -> str:
        """Preserve domain, anonymize local part."""
        domain = email.split('@')[1] if '@' in email else 'example.com'
        hash_val = hashlib.md5(email.encode()).hexdigest()[:8]
        return f"test_{hash_val}@{domain}"

    def _anonymize_phone(self, phone: str) -> str:
        """Generate random valid Taiwan mobile number."""
        return f"09{fake.random_number(digits=8, fix_len=True)}"

    def _generate_fake_national_id(self) -> str:
        """
        Generate fake Taiwan national ID with valid format but invalid checksum.
        Format: Letter + 9 digits, but checksum deliberately wrong.
        """
        letter = fake.random_element(elements=['A', 'B', 'C', 'D', 'E'])
        digits = fake.random_number(digits=9, fix_len=True)
        return f"{letter}{digits}"

    def _generate_fake_bank_account(self) -> str:
        """Generate fake bank account with valid format."""
        return f"{fake.random_number(digits=3, fix_len=True)}-" \
               f"{fake.random_number(digits=3, fix_len=True)}-" \
               f"{fake.random_number(digits=7, fix_len=True)}"

    def _anonymize_birth_date(self, birth_date: str) -> str:
        """Keep month and day, randomize year within ±2 years."""
        from datetime import datetime
        dt = datetime.fromisoformat(birth_date)
        year_offset = fake.random_int(min=-2, max=2)
        new_year = dt.year + year_offset
        return f"{new_year}-{dt.month:02d}-{dt.day:02d}"

    def _add_noise(self, value: float, noise_pct: int = 5) -> float:
        """Add random noise to numeric values."""
        import random
        noise = random.uniform(-noise_pct/100, noise_pct/100)
        return round(value * (1 + noise))
```

**Usage**:
```python
# Anonymize production export
anonymizer = DataAnonymizer()
prod_data = load_production_export('employees.json')

test_data = [anonymizer.anonymize_employee(emp) for emp in prod_data]
save_test_data('tests/fixtures/employees_anonymized.json', test_data)
```

**PDPA Compliance Checklist**:
- [ ] All personal identifiers replaced with fake data
- [ ] No real national IDs used
- [ ] No real contact information (phone, email, address)
- [ ] No real bank account numbers
- [ ] Salary data perturbed to prevent identification
- [ ] Anonymization process documented
- [ ] Original data never committed to version control
- [ ] Test data clearly marked as "TEST DATA" in files

---

### Data Masking Rules (Privacy Protection)

#### Sensitivity Classification

| Data Field | Sensitivity Level | Masking Required | Masking Method | Example |
|------------|------------------|------------------|----------------|---------|
| National ID | Critical | Always | Replace with fake valid format | A123456789 → X000000000 |
| Full Name | High | Always | Replace with fake name | 王小明 → 測試用戶A |
| Phone Number | High | Always | Randomize digits | 0912-345-678 → 0987-654-321 |
| Email | High | Always | Domain-preserving hash | user@mail.com → test001@mail.com |
| Bank Account | Critical | Always | Generate fake format | Real → 000-000-0000000 |
| Address | High | Always | Use generic address | Real → 測試地址 |
| Birth Date | Medium | Yes | Preserve month/day, change year | 1990-05-15 → 1991-05-15 |
| Salary | Medium | Recommended | Add noise ±5% | 48000 → 45600-50400 |
| Employee ID | Low | No | Can use sequential | EMP001, EMP002... |
| Department | Low | No | Use real values | Engineering, HR... |
| Position | Low | No | Use real values | Engineer, Manager... |
| Hire Date | Low | No | Use real dates | 2020-03-15 |

#### Taiwan PDPA Compliance Requirements

**Personal Data Protection Act (個人資料保護法) - Key Points**:

1. **Data Minimization**
   - Only collect data necessary for testing
   - Don't use production data unless anonymized
   - Delete test data after testing complete

2. **Consent and Purpose**
   - Test data must be used only for testing purposes
   - Cannot be used for other purposes without consent
   - Document data usage purpose

3. **Security Measures**
   - Encrypt sensitive test data at rest
   - Control access to test databases
   - Log all test data access
   - Don't commit sensitive data to Git

4. **Data Subject Rights**
   - Test data should not be traceable to real individuals
   - If using anonymized real data, maintain anonymization log
   - Ability to demonstrate compliance if audited

**Implementation Guidelines**:

```python
# tests/conftest.py - Test data fixtures with privacy protection

import pytest
from typing import Dict, Any
import json
from pathlib import Path

class SecureTestData:
    """
    Secure test data loader with privacy protection.
    Ensures no sensitive data is exposed in test outputs.
    """

    SENSITIVE_FIELDS = [
        'national_id', 'phone', 'email', 'address',
        'bank_account', 'password', 'credit_card'
    ]

    @staticmethod
    def load_fixture(fixture_name: str) -> Dict[str, Any]:
        """
        Load test fixture with automatic PII masking in logs.

        Args:
            fixture_name: Name of fixture file (without extension)

        Returns:
            Test data dictionary with sensitive fields marked

        Dependencies:
            - Fixture files must be in tests/fixtures/
            - Sensitive fields auto-masked in test output
        """
        fixture_path = Path(__file__).parent / 'fixtures' / f'{fixture_name}.json'

        with open(fixture_path, 'r', encoding='utf-8') as f:
            data = json.load(f)

        # Mark sensitive data for masking in test output
        return SecureTestData._mark_sensitive(data)

    @staticmethod
    def _mark_sensitive(data: Dict[str, Any]) -> Dict[str, Any]:
        """Mark sensitive fields for automatic masking in logs."""
        if isinstance(data, dict):
            for key, value in data.items():
                if key in SecureTestData.SENSITIVE_FIELDS:
                    # Replace with masked value in test output
                    data[key] = f"***MASKED_{key.upper()}***"
                elif isinstance(value, (dict, list)):
                    data[key] = SecureTestData._mark_sensitive(value)
        elif isinstance(data, list):
            return [SecureTestData._mark_sensitive(item) for item in data]

        return data

@pytest.fixture
def employee_test_data():
    """Provide employee test data with PII protection."""
    return SecureTestData.load_fixture('employees_test')

@pytest.fixture
def overtime_test_data():
    """Provide overtime test data."""
    return SecureTestData.load_fixture('overtime_cases')
```

---

### Data Versioning Strategy

#### Version Control Structure

```
tests/
├── fixtures/
│   ├── v1.0/                          # Historical versions
│   │   ├── overtime_golden_data.json
│   │   └── leave_entitlement_data.json
│   ├── v2.0/                          # Current version
│   │   ├── overtime_golden_data.json   (updated for 2024 law amendment)
│   │   └── leave_entitlement_data.json
│   └── current -> v2.0/               # Symlink to current version
├── legal_amendments/
│   ├── 2024_Q1_overtime_changes.md    # Document law changes
│   └── test_data_migration.md         # How test data was updated
└── version_history.md                 # Track all versions
```

#### Versioning Rules

| Trigger | Version Change | Action Required |
|---------|---------------|-----------------|
| Legal amendment affecting calculations | Major version (v1 → v2) | Update golden data, re-validate, regression test old version |
| New feature added | Minor version (v2.0 → v2.1) | Add new test cases, keep existing |
| Bug fix in test data | Patch version (v2.1.0 → v2.1.1) | Fix specific cases, document correction |
| Routine test expansion | No version change | Add to current version |

#### Legal Amendment Tracking

```markdown
# tests/legal_amendments/2024_Q1_overtime_changes.md

## Legal Amendment: 2024 Q1 Overtime Regulation Update

### Amendment Details
- **Effective Date**: 2024-03-01
- **Legal Reference**: Labor Standards Act Article 24 Amendment
- **Summary**: Updated overtime calculation for rest day work

### Changes to Test Data

#### Modified Test Cases
| Test ID | Previous Expected | New Expected | Change Reason |
|---------|------------------|--------------|---------------|
| GOLD-005 | 1800 | 1872 | Rest day calculation method updated |
| BOUND-012 | 2100 | 2140 | Special rate for 6+ hours on rest day |

#### New Test Cases Required
| Test ID | Description | Legal Reference |
|---------|-------------|----------------|
| GOLD-015 | New rest day 8+ hour calculation | Article 24-2 |
| BOUND-020 | Boundary at 8 hour rest day work | Article 24-2 |

#### Deprecated Test Cases
| Test ID | Reason |
|---------|--------|
| GOLD-OLD-005 | Calculation method no longer valid after 2024-03-01 |

### Migration Process
1. Archive old test data to `v1.x/` directory
2. Update test cases in `v2.0/` directory
3. Re-validate all golden data with government tools
4. Run regression suite with old version (expect failures for changed cases)
5. Update documentation

### Validation
- [ ] All golden data re-validated with MOL calculator (2024-03-01 version)
- [ ] Regression tests run and analyzed
- [ ] New test cases reviewed by legal expert
- [ ] Documentation updated
```

#### Version History Log

```markdown
# tests/version_history.md

## Test Data Version History

### v2.0.0 (2024-03-01)
**Type**: Major - Legal Amendment

**Changes**:
- Updated overtime calculation for rest days (2024 Q1 amendment)
- Added 3 new golden data cases
- Deprecated 1 obsolete case
- Re-validated all 15 existing cases

**Files Changed**:
- `overtime_golden_data.json`: Updated 2 cases, added 3 cases
- `boundary_conditions.json`: Added 2 new boundary tests
- Archived previous version to `v1.0/`

**Validation**:
- Cross-checked with MOL calculator v2024.3
- Legal review completed by Labor Law Consultant

---

### v1.2.0 (2024-01-15)
**Type**: Minor - Feature Addition

**Changes**:
- Added annual leave carryover test cases
- Added pro-rated salary calculations

**Files Changed**:
- `leave_entitlement_data.json`: Added 8 new cases
- `salary_calculations.json`: New file with 12 cases

**Validation**:
- All new cases validated with government tools

---

### v1.1.0 (2023-10-01)
**Type**: Minor - Test Expansion

**Changes**:
- Expanded boundary condition tests
- Added error handling test cases

**Files Changed**:
- `boundary_conditions.json`: Added 10 cases
- `error_cases.json`: New file with 15 error scenarios

---

### v1.0.0 (2023-06-01)
**Type**: Initial Release

**Changes**:
- Initial golden data set with 12 standard cases
- Basic boundary conditions
- Initial legal validation cases

**Files**:
- `overtime_golden_data.json`: 12 cases
- `leave_entitlement_data.json`: 8 cases
- `boundary_conditions.json`: 15 cases
```

---

### Data Validation Process

#### Validation Workflow

```
┌─────────────────────────────────────────────────────────────────┐
│                     Test Data Validation Flow                    │
└─────────────────────────────────────────────────────────────────┘

1. CREATE Test Data
   │
   ├─→ Manual: Create golden data cases
   ├─→ Factory: Generate bulk test data
   └─→ Anonymize: If using real data
   │
   ↓
2. VALIDATE Format
   │
   ├─→ Schema validation (JSON Schema)
   ├─→ Data type checking (Pydantic models)
   └─→ Required fields present
   │
   ↓
3. VALIDATE Calculations
   │
   ├─→ Manual calculation verification
   ├─→ Cross-check with government tools
   └─→ Compare with legal references
   │
   ↓
4. VALIDATE Privacy
   │
   ├─→ No real PII in test data
   ├─→ All sensitive fields masked
   └─→ PDPA compliance check
   │
   ↓
5. REVIEW & APPROVE
   │
   ├─→ Peer review by QA
   ├─→ Legal review (for golden data)
   └─→ Technical lead approval
   │
   ↓
6. COMMIT to Repository
   │
   ├─→ Version tagged
   ├─→ Documentation updated
   └─→ CI/CD validation passes
```

#### Automated Validation Script

```python
# tests/scripts/validate_test_data.py

import json
from pathlib import Path
from typing import Dict, List, Any
from datetime import datetime
import requests

class TestDataValidator:
    """
    Automated validator for test data quality and compliance.
    """

    def __init__(self, fixtures_path: Path):
        self.fixtures_path = fixtures_path
        self.errors: List[str] = []
        self.warnings: List[str] = []

    def validate_all(self) -> bool:
        """
        Run all validation checks.

        Returns:
            True if all validations pass, False otherwise

        Dependencies:
            - JSON fixture files in tests/fixtures/
            - Schema definitions in tests/schemas/
        """
        print("🔍 Validating test data...")

        self.validate_schema()
        self.validate_calculations()
        self.validate_privacy()
        self.validate_legal_references()

        self.print_report()

        return len(self.errors) == 0

    def validate_schema(self):
        """Validate data structure and types."""
        print("  ├─ Checking schema...")

        fixture_files = self.fixtures_path.glob('*.json')
        for fixture_file in fixture_files:
            try:
                with open(fixture_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)

                # Check required fields
                if 'test_cases' not in data:
                    self.errors.append(f"{fixture_file.name}: Missing 'test_cases' field")

                # Validate each test case
                for idx, case in enumerate(data.get('test_cases', [])):
                    if 'id' not in case:
                        self.errors.append(f"{fixture_file.name}[{idx}]: Missing 'id'")
                    if 'input' not in case:
                        self.errors.append(f"{fixture_file.name}[{idx}]: Missing 'input'")
                    if 'expected_output' not in case:
                        self.errors.append(f"{fixture_file.name}[{idx}]: Missing 'expected_output'")

            except json.JSONDecodeError as e:
                self.errors.append(f"{fixture_file.name}: Invalid JSON - {str(e)}")

    def validate_calculations(self):
        """Cross-validate calculations with formulas."""
        print("  ├─ Validating calculations...")

        golden_data_file = self.fixtures_path / 'overtime_golden_data.json'
        if not golden_data_file.exists():
            self.warnings.append("Golden data file not found, skipping calculation validation")
            return

        with open(golden_data_file, 'r', encoding='utf-8') as f:
            data = json.load(f)

        for case in data.get('test_cases', []):
            test_id = case['id']
            input_data = case['input']
            expected = case['expected_output']

            # Recalculate and compare
            calculated = self._calculate_overtime(input_data)

            if abs(calculated - expected.get('overtime_pay', 0)) > 0.01:
                self.errors.append(
                    f"{test_id}: Calculation mismatch - "
                    f"expected {expected['overtime_pay']}, calculated {calculated}"
                )

    def validate_privacy(self):
        """Check for PII in test data."""
        print("  ├─ Checking privacy compliance...")

        sensitive_patterns = [
            (r'[A-Z][12]\d{8}', 'Potential real National ID'),
            (r'09\d{8}', 'Potential real phone number'),
            (r'\d{3}-\d{6}', 'Potential real bank account'),
        ]

        fixture_files = self.fixtures_path.glob('*.json')
        for fixture_file in fixture_files:
            with open(fixture_file, 'r', encoding='utf-8') as f:
                content = f.read()

            import re
            for pattern, description in sensitive_patterns:
                if re.search(pattern, content):
                    self.warnings.append(
                        f"{fixture_file.name}: {description} detected - verify it's fake data"
                    )

    def validate_legal_references(self):
        """Ensure all test cases have legal references."""
        print("  ├─ Validating legal references...")

        fixture_files = self.fixtures_path.glob('*.json')
        for fixture_file in fixture_files:
            with open(fixture_file, 'r', encoding='utf-8') as f:
                data = json.load(f)

            for idx, case in enumerate(data.get('test_cases', [])):
                if 'legal_reference' not in case or not case['legal_reference']:
                    self.warnings.append(
                        f"{fixture_file.name}[{idx}]: Missing legal reference"
                    )

    def _calculate_overtime(self, input_data: Dict[str, Any]) -> float:
        """Calculate overtime pay based on input."""
        monthly_salary = input_data.get('monthly_salary', 0)
        overtime_hours = input_data.get('overtime_hours', 0)
        day_type = input_data.get('day_type', 'weekday')

        hourly_rate = monthly_salary / 240

        if day_type == 'holiday':
            return hourly_rate * 2.0 * overtime_hours
        elif overtime_hours <= 2:
            return hourly_rate * 1.34 * overtime_hours
        else:
            return (hourly_rate * 1.34 * 2) + (hourly_rate * 1.67 * (overtime_hours - 2))

    def print_report(self):
        """Print validation report."""
        print("\n" + "="*70)
        print("Test Data Validation Report")
        print("="*70)

        if self.errors:
            print(f"\n❌ ERRORS ({len(self.errors)}):")
            for error in self.errors:
                print(f"  • {error}")

        if self.warnings:
            print(f"\n⚠️  WARNINGS ({len(self.warnings)}):")
            for warning in self.warnings:
                print(f"  • {warning}")

        if not self.errors and not self.warnings:
            print("\n✅ All validations passed!")

        print("="*70)

# Usage in CI/CD
if __name__ == '__main__':
    fixtures_path = Path(__file__).parent.parent / 'fixtures'
    validator = TestDataValidator(fixtures_path)

    success = validator.validate_all()
    exit(0 if success else 1)
```

#### CI/CD Integration

```yaml
# .github/workflows/test-data-validation.yml

name: Test Data Validation

on:
  pull_request:
    paths:
      - 'tests/fixtures/**'
      - 'tests/schemas/**'

jobs:
  validate-test-data:
    runs-on: ubuntu-latest

    steps:
      - name: Checkout code
        uses: actions/checkout@v3

      - name: Set up Python
        uses: actions/setup-python@v4
        with:
          python-version: '3.11'

      - name: Install dependencies
        run: |
          pip install jsonschema faker hypothesis

      - name: Validate test data
        run: |
          python tests/scripts/validate_test_data.py

      - name: Check for PII
        run: |
          python tests/scripts/check_pii.py

      - name: Validate golden data with formulas
        run: |
          pytest tests/validation/test_golden_data_accuracy.py -v
```

---

### Recommendations

#### Implementation Priority

| Priority | Task | Effort | Impact | Status |
|----------|------|--------|--------|--------|
| P0 | Create golden data fixtures for overtime calculations | 3 days | Critical | 🔴 Not Started |
| P0 | Implement data anonymization for any real data | 2 days | Critical | 🔴 Not Started |
| P0 | Set up automated validation script | 2 days | High | 🔴 Not Started |
| P1 | Implement factory patterns for dynamic data | 3 days | High | 🔴 Not Started |
| P1 | Create boundary condition test data set | 2 days | High | 🔴 Not Started |
| P1 | Document data versioning strategy | 1 day | Medium | 🔴 Not Started |
| P2 | Add property-based testing with Hypothesis | 3 days | Medium | 🔴 Not Started |
| P2 | Set up CI/CD test data validation | 1 day | Medium | 🔴 Not Started |

#### Next Steps

1. **Week 1-2**: Create golden data foundation
   - Identify 10-15 key calculation scenarios
   - Manual calculation verification
   - Cross-validate with MOL government tools
   - Document legal references

2. **Week 3**: Implement privacy protection
   - Set up anonymization scripts
   - Define masking rules
   - PDPA compliance review

3. **Week 4**: Automate validation
   - Implement validation scripts
   - Set up CI/CD checks
   - Create monitoring dashboard

4. **Ongoing**: Maintain and version
   - Monitor legal amendments
   - Update test data quarterly
   - Review and expand coverage

---

### Maintenance Schedule

| Activity | Frequency | Owner | Checklist |
|----------|-----------|-------|-----------|
| Review golden data accuracy | Quarterly | QA Lead | Cross-validate with latest gov tools |
| Check for legal amendments | Monthly | Legal Reviewer | Monitor MOL website for updates |
| Update test data versions | Per Amendment | Dev + QA | Follow versioning strategy |
| Audit privacy compliance | Quarterly | Data Protection Officer | Review all fixtures for PII |
| Expand test coverage | Per Sprint | QA Team | Add cases for new features |
| Performance data refresh | Per Release | Dev Lead | Generate new bulk test data |
| Validate calculation accuracy | Per Deployment | QA Team | Run full validation suite |

---

### Best Practices

1. **Golden Data is Sacred**
   - Verify with government tools
   - Document legal basis
   - Version control strictly
   - Never modify without review

2. **Privacy First**
   - No real PII in test data
   - Use anonymization always
   - Comply with Taiwan PDPA
   - Regular privacy audits

3. **Automation is Key**
   - Automate validation
   - Automate generation (factories)
   - Automate privacy checks
   - CI/CD integration

4. **Legal Compliance**
   - Cross-validate calculations
   - Track legal amendments
   - Update test data promptly
   - Maintain audit trail

5. **Version Control**
   - Archive old versions
   - Document changes
   - Tag releases
   - Enable rollback

6. **Test Data Quality**
   - Realistic distributions
   - Edge cases covered
   - Error scenarios included
   - Performance data scaled

---

### Integration with Other Skills

| Related Skill | Integration Point | Usage |
|--------------|------------------|-------|
| `bdd-scenario` | Test data drives BDD examples | Use test data categories to create Scenario Outline examples |
| `test-coverage` | Validate test data coverage | Ensure all code paths have corresponding test data |
| `quality-gate` | Test data validation in gates | Include test data quality checks in quality gates |
| `bdd-step-definition` | Use test data in step implementations | Load fixtures and factories in step definitions |
| `defect-report` | Test data for bug reproduction | Create minimal test cases to reproduce defects |

---
```

## Example Usage

Input: `/test-data-strategy overtime calculation module`

Output: [Full strategy report as shown above with specific data for overtime calculations]

---

## Notes

- **Legal accuracy is critical** - all golden data must be verified
- **Privacy compliance is mandatory** - Taiwan PDPA must be followed
- **Version control is essential** - track legal amendments
- **Automation reduces errors** - validate test data automatically
- **Documentation prevents confusion** - document data sources and validation methods
