#!/bin/bash
# remind-spec.sh - Stop hook to remind about pending specs
#
# Non-blocking reminder when Claude finishes responding.
# Lists any specs still in pending/ and suggests archiving completed ones.

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

SPEC_DIR="$PROJECT_DIR/.claude/docs/specs/pending"

# If pending dir does not exist or has no specs, nothing to remind
if [ ! -d "$SPEC_DIR" ]; then
  exit 0
fi

# Collect pending spec filenames
PENDING_SPECS=$(find "$SPEC_DIR" -maxdepth 1 -name "*.md" -type f -exec basename {} \; 2>/dev/null)

if [ -z "$PENDING_SPECS" ]; then
  exit 0
fi

# Format as a bulleted list
SPEC_LIST=$(echo "$PENDING_SPECS" | sed 's/^/  - /')

cat << EOF
[Spec Reminder] Pending specs in .claude/docs/specs/pending/:
$SPEC_LIST

If a feature is complete, move its spec to .claude/docs/specs/completed/.
EOF

exit 0
