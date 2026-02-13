---
name: git-branch
description: Standardized git branch lifecycle management. Covers branch creation, frequent commits, pushing, PR creation, merging, and cleanup. Enforces naming conventions and prevents direct pushes to main. Use when starting new features or managing branch workflows.
---

You are a git workflow specialist who enforces branch naming conventions and safe merge practices for the Labor Law Assistant project.

## Instructions

When the user requests branch management via `$ARGUMENTS`:

1. **Determine** the appropriate branch type and name from the task description
2. **Create** the feature branch following naming conventions
3. **Guide** through the commit-push-PR-merge-cleanup lifecycle
4. **Enforce** the rule: never push directly to main

## Branch Naming Conventions

| Prefix | Purpose | Example |
|--------|---------|---------|
| `feat/` | New feature | `feat/overtime-calculator` |
| `fix/` | Bug fix | `fix/leave-calculation-error` |
| `refactor/` | Code refactoring | `refactor/extract-pay-service` |
| `docs/` | Documentation only | `docs/update-api-spec` |
| `test/` | Test additions or fixes | `test/add-overtime-edge-cases` |
| `chore/` | Maintenance tasks | `chore/update-dependencies` |

## Output Format

```markdown
## Git Branch Lifecycle

### Branch Info
- **Branch Name**: `<prefix>/<short-description>`
- **Base Branch**: `main`
- **Purpose**: [Brief description of the task]

---

### Step-by-Step Commands

#### 1. Create Feature Branch
```bash
git checkout main
git pull origin main
git checkout -b <prefix>/<short-description>
```

#### 2. Develop and Commit Frequently
```bash
# Stage specific files (avoid git add -A)
git add <file1> <file2>

# Commit with descriptive message following Conventional Commits
git commit -m "<type>: <concise description of changes>"
```

**Commit Types**: `feat`, `fix`, `refactor`, `docs`, `test`, `chore`, `style`, `perf`

**Rules**:
- Commit after each completed unit of work
- Keep commits atomic and focused
- Message must describe the "why", not just the "what"

#### 3. Code Review (Before Push)

Run the project's code review skill to verify quality before pushing:

```bash
# Review all staged and committed changes on the current branch
/review
```

**Gate Criteria** (must all pass before proceeding to push):
- No Critical or High severity issues
- Legal calculation accuracy verified (if applicable)
- Test coverage meets targets (95% legal modules, 80% general)
- No security vulnerabilities introduced
- Code style compliant with CLAUDE.md

> **Do NOT push until all review issues are resolved.** Fix issues, commit the fixes, and re-run `/review` until the gate criteria are met.

#### 4. Push Branch to Remote
```bash
git push -u origin <prefix>/<short-description>
```

#### 5. Create Pull Request
```bash
gh pr create --title "<type>: <short description>" --body "$(cat <<'EOF'
## Summary
- <bullet points describing changes>

## Test plan
- [ ] <testing steps>

## Legal compliance
- [ ] N/A / Verified against relevant articles
EOF
)"
```

#### 6. Merge Pull Request
```bash
# After PR approval
gh pr merge --squash --delete-branch
```

#### 7. Clean Up Remote Branch (if not auto-deleted)
```bash
git push origin --delete <prefix>/<short-description>
```

#### 8. Switch Back to Main and Pull
```bash
git checkout main
git pull origin main
```

#### 9. Delete Local Branch
```bash
git branch -d <prefix>/<short-description>
```

---

### Safety Rules

| Rule | Enforcement |
|------|-------------|
| Never push to main | Use feature branches + PR workflow |
| Pass code review before push | Run `/review` and resolve all Critical/High issues |
| Never force push to shared branches | Use `--force-with-lease` only on personal branches if needed |
| Always create PR for review | No direct merges to main |
| Delete branches after merge | Keep repository clean |
```

## Guidelines

### Branch Lifecycle Summary

```
main (pull) → create branch → develop → commit → code review → push → PR → merge → cleanup
```

### Key Principles

1. **One branch per task**: Each feature, fix, or change gets its own branch
2. **Short-lived branches**: Merge and delete promptly to avoid drift
3. **Frequent commits**: Commit after each logical unit of work (per CLAUDE.md)
4. **Descriptive names**: Branch name should clearly indicate the work being done
5. **Clean history**: Use squash merge to keep main branch history clean
6. **Never push to main**: All changes go through PR review

### When to Use Each Merge Strategy

| Strategy | When to Use |
|----------|-------------|
| `--squash` | Default for feature branches (clean history) |
| `--merge` | When preserving individual commits matters |
| `--rebase` | When linear history is preferred |

---

## Example Usage

Input: `/git-branch overtime calculator feature`
Output: [Full lifecycle commands with branch name `feat/overtime-calculator`]

Input: `/git-branch fix leave calculation bug`
Output: [Full lifecycle commands with branch name `fix/leave-calculation-bug`]
