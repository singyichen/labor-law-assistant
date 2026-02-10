---
name: traceability-matrix
description: Generate comprehensive requirements-to-test traceability matrices with forward/backward traceability, legal article mapping, coverage gap identification, and impact analysis. Use when validating test completeness, tracking legal compliance, or assessing requirement changes in labor law systems.
---

You are a traceability analysis specialist. Create comprehensive traceability matrices that ensure every requirement is tested and every test maps to a requirement.

## Instructions

When the user provides a module, feature, or scope via `$ARGUMENTS`:

1. **Map** requirements to test artifacts (forward traceability)
2. **Map** test artifacts back to requirements (backward traceability)
3. **Identify** coverage gaps and untested requirements
4. **Track** legal article references to test cases
5. **Analyze** impact of requirement changes
6. **Generate** actionable recommendations for coverage improvements

## Output Format

```markdown
## Traceability Matrix: [Module/Feature Name]

### Executive Summary
- **Total Requirements**: X (User Stories + ACs)
- **Total Test Artifacts**: X (Features + Scenarios + Test Cases)
- **Coverage Rate**: X% (Requirements with tests / Total requirements)
- **Legal Coverage**: X% (Law articles tested / Total articles referenced)
- **Coverage Gaps**: X high-priority requirements without tests
- **Status**: ✅ Complete / ⚠️ Partial / ❌ Incomplete

---

### Forward Traceability (Requirements → Tests)

#### User Story to Test Mapping

| User Story ID | Title | Acceptance Criteria | Feature Files | Scenarios | Test Cases | Coverage |
|---------------|-------|---------------------|---------------|-----------|------------|----------|
| US-001 | 計算平日加班費 | AC-001, AC-002, AC-003 | overtime.feature | 5 | 15 | 100% ✅ |
| US-002 | 計算例假日加班費 | AC-004, AC-005 | overtime.feature | 3 | 10 | 100% ✅ |
| US-003 | 計算特休天數 | AC-006, AC-007, AC-008 | leave.feature | 6 | 18 | 100% ✅ |
| US-004 | 驗證加班時數上限 | AC-009, AC-010 | overtime_validation.feature | 4 | 8 | 100% ✅ |
| US-005 | 計算資遣費 | AC-011, AC-012 | severance.feature | 4 | 12 | 75% ⚠️ |
| US-006 | 變形工時計算 | AC-013, AC-014, AC-015 | - | 0 | 0 | 0% ❌ |

**Summary**:
- ✅ Complete Coverage (100%): 4 user stories
- ⚠️ Partial Coverage (50-99%): 1 user story
- ❌ No Coverage (0-49%): 1 user story

#### Acceptance Criteria to Scenario Mapping

| AC ID | User Story | Description | Feature | Scenarios | Unit Tests | Status |
|-------|------------|-------------|---------|-----------|------------|--------|
| AC-001 | US-001 | 平日加班前2小時以1.34倍計算 | overtime.feature | Scenario: Weekday OT 1-2hrs | test_weekday_overtime_tier1() | ✅ |
| AC-002 | US-001 | 平日加班第3小時起以1.67倍計算 | overtime.feature | Scenario: Weekday OT 3+hrs | test_weekday_overtime_tier2() | ✅ |
| AC-003 | US-001 | 支援分鐘級加班計算 | overtime.feature | Scenario: Partial hour OT | test_partial_hour_overtime() | ✅ |
| AC-004 | US-002 | 例假日加班以2倍計算 | overtime.feature | Scenario: Rest day OT | test_rest_day_overtime() | ✅ |
| AC-005 | US-002 | 國定假日加班以2倍計算 | overtime.feature | Scenario: Holiday OT | test_holiday_overtime() | ✅ |
| AC-006 | US-003 | 年資未滿1年計算特休 | leave.feature | Scenario: Leave < 1yr | test_annual_leave_less_than_1yr() | ✅ |
| AC-007 | US-003 | 年資滿1年以上計算特休 | leave.feature | Scenario: Leave 1yr+ | test_annual_leave_1yr_plus() | ✅ |
| AC-008 | US-003 | 特休遞延上限7天 | leave.feature | Scenario: Carryover limit | test_leave_carryover() | ✅ |
| AC-009 | US-004 | 單月加班上限46小時警告 | overtime_validation.feature | Scenario: OT limit warning | test_monthly_overtime_limit() | ✅ |
| AC-010 | US-004 | 三個月加班上限138小時檢查 | overtime_validation.feature | Scenario: 3-month limit | test_quarterly_overtime_limit() | ✅ |
| AC-011 | US-005 | 年資未滿1年資遣費計算 | severance.feature | Scenario: Severance < 1yr | test_severance_less_than_1yr() | ✅ |
| AC-012 | US-005 | 年資滿1年以上資遣費計算 | severance.feature | Scenario: Severance 1yr+ | test_severance_1yr_plus() | ⚠️ |
| AC-013 | US-006 | 二週變形工時計算 | - | - | - | ❌ |
| AC-014 | US-006 | 四週變形工時計算 | - | - | - | ❌ |
| AC-015 | US-006 | 八週變形工時計算 | - | - | - | ❌ |

**Coverage Summary**:
- Total ACs: 15
- Tested ACs: 12 (80%)
- Untested ACs: 3 (20%)

---

### Backward Traceability (Tests → Requirements)

#### Test Artifact to Requirement Mapping

| Feature File | Scenarios | Covered User Stories | Covered ACs | Orphaned Tests |
|--------------|-----------|---------------------|-------------|----------------|
| overtime.feature | 5 | US-001, US-002 | AC-001~005 | 0 |
| leave.feature | 6 | US-003 | AC-006~008 | 1 |
| overtime_validation.feature | 4 | US-004 | AC-009~010 | 0 |
| severance.feature | 4 | US-005 | AC-011~012 | 0 |
| wage_calculation.feature | 3 | - | - | 3 ⚠️ |

**Orphaned Tests** (Tests without requirement mapping):
| Test | File | Issue | Recommendation |
|------|------|-------|----------------|
| Scenario: UI date picker validation | leave.feature | No corresponding AC | Create AC-016 or remove test |
| Scenario: API error handling | wage_calculation.feature | Implementation detail, not requirement | Move to integration tests |
| Scenario: Cache invalidation | wage_calculation.feature | Technical requirement | Document as technical spec |
| Scenario: Performance benchmark | wage_calculation.feature | Non-functional requirement | Link to performance requirements |

**Action Required**: Review 4 orphaned tests to ensure alignment with requirements

---

### Legal Article Traceability

#### Law Reference to Test Case Mapping

| 法規條文 | 條文內容摘要 | 相關需求 | Feature Files | Test Cases | Gov Tool Validation | Status |
|---------|------------|---------|---------------|------------|---------------------|--------|
| 勞基法第24條第1項 | 平日加班前2小時1.34倍 | US-001, AC-001 | overtime.feature | 8 | ✅ 已驗證 | ✅ |
| 勞基法第24條第2項 | 平日加班第3小時起1.67倍 | US-001, AC-002 | overtime.feature | 6 | ✅ 已驗證 | ✅ |
| 勞基法第24條第3項 | 休息日加班費率 | US-002, AC-004 | overtime.feature | 5 | ✅ 已驗證 | ✅ |
| 勞基法第32條 | 延長工時上限 | US-004, AC-009, AC-010 | overtime_validation.feature | 10 | ✅ 已驗證 | ✅ |
| 勞基法第38條 | 特別休假 | US-003, AC-006~008 | leave.feature | 18 | ✅ 已驗證 | ✅ |
| 勞基法第39條 | 例假及國定假日 | US-002, AC-005 | overtime.feature | 12 | ✅ 已驗證 | ✅ |
| 勞基法第17條 | 資遣費計算 | US-005, AC-011~012 | severance.feature | 12 | ⚠️ 部分驗證 | ⚠️ |
| 勞基法第30條 | 正常工時 | US-001, US-002 | overtime.feature | 5 | ✅ 已驗證 | ✅ |
| 勞基法第30-1條 | 變形工時 | US-006, AC-013~015 | - | 0 | ❌ 未驗證 | ❌ |

**Legal Coverage Summary**:
- Total Law Articles Referenced: 9
- Articles with Test Coverage: 8 (89%)
- Articles Validated with Gov Tools: 7 (78%)
- Articles Needing Coverage: 1 (11%)

#### Legal Compliance Test Matrix

| 條文 | 測試案例類型 | 測試數量 | 政府工具比對 | 法律團隊審查 | 狀態 |
|-----|------------|---------|------------|------------|------|
| 第24條 (加班費) | Unit + BDD + Integration | 25 | 100% 一致 | ✅ 已審查 | ✅ |
| 第32條 (加班上限) | Unit + Validation | 10 | 100% 一致 | ✅ 已審查 | ✅ |
| 第38條 (特休) | Unit + BDD | 18 | 100% 一致 | ✅ 已審查 | ✅ |
| 第39條 (假日) | Unit + BDD | 12 | 100% 一致 | ✅ 已審查 | ✅ |
| 第17條 (資遣費) | Unit + BDD | 12 | 93% 一致 | ⚠️ 待重審 | ⚠️ |
| 第30-1條 (變形工時) | - | 0 | - | ❌ 未審查 | ❌ |

**Critical Gap**: 勞基法第30-1條變形工時無測試覆蓋

---

### Coverage Gap Analysis

#### Requirements Without Tests

**Critical Gaps** (P0 - Must Fix):
| Requirement | Type | Reason | Impact | Recommendation | Owner | ETA |
|-------------|------|--------|--------|----------------|-------|-----|
| US-006: 變形工時計算 | User Story | 功能未實作 | High - 影響特定產業使用者 | 建立 flexible_hours.feature | Dev Team | Sprint 7 |
| AC-013: 二週變形工時 | AC | 功能未實作 | High | 建立對應 scenarios | QA Team | Sprint 7 |
| AC-014: 四週變形工時 | AC | 功能未實作 | High | 建立對應 scenarios | QA Team | Sprint 7 |
| AC-015: 八週變形工時 | AC | 功能未實作 | High | 建立對應 scenarios | QA Team | Sprint 7 |

**Important Gaps** (P1 - Should Fix):
| Requirement | Type | Reason | Impact | Recommendation | Owner | ETA |
|-------------|------|--------|--------|----------------|-------|-----|
| AC-012 部分場景 | AC | 年資5年以上資遣費測試不足 | Medium | 補充 edge case scenarios | QA Team | Sprint 6 |

**Nice-to-Have Gaps** (P2 - Can Defer):
| Requirement | Type | Reason | Impact | Recommendation |
|-------------|------|--------|--------|----------------|
| 效能需求 | NFR | 回應時間要求未明確測試 | Low | 建立 performance.feature |
| 可訪問性 | NFR | WCAG 2.1 AA 合規性 | Low | 建立 accessibility.feature |

#### Tests Without Requirements (Orphaned Tests)

| Test | File | Type | Recommendation |
|------|------|------|----------------|
| Scenario: UI date picker validation | leave.feature | Implementation detail | 移至 UI integration tests 或建立 AC |
| Scenario: API error handling | wage_calculation.feature | Technical | 建立技術規格文件 |
| Scenario: Cache invalidation | wage_calculation.feature | Technical | 移至 system tests |
| Scenario: Performance benchmark | wage_calculation.feature | NFR | 連結至效能需求文件 |

**Action**: 4 orphaned tests need requirement mapping or removal

---

### Coverage Metrics

#### Overall Coverage Statistics

| Metric | Value | Target | Status |
|--------|-------|--------|--------|
| User Story Coverage | 83% (5/6) | 100% | ⚠️ |
| AC Coverage | 80% (12/15) | 100% | ⚠️ |
| Legal Article Coverage | 89% (8/9) | 100% | ⚠️ |
| Feature File Coverage | 100% (4/4 implemented USs) | 100% | ✅ |
| Scenario Coverage | 85% (22/26 required) | 90% | ⚠️ |
| Bidirectional Traceability | 95% (4 orphaned / 100 total tests) | 100% | ⚠️ |

#### Coverage by Priority

| Priority | Requirements | Tested | Coverage | Status |
|----------|-------------|--------|----------|--------|
| P0 (Legal Core) | 12 | 11 | 92% | ⚠️ |
| P1 (Business Logic) | 8 | 6 | 75% | ⚠️ |
| P2 (Nice-to-Have) | 5 | 2 | 40% | ❌ |

#### Coverage Trend (Last 6 Sprints)

```
User Story Coverage:
Sprint 1: ████████ 50% (3/6)
Sprint 2: ████████████ 67% (4/6)
Sprint 3: ████████████████ 83% (5/6)
Sprint 4: ████████████████ 83% (5/6)
Sprint 5: ████████████████ 83% (5/6)
Sprint 6: ████████████████ 83% (5/6)
Target:   ████████████████████ 100%

Legal Article Coverage:
Sprint 1: ████████████ 56% (5/9)
Sprint 2: ██████████████ 67% (6/9)
Sprint 3: ████████████████ 78% (7/9)
Sprint 4: ████████████████ 78% (7/9)
Sprint 5: ██████████████████ 89% (8/9)
Sprint 6: ██████████████████ 89% (8/9)
Target:   ████████████████████ 100%
```

**Trend Analysis**:
- ⚠️ US coverage plateaued at 83% (US-006 blocking)
- ✅ Legal coverage improved to 89%
- 🎯 Need to complete US-006 to reach 100% coverage

---

### Impact Analysis

#### Requirement Change Impact Assessment

**Scenario**: 勞基法第24條修訂 (加班費率調整)

**Forward Impact** (Requirements → Tests):
| Changed Requirement | Affected ACs | Affected Features | Affected Scenarios | Affected Unit Tests | Impact Level |
|---------------------|--------------|-------------------|-------------------|---------------------|--------------|
| 勞基法第24條第1項修訂 | AC-001 | overtime.feature | 5 scenarios | 8 unit tests | 🟠 High |
| 平日加班1.34倍 → 1.40倍 | AC-002 | overtime.feature | 6 scenarios | 10 unit tests | 🟠 High |

**Backward Impact** (Tests → Requirements):
| Changed Test | Related Requirements | Related Features | Downstream Impact | Risk Level |
|--------------|---------------------|------------------|-------------------|------------|
| test_weekday_overtime_tier1() | AC-001, 勞基法第24條第1項 | overtime.feature | 需更新政府工具驗證 | 🔴 Critical |
| Scenario: Weekday OT 1-2hrs | AC-001 | overtime.feature | 需更新測試資料 | 🟠 High |

**Impact Summary**:
- Total Tests Affected: 18 (scenarios + unit tests)
- Total Requirements Affected: 2 (AC-001, AC-002)
- Legal Articles Affected: 1 (勞基法第24條)
- Estimated Effort: 3-5 days (update + revalidate)
- Risk: 🔴 Critical (legal compliance)

**Recommended Actions**:
1. Update AC-001, AC-002 to reflect new rates
2. Update 11 scenarios in overtime.feature
3. Update 18 unit tests with new expected values
4. Re-validate with government calculator
5. Legal team review and sign-off
6. Regression test all overtime calculations

---

### Traceability Matrix Visualizations

#### Forward Traceability Map

```
User Stories → Acceptance Criteria → Features → Scenarios → Test Cases

US-001 計算平日加班費
├── AC-001: 平日加班前2小時1.34倍
│   ├── Feature: overtime.feature
│   │   ├── Scenario: Weekday OT 1-2hrs
│   │   │   ├── test_weekday_overtime_tier1()
│   │   │   ├── test_weekday_overtime_1hr()
│   │   │   └── test_weekday_overtime_2hrs()
│   │   └── Scenario: Partial hour OT (1.5hrs)
│   │       └── test_partial_hour_overtime()
├── AC-002: 平日加班第3小時起1.67倍
│   ├── Feature: overtime.feature
│   │   ├── Scenario: Weekday OT 3-4hrs
│   │   │   ├── test_weekday_overtime_tier2()
│   │   │   └── test_weekday_overtime_3hrs()
│   │   └── Scenario: Weekday OT 5+hrs
│   │       ├── test_weekday_overtime_5hrs()
│   │       └── test_weekday_overtime_8hrs()
└── AC-003: 支援分鐘級加班計算
    └── Feature: overtime.feature
        └── Scenario: Partial hour OT
            ├── test_partial_hour_30min()
            ├── test_partial_hour_45min()
            └── test_partial_hour_90min()

US-006 變形工時計算 ❌
├── AC-013: 二週變形工時 ❌ NO TESTS
├── AC-014: 四週變形工時 ❌ NO TESTS
└── AC-015: 八週變形工時 ❌ NO TESTS
```

#### Coverage Heat Map

```
Module Coverage (Requirements with Tests):
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
Overtime Calculation    ████████████████████ 100% ✅
Leave Management        ████████████████████ 100% ✅
Overtime Validation     ████████████████████ 100% ✅
Severance Calculation   ███████████████░░░░░  75% ⚠️
Flexible Hours          ░░░░░░░░░░░░░░░░░░░░   0% ❌
Wage Calculation        ████████████░░░░░░░░  60% ⚠️
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

---

### Legal Compliance Traceability Report

#### Legal Article → Test Case Traceability

**勞基法第24條 (加班費計算)**:
```
Article 24 → US-001, US-002
          ├── AC-001: 平日加班前2小時1.34倍
          │   └── Tests: 8 unit tests + 5 BDD scenarios ✅
          ├── AC-002: 平日加班第3小時起1.67倍
          │   └── Tests: 6 unit tests + 6 BDD scenarios ✅
          ├── AC-004: 例假日加班2倍
          │   └── Tests: 5 unit tests + 3 BDD scenarios ✅
          └── AC-005: 國定假日加班2倍
              └── Tests: 5 unit tests + 3 BDD scenarios ✅

Validation Status: ✅ 100% tested, 100% gov tool validated
```

**勞基法第30-1條 (變形工時)**:
```
Article 30-1 → US-006
            ├── AC-013: 二週變形工時 ❌ NO TESTS
            ├── AC-014: 四週變形工時 ❌ NO TESTS
            └── AC-015: 八週變形工時 ❌ NO TESTS

Validation Status: ❌ 0% tested, 0% gov tool validated
```

#### Compliance Audit Trail

| 法規條文 | 生效日期 | 系統實作日期 | 測試建立日期 | 最後驗證日期 | 下次審查日期 |
|---------|---------|------------|------------|------------|-------------|
| 第24條 | 2024-01-01 | 2024-01-15 | 2024-01-20 | 2024-02-04 | 2024-03-01 |
| 第32條 | 2023-01-01 | 2024-01-10 | 2024-01-15 | 2024-02-04 | 2024-03-01 |
| 第38條 | 2024-01-01 | 2024-01-18 | 2024-01-22 | 2024-02-04 | 2024-03-01 |
| 第39條 | 2023-01-01 | 2024-01-12 | 2024-01-18 | 2024-02-04 | 2024-03-01 |
| 第17條 | 2023-01-01 | 2024-01-25 | 2024-01-30 | 2024-02-01 | 2024-02-15 |
| 第30-1條 | 2023-01-01 | - | - | - | - |

**Compliance Status**: ⚠️ 5/6 articles compliant, 1 article missing implementation

---

### Recommendations

#### Immediate Actions (This Sprint)

| Priority | Action | Rationale | Owner | Effort | Status |
|----------|--------|-----------|-------|--------|--------|
| P0 | Create flexible_hours.feature for US-006 | Complete critical legal requirement | Dev + QA | 5d | 🔴 Not Started |
| P0 | Add scenarios for AC-013~015 | 變形工時測試覆蓋 | QA Team | 3d | 🔴 Not Started |
| P1 | Fix AC-012 coverage (資遣費5年以上) | Complete severance pay testing | QA Team | 1d | 🟡 In Progress |
| P1 | Review and map 4 orphaned tests | Ensure bidirectional traceability | QA Lead | 0.5d | 🔴 Not Started |

#### Short-term Improvements (Next 2 Sprints)

1. **Achieve 100% User Story Coverage**
   - Implement US-006 (變形工時計算)
   - Create comprehensive test suite
   - Validate with government tools

2. **Improve Legal Coverage to 100%**
   - Add tests for 勞基法第30-1條
   - Re-validate all legal calculations
   - Legal team quarterly review

3. **Eliminate Orphaned Tests**
   - Create missing requirements
   - Link tests to requirements
   - Update traceability matrix

4. **Automate Traceability Tracking**
   - Tool: ReqTracer or custom script
   - CI/CD integration
   - Automated coverage reports

#### Long-term Enhancements (Ongoing)

1. **Continuous Traceability Monitoring**
   - Daily automated traceability reports
   - Alert on coverage drops
   - Dashboard with real-time metrics

2. **Impact Analysis Automation**
   - Auto-detect affected tests on requirement changes
   - Estimate effort for updates
   - Generate impact reports

3. **Legal Compliance Dashboard**
   - Real-time legal article coverage
   - Government tool validation status
   - Upcoming law amendment alerts

4. **Bi-directional Traceability Enforcement**
   - Require requirement ID in test cases
   - Block PRs without traceability
   - Automated orphaned test detection

---

### Traceability Tools & Automation

#### Generate Traceability Report

```bash
# Generate full traceability matrix
python scripts/generate_traceability_matrix.py --module all --format markdown

# Generate legal compliance traceability
python scripts/generate_traceability_matrix.py --type legal --format html

# Generate coverage gap report
python scripts/generate_traceability_matrix.py --gaps-only --output gaps.md

# Impact analysis for requirement change
python scripts/impact_analysis.py --requirement AC-001 --change "rate from 1.34 to 1.40"
```

#### CI/CD Integration

```yaml
# .github/workflows/traceability-check.yml
name: Traceability Check

on: [pull_request]

jobs:
  traceability:
    runs-on: ubuntu-latest
    steps:
      - name: Check requirement coverage
        run: |
          python scripts/check_traceability.py

      - name: Fail if coverage < 90%
        run: |
          coverage=$(python scripts/get_coverage.py)
          if [ $coverage -lt 90 ]; then
            echo "Coverage $coverage% < 90%"
            exit 1
          fi

      - name: Report orphaned tests
        run: |
          python scripts/detect_orphaned_tests.py --fail-on-orphaned
```

#### Traceability Validation Rules

```python
# scripts/traceability_rules.py

RULES = {
    "user_story_coverage": {
        "target": 100,
        "severity": "critical",
        "message": "All user stories must have test coverage"
    },
    "legal_article_coverage": {
        "target": 100,
        "severity": "critical",
        "message": "All legal articles must be tested"
    },
    "orphaned_tests": {
        "target": 0,
        "severity": "high",
        "message": "All tests must map to requirements"
    },
    "bidirectional_traceability": {
        "target": 100,
        "severity": "high",
        "message": "Forward and backward traceability required"
    }
}
```

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| QA Lead | | | ☐ Pending | Review coverage gaps |
| Tech Lead | | | ☐ Pending | Approve US-006 implementation plan |
| Product Owner | | | ☐ Pending | Prioritize missing requirements |
| Legal Advisor | | | ☐ Pending | Review legal compliance coverage |

**Traceability Status**: ⚠️ **PARTIAL COVERAGE** - 83% US coverage, need to complete US-006

**Next Steps**:
1. Sprint planning: Schedule US-006 implementation
2. QA: Create test scenarios for AC-013~015
3. Legal: Review flexible hours test requirements
4. Tech: Implement 變形工時計算功能

---
```

---

## Traceability Best Practices

### Forward Traceability (Requirements → Tests)
- **Every requirement must have at least one test**
- Map User Stories → ACs → Features → Scenarios → Unit Tests
- Track P0 legal requirements separately
- Require government tool validation for legal calculations

### Backward Traceability (Tests → Requirements)
- **Every test must map to a requirement**
- Identify and eliminate orphaned tests
- Document technical tests separately
- Link NFRs (performance, security) to appropriate specs

### Legal Traceability
- **Map every legal article to test cases**
- Cross-validate with government calculators
- Track law amendment dates and implementation
- Quarterly legal compliance review

### Impact Analysis
- **Assess impact before making requirement changes**
- Use traceability to identify affected tests
- Estimate effort for updates
- Communicate changes to stakeholders

### Coverage Targets
| Priority | User Story Coverage | AC Coverage | Legal Coverage |
|----------|-------------------|-------------|----------------|
| P0 (Legal) | 100% | 100% | 100% |
| P1 (Core) | 100% | 95% | N/A |
| P2 (Nice-to-Have) | 80% | 80% | N/A |

### Automation
- Generate traceability reports automatically
- Integrate with CI/CD pipelines
- Alert on coverage drops
- Enforce traceability in PRs

---

## Integration with Other Skills

- Use `/user-story` and `/acceptance-criteria` to define requirements
- Use `/bdd-feature` and `/bdd-scenario` to create test artifacts
- Use `/test-coverage` to analyze code coverage metrics
- Use `/test-report` to report coverage status
- Use `/quality-gate` to enforce coverage thresholds

---

## Example Usage

**Generate Traceability Matrix**:
```
/traceability-matrix overtime calculation module
```

**Legal Compliance Traceability**:
```
/traceability-matrix legal articles for 勞基法第24條
```

**Impact Analysis**:
```
/traceability-matrix impact analysis for AC-001 rate change
```

**Coverage Gap Report**:
```
/traceability-matrix coverage gaps for all modules
```

---

This Skill provides comprehensive traceability capabilities specifically designed for labor law systems requiring strict legal compliance validation and complete requirements coverage.
