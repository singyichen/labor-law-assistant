#!/bin/bash
# check-spec.sh - PreToolUse hook to enforce "write docs before code"
#
# Blocks source code file creation/editing when no spec exists
# in specs/. Uses spec-kit convention: specs/NNN-feature-name/spec.md
#
# Exit behavior:
#   exit 0 with no stdout   = allow
#   exit 0 with JSON stdout = allow or deny (via permissionDecision)
#   exit 2 with stderr      = block (fallback)

set -euo pipefail

# Deny message used when no spec is found
readonly SPEC_REQUIRED_MSG='No spec found in specs/. Before writing source code, please create a spec document first.\n\n1. Run /speckit.specify <feature description> to create a spec\n2. This will create specs/NNN-feature-name/spec.md\n3. Then retry your code changes.\n\nThis project follows a \"write docs before code\" workflow (spec-kit).'

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

# 3. Anything under specs/ directory (spec-kit spec files)
if [[ "$FILE_PATH" == *"/specs/"* ]] || [[ "$FILE_PATH" == "specs/"* ]]; then
  exit 0
fi

# 4. Anything under .specify/ directory (spec-kit config)
if [[ "$FILE_PATH" == *"/.specify/"* ]] || [[ "$FILE_PATH" == ".specify/"* ]]; then
  exit 0
fi

# 5. Anything under scripts/ directory (spec-kit scripts)
if [[ "$FILE_PATH" == *"/scripts/"* ]] || [[ "$FILE_PATH" == "scripts/"* ]]; then
  exit 0
fi

# 6. Any markdown file anywhere
if [[ "$FILE_PATH" == *.md ]]; then
  exit 0
fi

# 7. Config files
case "$FILE_PATH" in
  *.json|*.yaml|*.yml|*.toml|*.cfg|*.ini|*.env|*.env.*)
    exit 0
    ;;
esac

# 8. Git scaffolding
BASENAME=$(basename "$FILE_PATH")
case "$BASENAME" in
  .gitkeep|.gitignore|.gitattributes|.pre-commit-config.yaml)
    exit 0
    ;;
esac

# 9. Build infrastructure files
case "$BASENAME" in
  Dockerfile|Makefile|Procfile|Taskfile.yml)
    exit 0
    ;;
esac
if [[ "$BASENAME" == docker-compose* ]]; then
  exit 0
fi

# 10. Dependency / lock files
case "$BASENAME" in
  requirements*.txt|pyproject.toml|uv.lock|poetry.lock|Pipfile|Pipfile.lock|package.json|package-lock.json|pnpm-lock.yaml)
    exit 0
    ;;
esac

# --- Check for active specs in specs/ ---

SPEC_DIR="$PROJECT_DIR/specs"

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

# If the specs directory does not exist, block
if [ ! -d "$SPEC_DIR" ]; then
  deny_no_spec
fi

# Search recursively for spec.md files, excluding completed specs (those with .completed marker)
ACTIVE_SPECS=0
for spec_file in $(find "$SPEC_DIR" -name "spec.md" -type f 2>/dev/null); do
  spec_dir=$(dirname "$spec_file")
  # Check if this spec directory has a .completed marker
  if [ ! -f "$spec_dir/.completed" ]; then
    ACTIVE_SPECS=$((ACTIVE_SPECS + 1))
  fi
done

if [ "$ACTIVE_SPECS" -eq 0 ]; then
  deny_no_spec
fi

# Active spec exists -- allow code writing
exit 0
