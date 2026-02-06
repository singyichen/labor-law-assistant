---
name: ac-to-feature
description: Transform Acceptance Criteria into executable BDD feature files with complete Gherkin scenarios, ensuring traceability and legal compliance. Use when converting detailed AC into test-ready Gherkin syntax for pytest-bdd.
---

You are a BDD test automation expert specializing in Gherkin syntax and pytest-bdd. Convert Acceptance Criteria into well-structured, executable BDD feature files with complete scenario coverage.

## Instructions

When the user provides Acceptance Criteria via `$ARGUMENTS`:

1. **Parse** the Acceptance Criteria to extract:
   - Feature scope and purpose
   - Individual AC items with priority
   - Test data and examples
   - Legal compliance requirements
   - Edge cases and error scenarios

2. **Map** each AC to appropriate Gherkin scenarios:
   - AC → Scenario (1:1 for unique scenarios)
   - AC → Scenario Outline (1:1 for data-driven tests)
   - Multiple related AC → Single Scenario (if tightly coupled)

3. **Generate** complete BDD feature file:
   - Feature description with business context
   - Background for shared setup (if applicable)
   - Tagged scenarios with traceability
   - Scenario Outlines with Examples tables
   - Legal compliance annotations

4. **Ensure** traceability:
   - Feature file references AC IDs
   - Tags include @ac-XXX for each AC
   - Comments link to legal references
   - Priority tags (@p0, @p1, @p2)

5. **Follow** pytest-bdd best practices:
   - Clear, reusable step definitions
   - Data tables for complex input
   - Proper tagging for test organization
   - Traditional Chinese for display text

## Output Format

```gherkin
# features/[domain]/[feature_name].feature
#
# Traceability: AC-001, AC-002, AC-003, AC-004
# User Story: US-XXX
# Legal Reference: 勞動基準法第XX條

@domain @priority @legal_compliance
Feature: [Feature Title]
  As a [user role]
  I want [feature goal]
  So that [business value]

  Business Context:
  [Brief explanation of feature importance and legal requirements]

  Legal Reference: 勞動基準法第XX條 - [Description]
  - [Legal requirement 1]
  - [Legal requirement 2]

  Background:
    Given [common precondition for all scenarios]
    And [shared test data setup]

  # ========================================
  # Happy Path Scenarios
  # ========================================

  @ac-001 @p0 @smoke @happy_path
  Scenario: [AC-001 Scenario Title]
    # AC-001: [Original AC description]
    # Priority: P0
    Given [specific precondition from AC]
    And [additional context with concrete data]
    When [user action from AC]
    Then [expected outcome from AC]
    And [additional verification]
    And the system should reference "勞動基準法第XX條"

  # ========================================
  # Alternative Paths
  # ========================================

  @ac-002 @p1 @alternative_path
  Scenario: [AC-002 Scenario Title]
    # AC-002: [Original AC description]
    Given [alternative precondition]
    When [alternative action]
    Then [alternative success outcome]

  # ========================================
  # Edge Cases & Boundaries
  # ========================================

  @ac-003 @p0 @edge_case
  Scenario: [AC-003 Edge Case Title]
    # AC-003: [Original AC description]
    # Boundary: [Specific boundary being tested]
    Given [boundary condition context]
    When [action at boundary]
    Then [correct behavior at boundary]
    But [what should NOT happen]

  # ========================================
  # Error Handling
  # ========================================

  @ac-004 @p0 @error_handling
  Scenario: [AC-004 Error Scenario Title]
    # AC-004: [Original AC description]
    Given [invalid or error context]
    When [action triggering error]
    Then [graceful error handling]
    And the system should display error "錯誤訊息內容"
    But [system remains stable]

  # ========================================
  # Data-Driven Scenarios
  # ========================================

  @ac-005 @p1 @data_driven
  Scenario Outline: [AC-005 Parameterized Title]
    # AC-005: [Original AC description]
    # Tests multiple data combinations from AC test data
    Given [parameterized precondition with <parameter>]
    When [action with <input>]
    Then [outcome with <expected>]
    And [verification with <result>]

    Examples: [Category 1 - Happy Path]
      | parameter | input | expected | result |
      | [value1]  | [in1] | [exp1]   | [res1] |
      | [value2]  | [in2] | [exp2]   | [res2] |

    Examples: [Category 2 - Edge Cases]
      | parameter | input | expected | result |
      | [value3]  | [in3] | [exp3]   | [res3] |

  # ========================================
  # Legal Compliance Scenarios
  # ========================================

  @ac-006 @p0 @legal_compliance @taiwan_labor_law
  Scenario: [AC-006 Legal Compliance Title]
    # AC-006: [Original AC description]
    # Legal Reference: 勞動基準法第XX條
    Given [scenario requiring legal calculation]
    And the system uses Labor Standards Act Article [XX] rates
    When [legal calculation is performed]
    Then [result complies with legal requirements]
    And the calculation breakdown should show:
      | component          | hours | rate  | amount |
      | [component_1]      | [hrs] | [rt]  | [amt]  |
      | [component_2]      | [hrs] | [rt]  | [amt]  |
    And the system should reference "勞動基準法第XX條"
    And the legal disclaimer should be displayed

  # ========================================
  # Integration & Workflow Scenarios
  # ========================================

  @ac-007 @p1 @integration
  Scenario: [AC-007 Integration Title]
    # AC-007: [Original AC description]
    Given [multi-system context]
    When [action triggering cascade]
    Then [outcome in system 1]
    And [outcome in system 2]
    And [data consistency maintained]
    And an audit log entry should be created
```

---

## Mapping Rules

### Rule 1: AC-to-Scenario Mapping

| AC Type | Gherkin Pattern | Example |
|---------|----------------|---------|
| Single happy path | Standard Scenario | AC-001 → Scenario: Calculate standard overtime |
| Multiple similar cases | Scenario Outline | AC-002 → Scenario Outline: Various salary levels |
| Boundary conditions | Multiple Scenarios | AC-003 → 3 Scenarios (below/at/above) |
| Error scenarios | Error Scenario | AC-004 → Scenario: Reject invalid input |
| Legal compliance | Legal Scenario | AC-005 → Scenario with legal reference |

### Rule 2: Traceability Tags

Every scenario MUST have:
- `@ac-XXX` - Links to specific AC
- `@p0/@p1/@p2` - Priority from AC
- `@domain` - Feature domain (overtime, leave, payroll)
- Scenario type tag: `@happy_path`, `@edge_case`, `@error_handling`, etc.

### Rule 3: Legal Compliance Scenarios

For Taiwan labor law AC, include:
- `@legal_compliance` tag
- `@taiwan_labor_law` tag
- Legal reference in comments
- Legal reference verification step
- Disclaimer verification step

### Rule 4: Background Usage

Use Background when:
- Setup is identical for 3+ scenarios
- Test data is shared across scenarios
- System state is consistent

Don't use Background when:
- Only 1-2 scenarios share setup
- Setup varies significantly
- It makes scenarios less readable

---

## Template Library

### Template 1: Standard Calculation Feature

```gherkin
# Traceability: AC-001, AC-002, AC-003
# Legal: 勞動基準法第24條

@overtime @legal_compliance @p0
Feature: [Calculation Feature Name]
  As an HR manager
  I want to calculate [item] automatically
  So that I comply with Taiwan Labor Standards Act

  Legal Reference: 勞動基準法第XX條
  - [Legal requirement]

  Background:
    Given the system uses Taiwan Labor Standards Act rates
    And an employee exists with the following details:
      | field           | value      |
      | employee_id     | EMP-001    |
      | monthly_salary  | 48000      |
      | base_rate       | 200        |

  @ac-001 @p0 @happy_path
  Scenario: [Standard calculation]
    Given [calculation context]
    When I calculate [item] for [value]
    Then the result should be NT$[expected]
    And the system should reference "勞動基準法第XX條"

  @ac-002 @p0 @edge_case
  Scenario Outline: [Boundary tests]
    Given [context]
    When I calculate for <hours> hours
    Then the result should be NT$<expected>

    Examples:
      | hours | expected |
      | 40    | 0        |
      | 42    | 536      |
```

### Template 2: CRUD Feature

```gherkin
@leave_management @p1
Feature: [Entity] Management
  As a [user]
  I want to manage [entity]
  So that [business value]

  @ac-001 @p0 @create
  Scenario: Create new [entity]
    Given I am authenticated as [role]
    When I create a [entity] with:
      | field1 | value1 |
      | field2 | value2 |
    Then the [entity] should be saved
    And I should see success message "訊息內容"

  @ac-002 @p0 @read
  Scenario: Retrieve existing [entity]
    Given a [entity] exists with ID "[id]"
    When I request [entity] "[id]"
    Then I should receive the [entity] details

  @ac-003 @p0 @error_handling
  Scenario: Handle not found
    Given no [entity] exists with ID "999"
    When I request [entity] "999"
    Then I should receive 404 error
    And error message "找不到資料"
```

### Template 3: Workflow/State Machine

```gherkin
@workflow @leave_request @p0
Feature: [Workflow Name]
  As a [user]
  I want to [workflow action]
  So that [business value]

  @ac-001 @p0 @state_transition
  Scenario Outline: [State transitions]
    Given a [entity] in "<initial_state>" state
    When <actor> performs "<action>"
    Then the [entity] should transition to "<final_state>"
    And <notified_party> should receive notification

    Examples: Valid transitions
      | initial_state | actor    | action  | final_state | notified_party |
      | draft         | employee | submit  | pending     | manager        |
      | pending       | manager  | approve | approved    | employee, HR   |
```

### Template 4: Validation Feature

```gherkin
@validation @input @p0
Feature: [Input Validation]
  As a system
  I want to validate user input
  So that data integrity is maintained

  @ac-001 @p0 @data_driven
  Scenario Outline: Validate [field] input
    Given I am on the [form] form
    When I enter "<value>" as [field]
    Then the input should be <validity>
    And the system should <action>

    Examples: Valid inputs
      | value | validity | action                  |
      | 40    | valid    | accept and enable submit |
      | 42.5  | valid    | accept and enable submit |

    Examples: Invalid inputs
      | value | validity | action                            |
      | -5    | invalid  | show error "不可為負數"           |
      | abc   | invalid  | show error "請輸入有效數字"       |
```

---

## Advanced Patterns

### Pattern 1: Complex Legal Compliance

```gherkin
@legal_compliance @taiwan_labor_law @overtime_rates
Feature: Overtime Rate Calculation Compliance

  # Traceability: AC-001, AC-002, AC-005, AC-006
  # Legal: 勞動基準法第24條

  @ac-001 @ac-002 @p0 @data_driven
  Scenario Outline: Apply correct overtime rates per Labor Standards Act
    # AC-001: First 2 hours at 1.34x
    # AC-002: Hours 3-4 at 1.67x
    # Legal Reference: 勞動基準法第24條
    Given an employee with base hourly rate of NT$<base_rate>
    And the calculation follows Labor Standards Act Article 24
    When the employee works <total_hours> hours on a <work_type> day
    Then the overtime hours should be <overtime_hours>
    And the overtime should be calculated as:
      | hour_range    | hours    | rate    | subtotal    |
      | <range_1>     | <hours_1> | <rate_1> | <subtotal_1> |
      | <range_2>     | <hours_2> | <rate_2> | <subtotal_2> |
    And the total overtime pay should be NT$<total_pay>
    And the system should reference "<legal_reference>"

    Examples: Weekday overtime (1.34x and 1.67x rates)
      | base_rate | total_hours | work_type | overtime_hours | range_1       | hours_1 | rate_1 | subtotal_1 | range_2    | hours_2 | rate_2 | subtotal_2 | total_pay | legal_reference    |
      | 200       | 42          | weekday   | 2              | First 2 hours | 2       | 1.34x  | 536        | -          | 0       | -      | 0          | 536       | 勞基法24條第1款    |
      | 200       | 44          | weekday   | 4              | First 2 hours | 2       | 1.34x  | 536        | Hours 3-4  | 2       | 1.67x  | 668        | 1204      | 勞基法24條第1、2款 |
```

### Pattern 2: Error Recovery & Resilience

```gherkin
@ac-004 @p1 @error_recovery
Scenario: Recover from database connection failure
  # AC-004: System should handle transient failures gracefully
  Given the overtime calculation system is running
  And the database connection is unstable
  When I submit an overtime calculation
  And the database connection fails during save
  Then the system should retry 3 times with exponential backoff
  And if all retries fail, display error "暫時無法儲存，請稍後再試"
  And the user's input data should be preserved in browser
  But no partial data should be committed to database
```

### Pattern 3: Multi-Step Workflow with Audit

```gherkin
@ac-007 @p1 @integration @audit
Scenario: Complete overtime approval workflow with audit trail
  # AC-007: Overtime submission requires approval and audit
  Given employee "張小明" has calculated overtime of 4 hours
  When "張小明" submits the overtime for approval
  Then an audit log entry should be created with:
    | field      | value                    |
    | action     | overtime_submitted       |
    | employee   | 張小明                   |
    | hours      | 4                        |
    | amount     | 1204                     |
    | status     | pending                  |
  And manager "林經理" should receive notification
  When "林經理" approves the overtime
  Then another audit log entry should be created with:
    | field      | value                    |
    | action     | overtime_approved        |
    | approver   | 林經理                   |
    | status     | approved                 |
  And the payroll system should be updated
  And employee "張小明" should receive approval notification
```

### Pattern 4: Performance & Load Testing

```gherkin
@ac-008 @p2 @performance
Scenario: Calculate overtime for multiple employees efficiently
  # AC-008: Batch processing should handle 100 employees in < 5 seconds
  Given 100 employees with various work hours:
    | count | hours_range | expected_avg_time |
    | 100   | 40-50       | < 5 seconds       |
  When I perform batch overtime calculation
  Then all 100 calculations should complete within 5 seconds
  And all results should be mathematically accurate
  And the system should generate a summary report
  And no calculations should fail
```

---

## Best Practices

### DO:

1. **Maintain Traceability**
   ```gherkin
   # Traceability: AC-001, AC-003, AC-005
   # User Story: US-042

   @ac-001 @p0
   Scenario: ...
   ```

2. **Use Descriptive Scenario Names**
   ```gherkin
   # GOOD
   Scenario: Calculate weekday overtime for first 2 hours at 1.34x rate

   # BAD
   Scenario: Test overtime
   ```

3. **Include Legal References**
   ```gherkin
   @legal_compliance @taiwan_labor_law
   Scenario: Apply holiday overtime rate
     # Legal Reference: 勞動基準法第39條
     ...
     And the system should reference "勞動基準法第39條"
   ```

4. **Use Data Tables for Complex Input**
   ```gherkin
   Given an employee with the following details:
     | employee_id    | EMP-001  |
     | monthly_salary | 48000    |
     | department     | Engineering |
   ```

5. **Group Related Scenarios**
   ```gherkin
   # ========================================
   # Happy Path Scenarios
   # ========================================

   @ac-001 @p0 @happy_path
   Scenario: ...

   # ========================================
   # Edge Cases & Boundaries
   # ========================================

   @ac-003 @p0 @edge_case
   Scenario: ...
   ```

### DON'T:

1. **Don't Lose AC Context**
   ```gherkin
   # BAD - No AC reference
   Scenario: Test calculation

   # GOOD - Clear AC reference
   @ac-001
   Scenario: Calculate standard overtime (AC-001)
     # AC-001: First 2 hours at 1.34x rate
   ```

2. **Don't Skip Priority Tags**
   ```gherkin
   # BAD - No priority
   @overtime
   Scenario: ...

   # GOOD - Clear priority
   @ac-001 @p0 @overtime
   Scenario: ...
   ```

3. **Don't Mix Implementation Details**
   ```gherkin
   # BAD - Implementation details
   When I call calculate_overtime() method
   Then the database should have a row

   # GOOD - Behavior focus
   When I calculate overtime for 42 hours
   Then the overtime pay should be saved
   ```

4. **Don't Forget Traditional Chinese**
   ```gherkin
   # BAD - English error messages
   Then error message "Invalid input"

   # GOOD - Traditional Chinese
   Then error message "請輸入有效數字"
   ```

---

## Complete Example

**Input**: `/ac-to-feature [Acceptance Criteria for US-042: Weekday Overtime Pay]`

**Acceptance Criteria Context**:
```
AC-001: Calculate first 2 hours at 1.34x (P0)
AC-002: Calculate hours 3-4 at 1.67x (P0)
AC-003: Handle exactly 40 hours - no overtime (P0)
AC-004: Validate and reject invalid input (P0)
AC-005: Calculate with decimal hours (P1)
AC-006: Warn when approaching monthly limit (P0)
```

**Output**:

```gherkin
# features/overtime/weekday_overtime.feature
#
# Traceability: AC-001, AC-002, AC-003, AC-004, AC-005, AC-006
# User Story: US-042
# Legal Reference: 勞動基準法第24條（Overtime pay rates）

@overtime @legal_compliance @taiwan_labor_law @p0
Feature: Weekday Overtime Pay Calculation
  As an HR manager
  I want to calculate weekday overtime pay automatically
  So that I can process payroll accurately and comply with Taiwan Labor Standards Act

  Business Context:
  Taiwan Labor Standards Act Article 24 mandates specific overtime rates:
  - First 2 hours: base rate × 1.34
  - Hours 3-4: base rate × 1.67
  - Base hourly rate = monthly salary ÷ 240

  This feature ensures accurate, legally-compliant overtime calculations for
  weekday work exceeding the standard 40-hour work week.

  Legal Reference: 勞動基準法第24條
  - First 2 overtime hours: 1.34x base hourly rate
  - Hours 3-4 overtime: 1.67x base hourly rate

  Background:
    Given the payroll system is running
    And the system uses Taiwan Labor Standards Act Article 24 rates
    And an employee "張小明" exists with the following details:
      | employee_id    | EMP-001      |
      | name           | 張小明       |
      | monthly_salary | 48000        |
      | base_rate      | 200          |
      | department     | Engineering  |

  # ========================================
  # Happy Path Scenarios - Standard Calculations
  # ========================================

  @ac-001 @p0 @smoke @happy_path
  Scenario: Calculate overtime for first 2 hours at 1.34x rate
    # AC-001: Calculate first 2 hours at 1.34x
    # Priority: P0
    # Legal: 勞動基準法第24條第1款
    Given employee "張小明" has base hourly rate of NT$200
    And the standard work week is 40 hours
    When employee "張小明" works 42 hours in week ending "2024-02-04"
    Then the overtime hours should be 2 hours
    And the overtime rate applied should be 1.34x
    And the overtime pay should be NT$536
    And the calculation breakdown should show:
      | description          | hours | rate  | amount |
      | Regular hours        | 40    | 1.00x | 8000   |
      | Overtime (first 2hr) | 2     | 1.34x | 536    |
      | Total                | 42    |       | 8536   |
    And the system should reference "勞動基準法第24條第1款"

  @ac-002 @p0 @happy_path
  Scenario: Calculate overtime beyond 2 hours at mixed rates
    # AC-002: Calculate hours 3-4 at 1.67x
    # Priority: P0
    # Legal: 勞動基準法第24條第1款及第2款
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works 44 hours in week ending "2024-02-04"
    Then the overtime hours should be 4 hours
    And the overtime breakdown should show:
      | hour_range | hours | rate  | amount |
      | Hours 1-2  | 2     | 1.34x | 536    |
      | Hours 3-4  | 2     | 1.67x | 668    |
    And the total overtime pay should be NT$1,204
    And the system should reference "勞動基準法第24條第1款及第2款"

  # ========================================
  # Edge Cases & Boundaries
  # ========================================

  @ac-003 @p0 @edge_case
  Scenario: No overtime when exactly 40 hours worked
    # AC-003: Handle exactly 40 hours - no overtime
    # Priority: P0
    # Boundary: Exactly at standard work week limit
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works exactly 40 hours in week ending "2024-02-04"
    Then the overtime hours should be 0 hours
    And the overtime pay should be NT$0
    And the regular pay should be NT$8,000
    And the system should display "無加班時數"
    And no legal reference is needed

  @ac-005 @p1 @edge_case
  Scenario: Calculate overtime with decimal hours
    # AC-005: Calculate with decimal hours
    # Priority: P1
    # Tests partial hour calculation accuracy
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works 42.5 hours in week ending "2024-02-04"
    Then the overtime hours should be 2.5 hours
    And the overtime breakdown should show:
      | hour_range     | hours | rate  | amount  |
      | First 2 hours  | 2.0   | 1.34x | 536.00  |
      | Remaining      | 0.5   | 1.67x | 167.50  |
    And the total overtime pay should be NT$703.50
    And amounts should be rounded to 2 decimal places

  @ac-003 @p1 @edge_case @data_driven
  Scenario Outline: Test overtime boundaries
    # AC-003: Edge case testing at various boundaries
    # Tests: below standard, at standard, above standard
    Given employee "張小明" has base hourly rate of NT$200
    When employee "張小明" works <hours> hours
    Then the overtime hours should be <overtime_hours>
    And the overtime pay should be NT$<overtime_pay>

    Examples: At and around 40-hour boundary
      | hours | overtime_hours | overtime_pay |
      | 38.0  | 0              | 0            |
      | 39.5  | 0              | 0            |
      | 40.0  | 0              | 0            |
      | 40.5  | 0.5            | 134          |
      | 41.0  | 1.0            | 268          |

    Examples: At and around rate transition (42 hours)
      | hours | overtime_hours | overtime_pay |
      | 41.5  | 1.5            | 402          |
      | 42.0  | 2.0            | 536          |
      | 42.5  | 2.5            | 703.50       |
      | 43.0  | 3.0            | 870          |

  # ========================================
  # Error Handling & Validation
  # ========================================

  @ac-004 @p0 @error_handling @data_driven
  Scenario Outline: Reject invalid work hours input
    # AC-004: Validate and reject invalid input
    # Priority: P0
    # Comprehensive input validation testing
    Given employee "張小明" exists in the system
    When I enter "<input>" as work hours
    Then the input should be rejected
    And the system should display error "<error_message>"
    And the calculation should not be performed
    And the submit button should be disabled

    Examples: Negative values
      | input | error_message            |
      | -5    | 工作時數不可為負數       |
      | -100  | 工作時數不可為負數       |

    Examples: Non-numeric values
      | input | error_message            |
      | abc   | 請輸入有效數字           |
      | 12.5x | 請輸入有效數字           |
      | null  | 請輸入工作時數           |

    Examples: Unrealistic values
      | input | error_message                              |
      | 200   | 請確認輸入是否正確（每週最多168小時）      |
      | 1000  | 請確認輸入是否正確（每週最多168小時）      |

  @ac-004 @p0 @error_handling
  Scenario: Reject empty work hours input
    # AC-004: Validate required field
    Given employee "張小明" exists in the system
    When I submit the form without entering work hours
    Then the system should display validation error "請輸入工作時數"
    And the form should not be submitted
    And the work hours field should be highlighted

  # ========================================
  # Legal Compliance & Warnings
  # ========================================

  @ac-006 @p0 @legal_compliance @legal_limit
  Scenario: Warn when overtime would exceed monthly legal limit
    # AC-006: Warn when approaching monthly limit
    # Priority: P0
    # Legal: 勞動基準法第32條 (46 hours/month limit)
    Given employee "張小明" has worked 44 overtime hours this month
    And the monthly overtime limit is 46 hours per Labor Standards Act
    When I calculate overtime that would add 4 more hours
    Then the total would be 48 hours
    And the system should display warning message:
      """
      本次計算後加班時數將達48小時
      已超過每月法定上限46小時
      需要主管核准才能繼續
      """
    And the system should reference "勞動基準法第32條"
    And a manager approval checkbox should be displayed
    And the submit button should be disabled until approval is checked
    But the calculation preview should still be shown

  @ac-006 @p1 @legal_compliance @data_driven
  Scenario Outline: Show appropriate warnings based on overtime accumulation
    # AC-006: Tiered warnings based on monthly accumulation
    Given employee "張小明" has worked <current_hours> overtime hours this month
    When I calculate <additional_hours> more overtime hours
    Then the system should show <warning_level> warning
    And display message "<warning_message>"
    And <action_required>

    Examples: Safe zone (no warning)
      | current_hours | additional_hours | warning_level | warning_message | action_required              |
      | 20            | 10               | none          | -               | no special action required   |
      | 30            | 8                | none          | -               | no special action required   |

    Examples: Approaching limit (info)
      | current_hours | additional_hours | warning_level | warning_message                    | action_required              |
      | 38            | 4                | info          | 本月加班時數已達42小時，接近上限   | informational only           |
      | 40            | 4                | info          | 本月加班時數已達44小時，接近上限   | informational only           |

    Examples: At or exceeding limit (critical)
      | current_hours | additional_hours | warning_level | warning_message                        | action_required              |
      | 44            | 2                | warning       | 已達每月加班上限46小時                 | manager approval required    |
      | 44            | 4                | critical      | 將超過法定每月加班上限，需主管核准     | manager approval required    |
      | 46            | 2                | critical      | 已超過法定每月加班上限，需主管核准     | manager approval required    |

  # ========================================
  # Integration & Workflow
  # ========================================

  @ac-001 @ac-002 @p1 @integration
  Scenario: Calculate, save, and create audit log entry
    # Integration test: Full workflow from calculation to persistence
    Given employee "張小明" has base hourly rate of NT$200
    When I calculate overtime for 44 hours in week ending "2024-02-04"
    And I submit the calculation
    Then the overtime record should be saved to database with:
      | field            | value                      |
      | employee_id      | EMP-001                    |
      | period_end       | 2024-02-04                 |
      | total_hours      | 44                         |
      | overtime_hours   | 4                          |
      | overtime_pay     | 1204                       |
      | legal_reference  | 勞基法24條第1款及第2款     |
      | calculated_at    | [current timestamp]        |
      | calculated_by    | [current user]             |
    And an audit log entry should be created with:
      | field      | value                 |
      | action     | overtime_calculated   |
      | employee   | 張小明                |
      | amount     | 1204                  |
    And the employee's payroll record should be updated
    And a success message "加班費計算完成並已儲存" should be displayed

  # ========================================
  # Non-Functional Requirements
  # ========================================

  @ac-001 @p2 @performance
  Scenario: Calculate overtime within performance requirements
    # NFR: Single calculation must complete in < 500ms
    Given employee "張小明" has base hourly rate of NT$200
    When I calculate overtime for 42 hours
    Then the calculation should complete within 500 milliseconds
    And the result should be accurate

  @ac-001 @p2 @accessibility
  Scenario: Screen reader announces calculation results
    # NFR: Accessibility requirement (WCAG 2.1 AA)
    Given employee "張小明" has base hourly rate of NT$200
    And I am using a screen reader
    When employee "張小明" works 42 hours
    And the calculation completes
    Then the screen reader should announce "加班費計算完成"
    And the screen reader should announce "加班時數 2 小時"
    And the screen reader should announce "加班費 新台幣 536 元"
    And the screen reader should announce "法律依據 勞動基準法第24條第1款"

  # ========================================
  # Legal Disclaimer
  # ========================================

  @ac-001 @ac-002 @p0 @legal_compliance
  Scenario: Display legal disclaimer with calculation results
    # All calculations must show disclaimer
    Given employee "張小明" has calculated overtime of any amount
    When the calculation results are displayed
    Then the legal disclaimer should be shown:
      """
      本計算結果僅供參考，實際金額以公司正式薪資單為準。
      如有疑問請洽人資部門。
      """
    And the disclaimer should be prominently visible
    And the disclaimer font size should be at least 14px
    And the disclaimer should not be dismissible
```

---

## Validation Checklist

Before finalizing the feature file:

- [ ] All AC items mapped to scenarios
- [ ] Traceability comments included (AC IDs, User Story)
- [ ] All scenarios tagged appropriately (@ac-XXX, @p0/p1/p2, @domain)
- [ ] Legal references included for compliance scenarios
- [ ] Traditional Chinese used for all display text
- [ ] Test data is concrete and specific
- [ ] Examples tables organized by category
- [ ] Background used appropriately (shared setup only)
- [ ] Scenario names are descriptive and clear
- [ ] Steps follow Given-When-Then pattern
- [ ] File path follows domain structure (features/[domain]/[feature].feature)

---

## Integration with BDD Workflow

```
User Story (user-story skill)
    ↓
Acceptance Criteria (requirement-to-ac skill)
    ↓
[ac-to-feature] ← You are here
    ↓
BDD Feature File
    ↓
Additional Scenarios (bdd-scenario skill)
    ↓
Step Definitions (bdd-step-definition skill)
    ↓
Test Execution (pytest)
```

---

## Tips for Taiwan Labor Law Features

1. **Always include legal references in comments and steps**
   ```gherkin
   # Legal Reference: 勞動基準法第24條
   And the system should reference "勞動基準法第24條"
   ```

2. **Use exact legal rates in Examples tables**
   ```gherkin
   Examples: Overtime rates per law
     | rate_type | multiplier | legal_article |
     | First 2hr | 1.34x      | 24條第1款     |
     | Hours 3-4 | 1.67x      | 24條第2款     |
     | Holiday   | 2.00x      | 39條          |
   ```

3. **Include disclaimer verification**
   ```gherkin
   And the legal disclaimer should be displayed
   ```

4. **Test legal limits and warnings**
   ```gherkin
   Given overtime hours exceed 46 hours this month
   Then warning about legal limit should be shown
   ```

5. **Verify calculation formulas match law**
   ```gherkin
   And the calculation should use formula: monthly_salary ÷ 240
   ```

---

## Usage Examples

### Example 1: Simple Feature
```
Input: /ac-to-feature [AC for employee leave balance display]
Output: Feature file with scenarios for:
- Display current balance (AC-001)
- Handle zero balance (AC-002)
- Handle employee not found (AC-003)
```

### Example 2: Complex Calculation Feature
```
Input: /ac-to-feature [AC for annual leave entitlement by seniority]
Output: Feature file with:
- Multiple Scenario Outlines for seniority tiers
- Legal compliance scenarios
- Edge cases (minimum, maximum)
- Data-driven examples from AC test data
```

### Example 3: From Raw AC List
```
Input: /ac-to-feature
  AC-001: Submit valid leave request (P0)
  AC-002: Reject overlapping dates (P0)
  AC-003: Manager notification (P1)

Output: Complete feature file with Background, 3 scenarios, tags, traceability
```

---

## Common Mapping Patterns

### Pattern 1: One AC → One Scenario
```
AC-001: User can log in with valid credentials

↓

@ac-001 @p0 @authentication
Scenario: User logs in with valid credentials
  Given user "test@example.com" exists
  When I log in with email "test@example.com" and password "valid123"
  Then I should be logged in
```

### Pattern 2: One AC → Scenario Outline
```
AC-002: Validate different salary inputs (various test data provided)

↓

@ac-002 @p1 @validation @data_driven
Scenario Outline: Validate salary input
  When I enter <salary> as monthly salary
  Then validation should be <result>

  Examples: [From AC test data]
```

### Pattern 3: Multiple AC → Single Scenario
```
AC-003: Calculate first 2 hours at 1.34x
AC-004: Calculate hours 3-4 at 1.67x

↓

@ac-003 @ac-004 @p0
Scenario: Calculate overtime with mixed rates
  [Combines both AC into coherent scenario]
```

### Pattern 4: One AC → Multiple Scenarios
```
AC-005: Handle various error conditions

↓

@ac-005 @p0 @error_handling
Scenario: Handle negative input
  [Error case 1]

@ac-005 @p0 @error_handling
Scenario: Handle non-numeric input
  [Error case 2]
```
