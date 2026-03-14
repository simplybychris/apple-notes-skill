#!/bin/bash
# Update an existing note (full content replacement) in a specific folder
# All parameters passed via argv (safe from shell injection)
#
# Usage: ./update-note.sh <folder> <note_name> <new_content> [account]
# Returns: "OK: <note_name>" on success

FOLDER="$1"
NOTE_NAME="$2"
NEW_CONTENT="$3"
ACCOUNT="${4:-iCloud}"

if [ -z "$FOLDER" ] || [ -z "$NOTE_NAME" ] || [ -z "$NEW_CONTENT" ]; then
    echo "Error: folder, note name, and content are required"
    echo "Usage: $0 <folder> <note_name> <new_content> [account]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_NAME" "$NEW_CONTENT" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteName to item 3 of argv
    set newBody to item 4 of argv

    tell application "Notes"
        try
            set theNote to note noteName in folder folName of account accName
            set formattedBody to "<div>" & newBody & "</div>"
            set body of theNote to formattedBody
            return "OK: " & noteName
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
