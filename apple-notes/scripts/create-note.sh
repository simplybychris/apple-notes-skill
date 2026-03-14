#!/bin/bash
# Create a new note in a specific folder
# All parameters passed via argv (safe from shell injection)
#
# Usage: ./create-note.sh <folder> <title> [content] [account]
# Returns: "OK: <title>" on success

FOLDER="$1"
NOTE_TITLE="$2"
NOTE_CONTENT="${3:-}"
ACCOUNT="${4:-iCloud}"

if [ -z "$FOLDER" ] || [ -z "$NOTE_TITLE" ]; then
    echo "Error: folder and title are required"
    echo "Usage: $0 <folder> <title> [content] [account]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" "$NOTE_TITLE" "$NOTE_CONTENT" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv
    set noteTitle to item 3 of argv
    set noteBody to item 4 of argv

    tell application "Notes"
        try
            tell account accName
                set theFolder to folder folName
                if noteBody is not "" then
                    set formattedBody to "<div>" & noteBody & "</div>"
                else
                    set formattedBody to ""
                end if
                set newNote to make new note at theFolder with properties {name:noteTitle, body:formattedBody}
                return "OK: " & noteTitle
            end tell
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run
APPLESCRIPT
