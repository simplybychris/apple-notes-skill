#!/bin/bash
# List all Apple Notes accounts
# Used ONLY to help user pick their account
#
# Usage: ./list-accounts.sh
# Returns: one account name per line

osascript <<'APPLESCRIPT'
tell application "Notes"
    try
        set accountList to every account
        set accountNames to {}
        repeat with acc in accountList
            set end of accountNames to name of acc
        end repeat
        set AppleScript's text item delimiters to linefeed
        return accountNames as string
    on error errMsg
        return "Error: " & errMsg
    end try
end tell
APPLESCRIPT
