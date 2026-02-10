# Claude Code Skills Directory

This document provides a comprehensive overview of all available Skills for the Labor Law Assistant project, including when and how to use them.

## Quick Reference

| Category | Count | Skills |
|----------|-------|--------|
| Requirements Conversion | 2 | requirement-to-ac, ac-to-feature |
| BDD Development | 3 | bdd-feature, bdd-scenario, bdd-step-definition |
| Quality Control | 5 | test-coverage, quality-gate, defect-report, test-plan, test-report |
| Tracking & Management | 3 | traceability-matrix, regression-suite, test-tracking |
| Advanced Testing | 2 | exploratory-testing, test-data-strategy |
| Code Review | 4 | code-review, code-review-checklist, pr-review, code-smell |
| Documentation | 8 | user-story, acceptance-criteria, api-spec, backend-spec, frontend-spec, data-model, flowchart, functional-req |
| **Total** | **27** | |

---

## Skills by Development Phase

### Phase 1: Requirements & Planning

| Skill | Purpose | When to Use | Output |
|-------|---------|-------------|--------|
| `/user-story` | Create User Stories | When PM defines new features | User Story in standard format |
| `/functional-req` | Write functional requirements | When detailing feature specifications | Functional requirements document |
| `/requirement-to-ac` | Convert User Story to Acceptance Criteria | After User Story is approved | Testable AC with legal references |
| `/ac-to-feature` | Convert AC to BDD Feature | Before development starts | Gherkin Feature file |

**Workflow:**
```
PM Request → /user-story → /requirement-to-ac → /ac-to-feature → Ready for Dev
```

---

### Phase 2: Design & Specification

| Skill | Purpose | When to Use | Output |
|-------|---------|-------------|--------|
| `/api-spec` | Design API specifications | When planning new endpoints | OpenAPI/Swagger spec |
| `/backend-spec` | Backend architecture spec | When designing backend modules | Technical specification |
| `/frontend-spec` | Frontend component spec | When designing UI components | Component specification |
| `/data-model` | Database schema design | When planning data structures | ER diagram, schema definition |
| `/flowchart` | Process flow diagrams | When documenting workflows | Mermaid/ASCII flowcharts |

**Workflow:**
```
Feature Approved → /api-spec → /backend-spec + /frontend-spec → /data-model → Ready for Dev
```

---

### Phase 3: BDD Test Development

| Skill | Purpose | When to Use | Output |
|-------|---------|-------------|--------|
| `/bdd-feature` | Write Gherkin Feature files | Before implementing feature | .feature file |
| `/bdd-scenario` | Design test scenarios | When detailing test cases | Scenario/Scenario Outline |
| `/bdd-step-definition` | Implement step definitions | When coding tests | pytest-bdd step files |
| `/test-data-strategy` | Plan test data | When preparing test environment | Data generation strategy |

**Workflow:**
```
/bdd-feature → /bdd-scenario → /test-data-strategy → /bdd-step-definition → Run Tests
```

---

### Phase 4: Development & Code Review

| Skill | Purpose | When to Use | Frequency |
|-------|---------|-------------|-----------|
| `/code-review` | Comprehensive code review | Before submitting PR | 🔴 Daily |
| `/code-review-checklist` | Generate review checklist | Before self-review | 🔴 Daily |
| `/pr-review` | Review Pull Requests | When reviewing others' PRs | 🟠 Per PR |
| `/code-smell` | Identify code smells | During refactoring | 🟡 Weekly |

**Workflow:**
```
Code Complete → /code-review-checklist → /code-review → Submit PR → /pr-review → Merge
```

---

### Phase 5: Testing & Quality Assurance

| Skill | Purpose | When to Use | Output |
|-------|---------|-------------|--------|
| `/test-plan` | Create test plan | At Sprint start | Test strategy document |
| `/test-coverage` | Analyze coverage | After test execution | Coverage report |
| `/exploratory-testing` | Guide exploratory testing | For ad-hoc testing | Charter, session notes |
| `/defect-report` | Document bugs | When bugs are found | Standardized bug report |
| `/test-tracking` | Track test progress | During Sprint | Progress dashboard |

**Workflow:**
```
Sprint Start → /test-plan → Execute Tests → /test-coverage → /test-tracking → /defect-report (if bugs)
```

---

### Phase 6: Release & Deployment

| Skill | Purpose | When to Use | Output |
|-------|---------|-------------|--------|
| `/regression-suite` | Plan regression tests | Before release | Regression test plan |
| `/traceability-matrix` | Verify requirement coverage | Before release | Traceability report |
| `/quality-gate` | Check quality criteria | Before deployment | Go/No-Go decision |
| `/test-report` | Generate test report | At Sprint/Release end | Summary report |

**Workflow:**
```
Release Candidate → /regression-suite → /traceability-matrix → /quality-gate → /test-report → Deploy
```

---

## Complete Skill Reference

### Requirements Conversion Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `requirement-to-ac` | Convert User Story to SMART Acceptance Criteria with legal references | `/requirement-to-ac 加班費計算功能` |
| `ac-to-feature` | Transform AC to Gherkin Feature with traceability tags | `/ac-to-feature AC-001 overtime calculation` |

### BDD Development Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `bdd-feature` | Write complete Gherkin Feature files | `/bdd-feature overtime pay calculation` |
| `bdd-scenario` | Design scenarios with Scenario Outline and Examples | `/bdd-scenario edge cases for annual leave` |
| `bdd-step-definition` | Implement pytest-bdd step definitions | `/bdd-step-definition overtime calculation steps` |

### Quality Control Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `test-coverage` | Analyze test coverage with legal module focus (≥95%) | `/test-coverage app/calculators/` |
| `quality-gate` | Evaluate quality gates with legal compliance check | `/quality-gate production v1.0.0` |
| `defect-report` | Create standardized defect reports | `/defect-report 加班費計算結果錯誤` |
| `test-plan` | Generate comprehensive test plans | `/test-plan Sprint 6` |
| `test-report` | Generate Sprint/Release/Legal compliance reports | `/test-report sprint Sprint 6 summary` |

### Tracking & Management Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `traceability-matrix` | Build requirement-to-test traceability | `/traceability-matrix overtime module` |
| `regression-suite` | Plan risk-based regression testing | `/regression-suite v2.0.0 release` |
| `test-tracking` | Track execution progress with dashboards | `/test-tracking Sprint 6 dashboard` |

### Advanced Testing Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `exploratory-testing` | Generate test charters and session templates | `/exploratory-testing 加班費邊界條件` |
| `test-data-strategy` | Plan test data with privacy compliance | `/test-data-strategy overtime module` |

### Code Review Skills

| Skill | Description | Example Usage |
|-------|-------------|---------------|
| `code-review` | Comprehensive code review with security & legal checks | `/code-review app/calculators/overtime.py` |
| `code-review-checklist` | Generate project-specific checklists | `/code-review-checklist legal` |
| `pr-review` | Review PRs with breaking changes detection | `/pr-review #123` |
| `code-smell` | Identify code smells and refactoring opportunities | `/code-smell app/services/` |

---

## Usage Frequency Guide

### 🔴 Daily Usage (Most Frequent)

| Skill | Trigger | Time |
|-------|---------|------|
| `/code-review` | After completing code changes | Before every PR |
| `/code-review-checklist` | Before self-review | Before every PR |
| `/bdd-scenario` | When writing tests | During development |

### 🟠 Weekly Usage

| Skill | Trigger | Time |
|-------|---------|------|
| `/pr-review` | When reviewing team PRs | 2-3 times per week |
| `/test-coverage` | After test updates | Mid-sprint |
| `/test-tracking` | Progress check | Weekly standup |
| `/defect-report` | When bugs found | As needed |

### 🟡 Per Sprint Usage

| Skill | Trigger | Time |
|-------|---------|------|
| `/test-plan` | Sprint planning | Sprint start |
| `/test-report` | Sprint review | Sprint end |
| `/code-smell` | Technical debt review | Sprint end |
| `/traceability-matrix` | Coverage verification | Before release |

### 🟢 Per Release Usage

| Skill | Trigger | Time |
|-------|---------|------|
| `/regression-suite` | Release preparation | Before release |
| `/quality-gate` | Go/No-Go decision | Before deployment |
| `/test-report release` | Release documentation | After release |

### 🔵 On-Demand Usage

| Skill | Trigger | Time |
|-------|---------|------|
| `/requirement-to-ac` | New feature request | When requirements arrive |
| `/ac-to-feature` | Feature development start | After AC approval |
| `/exploratory-testing` | Ad-hoc testing needed | When exploring edge cases |
| `/test-data-strategy` | New module development | When planning tests |

---

## Workflow Examples

### Example 1: New Feature Development

```bash
# 1. Requirements Phase
/requirement-to-ac 資遣費計算功能

# 2. Convert to BDD
/ac-to-feature 資遣費計算 AC

# 3. Write Feature file
/bdd-feature severance pay calculation

# 4. Design scenarios
/bdd-scenario 資遣費計算邊界條件

# 5. Plan test data
/test-data-strategy severance calculation

# 6. Implement steps
/bdd-step-definition severance calculation steps

# 7. Code review before PR
/code-review-checklist legal
/code-review app/calculators/severance.py

# 8. Submit PR and review
/pr-review #45
```

### Example 2: Sprint Workflow

```bash
# Sprint Start
/test-plan Sprint 7 - Annual Leave Features

# During Sprint
/test-tracking Sprint 7 progress
/defect-report 特休計算錯誤    # if bugs found

# Before Release
/regression-suite v1.2.0
/traceability-matrix annual leave module
/test-coverage app/calculators/

# Release Decision
/quality-gate staging v1.2.0

# Sprint End
/test-report sprint Sprint 7 summary
```

### Example 3: Code Review Workflow

```bash
# Self Review (before PR)
/code-review-checklist           # General checklist
/code-review-checklist legal     # Legal module checklist
/code-review app/calculators/    # Automated review

# Peer Review (reviewing PR)
/pr-review #123                  # Full PR review
/code-smell app/services/        # Check for code smells

# Fix issues and re-review
/code-review app/calculators/overtime.py
```

### Example 4: Bug Investigation

```bash
# Document the bug
/defect-report 加班費計算在跨月時結果錯誤

# Exploratory testing
/exploratory-testing 加班費跨月計算邊界條件

# After fix - verify coverage
/test-coverage app/calculators/overtime.py
/regression-suite overtime module
```

---

## Legal Module Special Requirements

For the Labor Law Assistant project, these skills have special considerations for legal modules:

| Skill | Legal Requirement |
|-------|-------------------|
| `/test-coverage` | Legal modules require ≥95% coverage (vs 80% general) |
| `/code-review` | Must verify law article references and calculations |
| `/code-review-checklist legal` | Includes government calculator cross-validation |
| `/quality-gate` | Legal compliance is a blocking criterion |
| `/test-report legal` | Includes legal compliance verification section |
| `/traceability-matrix` | Maps law articles to test cases |
| `/regression-suite` | Legal modules always require full regression |
| `/defect-report` | Legal calculation errors auto-marked as Critical |

---

## Integration with CI/CD

### Pre-commit Hook
```bash
/code-review-checklist
/code-review ${CHANGED_FILES}
```

### PR Check
```bash
/pr-review ${PR_NUMBER}
/test-coverage
```

### Pre-deployment
```bash
/quality-gate ${ENVIRONMENT} ${VERSION}
/regression-suite ${VERSION}
```

### Post-deployment
```bash
/test-report release ${VERSION}
```

---

## Skill Dependencies

```
User Story
    ↓
/requirement-to-ac
    ↓
/ac-to-feature ←→ /traceability-matrix
    ↓
/bdd-feature
    ↓
/bdd-scenario ←→ /test-data-strategy
    ↓
/bdd-step-definition
    ↓
/test-plan ←→ /test-tracking
    ↓
pytest-bdd execution
    ↓
/test-coverage → /quality-gate
    ↓                ↓
/defect-report   /test-report
    ↓
/regression-suite
    ↓
Release
```

---

## Quick Command Reference

| Task | Command |
|------|---------|
| Start new feature | `/requirement-to-ac [feature description]` |
| Write BDD tests | `/bdd-feature [feature name]` |
| Self code review | `/code-review [file path]` |
| Review a PR | `/pr-review #[number]` |
| Check coverage | `/test-coverage [module path]` |
| Sprint test plan | `/test-plan [sprint name]` |
| Release readiness | `/quality-gate [env] [version]` |
| Sprint report | `/test-report sprint [sprint name]` |
| Find code smells | `/code-smell [path]` |
| Document bug | `/defect-report [description]` |

---

## Related Documentation

- **AGENTS.md**: Reference for available AI agents
- **CLAUDE.md**: Project coding standards and conventions
- **CODE_REVIEW_SKILLS.md**: Detailed code review usage guide

---

*Last Updated: 2026-02-10*
*Total Skills: 27*
