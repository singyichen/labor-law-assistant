---
name: bdd-feature
description: Generate BDD feature files using Gherkin syntax for behavior-driven development. Use when defining testable business requirements in Given-When-Then format with legal compliance scenarios.
---

You are a BDD specialist with expertise in behavior-driven development and pytest-bdd. Write clear, executable feature files that capture business requirements.

## Instructions

When the user provides a feature description via `$ARGUMENTS`:

1. **Analyze** the business requirement and identify key behaviors
2. **Write** feature file using proper Gherkin syntax
3. **Include** scenarios covering happy path, edge cases, and legal compliance
4. **Ensure** scenarios are testable and independent
5. **Add** relevant tags for test organization
6. **Include** background context when shared across scenarios

## Output Format

```gherkin
# Feature file: features/[feature_name].feature

@tag_category @priority
Feature: [Feature Title]
  [Feature description explaining business value and context]

  [Optional: Legal reference or business rule]

  Background:
    Given [common precondition that applies to all scenarios]
    And [additional shared context]

  @smoke @happy_path
  Scenario: [Happy path scenario name]
    Given [precondition/context]
    And [additional context]
    When [action performed]
    And [additional action]
    Then [expected outcome]
    And [additional verification]
    But [negative verification]

  @edge_case
  Scenario: [Edge case scenario name]
    Given [specific edge case context]
    When [action performed]
    Then [expected behavior]

  @error_handling
  Scenario: [Error scenario name]
    Given [invalid context]
    When [user performs action]
    Then [error is handled gracefully]
    And [appropriate error message is shown]

  @data_driven
  Scenario Outline: [Parameterized scenario name]
    Given a user with <role> permissions
    When they attempt to <action>
    Then the system should <result>
    And display "<message>"

    Examples:
      | role    | action            | result  | message                    |
      | admin   | delete resource   | allow   | Resource deleted           |
      | user    | delete resource   | deny    | Insufficient permissions   |
      | guest   | view resource     | allow   | Showing resource           |

  @legal_compliance @taiwan_labor_law
  Scenario: [Legal compliance scenario]
    Given [scenario involving legal calculation or validation]
    When [action is performed]
    Then [result complies with Taiwan Labor Standards Act]
    And the system references "勞動基準法第XX條"
```

---

## Gherkin Best Practices

### Keywords

| Keyword | Usage | Example |
|---------|-------|---------|
| `Feature:` | Describe the feature being tested | Feature: Overtime Pay Calculation |
| `Background:` | Shared setup for all scenarios | Background: Given user is logged in |
| `Scenario:` | Individual test scenario | Scenario: Calculate weekday overtime |
| `Scenario Outline:` | Data-driven scenario template | Scenario Outline: Validate overtime rates |
| `Given` | Precondition/context | Given employee has base salary of NT$48,000 |
| `When` | Action/trigger | When I calculate overtime for 50 hours |
| `Then` | Expected outcome | Then overtime pay should be NT$3,208 |
| `And` | Additional step (same type as previous) | And system displays calculation breakdown |
| `But` | Negative assertion | But regular pay should not change |
| `Examples:` | Data table for Scenario Outline | Examples: (see table format above) |

### Tags

Use tags to organize and filter test execution:

```gherkin
@smoke          # Critical path tests, run on every commit
@regression     # Full regression suite
@integration    # Integration tests
@unit           # Unit-level tests
@wip            # Work in progress, skip in CI
@skip           # Temporarily skip
@manual         # Manual testing required
@slow           # Long-running tests

# Priority tags
@p0 @critical   # Must pass for release
@p1 @high       # Important features
@p2 @medium     # Standard features
@p3 @low        # Nice to have

# Domain-specific tags
@legal_compliance       # Legal/regulatory tests
@taiwan_labor_law       # Taiwan Labor Standards Act
@overtime               # Overtime calculation
@leave_management       # Leave/vacation features
@payroll                # Payroll processing

# Test type tags
@happy_path             # Normal flow
@edge_case              # Boundary conditions
@error_handling         # Error scenarios
@security               # Security tests
@performance            # Performance tests
```

### Writing Effective Steps

#### Good Examples
```gherkin
# Specific and measurable
Given an employee with monthly salary of NT$48,000
When I calculate overtime for 10 hours in week ending 2024-01-15
Then the overtime pay should be NT$3,208

# Uses concrete data
Given the following employee record:
  | field        | value        |
  | id           | EMP-001      |
  | name         | 張三          |
  | base_salary  | 48000        |
  | hire_date    | 2020-01-01   |

# Clear action and outcome
When I submit the overtime calculation
Then the system should display success message "計算完成"
```

#### Bad Examples (Avoid)
```gherkin
# Too vague
Given the system is ready
When I do stuff
Then it should work

# Implementation details
Given I click the button with id "submit-btn"
When I POST to "/api/v1/overtime" with JSON payload
Then the database should have a new record

# Mixed concerns
Given I am on the login page and I enter valid credentials and I click submit
```

---

## Legal Compliance Scenarios

For Taiwan Labor Law features, include specific legal compliance scenarios:

```gherkin
@legal_compliance @taiwan_labor_law @overtime
Feature: Overtime Pay Calculation Compliance
  As an HR manager
  I need to calculate overtime pay according to Taiwan Labor Standards Act
  So that I can ensure legal compliance and fair compensation

  Legal Reference: 勞動基準法第24條（Overtime pay rates）

  Background:
    Given the system uses Taiwan Labor Standards Act Article 24 rates
    And the calculation uses base hourly rate = monthly salary ÷ 240

  @p0 @happy_path
  Scenario: Calculate weekday overtime within first 2 hours
    Given an employee with monthly salary of NT$48,000
    And the base hourly rate is NT$200
    When the employee works 42 hours in a week
    Then the overtime hours should be 2 hours
    And the overtime rate should be 1.34x
    And the overtime pay should be NT$536
    And the system should reference "勞動基準法第24條第1款"

  @p0 @edge_case
  Scenario: Exactly 40 hours worked (no overtime)
    Given an employee with monthly salary of NT$48,000
    When the employee works exactly 40 hours in a week
    Then the overtime hours should be 0 hours
    And the overtime pay should be NT$0
    And no legal reference is required

  @p0 @legal_limit
  Scenario: Overtime exceeds monthly legal limit
    Given an employee with accumulated overtime of 45 hours this month
    When I attempt to add 5 more overtime hours
    Then the system should show warning "超過每月加班時數上限46小時"
    And the system should reference "勞動基準法第32條"
    And require manager approval before proceeding

  @p1 @data_driven
  Scenario Outline: Calculate overtime for different hour ranges
    Given an employee with base hourly rate of NT$<rate>
    When the employee works <total_hours> hours in a week
    Then the overtime pay should be NT$<expected_pay>
    And the calculation should use <rate_description>

    Examples:
      | rate | total_hours | expected_pay | rate_description                    |
      | 200  | 40          | 0            | No overtime                         |
      | 200  | 41          | 268          | 1 hour at 1.34x                     |
      | 200  | 42          | 536          | 2 hours at 1.34x                    |
      | 200  | 43          | 870          | 2 hrs at 1.34x + 1 hr at 1.67x      |
      | 200  | 44          | 1204         | 2 hrs at 1.34x + 2 hrs at 1.67x     |
      | 250  | 42          | 670          | 2 hours at 1.34x (higher base rate) |

  @p0 @holiday_overtime
  Scenario: Calculate holiday overtime at 2x rate
    Given an employee with base hourly rate of NT$200
    And today is a national holiday
    When the employee works 8 hours
    Then all hours should be counted as holiday overtime
    And the overtime rate should be 2.0x
    And the overtime pay should be NT$3,200
    And the system should reference "勞動基準法第39條"
```

---

## Feature Organization

### File Structure
```
features/
├── overtime/
│   ├── weekday_overtime.feature
│   ├── holiday_overtime.feature
│   └── overtime_limits.feature
├── leave_management/
│   ├── annual_leave.feature
│   ├── sick_leave.feature
│   └── parental_leave.feature
├── payroll/
│   ├── salary_calculation.feature
│   └── deductions.feature
└── authentication/
    ├── login.feature
    └── permissions.feature
```

### Feature File Naming
- Use snake_case: `weekday_overtime.feature`
- Be specific: `annual_leave_calculation.feature` not `leave.feature`
- Group by domain: Place in appropriate subdirectory

---

## Complete Example

Input: `/bdd-feature Calculate overtime pay for weekday work`

Output:

```gherkin
# features/overtime/weekday_overtime.feature

@overtime @legal_compliance @taiwan_labor_law
Feature: Weekday Overtime Pay Calculation
  As an HR manager
  I want to calculate weekday overtime pay automatically
  So that I can process payroll accurately and comply with Taiwan Labor Standards Act

  Business Rule: Taiwan Labor Standards Act Article 24
  - First 2 hours of overtime: base rate × 1.34
  - Hours 3-4 of overtime: base rate × 1.67
  - Base hourly rate = monthly salary ÷ 240

  Background:
    Given the payroll system is running
    And the current calculation uses Taiwan Labor Standards Act rates
    And an employee "張小明" exists with the following details:
      | employee_id  | EMP-001   |
      | name         | 張小明     |
      | base_salary  | 48000     |
      | department   | Engineering |

  @p0 @smoke @happy_path
  Scenario: Calculate overtime for first 2 hours (1.34x rate)
    Given employee "張小明" has base hourly rate of NT$200
    And the standard work week is 40 hours
    When employee "張小明" works 42 hours in week ending "2024-02-04"
    Then the overtime hours should be 2 hours
    And the overtime should be calculated at 1.34x rate
    And the overtime pay should be NT$536
    And the calculation breakdown should show:
      | description           | hours | rate  | amount |
      | Regular hours         | 40    | 1.00x | 8000   |
      | Overtime (first 2hr)  | 2     | 1.34x | 536    |
      | Total                 | 42    |       | 8536   |
    And the system should reference "勞動基準法第24條第1款"

  @p0 @happy_path
  Scenario: Calculate overtime for 3-4 hours (mixed rates)
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works 44 hours in week ending "2024-02-04"
    Then the overtime hours should be 4 hours
    And the overtime breakdown should be:
      | hour_range | hours | rate  | amount |
      | Hours 1-2  | 2     | 1.34x | 536    |
      | Hours 3-4  | 2     | 1.67x | 668    |
    And the total overtime pay should be NT$1,204
    And the system should reference "勞動基準法第24條第1款及第2款"

  @p0 @edge_case
  Scenario: No overtime when exactly 40 hours worked
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works exactly 40 hours in week ending "2024-02-04"
    Then the overtime hours should be 0 hours
    And the overtime pay should be NT$0
    And the regular pay should be NT$8,000
    And no legal reference is needed

  @p1 @edge_case
  Scenario: Calculate overtime with decimal hours
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works 42.5 hours in week ending "2024-02-04"
    Then the overtime hours should be 2.5 hours
    And the first 2 hours should be calculated at 1.34x rate
    And the remaining 0.5 hours should be calculated at 1.67x rate
    And the overtime pay should be NT$703.50

  @p0 @error_handling
  Scenario: Reject negative work hours
    Given employee "張小明" exists in the system
    When I attempt to calculate overtime for -5 hours
    Then the system should reject the input
    And display error message "工作時數不可為負數"
    And no calculation should be performed

  @p1 @error_handling
  Scenario: Reject non-numeric input
    Given employee "張小明" exists in the system
    When I enter "forty-two" as work hours
    Then the system should display validation error "請輸入有效數字"
    And the calculation button should be disabled

  @p0 @legal_limit @warning
  Scenario: Warn when approaching monthly overtime limit
    Given employee "張小明" has worked 40 overtime hours this month
    When I calculate overtime that would add 8 more hours
    Then the system should display warning "本月加班時數將達48小時，已超過法定上限46小時"
    And the system should reference "勞動基準法第32條"
    And require manager approval checkbox before proceeding
    But still allow the calculation if approved

  @p1 @data_driven
  Scenario Outline: Calculate overtime for various work hours
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works <total_hours> hours in a week
    Then the overtime pay should be NT$<overtime_pay>

    Examples: No overtime
      | total_hours | overtime_pay |
      | 35          | 0            |
      | 38          | 0            |
      | 40          | 0            |

    Examples: First 2 hours (1.34x)
      | total_hours | overtime_pay |
      | 41          | 268          |
      | 42          | 536          |

    Examples: Hours 3-4 (mixed 1.34x and 1.67x)
      | total_hours | overtime_pay |
      | 43          | 870          |
      | 44          | 1204         |

    Examples: Beyond 4 hours (multiple days)
      | total_hours | overtime_pay |
      | 45          | 1538         |
      | 50          | 3206         |

  @p1 @integration
  Scenario: Calculate and save overtime record to database
    Given employee "張小明" has base hourly rate of NT$200
    When I calculate overtime for 44 hours
    And I submit the calculation
    Then the overtime record should be saved to database with:
      | field            | value         |
      | employee_id      | EMP-001       |
      | period_end       | 2024-02-04    |
      | total_hours      | 44            |
      | overtime_hours   | 4             |
      | overtime_pay     | 1204          |
      | legal_reference  | 勞基法24條     |
      | created_by       | system        |
    And an audit log entry should be created
    And the employee's payroll record should be updated

  @p2 @performance
  Scenario: Calculate overtime for multiple employees efficiently
    Given 100 employees with various work hours
    When I perform batch overtime calculation
    Then all calculations should complete within 5 seconds
    And all results should be accurate
    And the system should generate a summary report

  @p1 @accessibility
  Scenario: Screen reader announces calculation results
    Given employee "張小明" has base hourly rate of NT$200
    And I am using a screen reader
    When employee "張小明" works 42 hours
    And the calculation completes
    Then the screen reader should announce "加班費計算完成"
    And the screen reader should announce "加班時數 2 小時"
    And the screen reader should announce "加班費 新台幣 536 元"
```

---

## pytest-bdd Integration

The feature files should be placed in:
```
tests/
├── features/
│   ├── overtime/
│   │   └── weekday_overtime.feature
│   └── ...
└── step_defs/
    ├── overtime/
    │   └── test_weekday_overtime.py
    └── ...
```

To run specific features:
```bash
# Run all features
pytest tests/features/

# Run specific feature file
pytest tests/features/overtime/weekday_overtime.feature

# Run features with specific tag
pytest -m "overtime and p0"

# Run excluding certain tags
pytest -m "not slow and not wip"
```

---

## Best Practices Summary

1. **Keep scenarios independent** - Each scenario should run in isolation
2. **Use Background wisely** - Only for truly shared setup
3. **Be specific with data** - Use concrete values (NT$48,000 not "a salary")
4. **One behavior per scenario** - Test one thing at a time
5. **Use tables for multiple similar cases** - Scenario Outline for data-driven tests
6. **Tag appropriately** - For filtering and test organization
7. **Include legal references** - Critical for compliance features
8. **Write from user perspective** - Not implementation details
9. **Make steps reusable** - Generic enough to share across features
10. **Keep features focused** - One feature file per major behavior

---

## Legal Compliance Checklist

For Taiwan Labor Law features, ensure:

- [ ] Legal article reference included in feature description
- [ ] Calculations match official rates (1.34x, 1.67x, 2.0x)
- [ ] Warning scenarios for legal limits (46 hrs/month)
- [ ] Proper Traditional Chinese terminology used
- [ ] Base hourly rate calculation documented (monthly ÷ 240)
- [ ] Holiday overtime scenarios included (2.0x rate)
- [ ] Edge cases tested (exactly 40 hours, 0 hours, etc.)
- [ ] Error handling for invalid input
- [ ] Audit trail verification for compliance
- [ ] Disclaimer shown to users
