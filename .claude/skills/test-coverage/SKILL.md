---
name: test-coverage
description: Generate test coverage analysis reports with coverage targets, gap identification, and improvement recommendations. Use when evaluating test completeness and identifying untested code paths, especially for legal calculation accuracy.
---

You are a test coverage specialist. Analyze test coverage to ensure comprehensive testing of all critical paths.

## Instructions

When the user provides a module or feature via `$ARGUMENTS`:

1. **Analyze** current test coverage metrics (line, branch, function)
2. **Identify** untested code paths and gaps
3. **Prioritize** coverage improvements based on criticality
4. **Define** coverage targets for different module types
5. **Generate** actionable recommendations

## Output Format

```markdown
## Test Coverage Report: [Module/Feature Name]

### Executive Summary
- **Overall Coverage**: X% (Target: Y%)
- **Status**: On Track / Needs Improvement / Critical
- **Critical Gaps**: [Number] high-priority untested paths
- **Recommendation**: [Brief action item]

---

### Coverage Metrics

#### Overall Coverage
| Metric | Current | Target | Status | Delta |
|--------|---------|--------|--------|-------|
| Line Coverage | X% | 80% | ✅/⚠️/❌ | +/- X% |
| Branch Coverage | X% | 75% | ✅/⚠️/❌ | +/- X% |
| Function Coverage | X% | 90% | ✅/⚠️/❌ | +/- X% |
| Integration Coverage | X% | 70% | ✅/⚠️/❌ | +/- X% |

#### Coverage by Module
| Module | Type | Line % | Branch % | Function % | Priority | Status |
|--------|------|--------|----------|------------|----------|--------|
| labor_law_calculator | Core | 95% | 92% | 100% | P0 | ✅ |
| overtime_validator | Core | 78% | 65% | 85% | P0 | ⚠️ |
| api_handlers | API | 82% | 70% | 88% | P1 | ✅ |
| data_models | Model | 70% | 60% | 75% | P1 | ⚠️ |
| utils | Utility | 65% | 55% | 70% | P2 | ❌ |

---

### Coverage Targets by Module Type

#### Legal Calculation Modules (P0 - Critical)
| Requirement | Target | Rationale |
|-------------|--------|-----------|
| Line Coverage | ≥ 95% | Legal accuracy is mission-critical |
| Branch Coverage | ≥ 90% | All calculation paths must be verified |
| Function Coverage | 100% | Every calculation function must be tested |
| Edge Case Coverage | 100% | All legal edge cases documented and tested |
| Integration Tests | ≥ 80% | Formula integration with real scenarios |

**Legal-Specific Coverage**:
- [ ] All formulas tested against official government calculators
- [ ] All legal article references validated with test cases
- [ ] All boundary conditions (e.g., max overtime hours) tested
- [ ] All exceptional cases (e.g., holidays, special rates) tested

#### Business Logic Modules (P0 - Critical)
| Requirement | Target | Rationale |
|-------------|--------|-----------|
| Line Coverage | ≥ 85% | Core business rules must be reliable |
| Branch Coverage | ≥ 80% | All decision paths tested |
| Function Coverage | ≥ 95% | Most functions should have tests |
| Integration Tests | ≥ 70% | Workflows tested end-to-end |

#### API/Controllers (P1 - Important)
| Requirement | Target | Rationale |
|-------------|--------|-----------|
| Line Coverage | ≥ 80% | Request handling must be reliable |
| Branch Coverage | ≥ 75% | Error paths covered |
| Function Coverage | ≥ 90% | All endpoints tested |
| Contract Tests | 100% | API contracts fully verified |

#### Data Models (P1 - Important)
| Requirement | Target | Rationale |
|-------------|--------|-----------|
| Line Coverage | ≥ 75% | Validation logic tested |
| Branch Coverage | ≥ 70% | Model methods covered |
| Property Tests | ≥ 50% | Schema validation automated |

#### Utilities/Helpers (P2 - Nice to have)
| Requirement | Target | Rationale |
|-------------|--------|-----------|
| Line Coverage | ≥ 70% | Common utilities tested |
| Branch Coverage | ≥ 65% | Error handling covered |
| Function Coverage | ≥ 80% | Public functions tested |

---

### Coverage Gaps

#### Critical Gaps (P0 - Must Fix)
| File/Module | Function/Path | Coverage | Risk | Impact | Test Required |
|-------------|---------------|----------|------|--------|---------------|
| overtime_calculator.py | calculate_holiday_overtime() | 0% | High | Legal miscalculation | Unit + Integration |
| leave_validator.py | validate_annual_leave_edge_case() | 45% | High | Incorrect entitlement | Unit + Edge cases |
| wage_processor.py | apply_special_industry_rules() | 30% | Medium | Wrong wage calculation | Unit + Scenario |

**Legal Accuracy Risks**:
- ⚠️ Untested formulas may produce incorrect legal calculations
- ⚠️ Missing edge case tests for boundary conditions
- ⚠️ No regression tests for recent law amendments

#### Important Gaps (P1 - Should Fix)
| File/Module | Function/Path | Coverage | Reason | Recommendation |
|-------------|---------------|----------|--------|----------------|
| api/resources.py | error_handling_paths | 60% | Missing error scenarios | Add negative test cases |
| validators/input.py | edge_case_validation | 55% | Limited boundary tests | Add property-based tests |

#### Nice-to-Have Gaps (P2 - Can Defer)
| File/Module | Function/Path | Coverage | Priority |
|-------------|---------------|----------|----------|
| utils/formatters.py | date_formatting_edge_cases | 65% | Low |
| helpers/logging.py | log_rotation_paths | 50% | Low |

---

### Untested Code Paths

#### By Risk Level

**Critical Paths (Must Test)**:
```python
# Example: Untested branch in overtime calculation
def calculate_overtime_pay(hours: float, base_rate: float) -> float:
    if hours <= 40:
        return 0.0

    overtime = hours - 40

    # UNTESTED: Holiday overtime branch
    if is_holiday():  # ❌ No test coverage
        return overtime * base_rate * 2.0

    # TESTED: Regular overtime
    if overtime <= 2:
        return overtime * base_rate * 1.34
    else:
        return (2 * base_rate * 1.34) + ((overtime - 2) * base_rate * 1.67)
```

**Missing Test Scenarios**:
- ❌ Overtime on national holidays
- ❌ Overtime exceeding legal monthly limit (46 hours)
- ❌ Partial hour overtime (e.g., 1.5 hours)
- ❌ Negative hours input (error handling)
- ❌ Zero base rate (edge case)

**High Risk Paths (Should Test)**:
```python
# Example: Partially tested validation
def validate_leave_request(employee_id: str, days: int) -> bool:
    # TESTED
    if days <= 0:
        raise ValueError("Days must be positive")

    # UNTESTED: Seniority calculation branch
    seniority = get_employee_seniority(employee_id)  # ❌ Mock not set up
    max_days = calculate_max_annual_leave(seniority)  # ❌ No test coverage

    return days <= max_days
```

---

### BDD Scenario Coverage

#### Feature Coverage Matrix
| Feature | Scenarios Defined | Scenarios Tested | Scenarios Passing | Coverage |
|---------|-------------------|------------------|-------------------|----------|
| Overtime Calculation | 12 | 10 | 9 | 75% |
| Leave Management | 8 | 8 | 7 | 88% |
| Wage Calculation | 15 | 12 | 11 | 73% |
| Compliance Validation | 6 | 4 | 4 | 67% |

#### Missing BDD Scenarios
| Feature | Missing Scenario | Priority | Example |
|---------|------------------|----------|---------|
| Overtime Calculation | Holiday overtime with special rates | P0 | "Given employee works 8 hours on Labor Day, Then overtime pay should be 2x base rate" |
| Leave Management | Unused leave carryover rules | P0 | "Given employee has 5 unused annual leave days, When year ends, Then max 7 days can carry over" |
| Wage Calculation | Pro-rated salary for partial month | P1 | "Given employee starts on 15th, Then salary should be pro-rated for 16 days" |

#### Scenario Quality Metrics
| Metric | Count | Target | Status |
|--------|-------|--------|--------|
| Total Scenarios | 45 | 50+ | ⚠️ |
| Scenarios with Examples | 30 | 40+ | ⚠️ |
| Scenarios Automated | 38 | 45+ | ❌ |
| Scenarios Documented | 45 | 45 | ✅ |

---

### Coverage Trends

#### Historical Coverage
```
Last 6 Sprints Coverage Trend:

Overall Coverage:
Sprint 1: ████████████ 72%
Sprint 2: ██████████████ 75%
Sprint 3: ████████████████ 78%
Sprint 4: ████████████████ 78% (stagnant)
Sprint 5: ██████████████████ 80%
Sprint 6: ██████████████████ 80% (target met ✅)

Legal Module Coverage (Target: 95%):
Sprint 1: ████████████████████ 88%
Sprint 2: ██████████████████████ 90%
Sprint 3: ████████████████████████ 92%
Sprint 4: ██████████████████████████ 94%
Sprint 5: ███████████████████████████ 95% (target met ✅)
Sprint 6: ███████████████████████████ 95%
```

#### Coverage Velocity
| Period | Coverage Gain | New Code Added | Net Progress |
|--------|---------------|----------------|--------------|
| Sprint 4 → 5 | +2% | 250 lines | +1.2% |
| Sprint 5 → 6 | +0% | 180 lines | -0.5% |
| **Trend** | Slowing | Increasing | **Declining** ⚠️ |

**Analysis**:
- ⚠️ Coverage growth is slowing while new code is increasing
- ⚠️ Need to write tests before adding new features
- ✅ Legal module coverage maintained at target level

---

### Recommendations

#### Immediate Actions (This Sprint)
| Priority | Action | Owner | Effort | Impact | Status |
|----------|--------|-------|--------|--------|--------|
| P0 | Add tests for `calculate_holiday_overtime()` | QA Team | 2 days | High | 🔴 Not Started |
| P0 | Complete edge case tests for leave validation | Dev Team | 1 day | High | 🟡 In Progress |
| P0 | Add regression tests for Law Amendment 2024-Q1 | QA Lead | 3 days | Critical | 🔴 Not Started |
| P1 | Implement property-based tests for calculators | Dev Lead | 2 days | Medium | 🔴 Not Started |

#### Short-term (Next 2 Sprints)
1. **Achieve 90% branch coverage for legal modules**
   - Focus: `overtime_calculator`, `leave_entitlement`, `wage_processor`
   - Add: Boundary tests, error handling, special cases

2. **Automate remaining BDD scenarios**
   - Gap: 7 scenarios not yet automated
   - Priority: Holiday calculations, pro-rated wages

3. **Implement mutation testing for critical paths**
   - Tool: `mutmut` for Python
   - Target: Legal calculation functions (100% mutation score)

4. **Add integration tests for API error paths**
   - Current: 60% error path coverage
   - Target: 85% error path coverage

#### Long-term (Ongoing)
1. **Establish coverage ratcheting**
   - Prevent coverage decrease on each PR
   - Require +0.5% coverage for new features

2. **Implement differential coverage checks**
   - Require 90% coverage for all new code
   - Block PR if new code reduces overall coverage

3. **Add legal compliance test suite**
   - Cross-validate against government calculators
   - Quarterly review against law amendments
   - Automated comparison tests

4. **Create coverage dashboard**
   - Real-time coverage metrics
   - Per-developer coverage contribution
   - Coverage heat map visualization

---

### Test Quality Indicators

#### Test Effectiveness
| Indicator | Value | Target | Status |
|-----------|-------|--------|--------|
| Tests Passing | 245/250 | 100% | ⚠️ |
| Test Flakiness Rate | 2% | < 1% | ⚠️ |
| Average Test Execution Time | 3.2s | < 5s | ✅ |
| Mutation Score (Legal Module) | 88% | ≥ 90% | ⚠️ |
| Code Churn vs Test Churn | 1:0.6 | 1:0.8 | ❌ |

**Flaky Tests** (Need Investigation):
- `test_overtime_calculation_with_timezone` (intermittent failure)
- `test_concurrent_leave_requests` (race condition)

#### Test Maintenance Burden
| Metric | Value | Trend |
|--------|-------|-------|
| Tests per KLOC | 15 | ↗️ Increasing |
| Test Code Lines | 12,450 | ↗️ Increasing |
| Production Code Lines | 8,300 | ↗️ Increasing |
| Test to Code Ratio | 1.5:1 | ➡️ Stable |

---

### Coverage Tools & Commands

#### Generate Coverage Report
```bash
# Run tests with coverage
pytest --cov=labor_law_assistant --cov-report=html --cov-report=term-missing

# Coverage by module
pytest --cov=labor_law_assistant.calculators --cov-report=term

# Generate XML report for CI/CD
pytest --cov=labor_law_assistant --cov-report=xml

# Branch coverage
pytest --cov=labor_law_assistant --cov-branch --cov-report=html
```

#### Coverage Thresholds (CI/CD)
```bash
# Fail build if coverage below threshold
pytest --cov=labor_law_assistant --cov-fail-under=80

# Differential coverage (only new/changed code)
diff-cover coverage.xml --compare-branch=main --fail-under=90
```

#### Mutation Testing
```bash
# Run mutation tests on critical modules
mutmut run --paths-to-mutate=labor_law_assistant/calculators/

# Show mutation coverage
mutmut results

# Apply surviving mutants (find weak tests)
mutmut show --suspicious
```

#### BDD Coverage
```bash
# Run BDD scenarios with coverage
behave --format json.pretty --outfile=reports/behave.json

# Check scenario coverage vs features
python scripts/check_scenario_coverage.py
```

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| QA Lead | | | Pending | Review gap analysis |
| Tech Lead | | | Pending | Approve recommendations |
| Product Owner | | | Pending | Prioritize legal module tests |
```

---

## Coverage Calculation

### Line Coverage
```
Line Coverage % = (Lines Executed / Total Executable Lines) × 100
```

### Branch Coverage
```
Branch Coverage % = (Branches Executed / Total Branches) × 100
```

### Function Coverage
```
Function Coverage % = (Functions Called / Total Functions) × 100
```

### Mutation Score
```
Mutation Score % = (Killed Mutants / Total Mutants) × 100
```

---

## Priority Guidelines

| Priority | Coverage Target | Test Types Required | Review Required |
|----------|----------------|---------------------|-----------------|
| P0 (Legal) | ≥ 95% line, 90% branch | Unit + Integration + BDD + Mutation | Mandatory |
| P0 (Core) | ≥ 85% line, 80% branch | Unit + Integration | Mandatory |
| P1 (API) | ≥ 80% line, 75% branch | Unit + Contract | Recommended |
| P2 (Utils) | ≥ 70% line, 65% branch | Unit | Optional |

---

## Best Practices

- **Legal modules require 95%+ coverage** due to compliance requirements
- Focus on **branch coverage** not just line coverage
- Use **mutation testing** for critical calculation logic
- Track **coverage trends** over time, not just snapshots
- Require **differential coverage** on all PRs
- **BDD scenarios** should cover all happy paths and major edge cases
- Set up **coverage ratcheting** to prevent degradation
- **Untested code** in legal modules is a critical risk

---

## Example Usage

Input: `/test-coverage overtime calculation module`

Output: [Full report as shown above with actual metrics for overtime calculation module]
