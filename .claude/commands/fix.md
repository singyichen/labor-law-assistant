# Fix - Bug Fix Workflow

Investigate, fix, and verify bugs by orchestrating diagnostic and quality skills.

## Arguments

- `$ARGUMENTS`: Bug description, defect ID, or error symptom

## Workflow Steps

### Step 1: Document the Defect

Use the **defect-report** skill to create a comprehensive bug report for `$ARGUMENTS`.

- Classify severity (Critical/High/Medium/Low)
- Document reproduction steps
- Identify affected components and legal articles if applicable
- Perform initial root cause analysis
- Auto-classify legal calculation errors as Critical

### Step 2: Exploratory Testing

Use the **exploratory-testing** skill to investigate the bug scope.

- Create a focused test charter around the bug area
- Explore related functionality for similar issues
- Test boundary conditions and edge cases
- Document all findings and additional issues discovered
- Apply legal-specific heuristics (SFDPOT + legal compliance)

### Step 3: Design Regression Scenarios

Use the **bdd-scenario** skill to create test scenarios that cover the fix.

- Write scenarios that reproduce the original bug
- Add scenarios for related edge cases discovered during exploration
- Include Scenario Outlines for data-driven verification
- Ensure scenarios prevent regression of the fix

### Step 4: Review the Fix

After implementing the fix, use the **code-review** skill to verify quality.

- Confirm the fix addresses the root cause
- Check for unintended side effects
- Verify legal calculation accuracy if applicable
- Ensure code quality and security standards are met

### Step 5: Regression Verification

Use the **regression-suite** skill to plan post-fix regression testing.

- Identify impacted modules and test scope
- Run targeted regression around the fixed area
- Verify no existing functionality is broken
- Confirm legal modules maintain full regression pass

## Output

At each step, present the output to the user and confirm before proceeding to the next step.
Provide a final summary with:
- Root cause and fix description
- Test scenarios added
- Regression verification results
