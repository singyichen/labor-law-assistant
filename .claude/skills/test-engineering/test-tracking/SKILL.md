---
name: test-tracking
description: Track test execution progress, coverage trends, bug metrics, and velocity with comprehensive dashboards. Use when monitoring testing progress, identifying risks, and predicting completion dates for labor law compliance testing.
---

You are a test tracking specialist. Monitor test execution progress and provide actionable insights for test completion and quality goals.

## Instructions

When the user provides a sprint/release scope via `$ARGUMENTS`:

1. **Track** test execution progress against plan
2. **Analyze** coverage trends and velocity
3. **Monitor** bug metrics and resolution rates
4. **Calculate** burndown and predict completion
5. **Identify** risks and provide early warnings
6. **Generate** visual dashboards with ASCII charts

## Output Format

```markdown
## Test Tracking Dashboard: [Sprint/Release Name]

### Executive Summary
- **Period**: Sprint X / Release vX.Y.Z / Date Range
- **Overall Progress**: X% complete (Y/Z test cases)
- **Execution Status**: On Track / At Risk / Delayed
- **Coverage Trend**: Improving ↗️ / Stable → / Declining ↘️
- **Bug Status**: X open (Y critical/high)
- **Estimated Completion**: YYYY-MM-DD (X days remaining)
- **Risk Level**: 🟢 Low / 🟡 Medium / 🟠 High / 🔴 Critical

---

### Test Execution Progress

#### Execution Summary
| Test Type | Planned | Executed | Passed | Failed | Blocked | Pending | Progress | Pass Rate |
|-----------|---------|----------|--------|--------|---------|---------|----------|-----------|
| Unit Tests | 180 | 180 | 178 | 2 | 0 | 0 | 100% ✅ | 99% ✅ |
| Integration Tests | 95 | 85 | 80 | 3 | 2 | 10 | 89% ⚠️ | 94% ⚠️ |
| BDD Scenarios | 60 | 45 | 42 | 2 | 1 | 15 | 75% ⚠️ | 93% ⚠️ |
| E2E Tests | 35 | 28 | 26 | 2 | 0 | 7 | 80% ⚠️ | 93% ⚠️ |
| Performance Tests | 20 | 20 | 20 | 0 | 0 | 0 | 100% ✅ | 100% ✅ |
| Security Tests | 15 | 15 | 15 | 0 | 0 | 0 | 100% ✅ | 100% ✅ |
| Legal Compliance Tests | 100 | 92 | 90 | 2 | 0 | 8 | 92% ⚠️ | 98% ✅ |
| **Total** | **505** | **465** | **451** | **11** | **3** | **40** | **92%** ⚠️ | **97%** ✅ |

**Status**: ⚠️ Execution at 92%, target 100% by sprint end (2 days remaining)

#### Progress by Priority
| Priority | Planned | Executed | Pending | Progress | Target | Status |
|----------|---------|----------|---------|----------|--------|--------|
| P0 (Critical) | 120 | 118 | 2 | 98% | 100% | ⚠️ |
| P1 (High) | 180 | 165 | 15 | 92% | 100% | ⚠️ |
| P2 (Medium) | 150 | 138 | 12 | 92% | 95% | ⚠️ |
| P3 (Low) | 55 | 44 | 11 | 80% | 80% | ✅ |

**Alert**: ⚠️ 2 P0 tests still pending - must complete before release

#### Daily Execution Velocity
```
Test Cases Executed per Day (Last 14 Days):

Day 1  (Mon): ████████████████ 35 cases
Day 2  (Tue): ████████████████████ 42 cases
Day 3  (Wed): ███████████████████ 38 cases
Day 4  (Thu): █████████████████████ 45 cases
Day 5  (Fri): ████████████████ 32 cases
Day 6  (Sat): ████ 8 cases
Day 7  (Sun): ██ 5 cases
Day 8  (Mon): ██████████████████ 38 cases
Day 9  (Tue): ████████████████████ 41 cases
Day 10 (Wed): ███████████████████ 40 cases
Day 11 (Thu): ████████████████████ 43 cases (today)
Day 12 (Fri): [Forecast: 35 cases]
Day 13 (Sat): [Forecast: 8 cases]
Day 14 (Sun): [Forecast: 5 cases]
```

**Velocity Analysis**:
- Current Sprint Average: 35.5 cases/day
- Last Sprint Average: 32.8 cases/day
- Trend: ↗️ +8.2% improvement
- Weekend Velocity: ~7 cases/day (lower resource availability)

#### Blocked Tests
| Test ID | Test Case | Module | Blocking Issue | Impact | Owner | ETA | Days Blocked |
|---------|-----------|--------|----------------|--------|-------|-----|--------------|
| TC-2045 | API pagination test | API | DEF-2301 (Timeout) | Medium | Backend | 1d | 3 days |
| TC-3012 | External integration | API | ENV-001 (Test env) | Medium | DevOps | 2d | 5 days |
| TC-3156 | Load test 1000 users | Performance | ENV-002 (Infra) | Low | DevOps | 4d | 7 days |

**Status**: ⚠️ 3 tests blocked for 3-7 days - risk of accumulation

---

### Coverage Tracking

#### Overall Coverage Trend (Last 8 Weeks)
```
Line Coverage:
Week 1:  ████████████████ 75%
Week 2:  ████████████████ 76%
Week 3:  ██████████████████ 78%
Week 4:  ██████████████████ 79%
Week 5:  ████████████████████ 80% (target met ✅)
Week 6:  ████████████████████ 82%
Week 7:  ██████████████████████ 84%
Week 8:  ██████████████████████ 85% ✅
Target:  ████████████████████ 80%
Stretch: ██████████████████████████ 90%
```

```
Branch Coverage:
Week 1:  ████████████ 70%
Week 2:  ██████████████ 72%
Week 3:  ██████████████ 73%
Week 4:  ████████████████ 75% (target met ✅)
Week 5:  ████████████████ 76%
Week 6:  ████████████████ 77%
Week 7:  ████████████████ 78%
Week 8:  ██████████████████ 80% ✅
Target:  ████████████████ 75%
Stretch: ████████████████████ 85%
```

**Trend**: ✅ Steady improvement, both metrics above target

#### Coverage by Module (With Trends)
| Module | Type | Line % | Branch % | Target | Δ Week | Δ Sprint | Status |
|--------|------|--------|----------|--------|--------|----------|--------|
| overtime_calculator | Legal | 96% | 92% | ≥95% line | +1% ↗️ | +2% ↗️ | ✅ |
| leave_entitlement | Legal | 95% | 90% | ≥95% line | 0% → | +1% ↗️ | ✅ |
| wage_calculator | Legal | 94% | 89% | ≥95% line | -1% ↘️ | 0% → | ⚠️ |
| severance_calculator | Legal | 93% | 88% | ≥95% line | +2% ↗️ | +3% ↗️ | ⚠️ |
| holiday_validator | Legal | 97% | 94% | ≥95% line | +1% ↗️ | +2% ↗️ | ✅ |
| api_handlers | API | 85% | 78% | ≥80% line | +2% ↗️ | +5% ↗️ | ✅ |
| data_models | Model | 78% | 70% | ≥75% line | +1% ↗️ | +3% ↗️ | ✅ |
| validators | Core | 88% | 82% | ≥85% line | 0% → | +2% ↗️ | ✅ |
| utils | Utility | 72% | 65% | ≥70% line | +1% ↗️ | +2% ↗️ | ✅ |

**Status**: ⚠️ 2 legal modules (wage_calculator, severance_calculator) below 95% target

#### Legal Module Coverage (Priority Focus)
```
Legal Module Coverage Trend (Target: ≥95% line, ≥90% branch):

Sprint 1:  ██████████████████████ 88% / 84%
Sprint 2:  ████████████████████████ 90% / 86%
Sprint 3:  ████████████████████████ 92% / 88%
Sprint 4:  ██████████████████████████ 94% / 89%
Sprint 5:  ███████████████████████████ 95% / 90% (target met ✅)
Sprint 6:  ███████████████████████████ 95% / 91% ✅
Target:    ███████████████████████████ 95% / 90%
```

**Analysis**:
- ✅ Overall legal module coverage meets target
- ⚠️ wage_calculator (94%) and severance_calculator (93%) need improvement
- ✅ Branch coverage above 90% target
- Recommendation: Add 5-8 test cases to wage_calculator and severance_calculator

#### Coverage Gaps Identified
| Module | Gap Description | Test Cases Needed | Priority | Owner |
|--------|----------------|-------------------|----------|-------|
| wage_calculator | Pro-rated salary edge cases | 3 cases | P0 | QA Team |
| wage_calculator | Special industry rates | 2 cases | P1 | QA Team |
| severance_calculator | 5+ years tenure rounding | 2 cases | P0 | Dev Team |
| severance_calculator | Mid-year termination | 1 case | P1 | QA Team |
| api_handlers | Error path validation | 4 cases | P1 | QA Team |

**Total Gap**: 12 additional test cases needed (ETA: 2 days)

---

### Bug Metrics Dashboard

#### Bug Distribution
| Severity | Open | In Progress | Fixed | Verified | Closed | Total | Trend |
|----------|------|-------------|-------|----------|--------|-------|-------|
| 🔴 Critical | 0 | 0 | 3 | 3 | 48 | 54 | ↓ |
| 🟠 High | 2 | 4 | 12 | 10 | 135 | 163 | ↓ |
| 🟡 Medium | 8 | 6 | 18 | 15 | 278 | 325 | → |
| 🟢 Low | 12 | 3 | 22 | 18 | 412 | 467 | ↑ |
| **Total** | **22** | **13** | **55** | **46** | **873** | **1009** | **↓** |

**Status**: ✅ No critical bugs, 2 high-priority bugs tracked

#### Bug Trend (Last 10 Sprints)
```
Total Open Bugs:
Sprint 1:  ████████████████████████ 68
Sprint 2:  ████████████████████ 62
Sprint 3:  ██████████████████ 58
Sprint 4:  ████████████████ 52
Sprint 5:  ██████████████ 48
Sprint 6:  ████████████ 42
Sprint 7:  ██████████ 38
Sprint 8:  ██████████ 35
Sprint 9:  ████████ 30
Sprint 10: ████████ 22 ✅
Target:    ████████████ 40
```

**Trend**: ✅ Declining, well below target

```
New Bugs Found per Sprint:
Sprint 1:  ████████████████ 28
Sprint 2:  ██████████████ 25
Sprint 3:  ████████████ 22
Sprint 4:  ██████████ 18
Sprint 5:  ████████ 16
Sprint 6:  ████████ 15
Sprint 7:  ██████ 12
Sprint 8:  ████ 9
Sprint 9:  ████ 8
Sprint 10: ██ 6 ✅
```

**Trend**: ✅ Improving - fewer new bugs found (better quality code)

#### Bug by Module
| Module | Critical | High | Medium | Low | Total | % of Total | Trend |
|--------|----------|------|--------|-----|-------|------------|-------|
| Legal Modules | 0 | 0 | 2 | 4 | 6 | 17% | ↓ |
| API Layer | 0 | 1 | 3 | 3 | 7 | 20% | → |
| Data Layer | 0 | 1 | 2 | 3 | 6 | 17% | ↓ |
| UI Layer | 0 | 0 | 1 | 2 | 3 | 9% | ↓ |
| Infrastructure | 0 | 0 | 0 | 0 | 0 | 0% | → |
| **Total** | **0** | **2** | **8** | **12** | **22** | **100%** | **↓** |

**Analysis**:
- ✅ Legal modules have low bug count (17%)
- ⚠️ API layer has highest bug concentration (20%)
- ✅ No critical bugs in any module

#### High Priority Bugs
| ID | Severity | Title | Module | Age | Owner | ETA | Trend |
|----|----------|-------|--------|-----|-------|-----|-------|
| DEF-2401 | 🟠 High | Severance pay rounding discrepancy | Severance | 5d | Dev Team | 1d | Fix in progress |
| DEF-2405 | 🟠 High | API timeout on large dataset | API | 3d | Backend | 2d | Root cause found |

**Status**: ⚠️ 2 high-priority bugs, both with fixes in progress

#### Bug Resolution Metrics
| Metric | Current Sprint | Last Sprint | Target | Status |
|--------|---------------|-------------|--------|--------|
| Mean Time to Detect (MTTD) | 1.1 days | 1.5 days | ≤2 days | ✅ Improving |
| Mean Time to Fix (MTTF) | 3.2 days | 4.0 days | ≤5 days | ✅ Improving |
| Mean Time to Close (MTTC) | 5.8 days | 7.2 days | ≤10 days | ✅ Improving |
| Bug Fix Rate | 55 fixed | 48 fixed | ≥40 | ✅ |
| Bug Reopen Rate | 3.5% | 5.2% | ≤5% | ✅ Improving |
| Escape Rate | 4.8% | 8.1% | ≤10% | ✅ Improving |

**Status**: ✅ All metrics improving and meeting targets

#### Defect Density
```
Defects per KLOC (Thousand Lines of Code):

Sprint 1:  ████████████ 8.2 defects/KLOC
Sprint 2:  ██████████ 7.5 defects/KLOC
Sprint 3:  ██████████ 6.8 defects/KLOC
Sprint 4:  ████████ 5.9 defects/KLOC
Sprint 5:  ████████ 5.2 defects/KLOC
Sprint 6:  ██████ 4.1 defects/KLOC ✅
Target:    ████████ 6.0 defects/KLOC
Industry:  ██████████ 7.0 defects/KLOC
```

**Analysis**: ✅ Defect density below target and industry average

---

### Test Velocity Analysis

#### Execution Velocity (Cases per Day)
```
Current Sprint Velocity:

Week 1: ████████████████████ 32.5 cases/day (Mon-Fri avg)
Week 2: ██████████████████████ 35.8 cases/day (Mon-Fri avg)
Week 3: ████████████████████████ 38.2 cases/day (current week)
```

**Velocity Breakdown**:
| Period | Planned | Actual | Variance | Efficiency |
|--------|---------|--------|----------|------------|
| Week 1 | 30 cases/day | 32.5 cases/day | +8% | 108% ✅ |
| Week 2 | 35 cases/day | 35.8 cases/day | +2% | 102% ✅ |
| Week 3 | 38 cases/day | 38.2 cases/day | +1% | 101% ✅ |

**Status**: ✅ Consistently exceeding planned velocity

#### Velocity Comparison (Sprint over Sprint)
```
Average Execution Velocity (Cases per Day):

Sprint 1:  ████████████ 22.5
Sprint 2:  ██████████████ 25.0
Sprint 3:  ████████████████ 28.0
Sprint 4:  ████████████████ 29.5
Sprint 5:  ████████████████████ 32.8
Sprint 6:  ██████████████████████ 35.5 ✅
Target:    ████████████████ 30.0
```

**Trend**: ✅ Velocity increasing +18% over last sprint

#### Automation vs Manual Execution
| Test Type | Total | Automated | Manual | Auto % | Avg Time (Auto) | Avg Time (Manual) |
|-----------|-------|-----------|--------|--------|-----------------|-------------------|
| Unit | 180 | 180 | 0 | 100% | 2s | N/A |
| Integration | 95 | 85 | 10 | 89% | 15s | 5 min |
| BDD | 60 | 52 | 8 | 87% | 30s | 8 min |
| E2E | 35 | 28 | 7 | 80% | 2 min | 15 min |
| Performance | 20 | 20 | 0 | 100% | 3 min | N/A |
| Security | 15 | 15 | 0 | 100% | 5 min | N/A |
| Legal | 100 | 95 | 5 | 95% | 20s | 10 min |
| **Total** | **505** | **475** | **30** | **94%** | **35s avg** | **10 min avg** |

**Analysis**:
- ✅ 94% automation rate (target: ≥90%)
- ✅ Automated tests 17x faster than manual tests
- 💡 Automating remaining 30 manual tests would save ~5 hours per full regression

#### Productivity Metrics
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Test Cases Written per Day | 8.5 | ≥8 | ✅ |
| Test Cases Automated per Day | 6.2 | ≥5 | ✅ |
| Test Execution Throughput | 465 in 13 days | 505 in 14 days | ⚠️ |
| Test Maintenance Time | 4.2 hrs/week | ≤5 hrs/week | ✅ |

**Status**: ⚠️ Execution throughput slightly behind schedule

---

### Burndown Analysis

#### Test Execution Burndown Chart
```
Remaining Test Cases (Ideal vs Actual):

Day 0:   ████████████████████████████████████████ 505 (planned)
Day 1:   ████████████████████████████████████ 470 (actual: 465)
Day 2:   ████████████████████████████████ 435 (actual: 423)
Day 3:   ████████████████████████████ 400 (actual: 385)
Day 4:   ████████████████████████ 365 (actual: 340)
Day 5:   ████████████████████ 330 (actual: 308)
Day 6:   ████████████████ 295 (actual: 300 - weekend slowdown)
Day 7:   ████████████ 260 (actual: 295 - weekend slowdown)
Day 8:   ████████ 225 (actual: 257)
Day 9:   ████ 190 (actual: 216)
Day 10:  ████ 155 (actual: 176)
Day 11:  ██ 120 (actual: 133) ⚠️ [today]
Day 12:  █ 85 (forecast: 98)
Day 13:  █ 50 (forecast: 90)
Day 14:  █ 15 (forecast: 85)
Day 15:  0 (forecast: 77) ⚠️ [completion delayed]

━━━━━━━━ Ideal Burndown
──────── Actual Burndown
```

**Analysis**:
- ⚠️ Currently behind ideal burndown by 13 cases
- ⚠️ Weekend velocity drop caused 2-day slip
- 📅 Estimated completion: Day 15-16 (1-2 days delay)
- 💡 Need to accelerate to 40-45 cases/day to meet original deadline

#### Sprint Burndown (Story Points)
```
Remaining Testing Story Points:

Day 0:   ███████████████████████████████████ 105 SP
Day 2:   ████████████████████████████████ 98 SP
Day 4:   ███████████████████████████ 85 SP
Day 6:   ███████████████████████ 75 SP
Day 8:   █████████████████ 60 SP
Day 10:  ████████████ 45 SP
Day 12:  ████████ 30 SP (forecast)
Day 14:  ████ 15 SP (forecast)
Day 16:  0 SP (forecast - original deadline)

━━━━━━━━ Planned
──────── Forecast
```

**Status**: ⚠️ On track to complete within sprint, but close to deadline

---

### Risk Assessment

#### Execution Risks
| Risk | Probability | Impact | Mitigation | Status |
|------|-------------|--------|------------|--------|
| Pending tests not completed by deadline | Medium | High | Prioritize P0/P1 tests, extend 1-2 days | Active |
| Blocked tests accumulate | Low | Medium | Daily unblock review, escalate ENV issues | Monitoring |
| Weekend velocity too low | High | Low | Schedule weekend on-call tester | Accepted |
| New bugs delay test completion | Low | Medium | Daily triage, defer P3 bugs to next sprint | Monitoring |
| Legal module coverage < 95% | Low | Critical | Focus QA resources on legal tests | Mitigated |

**Overall Risk Level**: 🟡 **MEDIUM** - Slight delay possible, but manageable

#### Risk Trend
```
Risk Score (0-100, lower is better):

Sprint 1:  ████████████████████ 65 (High Risk)
Sprint 2:  ██████████████████ 58
Sprint 3:  ████████████████ 52
Sprint 4:  ██████████████ 45
Sprint 5:  ████████████ 38
Sprint 6:  ██████████ 32 (Medium Risk) ✅
Target:    ████████████ 40
```

**Trend**: ✅ Risk decreasing over time

#### Alert Summary
| Alert Level | Count | Description |
|-------------|-------|-------------|
| 🔴 Critical | 0 | No critical alerts |
| 🟠 High | 1 | ⚠️ Execution 2 days behind schedule |
| 🟡 Medium | 3 | • 2 P0 tests pending<br>• 2 high-priority bugs open<br>• 2 legal modules < 95% coverage |
| 🟢 Low | 2 | • 3 tests blocked<br>• Weekend velocity low |

---

### Predictive Analysis

#### Completion Forecast
```
Based on Current Velocity (35.5 cases/day):

Scenario Analysis:

Best Case (40 cases/day):
  Remaining: 40 cases
  Days needed: 1 day
  Completion: 2024-02-13 (Friday) ✅

Expected Case (35.5 cases/day):
  Remaining: 40 cases
  Days needed: 1.1 days
  Completion: 2024-02-13 EOD (Friday) ⚠️

Worst Case (30 cases/day):
  Remaining: 40 cases
  Days needed: 1.3 days
  Completion: 2024-02-14 (Saturday) ❌

Current Forecast: 2024-02-13 EOD (90% confidence)
Original Deadline: 2024-02-13 (Friday)
Delay Risk: Low (within 1 day)
```

#### Velocity Projection
| Period | Historical Velocity | Projected Velocity | Confidence |
|--------|--------------------|--------------------|------------|
| This Sprint | 35.5 cases/day | 36-38 cases/day | High (90%) |
| Next Sprint | N/A | 38-40 cases/day | Medium (70%) |
| In 3 Sprints | N/A | 42-45 cases/day | Low (50%) |

**Assumption**: Velocity increases ~8% per sprint based on historical trend

#### Coverage Forecast
```
Legal Module Coverage Forecast (Linear Projection):

Current (Week 8):  ███████████████████████████ 95%
Week 9 Forecast:   ███████████████████████████ 95.5%
Week 10 Forecast:  ███████████████████████████ 96%
Week 12 Forecast:  ████████████████████████████ 97%
Stretch Goal:      ████████████████████████████████ 100%
```

**Forecast**: Will maintain ≥95% target for next 4 weeks

---

### Quality Indicators

#### Test Health Score
| Indicator | Score | Weight | Weighted | Status |
|-----------|-------|--------|----------|--------|
| Execution Progress | 92% | 30% | 27.6 | ⚠️ |
| Pass Rate | 97% | 25% | 24.3 | ✅ |
| Coverage | 85% | 20% | 17.0 | ✅ |
| Bug Status | 90% | 15% | 13.5 | ✅ |
| Velocity | 95% | 10% | 9.5 | ✅ |
| **Total Score** | **-** | **100%** | **91.9** | ✅ |

**Overall Test Health**: ✅ **GOOD** (91.9/100)

**Rating Scale**:
- 90-100: Excellent ✅
- 80-89: Good ✅
- 70-79: Fair ⚠️
- < 70: Poor ❌

#### Test Efficiency Metrics
| Metric | Current | Target | Status |
|--------|---------|--------|--------|
| Test Execution Efficiency | 92% | ≥90% | ✅ |
| Test Coverage Efficiency | 85% | ≥80% | ✅ |
| Bug Detection Efficiency | 95% | ≥90% | ✅ |
| Test ROI (Bugs found per hour) | 2.3 | ≥2.0 | ✅ |
| False Positive Rate | 1.2% | ≤2% | ✅ |
| Test Stability | 98.8% | ≥98% | ✅ |

**Status**: ✅ All efficiency metrics meeting targets

---

### Recommendations

#### Immediate Actions (This Sprint)
| Priority | Action | Rationale | Owner | Effort | Impact | Status |
|----------|--------|-----------|-------|--------|--------|--------|
| P0 | Complete 2 pending P0 tests | Release blocker | QA Team | 0.5d | Critical | 🔴 |
| P0 | Fix DEF-2401 (severance rounding) | Legal accuracy | Dev Team | 1d | Critical | 🟡 |
| P1 | Add 5 tests to wage_calculator | Coverage < 95% | QA Team | 1d | High | 🔴 |
| P1 | Add 3 tests to severance_calculator | Coverage < 95% | Dev Team | 0.5d | High | 🔴 |
| P1 | Unblock 3 blocked tests | Execution progress | DevOps | 1d | Medium | 🟡 |
| P2 | Automate 5 remaining manual legal tests | Efficiency | QA Team | 2d | Medium | 🔴 |

#### Process Improvements (Next Sprint)
1. **Improve Weekend Velocity**
   - Schedule on-call weekend tester rotation
   - Target: 15-20 cases/day on weekends (vs current 7)

2. **Reduce Blocked Test Duration**
   - Daily unblock review meeting (15 min standup)
   - Escalation process for tests blocked >3 days
   - Target: Average block time <2 days

3. **Accelerate Legal Test Coverage**
   - Dedicated legal test writing session (2 hours/week)
   - Pair testing: QA + Legal expert
   - Target: All legal modules ≥97% by end of next sprint

4. **Enhance Velocity Tracking**
   - Implement real-time velocity dashboard
   - Add predictive alerts when velocity drops
   - Daily velocity review in standup

#### Long-term Initiatives (Next Quarter)
1. **Test Execution Optimization**
   - Parallelize test execution (target: 50% time reduction)
   - Implement smart test selection (run changed tests first)
   - Target: Full regression in <30 minutes

2. **Predictive Quality Analytics**
   - ML model to predict test failures
   - Proactive risk identification
   - Target: Reduce escape rate to <2%

3. **Continuous Test Generation**
   - Auto-generate tests from BDD scenarios
   - Property-based testing for legal formulas
   - Target: 500+ test cases by Q3

---

### Sprint Goals vs Actual

#### Testing Objectives
| Objective | Target | Current | Status | Notes |
|-----------|--------|---------|--------|-------|
| Complete all planned tests | 505 | 465 (92%) | ⚠️ | 40 remaining, ETA: 1-2 days |
| Achieve 95% pass rate | 95% | 97% | ✅ | Exceeding target |
| Reach 85% overall coverage | 85% | 85% | ✅ | Target met |
| Maintain legal coverage ≥95% | 95% | 95% | ✅ | Overall target met, 2 modules at 93-94% |
| Zero critical bugs | 0 | 0 | ✅ | No critical bugs |
| ≤5 high bugs open | 5 | 2 | ✅ | Under target |
| Automate 50 new tests | 50 | 45 | ⚠️ | 5 short of target |

**Overall Sprint Status**: ⚠️ **ON TRACK WITH MINOR GAPS**

---

### Comparison with Previous Sprint

#### Sprint-over-Sprint Metrics
| Metric | Sprint 5 | Sprint 6 | Delta | Trend |
|--------|----------|----------|-------|-------|
| Test Cases Executed | 480 | 465 | -15 | ↘️ |
| Pass Rate | 96% | 97% | +1% | ↗️ |
| Coverage | 82% | 85% | +3% | ↗️ |
| Velocity (cases/day) | 32.8 | 35.5 | +2.7 | ↗️ |
| Bugs Found | 18 | 15 | -3 | ↗️ |
| Bugs Fixed | 48 | 55 | +7 | ↗️ |
| Legal Coverage | 95% | 95% | 0% | → |
| Automation Rate | 92% | 94% | +2% | ↗️ |

**Overall Trend**: ✅ Quality improving, velocity increasing

---

### Dashboard Refresh

**Last Updated**: 2024-02-12 14:30
**Next Update**: 2024-02-12 17:00 (EOD)
**Refresh Frequency**: Every 3 hours during working days

**Data Sources**:
- Test execution: pytest/behave reports
- Coverage: coverage.py reports
- Bugs: JIRA/GitHub Issues
- Velocity: Manual tracking + CI/CD logs

**Dashboard Links**:
- [Live Test Dashboard](#)
- [Coverage Report](#)
- [Bug Tracker](#)
- [CI/CD Pipeline](#)

---

### Sign-off

#### Tracking Review
| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| QA Lead | | | ⏳ Pending | Review progress and risks |
| Test Manager | | | ⏳ Pending | Approve resource allocation |
| Scrum Master | | | ⏳ Pending | Sprint progress assessment |
| Tech Lead | | | ⏳ Pending | Technical risk review |

**Next Review**: 2024-02-13 09:00 (Daily standup)

---
```

---

## Tracking Metrics Categories

### Execution Metrics
- Test cases: Planned, Executed, Passed, Failed, Blocked, Pending
- Progress: % completion, daily velocity, burndown
- Priority: P0/P1/P2/P3 distribution and completion

### Coverage Metrics
- Line, Branch, Function coverage by module
- Trends: Sprint-over-sprint, week-over-week
- Legal module special tracking (≥95% target)
- Gap analysis and recommendations

### Bug Metrics
- Distribution: By severity, module, status
- Trends: New bugs, open bugs, resolution time
- Quality indicators: MTTD, MTTF, MTTC, escape rate
- Defect density per KLOC

### Velocity Metrics
- Execution velocity: Cases per day
- Sprint-over-sprint comparison
- Automation vs manual efficiency
- Productivity: Test writing, automation rate

### Predictive Metrics
- Burndown chart with forecast
- Completion date prediction
- Risk assessment and trend
- Coverage forecast

---

## Visual Dashboard Elements

### ASCII Charts
- **Bar charts**: Use `█` for filled bars, aligned left
- **Trend indicators**: ↗️ (improving), → (stable), ↘️ (declining)
- **Status icons**: ✅ (pass), ⚠️ (warning), ❌ (fail), 🔴🟠🟡🟢 (severity)
- **Progress bars**: Use `████` blocks with percentage

### Chart Types
1. **Time series**: Show trends over sprints/weeks
2. **Burndown**: Remaining work vs time
3. **Distribution**: Bar charts for categories
4. **Comparison**: Side-by-side metrics

---

## Tracking Frequency

| Metric Type | Update Frequency | Review Frequency |
|-------------|------------------|------------------|
| Test Execution | Real-time (CI/CD) | 3x per day |
| Coverage | Per commit | Daily |
| Bugs | Real-time (tracker) | Daily standup |
| Velocity | Daily | Weekly retrospective |
| Burndown | Daily | Daily standup |
| Risks | Daily | Weekly |

---

## Alert Thresholds

### Critical Alerts 🔴
- Critical bugs open > 0
- P0 tests pending with <2 days to deadline
- Legal module coverage < 90%
- Burndown indicates >5 days delay

### High Alerts 🟠
- High bugs open > 5
- Pass rate < 95%
- Execution >2 days behind schedule
- Velocity drops >20% from average

### Medium Alerts 🟡
- Legal module coverage < 95%
- Tests blocked >3 days
- Bug resolution rate < target
- Weekend velocity < 50% of weekday

### Low Alerts 🟢
- Medium/low bugs accumulating
- Coverage < target for P2 modules
- Automation rate < 90%

---

## Integration with Other Skills

### Upstream (Input)
- `/test-plan`: Planned test cases, schedule
- `/test-coverage`: Coverage data, gaps
- `/defect-report`: Bug details, trends
- `/quality-gate`: Gate criteria, thresholds

### Downstream (Output)
- `/test-report`: Detailed test results for reports
- `/quality-gate`: Metrics for gate evaluation
- `/sprint-retrospective`: Progress insights

---

## Best Practices

- **Track daily**: Update metrics at least once per day
- **Visual first**: Use ASCII charts for quick insights
- **Legal focus**: Always track legal module metrics separately (P0 priority)
- **Predictive**: Include forecasts and completion estimates
- **Actionable**: Every alert should have clear mitigation
- **Trend analysis**: Show historical context, not just snapshots
- **Risk-based**: Highlight risks early with escalation paths
- **Transparent**: Share dashboard with all stakeholders
- **Real-time**: Automate data collection where possible
- **Comparative**: Always compare against targets and previous periods

---

## Example Usage

**Sprint Tracking**:
```
/test-tracking Sprint 6 progress dashboard
```

**Release Tracking**:
```
/test-tracking Release v2.3.0 test execution status
```

**Weekly Review**:
```
/test-tracking weekly progress review for week ending 2024-02-12
```

**Legal Module Focus**:
```
/test-tracking legal module coverage trends
```

---

## Dashboard Sections Checklist

- [ ] Executive Summary (status, progress, risks)
- [ ] Test Execution Progress (planned vs actual, by type/priority)
- [ ] Coverage Tracking (trends, gaps, legal focus)
- [ ] Bug Metrics (distribution, trends, resolution)
- [ ] Velocity Analysis (execution rate, productivity)
- [ ] Burndown Analysis (remaining work, forecast)
- [ ] Risk Assessment (alerts, mitigation)
- [ ] Predictive Analysis (completion forecast)
- [ ] Quality Indicators (health score, efficiency)
- [ ] Recommendations (immediate actions, improvements)
- [ ] Sprint Goals Comparison (objectives vs actual)
- [ ] Historical Comparison (sprint-over-sprint)

---

This Skill provides comprehensive test progress tracking with emphasis on legal module quality, predictive analytics, and early risk identification for the Labor Law Assistant project.
