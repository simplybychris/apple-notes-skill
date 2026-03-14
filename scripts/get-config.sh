#!/bin/bash
# Read saved folder config
# Returns JSON: {"folder":"X","account":"Y"} or "NOT_CONFIGURED"
#
# Usage: ./get-config.sh <skill_dir>

SKILL_DIR="${1:-.}"
CONFIG_FILE="$SKILL_DIR/config.json"

if [ -f "$CONFIG_FILE" ]; then
    cat "$CONFIG_FILE"
else
    echo "NOT_CONFIGURED"
fi
