#!/bin/bash
# check-spec.sh - PreToolUse hook to enforce "write docs before code"
#
# Blocks source code file creation/editing when no spec exists
# in .claude/docs/specs/pending/. Allows documentation, config,
# and infrastructure files unconditionally.
#
# Exit behavior:
#   exit 0 with no stdout   = allow
#   exit 0 with JSON stdout = allow or deny (via permissionDecision)
#   exit 2 with stderr      = block (fallback)

set -euo pipefail

# Deny message used when no spec is found
readonly SPEC_REQUIRED_MSG='No spec found in .claude/docs/specs/pending/. Before writing source code, please create a spec document first.\n\n1. Use the template: .claude/docs/specs/_spec-template.md\n2. Save your spec to: .claude/docs/specs/pending/<feature-name>-spec.md\n3. Then retry your code changes.\n\nThis project follows a \"write docs before code\" workflow.'

INPUT=$(cat)

# Extract file_path from tool_input (Write and Edit both have file_path)
FILE_PATH=$(echo "$INPUT" | jq -r '.tool_input.file_path // empty')

# If no file_path or null, allow (safety fallback)
if [ -z "$FILE_PATH" ] || [ "$FILE_PATH" = "null" ]; then
  exit 0
fi

# Get the project directory
PROJECT_DIR=$(echo "$INPUT" | jq -r '.cwd // empty')
if [ -z "$PROJECT_DIR" ] || [ "$PROJECT_DIR" = "null" ]; then
  exit 0
fi

# --- Allowlist: files that never require a spec ---

# 1. Anything under .claude/ (specs, hooks, commands, skills, agents)
if [[ "$FILE_PATH" == *"/.claude/"* ]] || [[ "$FILE_PATH" == ".claude/"* ]]; then
  exit 0
fi

# 2. Anything under docs/ directory
if [[ "$FILE_PATH" == *"/docs/"* ]] || [[ "$FILE_PATH" == "docs/"* ]]; then
  exit 0
fi

# 3. Any markdown file anywhere
if [[ "$FILE_PATH" == *.md ]]; then
  exit 0
fi

# 4. Config files
case "$FILE_PATH" in
  *.json|*.yaml|*.yml|*.toml|*.cfg|*.ini|*.env|*.env.*)
    exit 0
    ;;
esac

# 5. Git scaffolding
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  .gitkeep|.gitignore|.gitattributes|.pre-commit-config.yaml)
    exit 0
    ;;
esac

# 6. Build infrastructure files
case "$BASENAME" in
  Dockerfile|Makefile|Procfile|Taskfile.yml)
    exit 0
    ;;
esac
if [[ "$BASENAME" == docker-compose* ]]; then
  exit 0
fi

# 7. Dependency / lock files
case "$BASENAME" in
  requirements*.txt|pyproject.toml|uv.lock|poetry.lock|Pipfile|Pipfile.lock|package.json|package-lock.json)
    exit 0
    ;;
esac

# --- Check for active specs in pending/ ---

SPEC_DIR="$PROJECT_DIR/.claude/docs/specs/pending"

# Helper: output deny JSON and exit
deny_no_spec() {
  jq -n --arg msg "$SPEC_REQUIRED_MSG" '{
    hookSpecificOutput: {
      hookEventName: "PreToolUse",
      permissionDecision: "deny",
      permissionDecisionReason: $msg
    }
  }'
  exit 0
}

# If the pending directory does not exist, block
if [ ! -d "$SPEC_DIR" ]; then
  deny_no_spec
fi

# Count markdown files in pending/ (excluding .gitkeep)
SPEC_COUNT=$(find "$SPEC_DIR" -maxdepth 1 -name "*.md" -type f 2>/dev/null | wc -l | tr -d ' ')

if [ "$SPEC_COUNT" -eq 0 ]; then
  deny_no_spec
fi

# Spec exists in pending/ -- allow code writing
exit 0
