#!/bin/bash
# List all folders in Apple Notes for a given account
# Used ONLY to help user pick their working folder
#
# Usage: ./list-folders.sh [account]
# Returns: one folder name per line

ACCOUNT="${1:-iCloud}"

osascript - "$ACCOUNT" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    tell application "Notes"
        try
            set folderList to every folder in account accName
            set folderNames to {}
            repeat with fldr in folderList
                set end of folderNames to name of fldr
            end repeat
            set AppleScript's text item delimiters to linefeed
            return folderNames as string
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
APPLESCRIPT
