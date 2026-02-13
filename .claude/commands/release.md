# Release - Release Preparation Workflow

Prepare for a release by orchestrating quality assurance and verification skills.

## Arguments

- `$ARGUMENTS`: Version number, release name, or environment target

## Workflow Steps

### Step 1: Plan Regression Testing

Use the **regression-suite** skill to create a regression test plan for `$ARGUMENTS`.

- Identify risk-based test prioritization
- Distinguish smoke vs full regression scope
- Mark legal calculation modules for mandatory full regression
- Recommend automated vs manual test allocation

### Step 2: Verify Traceability

Use the **traceability-matrix** skill to validate requirement coverage.

- Build forward traceability (requirements to tests)
- Build backward traceability (tests to requirements)
- Map legal articles to test cases
- Identify coverage gaps and untested requirements

### Step 3: Check Test Coverage

Use the **test-coverage** skill to verify coverage thresholds.

- Confirm legal modules meet 95% coverage requirement
- Confirm general modules meet 80% coverage requirement
- Identify critical paths without adequate testing
- Flag any coverage regressions from previous release

### Step 4: Evaluate Quality Gates

Use the **quality-gate** skill to make a Go/No-Go decision.

- Evaluate all quality criteria (code, build, test, deployment)
- Check legal compliance blocking criteria
- Verify security scan results
- Assess performance benchmark compliance
- Provide clear Go/No-Go recommendation with justification

### Step 5: Generate Release Test Report

Use the **test-report** skill to create a comprehensive release report.

- Summarize test execution results
- Document coverage metrics and trends
- Include legal compliance verification status
- List known issues and risk assessment
- Provide release sign-off checklist

## Output

Present a final release readiness summary with:
- Quality gate status (Pass/Fail for each criterion)
- Risk assessment and known issues
- Go/No-Go recommendation
- Release sign-off checklist
