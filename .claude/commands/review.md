# Review - Code Review Workflow

Perform a comprehensive code review by orchestrating quality-focused skills.

## Arguments

- `$ARGUMENTS`: File path, directory, or PR number to review

## Workflow Steps

### Step 1: Generate Review Checklist

Use the **code-review-checklist** skill to create a project-specific checklist for `$ARGUMENTS`.

- Generate checklist items based on the type of code being reviewed
- Include Python/FastAPI best practices
- Add legal module checks if reviewing calculator or law-related code
- Include BDD testing checklist items

### Step 2: Execute Code Review

Use the **code-review** skill to perform a comprehensive review.

- Analyze code quality (naming, complexity, duplication)
- Check for security vulnerabilities (OWASP Top 10)
- Evaluate performance (N+1 queries, missing indexes)
- Verify legal calculation correctness if applicable
- Assess test coverage adequacy
- Provide severity-rated findings (Critical/High/Medium/Low)

### Step 3: Detect Code Smells

Use the **code-smell** skill to identify anti-patterns and technical debt.

- Detect common smells (Long Method, God Class, Feature Envy, etc.)
- Categorize by type (Bloaters, OOP Abusers, Change Preventers, etc.)
- Provide concrete refactoring suggestions with code examples
- Calculate technical debt score

### Step 4: PR Review (if applicable)

If `$ARGUMENTS` is a PR number, use the **pr-review** skill for full PR evaluation.

- Analyze PR description completeness
- Evaluate change scope (focused vs too large)
- Identify breaking changes and impact
- Check CI/CD status and test results
- Provide Approve/Request Changes recommendation

## Output

Consolidate findings into a single review report with:
- Summary table of all issues by severity
- Prioritized action items
- Approve/Request Changes recommendation
