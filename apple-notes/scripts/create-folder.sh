#!/bin/bash
# Create a new folder in Apple Notes
# All parameters passed via argv (safe from shell injection)
#
# Usage: ./create-folder.sh <folder_name> [account]
# Returns: "OK: created <folder_name>" on success

FOLDER_NAME="$1"
ACCOUNT="${2:-iCloud}"

if [ -z "$FOLDER_NAME" ]; then
    echo "Error: folder name is required"
    echo "Usage: $0 <folder_name> [account]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER_NAME" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    set folderName to item 2 of argv

    tell application "Notes"
        try
            tell account accName
                try
                    set existingFolder to folder folderName
                    return "Error: Folder '" & folderName & "' already exists"
                on error
                    make new folder with properties {name:folderName}
                    return "OK: created " & folderName
                end try
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
APPLESCRIPT
