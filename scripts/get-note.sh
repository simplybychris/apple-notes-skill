#!/bin/bash
# Read a specific note by exact name from a specific folder
# All parameters passed via argv (safe from shell injection)
#
# Usage: ./get-note.sh <folder> <note_name> [account]
# Returns: note HTML body on success

FOLDER="$1"
NOTE_NAME="$2"
ACCOUNT="${3:-iCloud}"

if [ -z "$FOLDER" ] || [ -z "$NOTE_NAME" ]; then
    echo "Error: folder and note name are required"
    echo "Usage: $0 <folder> <note_name> [account]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv

    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            return body of theNote
        on error errMsg number errNum
            if errNum is -1719 then
                return "Error: Note '" & noteName & "' not found in folder '" & folName & "'"
            else
                return "Error: " & errMsg
            end if
        end try
    end tell
end run
APPLESCRIPT
