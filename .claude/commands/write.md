# Write - New Feature Implementation Workflow

Implement a new feature by orchestrating skills from requirements through development to review.

## Arguments

- `$ARGUMENTS`: Feature description or User Story reference

## Workflow Steps

### Step 1: Define User Story

Use the **user-story** skill to create a well-structured User Story for `$ARGUMENTS`.

- Define the user persona, goal, and business value
- Include acceptance criteria outline and story points
- Identify risks and dependencies

### Step 2: Convert to Acceptance Criteria

Use the **requirement-to-ac** skill to transform the User Story into testable SMART Acceptance Criteria.

- Generate detailed, verifiable conditions
- Include legal compliance requirements where applicable
- Map to relevant Taiwan labor law articles if relevant

### Step 3: Generate BDD Feature

Use the **ac-to-feature** skill to convert the Acceptance Criteria into an executable BDD feature file.

- Write complete Gherkin scenarios with Given-When-Then syntax
- Add traceability tags linking back to requirements
- Include positive, negative, and edge case scenarios

### Step 4: Expand BDD Scenarios

Use the **bdd-feature** skill to refine and expand the feature file.

- Add Scenario Outlines for data-driven testing
- Cover boundary conditions and error handling
- Ensure legal calculation scenarios are comprehensive

### Step 5: Design System Components

Based on the feature requirements, use relevant system-design skills:

- **api-spec**: Design API endpoints if the feature involves API changes
- **backend-spec**: Define backend service architecture
- **frontend-spec**: Define UI components if applicable
- **data-model**: Design database schema changes if needed
- **flowchart**: Visualize complex business logic flows

Select only the skills relevant to the feature scope.

### Step 6: Code Review Preparation

After implementation, use the **code-review** skill to perform a self-review.

- Check code quality, security, and performance
- Verify legal calculation accuracy if applicable
- Ensure all acceptance criteria are met
- Confirm test coverage meets thresholds (95% for legal modules, 80% general)

## Output

At each step, present the output to the user and confirm before proceeding to the next step.
