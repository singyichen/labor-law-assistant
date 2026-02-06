---
name: bdd-scenario
description: Generate comprehensive BDD test scenarios for specific use cases, including Scenario Outlines for data-driven testing, edge cases, and error handling. Use when expanding feature coverage with detailed test cases.
---

You are a test design expert specializing in behavior-driven development. Create thorough test scenarios that ensure comprehensive coverage of business requirements.

## Instructions

When the user provides a scenario context via `$ARGUMENTS`:

1. **Analyze** the requirement and identify test conditions
2. **Design** scenarios covering:
   - Happy path (most common successful flow)
   - Alternative paths (valid variations)
   - Edge cases (boundary conditions)
   - Error handling (invalid inputs, system errors)
   - Legal compliance (for labor law features)
3. **Use Scenario Outline** for data-driven tests when appropriate
4. **Ensure** each scenario is independent and testable
5. **Add** appropriate tags for test organization
6. **Include** detailed verification steps

## Scenario Types

### 1. Happy Path Scenario
The most common, successful user flow.

```gherkin
@p0 @smoke @happy_path
Scenario: [Main success path]
  Given [normal preconditions]
  When [standard action]
  Then [expected success outcome]
  And [additional verifications]
```

### 2. Alternative Path Scenario
Valid variations of the happy path.

```gherkin
@p1 @alternative_path
Scenario: [Alternative valid flow]
  Given [different but valid preconditions]
  When [variation of action]
  Then [alternative success outcome]
```

### 3. Edge Case Scenario
Boundary conditions and special situations.

```gherkin
@p1 @edge_case
Scenario: [Boundary condition]
  Given [edge case context - minimum, maximum, or boundary]
  When [action at boundary]
  Then [correct behavior at boundary]
```

### 4. Error Handling Scenario
Invalid inputs and error conditions.

```gherkin
@p0 @error_handling
Scenario: [Error condition]
  Given [invalid or problematic context]
  When [action that triggers error]
  Then [graceful error handling]
  And [helpful error message displayed]
  But [system remains stable]
```

### 5. Data-Driven Scenario (Scenario Outline)
Multiple test cases with different data.

```gherkin
@p1 @data_driven
Scenario Outline: [Parameterized test description]
  Given <initial_state>
  When <action>
  Then <outcome>

  Examples: [Category 1]
    | initial_state | action | outcome |
    | state1        | act1   | result1 |
    | state2        | act2   | result2 |

  Examples: [Category 2]
    | initial_state | action | outcome |
    | state3        | act3   | result3 |
```

### 6. Integration Scenario
Tests involving multiple systems or components.

```gherkin
@p1 @integration
Scenario: [Cross-system interaction]
  Given [setup in multiple systems]
  When [action triggers cascade]
  Then [outcomes across systems verified]
  And [data consistency maintained]
```

### 7. Security Scenario
Authentication, authorization, and security controls.

```gherkin
@p0 @security
Scenario: [Security requirement]
  Given [user with specific permissions]
  When [attempt sensitive action]
  Then [authorization enforced correctly]
```

### 8. Performance Scenario
Response time and load requirements.

```gherkin
@p2 @performance
Scenario: [Performance requirement]
  Given [specific load conditions]
  When [action performed]
  Then [response time within acceptable limit]
  And [system resources within bounds]
```

---

## Scenario Design Patterns

### Pattern 1: Equivalence Partitioning

Group inputs into valid and invalid classes:

```gherkin
@data_driven
Scenario Outline: Validate work hours input
  Given I am on the overtime calculator page
  When I enter <hours> as work hours
  Then the input should be <validity>
  And the system should <action>

  Examples: Valid inputs
    | hours | validity | action                    |
    | 0     | valid    | accept and enable submit  |
    | 40    | valid    | accept and enable submit  |
    | 80    | valid    | accept and enable submit  |
    | 168   | valid    | accept and enable submit  |

  Examples: Invalid inputs - Negative
    | hours | validity | action                                  |
    | -1    | invalid  | show error "工作時數不可為負數"         |
    | -100  | invalid  | show error "工作時數不可為負數"         |

  Examples: Invalid inputs - Non-numeric
    | hours | validity | action                                  |
    | abc   | invalid  | show error "請輸入有效數字"             |
    | 12.5x | invalid  | show error "請輸入有效數字"             |

  Examples: Invalid inputs - Unrealistic
    | hours  | validity | action                                 |
    | 169    | invalid  | show warning "超過每週最大時數168小時" |
    | 10000  | invalid  | show warning "請確認輸入是否正確"      |
```

### Pattern 2: Boundary Value Analysis

Test at, just below, and just above boundaries:

```gherkin
@edge_case @data_driven
Scenario Outline: Test overtime calculation boundaries
  Given an employee with base hourly rate of NT$200
  When the employee works <hours> hours
  Then the overtime calculation should use <rate_applied>
  And the overtime pay should be NT$<expected_pay>

  Examples: At and around 40-hour boundary (no overtime vs overtime)
    | hours | rate_applied           | expected_pay |
    | 39.5  | No overtime            | 0            |
    | 40.0  | No overtime            | 0            |
    | 40.5  | 0.5 hr at 1.34x        | 134          |

  Examples: At and around 42-hour boundary (1.34x vs 1.67x transition)
    | hours | rate_applied           | expected_pay |
    | 41.5  | 1.5 hr at 1.34x        | 402          |
    | 42.0  | 2.0 hr at 1.34x        | 536          |
    | 42.5  | 2 hr 1.34x + 0.5 1.67x | 703.5        |

  Examples: At and around monthly limit (46 hours)
    | hours | rate_applied | expected_pay |
    | 45.5  | Mixed rates  | 3040         |
    | 46.0  | Mixed rates  | 3206         |
    | 46.5  | Mixed rates  | 3373         |
```

### Pattern 3: State Transition Testing

Test transitions between states:

```gherkin
@p1 @state_transition
Scenario Outline: Leave request state transitions
  Given a leave request in "<initial_state>" state
  When the <actor> performs "<action>"
  Then the leave request should be in "<final_state>" state
  And the system should send notification to <notified_parties>

  Examples: Valid transitions
    | initial_state | actor      | action  | final_state | notified_parties    |
    | draft         | employee   | submit  | pending     | manager             |
    | pending       | manager    | approve | approved    | employee, HR        |
    | pending       | manager    | reject  | rejected    | employee            |
    | approved      | HR         | cancel  | cancelled   | employee, manager   |

  Examples: Invalid transitions (should fail)
    | initial_state | actor      | action  | final_state | notified_parties |
    | draft         | manager    | approve | draft       | none             |
    | rejected      | employee   | approve | rejected    | none             |
    | approved      | employee   | submit  | approved    | none             |
```

### Pattern 4: Decision Table Testing

Test all combinations of conditions:

```gherkin
@p1 @decision_table @data_driven
Scenario Outline: Determine overtime eligibility
  Given an employee with employment type "<emp_type>"
  And the employee has worked "<hours>" hours this week
  And today is a "<day_type>"
  When I check overtime eligibility
  Then overtime eligibility should be "<eligible>"
  And the reason should be "<reason>"

  Examples: Full-time employees
    | emp_type  | hours | day_type     | eligible | reason                     |
    | full_time | 35    | weekday      | no       | Below 40 hours             |
    | full_time | 40    | weekday      | no       | Exactly 40 hours           |
    | full_time | 45    | weekday      | yes      | Exceeds 40 hours           |
    | full_time | 8     | holiday      | yes      | Holiday work               |
    | full_time | 8     | rest_day     | yes      | Rest day work              |

  Examples: Part-time employees
    | emp_type  | hours | day_type     | eligible | reason                     |
    | part_time | 20    | weekday      | no       | Part-time, below threshold |
    | part_time | 8     | holiday      | yes      | Holiday work               |

  Examples: Contract employees
    | emp_type  | hours | day_type     | eligible | reason                     |
    | contract  | 50    | weekday      | no       | Contract terms apply       |
    | contract  | 8     | holiday      | no       | Contract terms apply       |
```

### Pattern 5: Error Recovery

Test system recovery from errors:

```gherkin
@p1 @error_recovery
Scenario: Recover from database connection failure
  Given the overtime calculation system is running
  And the database connection is unstable
  When I submit an overtime calculation
  And the database connection fails during save
  Then the system should retry 3 times with exponential backoff
  And if all retries fail, display error "暫時無法儲存，請稍後再試"
  And the user's input data should be preserved
  But no partial data should be saved to database

@p1 @error_recovery
Scenario: Recover from external service timeout
  Given I am calculating leave entitlement
  And the external payroll service is responding slowly
  When I request leave balance
  And the payroll service times out after 5 seconds
  Then the system should use cached data if available
  And display warning "使用暫存資料，可能不是最新"
  But still allow the user to proceed
```

---

## Legal Compliance Scenarios

Specific patterns for Taiwan Labor Law testing:

### Overtime Rate Scenarios

```gherkin
@legal_compliance @taiwan_labor_law @overtime_rates
Feature: Overtime Rate Calculation Compliance

  @p0 @data_driven
  Scenario Outline: Apply correct overtime rates per Labor Standards Act
    Given an employee with base hourly rate of NT$<base_rate>
    And the calculation follows Labor Standards Act Article 24
    When the employee works <total_hours> hours on a <work_type> day
    Then the overtime hours should be <overtime_hours>
    And the overtime should be calculated as:
      | hour_range    | hours         | rate  | subtotal           |
      | <range_1>     | <hours_1>     | <rate_1> | <subtotal_1>    |
      | <range_2>     | <hours_2>     | <rate_2> | <subtotal_2>    |
    And the total overtime pay should be NT$<total_pay>
    And the system should reference "<legal_reference>"

  Examples: Weekday overtime (1.34x and 1.67x rates)
    | base_rate | total_hours | work_type | overtime_hours | range_1          | hours_1 | rate_1 | subtotal_1 | range_2          | hours_2 | rate_2 | subtotal_2 | total_pay | legal_reference        |
    | 200       | 41          | weekday   | 1              | First 2 hours    | 1       | 1.34x  | 268        | -                | 0       | -      | 0          | 268       | 勞基法24條第1款        |
    | 200       | 42          | weekday   | 2              | First 2 hours    | 2       | 1.34x  | 536        | -                | 0       | -      | 0          | 536       | 勞基法24條第1款        |
    | 200       | 43          | weekday   | 3              | First 2 hours    | 2       | 1.34x  | 536        | Hours 3-4        | 1       | 1.67x  | 334        | 870       | 勞基法24條第1、2款     |
    | 200       | 44          | weekday   | 4              | First 2 hours    | 2       | 1.34x  | 536        | Hours 3-4        | 2       | 1.67x  | 668        | 1204      | 勞基法24條第1、2款     |
    | 250       | 42          | weekday   | 2              | First 2 hours    | 2       | 1.34x  | 670        | -                | 0       | -      | 0          | 670       | 勞基法24條第1款        |

  Examples: Holiday overtime (2.0x rate)
    | base_rate | total_hours | work_type | overtime_hours | range_1          | hours_1 | rate_1 | subtotal_1 | range_2 | hours_2 | rate_2 | subtotal_2 | total_pay | legal_reference        |
    | 200       | 8           | holiday   | 8              | Holiday work     | 8       | 2.0x   | 3200       | -       | 0       | -      | 0          | 3200      | 勞基法39條             |
    | 300       | 8           | holiday   | 8              | Holiday work     | 8       | 2.0x   | 4800       | -       | 0       | -      | 0          | 4800      | 勞基法39條             |

  Examples: Rest day overtime (special calculation)
    | base_rate | total_hours | work_type | overtime_hours | range_1          | hours_1 | rate_1 | subtotal_1 | range_2          | hours_2 | rate_2 | subtotal_2 | total_pay | legal_reference        |
    | 200       | 6           | rest_day  | 6              | First 2 hours    | 2       | 1.34x  | 536        | Hours 3-6        | 4       | 1.67x  | 1336       | 1872      | 勞基法24條第2款        |
```

### Legal Limit Scenarios

```gherkin
@legal_compliance @taiwan_labor_law @overtime_limits
Feature: Overtime Limit Compliance

  Background:
    Given the monthly overtime limit is 46 hours per Labor Standards Act Article 32

  @p0 @edge_case
  Scenario: Exactly at monthly overtime limit
    Given an employee has worked 46 overtime hours this month
    When I view the overtime summary
    Then the system should show total overtime as 46 hours
    And display status "已達每月加班上限"
    And show warning color indicator
    But still allow calculation for record-keeping

  @p0 @legal_limit @error_handling
  Scenario: Exceeding monthly overtime limit requires approval
    Given an employee has worked 44 overtime hours this month
    When I attempt to add 4 more overtime hours
    Then the total would be 48 hours
    And the system should display warning "將超過法定每月加班上限46小時"
    And require manager approval checkbox
    And show legal reference "勞動基準法第32條"
    And disable submit button until approval is checked

  @p1 @legal_limit @data_driven
  Scenario Outline: Overtime limit warnings at different thresholds
    Given an employee has worked <current_hours> overtime hours this month
    When I calculate <additional_hours> more overtime hours
    Then the system should show <warning_level> warning
    And display message "<warning_message>"

    Examples: Safe zone (no warning)
      | current_hours | additional_hours | warning_level | warning_message |
      | 0             | 10               | none          | -               |
      | 20            | 10               | none          | -               |
      | 30            | 8                | none          | -               |

    Examples: Approaching limit (info warning)
      | current_hours | additional_hours | warning_level | warning_message                  |
      | 38            | 4                | info          | 本月加班時數已達42小時，接近上限 |
      | 40            | 4                | info          | 本月加班時數已達44小時，接近上限 |

    Examples: At or exceeding limit (critical warning)
      | current_hours | additional_hours | warning_level | warning_message                      |
      | 44            | 2                | warning       | 已達每月加班上限46小時               |
      | 44            | 4                | critical      | 將超過法定每月加班上限，需主管核准   |
      | 46            | 2                | critical      | 已超過法定每月加班上限，需主管核准   |
```

### Leave Entitlement Scenarios

```gherkin
@legal_compliance @taiwan_labor_law @annual_leave
Feature: Annual Leave Calculation

  @p0 @data_driven
  Scenario Outline: Calculate annual leave days based on seniority
    Given an employee has worked for <years> years and <months> months
    When I calculate annual leave entitlement
    Then the employee should have <days> days of annual leave
    And the calculation should reference "勞動基準法第38條"

    Examples: 6 months to 1 year - 3 days
      | years | months | days |
      | 0     | 6      | 3    |
      | 0     | 9      | 3    |
      | 0     | 11     | 3    |

    Examples: 1-2 years - 7 days
      | years | months | days |
      | 1     | 0      | 7    |
      | 1     | 6      | 7    |

    Examples: 2-3 years - 10 days
      | years | months | days |
      | 2     | 0      | 10   |
      | 2     | 11     | 10   |

    Examples: 3-5 years - 14 days
      | years | months | days |
      | 3     | 0      | 14   |
      | 4     | 6      | 14   |

    Examples: 5+ years - increases by 1 day per year
      | years | months | days |
      | 5     | 0      | 15   |
      | 6     | 0      | 16   |
      | 10    | 0      | 20   |
      | 25    | 0      | 30   |
      | 30    | 0      | 30   |

  @p0 @edge_case
  Scenario: Maximum annual leave is 30 days
    Given an employee has worked for 35 years
    When I calculate annual leave entitlement
    Then the employee should have 30 days of annual leave
    And the system should note "已達年假上限"
    And reference "勞動基準法第38條"
```

---

## Scenario Anti-Patterns (What to Avoid)

### Bad: Testing implementation details
```gherkin
# DON'T DO THIS
Scenario: Save overtime to database
  Given I have overtime data
  When I call save_to_database() method
  Then the database table "overtime_records" should have a new row
  And the ORM should commit the transaction
```

### Good: Testing behavior
```gherkin
# DO THIS INSTEAD
Scenario: Record overtime for future reference
  Given an employee has worked 44 hours this week
  When I submit the overtime calculation
  Then the overtime record should be saved
  And I should be able to retrieve it later
  And the employee should see it in their history
```

### Bad: Multiple behaviors in one scenario
```gherkin
# DON'T DO THIS
Scenario: Complete overtime workflow
  Given I am logged in
  When I enter work hours and calculate overtime and save the record and generate a report
  Then everything should work
```

### Good: One behavior per scenario
```gherkin
# DO THIS INSTEAD
Scenario: Calculate overtime pay
  Given an employee with 44 work hours
  When I calculate overtime
  Then the overtime pay should be correct

Scenario: Save overtime record
  Given a calculated overtime result
  When I save the record
  Then it should be stored in the system

Scenario: Generate overtime report
  Given saved overtime records
  When I generate a report
  Then the report should include all records
```

---

## Complete Example

Input: `/bdd-scenario Test annual leave request with different employee tenures`

Output:

```gherkin
@leave_management @annual_leave @legal_compliance
Feature: Annual Leave Request Scenarios

  Background:
    Given the system follows Taiwan Labor Standards Act Article 38
    And today is "2024-02-04"
    And the company leave policy is configured

  @p0 @smoke @happy_path
  Scenario: Employee with 2 years tenure requests annual leave
    Given employee "李小華" has worked for exactly 2 years
    And "李小華" has 10 days of annual leave entitlement
    And "李小華" has not used any leave this year
    When "李小華" requests 5 days of annual leave from "2024-03-01" to "2024-03-05"
    Then the request should be submitted successfully
    And the remaining annual leave should be 5 days
    And the manager should receive notification
    And the leave request status should be "pending approval"

  @p1 @edge_case @data_driven
  Scenario Outline: Request leave at various tenure milestones
    Given employee "測試員工" has worked for <years> years and <months> months
    And the annual leave entitlement is <entitled_days> days
    When "測試員工" requests <requested_days> days of leave
    Then the request should be <result>
    And the remaining balance should be <remaining_days> days
    And the system should display "<message>"

    Examples: Valid requests within entitlement
      | years | months | entitled_days | requested_days | result   | remaining_days | message                          |
      | 0     | 6      | 3             | 3              | approved | 0              | 請假申請成功                     |
      | 1     | 0      | 7             | 5              | approved | 2              | 請假申請成功                     |
      | 2     | 0      | 10            | 8              | approved | 2              | 請假申請成功                     |
      | 5     | 0      | 15            | 15             | approved | 0              | 請假申請成功（已用完全年度假）   |

    Examples: Invalid requests exceeding entitlement
      | years | months | entitled_days | requested_days | result   | remaining_days | message                          |
      | 0     | 6      | 3             | 4              | rejected | 3              | 請假天數超過可用額度             |
      | 1     | 0      | 7             | 10             | rejected | 7              | 請假天數超過可用額度             |
      | 2     | 0      | 10            | 11             | rejected | 10             | 請假天數超過可用額度             |

  @p0 @edge_case
  Scenario: Employee with exactly 0 days remaining requests leave
    Given employee "張三" has 10 days of annual leave entitlement
    And "張三" has already used all 10 days
    When "張三" attempts to request 1 day of leave
    Then the request should be rejected
    And display error "年假額度已用完"
    And suggest using other leave types

  @p1 @error_handling
  Scenario: Request leave for dates in the past
    Given employee "王五" has 10 days of annual leave
    And today is "2024-02-04"
    When "王五" requests leave from "2024-01-01" to "2024-01-05"
    Then the system should reject the request
    And display error "無法申請過去日期的假期"

  @p1 @error_handling
  Scenario: Request overlapping leave periods
    Given employee "趙六" has pending leave from "2024-03-10" to "2024-03-15"
    When "趙六" requests another leave from "2024-03-12" to "2024-03-17"
    Then the system should reject the request
    And display error "請假日期與現有假期重疊"
    And show the conflicting leave period

  @p0 @business_rule
  Scenario: Leave request requires manager approval
    Given employee "劉七" is in the Engineering department
    And "劉七" reports to manager "林經理"
    When "劉七" submits a leave request for 3 days
    Then the request status should be "pending approval"
    And "林經理" should receive approval notification
    And "劉七" should not be able to modify the request
    But "劉七" can cancel the request

  @p1 @integration
  Scenario: Approved leave updates calendar and reduces balance
    Given employee "陳八" has 10 days of annual leave
    And "陳八" has requested 5 days from "2024-03-01" to "2024-03-05"
    When manager approves the leave request
    Then the leave status should change to "approved"
    And "陳八" should receive approval notification
    And the company calendar should show "陳八" on leave for those dates
    And "陳八"'s leave balance should be reduced to 5 days
    And an audit log entry should be created

  @p2 @performance
  Scenario: Calculate leave entitlement for all employees efficiently
    Given the company has 1000 employees with various tenures
    When the annual leave entitlement recalculation job runs
    Then all 1000 employees' leave balances should be updated
    And the job should complete within 30 seconds
    And all calculations should follow Labor Standards Act rates
    And a summary report should be generated

  @p1 @accessibility
  Scenario: Screen reader support for leave request form
    Given employee "盲眼使用者" is using a screen reader
    When "盲眼使用者" navigates to the leave request form
    Then all form fields should have proper labels
    And the screen reader should announce current leave balance
    And error messages should be announced immediately
    And the submit button state should be clearly announced
```

---

## Best Practices

1. **Scenario Independence**: Each scenario should run without depending on others
2. **Clear Naming**: Scenario name should describe expected behavior
3. **One Assertion**: Focus on testing one main behavior per scenario
4. **Use Tables**: Leverage Scenario Outline for multiple similar cases
5. **Tag Appropriately**: Use tags for filtering (@p0, @smoke, @legal_compliance)
6. **Concrete Data**: Use specific values, not vague descriptions
7. **User Perspective**: Write from user's viewpoint, not implementation
8. **Reusable Steps**: Write steps that can be shared across scenarios
9. **Legal References**: Always include legal citations for compliance scenarios
10. **Error Messages**: Verify actual error message text in Traditional Chinese

---

## Test Coverage Checklist

Ensure scenarios cover:

- [ ] Happy path (primary success scenario)
- [ ] Alternative paths (valid variations)
- [ ] Edge cases (boundaries: 0, max, just below, just at, just above)
- [ ] Error handling (invalid inputs, system errors)
- [ ] Legal compliance (calculations match law, references included)
- [ ] Security (authentication, authorization)
- [ ] Integration (cross-system interactions)
- [ ] Performance (response time requirements)
- [ ] Accessibility (screen reader, keyboard navigation)
- [ ] Data integrity (consistency, audit trails)
