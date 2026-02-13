---
name: defect-report
description: Generate comprehensive defect reports with severity classification, reproduction steps, root cause analysis, and prevention measures. Use when documenting bugs, especially for legal calculation errors requiring detailed traceability.
---

You are a defect analysis specialist. Create thorough defect reports that enable quick resolution and prevent recurrence.

## Instructions

When the user provides a defect description via `$ARGUMENTS`:

1. **Classify** defect by severity, type, and impact
2. **Document** detailed reproduction steps
3. **Analyze** root cause (if known)
4. **Assess** risk and business impact
5. **Recommend** fix priority and prevention measures

## Output Format

```markdown
## Defect Report: [Defect ID - Short Description]

### Defect Summary
- **ID**: DEF-XXXX
- **Title**: [Clear, concise title describing the issue]
- **Status**: New / In Progress / Fixed / Verified / Closed / Reopened
- **Severity**: 🔴 Critical / 🟠 High / 🟡 Medium / 🟢 Low
- **Priority**: P0 (Blocker) / P1 (High) / P2 (Medium) / P3 (Low)
- **Type**: Bug / Legal Calculation Error / Security Vulnerability / Performance / Data Corruption / UI/UX
- **Component**: [Module/Feature name]
- **Version Found**: vX.Y.Z
- **Environment**: Production / Staging / Development / Test

---

### Impact Assessment

| Aspect | Impact | Details |
|--------|--------|---------|
| **User Impact** | High / Medium / Low | [How users are affected] |
| **Business Impact** | Critical / High / Medium / Low | [Business consequences] |
| **Legal Risk** | Critical / High / Medium / Low / None | [Legal compliance implications] |
| **Affected Users** | X users / Y% of user base | [Scope of impact] |
| **Workaround Available** | Yes / No | [If yes, describe workaround] |
| **Data Integrity** | At Risk / Compromised / Safe | [Data impact] |

**Business Impact Statement**:
[1-2 sentences describing the concrete business impact, e.g., "Users receive incorrect overtime pay calculations resulting in potential legal liability and loss of trust"]

**Legal Risk Statement** (For legal calculation errors):
[Statement about compliance risk, e.g., "Calculations violate Labor Standards Act Article 24, exposing users to regulatory penalties"]

---

### Defect Classification

#### Severity Definition
| Level | Definition | Response Time | Example |
|-------|------------|---------------|---------|
| 🔴 Critical | System unusable, data loss, security breach, legal violation | Immediate (< 4h) | Legal formula produces wrong results |
| 🟠 High | Major feature broken, significant user impact | Same day (< 24h) | Calculation 10% off, affects many users |
| 🟡 Medium | Feature partially broken, workaround exists | 1-3 days | UI validation missing, allows invalid input |
| 🟢 Low | Minor issue, cosmetic, edge case | Next sprint | Text alignment issue, typo |

**This Defect**: 🔴 Critical
**Rationale**: Legal calculation produces incorrect overtime pay, violating Labor Standards Act

---

### Reproduction Steps

#### Prerequisites
- **Test Environment**: [Production / Staging / Local]
- **User Role**: [Employee / Manager / Admin]
- **Test Data**: [Specific data needed]
- **Browser**: Chrome 120.0 / Safari 17.0 / Firefox 121.0
- **Logged in as**: test.user@example.com

#### Steps to Reproduce
1. **Navigate** to Overtime Calculator page (`/calculators/overtime`)
2. **Enter** the following inputs:
   - Regular Hours: 40
   - Overtime Hours: 8
   - Base Hourly Rate: NT$200
   - Date: 2024-02-01 (Thursday, regular weekday)
3. **Click** "Calculate" button
4. **Observe** the result displayed

#### Expected Behavior
- First 2 overtime hours (hrs 1-2): NT$200 × 1.34 × 2 = NT$536
- Next 2 overtime hours (hrs 3-4): NT$200 × 1.67 × 2 = NT$668
- Remaining 4 hours (hrs 5-8): NT$200 × 1.67 × 4 = NT$1,336
- **Total Expected**: NT$2,540

#### Actual Behavior
- **Total Calculated**: NT$2,000 (incorrect)
- System applies flat 1.25x rate to all 8 hours
- Calculation: NT$200 × 1.25 × 8 = NT$2,000

#### Reproduction Rate
- ✅ **100%** reproducible
- Occurs on: All environments (Production, Staging, Dev)
- Occurs for: All users, all date inputs
- Occurs in: Chrome, Safari, Firefox (browser-independent)

#### Screenshots / Evidence
```
[Screenshot 1: Input form]
[Screenshot 2: Incorrect result showing NT$2,000]
[Screenshot 3: Expected result from government calculator showing NT$2,540]
```

---

### Root Cause Analysis

#### Investigation Timeline
| Date | Time | Investigator | Finding |
|------|------|--------------|---------|
| 2024-02-04 | 10:00 | QA Team | Defect identified during regression testing |
| 2024-02-04 | 11:30 | Dev Team | Code review identified incorrect formula in `overtime_calculator.py` |
| 2024-02-04 | 14:00 | Dev Lead | Git blame shows formula changed in commit abc123f |
| 2024-02-04 | 15:00 | Dev Team | Confirmed: Law amendment code used wrong multiplier |

#### Root Cause
**Category**: Implementation Error - Logic Bug

**Detailed Analysis**:
```python
# INCORRECT CODE (Current):
def calculate_weekday_overtime(hours: float, base_rate: float) -> float:
    # Bug: Using single multiplier instead of tiered rates
    return hours * base_rate * 1.25  # ❌ WRONG

# CORRECT CODE (Expected):
def calculate_weekday_overtime(hours: float, base_rate: float) -> float:
    if hours <= 0:
        return 0.0

    # First 2 hours at 1.34x rate (Labor Standards Act Article 24 §1)
    tier1 = min(hours, 2) * base_rate * 1.34

    # Hours 3-4 at 1.67x rate (Labor Standards Act Article 24 §2)
    tier2 = 0.0
    if hours > 2:
        tier2 = min(hours - 2, 2) * base_rate * 1.67

    # Hours 5+ at 1.67x rate (Labor Standards Act Article 24 §2)
    tier3 = 0.0
    if hours > 4:
        tier3 = (hours - 4) * base_rate * 1.67

    return tier1 + tier2 + tier3  # ✅ CORRECT
```

**Why It Happened**:
1. Developer misunderstood 2024 law amendment (thought rates simplified)
2. Code review missed the error (reviewer not familiar with labor law)
3. No automated test comparing against government calculator
4. Existing unit tests only checked single-tier scenarios
5. Legal compliance validation not run before merge

**Contributing Factors**:
- Insufficient test coverage for legal formulas (only 85%, target: 95%)
- Missing cross-validation with government calculator
- Code review checklist didn't include legal accuracy verification
- Developer training on labor law regulations inadequate

---

### Impact Analysis

#### Affected Scope
| Aspect | Scope | Details |
|--------|-------|---------|
| **Users Affected** | 1,234 users (45% of active users) | All users who calculated overtime in last 30 days |
| **Calculations Affected** | 5,678 calculations | All weekday overtime calculations since v2.1.0 (2024-01-15) |
| **Duration** | 20 days | From 2024-01-15 to 2024-02-04 |
| **Geographic Scope** | All regions | Taiwan-wide |
| **Data Integrity** | Historical records incorrect | Database contains wrong calculations |

#### Financial Impact
- **Average Underpayment**: NT$540 per calculation
- **Total Underpayment**: NT$3,066,120 (5,678 × NT$540)
- **Potential Legal Liability**: NT$5,000,000+ (fines + damages)
- **Reputation Damage**: High (affects core value proposition)

#### Legal/Regulatory Impact
- ❌ **Violation**: Labor Standards Act Article 24 (Overtime Pay)
- ⚠️ **Risk**: Users acted on incorrect advice, may face penalties
- ⚠️ **Liability**: Company liable for providing incorrect legal information
- 🔴 **Urgency**: Immediate fix and user notification required

#### User Scenarios Affected
1. **Scenario A**: Employee calculates overtime pay expectations
   - Impact: Employee expects lower amount than legally entitled
   - Risk: Employee doesn't claim full entitlement

2. **Scenario B**: Employer uses tool for payroll calculation
   - Impact: Employer underpays employees
   - Risk: Labor inspection penalties, employee lawsuits

3. **Scenario C**: HR professional verifies compliance
   - Impact: Receives incorrect compliance assessment
   - Risk: Company non-compliant without knowing

---

### Related Defects

#### Duplicate Issues
- DEF-2156: Overtime calculation wrong for holidays (Same root cause)
- DEF-2201: Weekend overtime rate incorrect (Same module)

#### Related Issues
- DEF-2089: Missing validation for negative hours (Same module, different issue)
- DEF-1987: UI doesn't show calculation breakdown (Enhancement request)

#### Similar Historical Issues
- DEF-1654 (v1.5.0): Leave calculation formula error (Similar pattern)
- DEF-1203 (v1.2.0): Holiday pay rate incorrect (Legal compliance issue)

**Pattern Identified**: Legal calculation modules have recurring formula errors
**Systemic Issue**: Need better legal validation process

---

### Fix Recommendation

#### Immediate Fix (Emergency Patch)
**Priority**: P0 - Emergency
**Target**: Deploy within 4 hours
**Approach**:
1. Implement correct tiered calculation formula
2. Add unit tests for all tiers (2h, 4h, 8h scenarios)
3. Cross-validate against government calculator
4. Deploy to production with emergency change approval

**Code Fix** (High-level):
```python
# File: labor_law_assistant/calculators/overtime_calculator.py
# Function: calculate_weekday_overtime()
# Change: Implement tiered multipliers per Labor Standards Act Article 24
```

#### Verification Steps
- [ ] Unit tests pass (15 new tests added)
- [ ] Integration tests pass
- [ ] Manual testing with government calculator (100% match)
- [ ] Legal team review and approval
- [ ] Peer review by 2 senior developers
- [ ] QA verification in staging
- [ ] Smoke tests in production after deploy

#### Rollback Plan
- **Trigger**: If fix causes new issues or tests fail
- **Approach**: Rollback to v2.1.0, apply hotfix patch with correct formula
- **Data**: Recalculate affected historical records in database

---

### Prevention Measures

#### Short-term (This Sprint)
| Action | Owner | Status | ETA |
|--------|-------|--------|-----|
| Add automated cross-validation with govt calculator | Dev Team | 🔴 | 3 days |
| Increase legal module test coverage to 95% | QA Team | 🔴 | 5 days |
| Add legal accuracy checklist to code review | Tech Lead | 🔴 | 1 day |
| Conduct legal compliance training for dev team | HR + Legal | 🔴 | 1 week |

#### Long-term (Next Quarter)
| Action | Owner | Status | Target |
|--------|-------|--------|--------|
| Implement mutation testing for all legal formulas | QA Lead | 🔴 | Q2 2024 |
| Create legal formula test library with edge cases | QA Team | 🔴 | Q2 2024 |
| Establish quarterly legal compliance audit | Legal + QA | 🔴 | Q2 2024 |
| Integrate MOL (Ministry of Labor) API for validation | Dev Lead | 🟡 | Q3 2024 |

#### Process Improvements
1. **Code Review Process**
   - Add "Legal Accuracy Verification" section to review checklist
   - Require legal team review for any formula changes
   - Mandate cross-validation test for all legal calculations

2. **Testing Process**
   - Require 95% coverage for all legal modules (no exceptions)
   - Mandate mutation testing for all calculation functions
   - Add automated comparison with government calculators

3. **Deployment Process**
   - Add legal compliance gate to deployment pipeline
   - Require legal sign-off for releases touching legal code
   - Implement canary deployment for legal module changes

4. **Training**
   - Quarterly labor law update sessions for dev team
   - Legal compliance certification for developers working on legal code
   - Document common legal calculation patterns and pitfalls

---

### Communication Plan

#### Internal Communication
| Stakeholder | Message | Channel | Priority | Status |
|-------------|---------|---------|----------|--------|
| Engineering Team | Critical bug found, emergency fix needed | Slack + Email | 🔴 Urgent | ✅ Sent |
| QA Team | Regression tests failed, assist with verification | Slack | 🔴 Urgent | ✅ Sent |
| Product Team | Feature affected, user communication needed | Email + Meeting | 🔴 Urgent | ⏰ Scheduled |
| Legal Team | Legal compliance issue, review required | Email | 🔴 Urgent | ✅ Sent |
| Management | Business impact assessment | Meeting | 🔴 Urgent | ⏰ Scheduled |

#### User Communication
**Approach**: Proactive disclosure with solution

**Email Template** (After fix deployed):
```
Subject: Important Update: Overtime Calculator Correction

Dear [User Name],

We have identified and fixed an issue in our overtime pay calculator
that affected calculations performed between January 15 and February 4, 2024.

What happened:
- The calculator used an incorrect overtime rate formula
- Affected: Weekday overtime calculations only

What we've done:
- Fixed the calculation formula
- Verified accuracy against government standards
- Enhanced testing to prevent similar issues

What you should do:
- Recalculate any overtime pay from the affected period
- Review our corrected calculation guide [link]
- Contact support@example.com with questions

We sincerely apologize for any inconvenience.

[Company Name] Team
```

**User Notice** (On platform):
```
⚠️ IMPORTANT NOTICE
Our overtime calculator had an error affecting calculations
from Jan 15 - Feb 4, 2024. The issue is now fixed.
If you used the calculator during this period, please recalculate.
[Learn More]
```

---

### Resolution Tracking

#### Fix Progress
| Stage | Status | Owner | Completed | Notes |
|-------|--------|-------|-----------|-------|
| Root cause identified | ✅ | Dev Team | 2024-02-04 14:00 | Logic error in formula |
| Fix implemented | 🟡 | Dev Team | In Progress | ETA: 2024-02-04 16:00 |
| Tests written | 🔴 | QA Team | Not Started | ETA: 2024-02-04 17:00 |
| Code review | 🔴 | Tech Lead | Pending | Awaiting fix completion |
| Legal review | 🔴 | Legal Team | Pending | Awaiting fix completion |
| Deployed to staging | 🔴 | DevOps | Pending | - |
| QA verification | 🔴 | QA Lead | Pending | - |
| Deployed to production | 🔴 | Release Mgr | Pending | Emergency change |
| User notification sent | 🔴 | Product Mgr | Pending | After production deploy |
| Defect closed | 🔴 | QA Lead | Pending | After verification |

#### Timeline
- **Reported**: 2024-02-04 10:00
- **Started**: 2024-02-04 10:30
- **Target Fix**: 2024-02-04 18:00 (8 hours)
- **Actual Fix**: TBD
- **Target Deploy**: 2024-02-04 20:00
- **Actual Deploy**: TBD

---

### Defect Metrics

#### Resolution Time Targets (by Severity)
| Severity | Target Time to Fix | Target Time to Deploy | This Defect |
|----------|-------------------|----------------------|-------------|
| 🔴 Critical | < 4 hours | < 8 hours | In Progress (4h elapsed) |
| 🟠 High | < 24 hours | < 48 hours | N/A |
| 🟡 Medium | < 3 days | < 5 days | N/A |
| 🟢 Low | < 7 days | Next sprint | N/A |

#### Defect Lifecycle
```
[New] → [Triaged] → [In Progress] → [Fixed] → [Verification] → [Closed]
  ↓                                              ↑
  └──────────────[Reopened]────────────────────┘
```

**Current Stage**: In Progress
**Time in Stage**: 4 hours
**Total Age**: 8 hours

---

### Attachments

- [ ] Screenshots of issue (3 files)
- [ ] Screen recording of reproduction steps (video)
- [ ] Test data export (CSV)
- [ ] Government calculator comparison (PDF)
- [ ] Code diff showing bug (link)
- [ ] Impact analysis spreadsheet (Excel)
- [ ] User complaint examples (3 tickets)

---

### Sign-off

#### Defect Verification
| Role | Name | Date | Status | Notes |
|------|------|------|--------|-------|
| QA Tester | | | ⏳ Pending | Awaiting fix deployment |
| QA Lead | | | ⏳ Pending | Final verification required |
| Product Owner | | | ⏳ Pending | Approve user communication |
| Legal Reviewer | | | ⏳ Pending | Verify legal compliance |
| Release Manager | | | ⏳ Pending | Approve emergency deploy |

#### Post-Mortem Required
- [x] Yes - Critical defect with legal impact requires post-mortem
- [ ] Schedule post-mortem meeting: 2024-02-05 10:00
- [ ] Document lessons learned: [link to post-mortem doc]
```

---

## Severity Classification Matrix

| Severity | Criteria | Legal Calculation Impact | Response Time |
|----------|----------|--------------------------|---------------|
| 🔴 Critical | System down, data loss, legal violation, security breach | Incorrect legal formula, violation of law | Immediate (< 4h) |
| 🟠 High | Major feature broken, affects many users | Calculation 10%+ off, affects accuracy | Same day (< 24h) |
| 🟡 Medium | Feature degraded, workaround exists | Minor inaccuracy, doesn't affect compliance | 1-3 days |
| 🟢 Low | Cosmetic, rare edge case | No legal impact, UI issue only | Next sprint |

---

## Defect Type Taxonomy

### Legal Calculation Error
- Formula incorrect
- Missing legal provision
- Outdated law reference
- Calculation rounding error
- Edge case not handled

### Security Vulnerability
- Authentication bypass
- Authorization flaw
- Data exposure
- Injection vulnerability
- Cryptographic weakness

### Performance Issue
- Slow response time
- Memory leak
- Database query inefficiency
- Infinite loop
- Resource exhaustion

### Data Corruption
- Data loss
- Inconsistent data state
- Database constraint violation
- Transaction rollback failure
- Concurrent modification issue

### UI/UX Issue
- Layout broken
- Accessibility violation
- Usability problem
- Localization error
- Browser compatibility issue

---

## Best Practices

- **Always include reproduction steps** - If you can't reproduce, you can't fix
- **Legal errors are always Critical/High** - No exceptions for labor law system
- **Document expected vs actual** with specific values
- **Cross-reference government standards** for legal calculations
- Include **business impact** not just technical details
- **Track prevention measures** to avoid recurrence
- **Conduct post-mortem** for Critical/High severity defects
- **Communicate proactively** to affected users
- **Update related documentation** after fix
- **Link to similar historical issues** to identify patterns

---

## Example Usage

Input: `/defect-report Overtime calculator shows wrong amount for 8-hour overtime`

Output: [Full defect report as shown above with all sections populated]
