#!/bin/bash
# Save folder config after user confirms
# Creates config.json in the skill directory
#
# Usage: ./set-config.sh <skill_dir> <folder> [account]

SKILL_DIR="${1:-.}"
FOLDER="$2"
ACCOUNT="${3:-iCloud}"

if [ -z "$FOLDER" ]; then
    echo "Error: folder is required"
    echo "Usage: $0 <skill_dir> <folder> [account]"
    exit 1
fi

CONFIG_FILE="$SKILL_DIR/config.json"

cat > "$CONFIG_FILE" << EOF
{"folder":"$FOLDER","account":"$ACCOUNT"}
EOF

echo "OK: folder=$FOLDER account=$ACCOUNT"
