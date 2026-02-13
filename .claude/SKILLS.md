# Claude Code Skills & Commands Directory

This document provides a comprehensive overview of all available Workflow Commands and Knowledge-Domain Skills for the Labor Law Assistant project.

## Directory Structure

```
.claude/
├── commands/              # Workflow Commands (orchestrate multiple skills)
│   ├── write.md           # New feature implementation
│   ├── review.md          # Code review
│   ├── test.md            # Test planning & execution
│   ├── release.md         # Release preparation
│   └── fix.md             # Bug fix
├── skills/                # Knowledge-Domain Skills (28 total)
│   ├── requirements-engineering/
│   │   ├── user-story/
│   │   ├── functional-req/
│   │   ├── acceptance-criteria/
│   │   └── requirement-to-ac/
│   ├── system-design/
│   │   ├── api-spec/
│   │   ├── backend-spec/
│   │   ├── frontend-spec/
│   │   ├── data-model/
│   │   └── flowchart/
│   ├── behavior-driven-development/
│   │   ├── ac-to-feature/
│   │   ├── bdd-feature/
│   │   ├── bdd-scenario/
│   │   └── bdd-step-definition/
│   ├── code-quality/
│   │   ├── CODE_REVIEW_GUIDE.md
│   │   ├── code-review/
│   │   ├── code-review-checklist/
│   │   ├── pr-review/
│   │   ├── code-smell/
│   │   └── git-branch/
│   ├── test-engineering/
│   │   ├── test-plan/
│   │   ├── test-coverage/
│   │   ├── test-data-strategy/
│   │   ├── test-tracking/
│   │   ├── exploratory-testing/
│   │   └── regression-suite/
│   └── quality-assurance/
│       ├── quality-gate/
│       ├── defect-report/
│       ├── traceability-matrix/
│       └── test-report/
└── SKILLS.md              # This file
```

---

## Workflow Commands

Workflow Commands orchestrate multiple skills in sequence to accomplish common development tasks. Use them as slash commands.

| Command | Purpose | Skills Orchestrated |
|---------|---------|---------------------|
| `/write` | Implement a new feature end-to-end | user-story → requirement-to-ac → ac-to-feature → bdd-feature → system-design → code-review |
| `/review` | Comprehensive code review | code-review-checklist → code-review → code-smell → pr-review |
| `/test` | Test planning and execution | test-plan → bdd-scenario → test-data-strategy → bdd-step-definition → test-coverage → test-tracking |
| `/release` | Release readiness verification | regression-suite → traceability-matrix → test-coverage → quality-gate → test-report |
| `/fix` | Bug investigation and fix | defect-report → exploratory-testing → bdd-scenario → code-review → regression-suite |

### Usage Examples

```bash
# Implement a new overtime calculation feature
/write overtime pay calculation for hourly workers

# Review code changes before PR
/review app/calculators/overtime.py

# Plan and execute tests for a Sprint
/test Sprint 7 - Annual Leave Features

# Prepare for release v1.2.0
/release v1.2.0 production

# Fix a bug in severance calculation
/fix severance pay calculation returns incorrect result for part-time workers
```

---

## Knowledge-Domain Skills

### Requirements Engineering (4 skills)

Skills for defining, converting, and validating requirements.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/user-story` | Create User Stories with acceptance criteria and story points | `/user-story overtime pay calculation` |
| `/functional-req` | Write functional and non-functional requirements | `/functional-req annual leave module` |
| `/acceptance-criteria` | Generate comprehensive AC checklists for verification | `/acceptance-criteria overtime feature` |
| `/requirement-to-ac` | Convert User Story to testable SMART AC with legal references | `/requirement-to-ac overtime pay calculation` |

### System Design (5 skills)

Skills for designing APIs, services, data models, and architecture.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/api-spec` | Design RESTful API specifications | `/api-spec overtime calculation endpoints` |
| `/backend-spec` | Generate backend service architecture specs | `/backend-spec overtime calculator service` |
| `/frontend-spec` | Generate frontend component specifications | `/frontend-spec overtime input form` |
| `/data-model` | Design database schemas and ER diagrams | `/data-model employee work records` |
| `/flowchart` | Generate Mermaid flowcharts for business processes | `/flowchart overtime calculation process` |

### Behavior-Driven Development (4 skills)

Skills for BDD workflow from acceptance criteria to executable tests.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/ac-to-feature` | Transform AC into Gherkin feature files | `/ac-to-feature AC-001 overtime calculation` |
| `/bdd-feature` | Write complete Gherkin Feature files | `/bdd-feature overtime pay calculation` |
| `/bdd-scenario` | Design detailed scenarios with Scenario Outlines | `/bdd-scenario edge cases for annual leave` |
| `/bdd-step-definition` | Implement pytest-bdd step definitions | `/bdd-step-definition overtime calculation steps` |

### Code Quality (5 skills)

Skills for code review, PR evaluation, technical debt management, and git branch workflow.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/code-review` | Comprehensive code review (quality, security, legal accuracy) | `/code-review app/calculators/overtime.py` |
| `/code-review-checklist` | Generate project-specific review checklists | `/code-review-checklist legal` |
| `/pr-review` | Full PR review with breaking changes detection | `/pr-review #123` |
| `/code-smell` | Detect code smells and suggest refactoring | `/code-smell app/services/` |
| `/git-branch` | Standardized git branch lifecycle (create, PR, merge, cleanup) | `/git-branch overtime calculator feature` |

See [CODE_REVIEW_GUIDE.md](skills/code-quality/CODE_REVIEW_GUIDE.md) for detailed code review usage guide.

### Test Engineering (6 skills)

Skills for test planning, execution, data management, and coverage analysis.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/test-plan` | Create comprehensive test plans with strategy and risk assessment | `/test-plan Sprint 6` |
| `/test-coverage` | Analyze test coverage with legal module focus (95% threshold) | `/test-coverage app/calculators/` |
| `/test-data-strategy` | Define test data management with privacy compliance | `/test-data-strategy overtime module` |
| `/test-tracking` | Track test execution progress with dashboards | `/test-tracking Sprint 6 dashboard` |
| `/exploratory-testing` | Guide exploratory testing sessions with charters | `/exploratory-testing overtime edge cases` |
| `/regression-suite` | Plan risk-based regression testing | `/regression-suite v2.0.0 release` |

### Quality Assurance (4 skills)

Skills for quality gates, defect management, traceability, and reporting.

| Skill | Purpose | Example Usage |
|-------|---------|---------------|
| `/quality-gate` | Evaluate quality gates for release readiness (Go/No-Go) | `/quality-gate production v1.0.0` |
| `/defect-report` | Create standardized defect reports with root cause analysis | `/defect-report overtime calculation error` |
| `/traceability-matrix` | Build requirement-to-test traceability with legal article mapping | `/traceability-matrix overtime module` |
| `/test-report` | Generate Sprint/Release test reports | `/test-report sprint Sprint 6 summary` |

---

## Quick Reference

| Domain | Count | Skills |
|--------|-------|--------|
| Requirements Engineering | 4 | user-story, functional-req, acceptance-criteria, requirement-to-ac |
| System Design | 5 | api-spec, backend-spec, frontend-spec, data-model, flowchart |
| Behavior-Driven Development | 4 | ac-to-feature, bdd-feature, bdd-scenario, bdd-step-definition |
| Code Quality | 5 | code-review, code-review-checklist, pr-review, code-smell, git-branch |
| Test Engineering | 6 | test-plan, test-coverage, test-data-strategy, test-tracking, exploratory-testing, regression-suite |
| Quality Assurance | 4 | quality-gate, defect-report, traceability-matrix, test-report |
| **Total** | **28** | |

---

## Legal Module Special Requirements

For the Labor Law Assistant project, these skills have special considerations for legal modules:

| Skill | Legal Requirement |
|-------|-------------------|
| `/test-coverage` | Legal modules require 95% coverage (vs 80% general) |
| `/code-review` | Must verify law article references and calculations |
| `/code-review-checklist legal` | Includes government calculator cross-validation |
| `/quality-gate` | Legal compliance is a blocking criterion |
| `/test-report legal` | Includes legal compliance verification section |
| `/traceability-matrix` | Maps law articles to test cases |
| `/regression-suite` | Legal modules always require full regression |
| `/defect-report` | Legal calculation errors auto-marked as Critical |

---

## Related Documentation

- **[CLAUDE.md](../CLAUDE.md)**: Project coding standards and conventions
- **[AGENTS.md](AGENTS.md)**: Reference for available AI agents
- **[CODE_REVIEW_GUIDE.md](skills/code-quality/CODE_REVIEW_GUIDE.md)**: Detailed code review usage guide

---

*Last Updated: 2026-02-13*
*Total Skills: 28 | Workflow Commands: 5*
