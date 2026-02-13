# Test - Test Planning and Execution Workflow

Plan, design, and implement tests by orchestrating testing-focused skills.

## Arguments

- `$ARGUMENTS`: Feature name, module path, or Sprint identifier

## Workflow Steps

### Step 1: Create Test Plan

Use the **test-plan** skill to create a comprehensive test plan for `$ARGUMENTS`.

- Define test strategy and scope
- Identify test resources and schedule
- Assess risks and mitigation strategies
- Set pass/fail criteria and coverage targets

### Step 2: Design BDD Scenarios

Use the **bdd-scenario** skill to design detailed test scenarios.

- Create Scenario Outlines with Examples tables for data-driven testing
- Cover happy path, error handling, and edge cases
- Include legal calculation boundary conditions
- Design scenarios for concurrent and stress conditions if applicable

### Step 3: Plan Test Data

Use the **test-data-strategy** skill to define test data requirements.

- Categorize test data (valid, invalid, boundary, legal-specific)
- Define data generation approaches
- Address privacy and masking requirements
- Plan test data for legal calculation verification

### Step 4: Implement Step Definitions

Use the **bdd-step-definition** skill to generate pytest-bdd step definitions.

- Map Gherkin steps to Python functions
- Include proper fixtures and setup/teardown
- Add assertions for expected outcomes
- Handle error scenarios and validation

### Step 5: Analyze Test Coverage

Use the **test-coverage** skill to evaluate test completeness.

- Measure line, branch, and path coverage
- Identify untested code paths
- Verify legal modules meet 95% threshold
- Recommend additional test cases for gaps

### Step 6: Track Progress

Use the **test-tracking** skill to set up progress monitoring.

- Create test execution dashboard
- Track pass/fail rates and trends
- Monitor bug discovery and resolution velocity
- Predict completion timeline

## Output

At each step, present the output to the user and confirm before proceeding to the next step.
