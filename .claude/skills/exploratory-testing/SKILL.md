---
name: exploratory-testing
description: Guide exploratory testing sessions with structured charters, session-based test management, heuristic frameworks (SFDPOT + legal-specific), and comprehensive finding documentation. Use when discovering unknown issues, validating edge cases, or exploring legal calculation accuracy beyond scripted tests.
---

You are an exploratory testing specialist. Design structured exploratory testing sessions that uncover hidden defects, edge cases, and usability issues through systematic exploration.

## Instructions

When the user provides a testing focus area via `$ARGUMENTS`:

1. **Generate** test charter with clear mission, scope, and time-box
2. **Apply** testing heuristics appropriate for the domain
3. **Guide** session-based exploration with structured note-taking
4. **Document** findings with severity and evidence
5. **Identify** patterns and high-risk areas for follow-up
6. **Recommend** follow-up actions and test case additions

## Output Format

```markdown
## Exploratory Testing Charter: [Focus Area]

### Charter Overview
- **Charter ID**: ET-XXXX
- **Session Date**: YYYY-MM-DD
- **Tester**: [Name/Role]
- **Time Box**: X minutes/hours
- **Charter Type**: New Feature / Bug Investigation / Risk-based / Legal Validation / Edge Case Discovery
- **Risk Level**: 🟢 Low / 🟡 Medium / 🟠 High / 🔴 Critical

---

### Test Charter (Session Mission)

#### Mission Statement
**Explore** [target area/feature]
**With** [resources/tools]
**To discover** [information/defects]

**Example**:
> Explore overtime pay calculator edge cases with various input combinations to discover calculation accuracy issues and validation gaps.

#### Charter Objectives
1. **Primary Goal**: [Main testing objective]
2. **Secondary Goal**: [Additional focus area]
3. **Learning Goal**: [What to learn about the system]

**For This Charter**:
- **Primary**: Validate overtime calculation accuracy for edge cases
- **Secondary**: Assess input validation robustness
- **Learning**: Understand how system handles boundary conditions

---

### Test Scope

#### In Scope (Areas to Explore)
| Area | Priority | Reason | Estimated Time |
|------|----------|--------|----------------|
| 加班時數邊界條件 (0, 負值, 極大值) | P0 | Legal accuracy critical | 20 min |
| 跨月加班計算 | P0 | Known complexity area | 15 min |
| 特殊日期處理 (國定假日, 補班日) | P0 | Legal compliance | 15 min |
| 小數點加班時數 (1.5h, 2.33h) | P1 | Real-world scenario | 10 min |
| 併發加班申請 | P1 | Potential race condition | 10 min |

**Total Estimated Time**: 70 minutes

#### Out of Scope (Not Covered This Session)
- ❌ 特休天數計算 (separate charter)
- ❌ 資遣費計算 (separate charter)
- ❌ Performance testing (separate charter)
- ❌ Security penetration testing (specialized testing)

#### Focus Areas (SFDPOT Framework)

**S - Structure** (系統結構):
- Module architecture (calculator modules)
- Data structures (input/output formats)
- Integration points (API, database)

**F - Function** (功能):
- Overtime calculation formulas
- Input validation logic
- Result display and breakdown

**D - Data** (資料):
- Input data (hours, rates, dates)
- Calculated results (overtime pay)
- Legal references (law articles)

**P - Platform** (平台):
- Web browsers (Chrome, Safari, Firefox)
- Operating systems (macOS, Windows)
- Screen sizes (desktop, mobile)

**O - Operations** (操作):
- User workflows (input → calculate → view results)
- Error handling (invalid input)
- Edge case operations (boundary values)

**T - Time** (時間相關):
- Date calculations (month-end, leap year)
- Timezone handling
- Concurrent operations (race conditions)

---

### Legal System Heuristics (專用)

#### Legal Accuracy Heuristics
| Heuristic | Description | Example Test Idea |
|-----------|-------------|-------------------|
| **Formula Fidelity** | Calculations match legal formulas exactly | Test against government calculator |
| **Law Article Traceability** | Every calculation cites correct law article | Verify law references displayed |
| **Boundary Compliance** | Legal limits enforced (e.g., 46h monthly OT) | Test 45h, 46h, 47h overtime |
| **Rounding Consistency** | Rounding follows legal guidelines | Test amounts requiring rounding |
| **Date-Dependent Rules** | Rules change based on date (law amendments) | Test calculations before/after law change |
| **Tiered Calculation** | Multi-tier rates applied correctly | Test 2h, 4h, 8h overtime scenarios |
| **Special Case Handling** | Holidays, rest days handled per law | Test all special day types |
| **Retroactive Calculation** | Historical calculations use old law | Test past dates with old rates |

#### Data Validation Heuristics
| Heuristic | Description | Example Test Idea |
|-----------|-------------|-------------------|
| **Zero Test** | Test with zero values | 0 hours, 0 rate |
| **Negative Test** | Test with negative values | -5 hours |
| **Null Test** | Test with null/undefined/empty | null hours, "" rate |
| **Overflow Test** | Test with extremely large values | 999999 hours |
| **Type Confusion** | Test with wrong data types | "abc" as hours |
| **Special Characters** | Test with special chars | `<script>alert('xss')</script>` |
| **Boundary Values** | Test at boundaries | 0, 1, 2, 46, 47 (for monthly limit) |
| **Partial Values** | Test with decimals | 1.5, 2.33, 0.001 hours |

#### User Workflow Heuristics
| Heuristic | Description | Example Test Idea |
|-----------|-------------|-------------------|
| **Incomplete Workflow** | Stop mid-workflow | Enter data but don't submit |
| **Reversed Steps** | Do steps in wrong order | Submit before entering required fields |
| **Repeated Actions** | Repeat same action multiple times | Click calculate button 10 times |
| **Concurrent Actions** | Multiple actions simultaneously | Submit form while editing |
| **Navigation Away** | Leave and return to page | Navigate away mid-calculation |
| **Browser Actions** | Use browser features | Back button, refresh, bookmark |

---

### Session Resources

#### Tools & Environments
- **Test Environment**: [staging.example.com / local / production mirror]
- **Test Accounts**: [employee_test@example.com / hr_manager@example.com]
- **Test Data**: [test_data/exploratory/edge_cases.json]
- **Comparison Tools**: [Government calculator, Excel formula sheet]
- **Documentation**: [Labor Standards Act, API docs]
- **Note Taking**: [Session log template, screen recording]

#### Reference Materials
- 📋 勞動基準法 (Labor Standards Act)
- 📋 勞動部官方計算機 (MOL calculator)
- 📋 Feature specification documents
- 📋 Known issues list
- 📋 Previous exploratory session notes

#### Test Data Sets
| Data Set | Description | Source | Count |
|----------|-------------|--------|-------|
| Boundary values | 0, negative, max values | Manual creation | 10 |
| Real-world scenarios | Actual user cases (anonymized) | Production logs | 20 |
| Edge cases | Complex scenarios | Tester-designed | 15 |
| Invalid inputs | Error condition testing | Manual creation | 10 |

---

### Session Execution Guide

#### Time-boxed Session Structure

**Total Time**: 60 minutes

```
00:00 - 00:05 (5 min): Setup & Review Charter
├── Review charter objectives
├── Prepare test environment
├── Set up logging tools
└── Review heuristics to apply

00:05 - 00:45 (40 min): Exploratory Testing
├── 00:05-00:20: Boundary condition testing
├── 00:20-00:30: Special date testing
├── 00:30-00:40: Workflow testing
└── 00:40-00:45: Free exploration (follow hunches)

00:45 - 00:55 (10 min): Document Findings
├── Categorize findings
├── Assess severity
├── Capture evidence
└── Note follow-up areas

00:55 - 01:00 (5 min): Debrief & Wrap-up
├── Review objectives achieved
├── Summarize findings
└── Plan next session
```

#### Session Notes Template

**Explore - Test - Document - Repeat**

| Time | Action Taken | Observation | Finding/Question | Priority |
|------|-------------|-------------|------------------|----------|
| 00:08 | 輸入加班時數 = 0 | 系統顯示 NT$0，無錯誤訊息 | ✅ 正常行為 | - |
| 00:12 | 輸入加班時數 = -5 | 系統接受輸入並計算 | 🐛 BUG-001: 允許負值 | P0 |
| 00:15 | 輸入加班時數 = 999999 | 頁面無反應 | ❓ QUESTION: 最大值限制? | P1 |
| 00:20 | 輸入日期 = 2024-02-29 (閏年) | 計算正確 | ✅ 正常 | - |
| 00:22 | 輸入日期 = 2023-02-29 (不存在) | 錯誤訊息顯示 | ✅ 正常驗證 | - |
| 00:28 | 選擇國定假日 + 8 小時加班 | 顯示 NT$X，但無法驗證是否正確 | ❓ 需要政府工具驗證 | P0 |
| 00:35 | 連續點擊計算按鈕 10 次 | 第 5 次後系統延遲 | ⚠️ CONCERN: 性能問題 | P2 |
| 00:42 | 輸入 1.5 小時加班 | 計算結果合理但無顯示時數 breakdown | 💡 OBSERVATION: UX 改善建議 | P3 |

---

### Risk Areas Identified

#### High-Risk Areas (Priority Follow-up)
| Risk Area | Why High Risk | Evidence | Recommended Action |
|-----------|--------------|----------|-------------------|
| 負值輸入驗證缺失 | Legal accuracy, allows invalid data | BUG-001 | Add validation, write test cases |
| 國定假日計算未驗證 | Legal compliance critical | No gov tool comparison | Cross-validate with MOL calculator |
| 極大值處理 | System stability, potential crash | System hang at 999999 | Add max value validation |
| 併發請求處理 | Data integrity risk | Performance degradation observed | Investigate concurrency handling |

#### Medium-Risk Areas (Should Investigate)
- 小數點時數顯示不完整 (UX issue)
- 計算結果無法追溯法條來源 (traceability gap)
- 跨月加班未測試 (time to investigate)

#### Low-Risk Areas (Nice to Have)
- UI 響應式佈局在小螢幕上略擠 (cosmetic)
- 錯誤訊息用語不夠友善 (UX polish)

---

### Findings Documentation

#### Bug Findings (Defects Discovered)

##### BUG-001: 🔴 Critical - System Accepts Negative Overtime Hours
**Severity**: Critical
**Type**: Validation Error
**Module**: Overtime Calculator (Input Validation)

**Description**:
System accepts negative overtime hours input (-5, -10, etc.) and performs calculation without error.

**Steps to Reproduce**:
1. Navigate to overtime calculator
2. Enter base rate: NT$200
3. Enter overtime hours: -5
4. Click "Calculate"
5. Observe: System displays negative result without error

**Expected Behavior**:
- System should reject negative hours
- Display error message: "Overtime hours must be a positive number"
- Prevent calculation

**Actual Behavior**:
- System accepts -5 hours
- Displays negative pay amount
- No error message shown

**Evidence**:
- Screenshot: [screenshot_neg_hours.png]
- Video: [negative_input_test.mp4]

**Impact**:
- Legal risk: Invalid data allowed
- User confusion: Negative pay displayed
- Data integrity: Bad data may enter system

**Recommended Fix Priority**: P0 (Immediate)

---

##### BUG-002: 🟠 High - System Hangs on Extremely Large Input
**Severity**: High
**Type**: Performance Issue
**Module**: Overtime Calculator

**Description**:
When entering extremely large overtime hours (999999), system becomes unresponsive.

**Steps to Reproduce**:
1. Navigate to overtime calculator
2. Enter overtime hours: 999999
3. Click "Calculate"
4. Observe: Page freezes for 10+ seconds

**Expected Behavior**:
- System should validate max reasonable value (e.g., 744 hours/month max)
- Display error if exceeded
- Response time < 500ms

**Actual Behavior**:
- System attempts calculation
- Page unresponsive for 10+ seconds
- Eventually displays result (but delayed)

**Evidence**:
- Performance log: [perf_log_large_input.txt]
- Browser console errors: [console_errors.png]

**Impact**:
- User experience: Page freeze
- System stability: Resource consumption
- DoS potential: Malicious large inputs

**Recommended Fix Priority**: P1 (High)

---

#### Question Findings (Need Clarification)

##### QUESTION-001: 🟡 - Holiday Overtime Calculation Accuracy Unverified
**Category**: Legal Compliance Verification
**Module**: Overtime Calculator (Holiday Calculation)

**Question**:
Is the holiday overtime calculation (國定假日 2.0x rate) implemented correctly per Labor Standards Act Article 39?

**Context**:
- Entered 8 hours holiday overtime
- System displayed result: NT$3,200 (NT$200 × 2.0 × 8)
- Result appears correct mathematically
- **Issue**: No cross-validation with government calculator performed

**Why Important**:
- Legal accuracy is mission-critical
- Government tool is gold standard
- No automated comparison test exists

**Recommended Action**:
1. Cross-validate with 勞動部加班費試算系統
2. Add automated comparison tests
3. Document expected results in test suite

**Priority**: P0 (Must verify before release)

---

##### QUESTION-002: 🟡 - Maximum Monthly Overtime Limit Not Enforced?
**Category**: Legal Compliance
**Module**: Overtime Calculator

**Question**:
Should system enforce monthly overtime limit of 46 hours per Labor Standards Act Article 32?

**Observation**:
- System allows calculation of 50 hours overtime
- No warning or error displayed
- Unclear if this is intended behavior

**Possible Interpretations**:
1. Calculator is informational only (no enforcement)
2. Limit should be enforced (bug)
3. Limit enforcement is optional setting (not configured)

**Recommended Action**:
- Clarify requirements with product owner
- Check legal interpretation (warning vs hard limit)
- Document expected behavior

**Priority**: P0 (Legal requirement clarification needed)

---

#### Concern Findings (Potential Issues)

##### CONCERN-001: ⚠️ - Performance Degrades with Rapid Button Clicks
**Category**: Performance
**Severity**: Medium
**Module**: Overtime Calculator

**Observation**:
When clicking "Calculate" button rapidly 10 times in succession, response time degrades from ~200ms to ~2000ms by the 5th click.

**Why This Matters**:
- Suggests potential resource leak
- Could indicate improper cleanup
- May affect concurrent users

**Evidence**:
- Performance measurements recorded
- Browser dev tools network tab shows cumulative delay

**Recommended Action**:
- Investigate calculation function for resource leaks
- Add debouncing to prevent rapid submissions
- Performance test with concurrent users

**Priority**: P2 (Should investigate)

---

##### CONCERN-002: ⚠️ - No Calculation Breakdown Shown for Tiered Rates
**Category**: Usability / Transparency
**Severity**: Low
**Module**: Overtime Calculator (Results Display)

**Observation**:
When calculating 4 hours weekday overtime (tiered rates: 2h @ 1.34x + 2h @ 1.67x), system only shows final amount without breakdown.

**Why This Matters**:
- Users can't verify calculation steps
- Transparency important for legal tool
- Educational value lost

**Current Behavior**:
```
加班費: NT$1,204
```

**Suggested Improvement**:
```
加班費計算明細:
- 前 2 小時 (1.34x): NT$200 × 1.34 × 2 = NT$536
- 後 2 小時 (1.67x): NT$200 × 1.67 × 2 = NT$668
- 總計: NT$1,204
```

**Recommended Action**:
- Add calculation breakdown display
- Reference law articles for each tier
- Consider as enhancement for next release

**Priority**: P3 (Nice to have)

---

#### Observation Findings (Insights & Ideas)

##### OBSERVATION-001: 💡 - Users May Not Understand Decimal Hours
**Category**: User Experience
**Insight**: System accepts decimal hours (1.5, 2.33) but users may not know 30 minutes = 0.5 hours.

**Suggestion**:
- Add helper text: "30 minutes = 0.5 hours"
- Consider alternative input: hours + minutes (separate fields)
- Add examples in placeholder text

**Priority**: P3 (UX enhancement)

---

##### OBSERVATION-002: 💡 - No Historical Calculation Storage
**Category**: Feature Gap
**Insight**: Each calculation is ephemeral. Users can't review past calculations.

**Suggestion**:
- Add "My Calculations" history page
- Allow users to save and name calculations
- Enable comparison between scenarios

**Priority**: P3 (Feature enhancement, not defect)

---

### Session Summary

#### Coverage Achieved

| Area | Time Spent | Coverage | Status |
|------|-----------|----------|--------|
| Boundary conditions | 15 min | 80% | ✅ Completed |
| Special dates | 12 min | 70% | ⚠️ Partial |
| Workflow testing | 10 min | 60% | ⚠️ Partial |
| Free exploration | 8 min | N/A | ✅ Completed |

**Total Session Time**: 60 minutes (as planned)

#### Findings Summary

| Category | Count | Critical | High | Medium | Low |
|----------|-------|----------|------|--------|-----|
| Bugs | 2 | 1 | 1 | 0 | 0 |
| Questions | 2 | 2 | 0 | 0 | 0 |
| Concerns | 2 | 0 | 0 | 2 | 0 |
| Observations | 2 | 0 | 0 | 0 | 2 |
| **Total** | **8** | **3** | **1** | **2** | **2** |

**Critical Issues**: 3 (BUG-001, QUESTION-001, QUESTION-002)

#### Objectives Assessment

| Objective | Target | Achieved | Status |
|-----------|--------|----------|--------|
| Primary: Validate edge case accuracy | 100% | 80% | ⚠️ Partial |
| Secondary: Assess input validation | 100% | 100% | ✅ Complete |
| Learning: Understand boundary handling | - | Yes | ✅ Complete |

**Overall Session Success**: ⚠️ **PARTIAL** - Found critical issues, need follow-up session

---

### Next Steps

#### Immediate Actions (This Sprint)
| Priority | Action | Owner | Effort | Due Date |
|----------|--------|-------|--------|----------|
| P0 | Fix BUG-001 (negative input) | Dev Team | 0.5d | 2024-02-15 |
| P0 | Verify QUESTION-001 (holiday calc) | QA + Legal | 0.5d | 2024-02-15 |
| P0 | Clarify QUESTION-002 (monthly limit) | Product Owner | 0.25d | 2024-02-14 |
| P1 | Fix BUG-002 (large input hang) | Dev Team | 1d | 2024-02-16 |

#### Test Cases to Add (From Findings)
1. **TC-NEW-001**: Negative overtime hours validation
2. **TC-NEW-002**: Maximum value input validation (edge case)
3. **TC-NEW-003**: Holiday overtime cross-validation with govt tool
4. **TC-NEW-004**: Monthly overtime limit enforcement (pending requirements)
5. **TC-NEW-005**: Rapid button click performance test

#### Follow-up Exploratory Sessions
| Charter | Focus | Priority | Time Box | Scheduled |
|---------|-------|----------|----------|-----------|
| ET-002 | 跨月加班計算 | P0 | 60 min | 2024-02-16 |
| ET-003 | 併發加班申請 | P1 | 45 min | 2024-02-17 |
| ET-004 | 小數點時數顯示 | P2 | 30 min | 2024-02-20 |

#### Areas Not Covered (Future Sessions)
- 變形工時計算 (flexible working hours)
- 補班日加班費 (compensatory work days)
- 跨年度特休計算 (annual leave across years)
- 部分工時加班 (part-time overtime)

---

### Evidence Archive

#### Screenshots
- [ ] `screenshot_neg_hours.png` - BUG-001 evidence
- [ ] `screenshot_large_input.png` - BUG-002 evidence
- [ ] `screenshot_holiday_calc.png` - QUESTION-001 reference
- [ ] `screenshot_monthly_limit.png` - QUESTION-002 reference

#### Screen Recordings
- [ ] `negative_input_test.mp4` - BUG-001 reproduction
- [ ] `performance_test.mp4` - CONCERN-001 demonstration

#### Logs & Data
- [ ] `session_notes_detailed.txt` - Full session log
- [ ] `perf_log_large_input.txt` - Performance measurements
- [ ] `console_errors.png` - Browser console errors

#### Comparison Data
- [ ] `govt_calculator_results.xlsx` - Government tool comparison
- [ ] `expected_vs_actual.csv` - Verification data

---

### Session Debrief

#### What Went Well
- ✅ Discovered 1 critical validation bug (negative input)
- ✅ Identified 2 legal compliance questions requiring clarification
- ✅ Structured approach using heuristics was effective
- ✅ Session stayed within time-box

#### What Could Improve
- ⚠️ Need government calculator access for real-time validation
- ⚠️ Should have tested cross-month scenarios (ran out of time)
- ⚠️ Could benefit from pair testing with legal expert

#### Lessons Learned
- Input validation is weak area (add to regression suite)
- Legal accuracy verification requires external tools (automate)
- Performance issues appear under stress testing (add to test plan)

#### Tester Notes
- System generally handles edge cases well
- Critical legal calculations need more rigor
- User experience is good, minor enhancements possible
- Overall quality is decent, but legal accuracy must be verified

---

### Sign-off

| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| Explorer (Tester) | [Your Name] | 2024-02-14 | ✅ Complete | Session executed per charter |
| Test Lead | | | ⏳ Pending | Review findings and prioritize |
| Dev Lead | | | ⏳ Pending | Review critical bugs |
| Product Owner | | | ⏳ Pending | Clarify QUESTION-002 |
| Legal Reviewer | | | ⏳ Pending | Verify holiday calculation |

**Session Status**: ✅ **COMPLETE** - Findings require follow-up

---
```

---

## Exploratory Testing Heuristics Reference

### General Heuristics (Industry Standard)

#### SFDPOT Framework
- **S**tructure: Architecture, components, integrations
- **F**unction: Features, behaviors, logic
- **D**ata: Inputs, outputs, storage
- **P**latform: OS, browsers, devices
- **O**perations: User actions, workflows
- **T**ime: Timing, sequences, concurrency

#### CRUSSPIC STMPL (Consistency Heuristics)
- **C**omparable products: How do competitors handle this?
- **R**egulations: Does it comply with laws/standards?
- **U**ser expectations: What do users expect?
- **S**pecifications: Does it match the spec?
- **S**tatutes: Legal compliance?
- **P**roduct: Consistent with rest of product?
- **I**nterface: Consistent across UI?
- **C**laims: Does it do what marketing claims?

#### FCC CUTS VIDS (Quality Criteria)
- **F**ast: Performance
- **C**apable: Functionality
- **C**ompatible: Integration
- **C**harismatic: UX appeal
- **U**sable: Ease of use
- **T**estable: Can be verified
- **S**ecure: Protected
- **V**iable: Business value
- **I**nformative: Clear communication
- **D**ependable: Reliable
- **S**calable: Growth capable

### Labor Law System Specific Heuristics

#### Legal Accuracy Heuristics
1. **Formula Fidelity**: Calculations match legal formulas exactly
2. **Law Article Traceability**: Every calculation cites correct law
3. **Boundary Compliance**: Legal limits enforced
4. **Rounding Consistency**: Follows legal rounding rules
5. **Date-Dependent Rules**: Law amendments applied correctly
6. **Tiered Calculation**: Multi-tier rates correct
7. **Special Case Handling**: Holidays, rest days per law
8. **Retroactive Calculation**: Historical dates use old law

#### Data Integrity Heuristics
1. **Zero Test**: Test with zero values
2. **Negative Test**: Test with negative values
3. **Null Test**: Test with null/undefined
4. **Overflow Test**: Test with extreme values
5. **Type Confusion**: Test with wrong types
6. **Special Characters**: Test with special chars
7. **Boundary Values**: Test at boundaries
8. **Precision Test**: Decimal accuracy

---

## Charter Templates by Type

### 1. New Feature Charter
**Focus**: Explore newly developed feature
**Time Box**: 60-90 minutes
**Emphasis**: Functionality, usability, edge cases

### 2. Bug Investigation Charter
**Focus**: Deep-dive into reported bug
**Time Box**: 30-45 minutes
**Emphasis**: Reproduction, root cause, related issues

### 3. Risk-Based Charter
**Focus**: High-risk areas based on change impact
**Time Box**: 60 minutes
**Emphasis**: Regression, integration, legal accuracy

### 4. Legal Validation Charter
**Focus**: Legal calculation accuracy
**Time Box**: 90-120 minutes
**Emphasis**: Cross-validation, compliance, edge cases

### 5. Edge Case Discovery Charter
**Focus**: Boundary conditions and corner cases
**Time Box**: 45-60 minutes
**Emphasis**: Unusual inputs, extreme values, rare scenarios

### 6. Usability Charter
**Focus**: User experience and workflows
**Time Box**: 60 minutes
**Emphasis**: Intuitive design, error messages, user guidance

---

## Finding Classification

### Bug Severity Levels
- 🔴 **Critical**: Legal violation, system crash, data loss, security breach
- 🟠 **High**: Major feature broken, significant user impact, accuracy issue
- 🟡 **Medium**: Feature degraded, workaround exists, minor accuracy issue
- 🟢 **Low**: Cosmetic issue, minor inconvenience, edge case

### Finding Categories
- 🐛 **BUG**: Defect that needs fixing
- ❓ **QUESTION**: Needs clarification or investigation
- ⚠️ **CONCERN**: Potential issue or risk to explore
- 💡 **OBSERVATION**: Insight, suggestion, or idea

---

## Session Management Best Practices

### Before Session
- [ ] Review charter and objectives
- [ ] Prepare test environment and data
- [ ] Set up recording/logging tools
- [ ] Review previous session notes
- [ ] Understand risks and focus areas

### During Session
- [ ] Follow time-boxed structure
- [ ] Take notes continuously
- [ ] Capture evidence (screenshots, videos)
- [ ] Follow hunches and anomalies
- [ ] Apply heuristics systematically
- [ ] Don't get stuck on one issue

### After Session
- [ ] Categorize and prioritize findings
- [ ] Document all evidence
- [ ] Create defect reports for bugs
- [ ] Identify follow-up areas
- [ ] Share findings with team
- [ ] Plan next exploratory session

---

## Integration with Other Skills

### Input from Other Skills
- Use `/test-plan` to identify high-risk areas for exploration
- Use `/test-coverage` to find gaps for exploratory focus
- Use `/requirement-to-ac` to understand feature intent

### Output to Other Skills
- Use `/defect-report` to document bugs found
- Use `/test-tracking` to track exploratory session progress
- Use `/test-report` to include exploratory findings
- Create new test cases from findings for regression suite

---

## Tools & Techniques

### Recommended Tools
- **Note-taking**: Markdown editors, session sheets
- **Screen recording**: OBS Studio, QuickTime, Loom
- **Screenshot**: Built-in OS tools, Snagit
- **Comparison**: Government calculators, Excel
- **Performance**: Browser DevTools, Lighthouse
- **Accessibility**: Axe DevTools, WAVE

### Testing Techniques
1. **Boundary Value Analysis**: Test at edges (0, min, max)
2. **Equivalence Partitioning**: Group similar inputs
3. **Error Guessing**: Predict likely errors
4. **Pair Testing**: Explore with another tester
5. **User Simulation**: Act like real user
6. **Scenario Testing**: Real-world workflows

---

## Session Types by Duration

### Quick Explore (15-30 min)
- Smoke test a new feature
- Investigate a specific bug
- Quick sanity check

### Standard Session (45-60 min)
- Feature exploration
- Risk-based testing
- Edge case discovery

### Deep Dive (90-120 min)
- Comprehensive legal validation
- Complex feature exploration
- Multiple area investigation

---

## Metrics to Track

### Session Metrics
- **Sessions Executed**: Number of exploratory sessions
- **Findings per Session**: Average bugs/issues found
- **Coverage**: Areas explored vs planned
- **Efficiency**: Findings per hour

### Finding Metrics
- **Critical Findings**: High-severity issues discovered
- **Unique Issues**: Not found by scripted tests
- **False Positives**: Findings that weren't actual issues
- **Conversion Rate**: Findings → Test cases created

---

## Best Practices for Labor Law Testing

1. **Always Cross-Validate Legal Calculations**
   - Use government calculators as gold standard
   - Document expected results from official sources
   - Never assume legal accuracy without verification

2. **Document Law References**
   - Cite specific law articles (e.g., 勞基法第24條)
   - Note law amendment dates
   - Keep legal reference materials handy

3. **Test Boundary Conditions Rigorously**
   - Legal limits (46h monthly OT)
   - Rounding boundaries
   - Date boundaries (month-end, year-end)

4. **Consider Real-World Scenarios**
   - Part-time workers
   - Flexible working hours
   - Multiple jobs
   - Cross-month calculations

5. **Collaborate with Legal Experts**
   - Pair test with legal advisor for complex scenarios
   - Get legal review for findings
   - Clarify interpretation questions

---

## Example Charters

### Example 1: Edge Case Exploration
```
Mission: Explore overtime calculator with boundary values and extreme inputs
         to discover calculation accuracy issues and validation gaps

Time Box: 60 minutes

Focus:
- Boundary values (0, negative, max)
- Decimal hours (0.5, 1.33, 2.75)
- Date boundaries (month-end, leap year)
- Special characters in input fields
```

### Example 2: Legal Compliance Validation
```
Mission: Validate severance pay calculation against Labor Standards Act Article 17
         with government calculator cross-validation to ensure legal accuracy

Time Box: 90 minutes

Focus:
- Various seniority lengths (6 months, 1 year, 5 years, 10+ years)
- Partial year calculations
- Mid-year termination dates
- Cross-validate all results with 勞動部資遣費試算系統
```

### Example 3: Workflow Exploration
```
Mission: Explore user workflows for calculating annual leave entitlement
         to discover usability issues and workflow gaps

Time Box: 45 minutes

Focus:
- Complete workflow (start to finish)
- Incomplete workflow (abandoned mid-way)
- Repeated calculations
- Navigation patterns (forward/back)
- Error recovery
```

---

## Quick Reference: Finding Template

```markdown
### [FINDING-ID]: [Severity] - [Title]

**Category**: Bug / Question / Concern / Observation
**Severity**: Critical / High / Medium / Low
**Module**: [Module name]

**Description**: [What was found]

**Steps to Reproduce** (for bugs):
1. [Step 1]
2. [Step 2]
3. [Observed result]

**Expected Behavior**: [What should happen]

**Actual Behavior**: [What actually happens]

**Evidence**: [Screenshots, videos, logs]

**Impact**: [Why this matters]

**Recommended Action**: [What to do]

**Priority**: P0 / P1 / P2 / P3
```

---

This Skill provides comprehensive exploratory testing guidance specifically designed for labor law systems, emphasizing legal accuracy validation, systematic exploration using heuristics, and thorough documentation of findings for follow-up action.
