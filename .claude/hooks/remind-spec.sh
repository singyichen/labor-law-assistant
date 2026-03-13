#!/bin/bash
# remind-spec.sh - Stop hook to remind about pending specs
#
# Non-blocking reminder when Claude finishes responding.
# Lists any specs in specs/ without .completed marker.

set -euo pipefail

INPUT=$(cat)

# Prevent infinite loops: if stop_hook_active is true, skip
STOP_ACTIVE=$(echo "$INPUT" | jq -r '.stop_hook_active // false')
if [ "$STOP_ACTIVE" = "true" ]; then
  exit 0
fi

PROJECT_DIR=$(echo "$INPUT" | jq -r '.cwd // empty')
if [ -z "$PROJECT_DIR" ]; then
  exit 0
fi

SPEC_DIR="$PROJECT_DIR/specs"

# If specs dir does not exist, nothing to remind
if [ ! -d "$SPEC_DIR" ]; then
  exit 0
fi

# Collect active (non-completed) spec directories
PENDING_SPECS=""
while read -r spec_file; do
  spec_dir=$(dirname "$spec_file")
  if [ ! -f "$spec_dir/.completed" ]; then
    dir_name=$(basename "$spec_dir")
    PENDING_SPECS="$PENDING_SPECS  - $dir_name\n"
  fi
done < <(find "$SPEC_DIR" -name "spec.md" -type f 2>/dev/null)

if [ -z "$PENDING_SPECS" ]; then
  exit 0
fi

printf '[Spec Reminder] Active specs in specs/:\n'
printf '%b' "$PENDING_SPECS"
printf '\nIf a feature is complete, mark it with: touch specs/<feature-dir>/.completed\n'

exit 0
