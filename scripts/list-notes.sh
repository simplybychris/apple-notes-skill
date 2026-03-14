#!/bin/bash
# List all notes in a specific folder
# All parameters passed via argv (safe from shell injection)
#
# Usage: ./list-notes.sh <folder> [account]
# Returns: one line per note: "name | modified_date | preview"

FOLDER="$1"
ACCOUNT="${2:-iCloud}"

if [ -z "$FOLDER" ]; then
    echo "Error: folder is required"
    echo "Usage: $0 <folder> [account]"
    exit 1
fi

osascript - "$ACCOUNT" "$FOLDER" <<'APPLESCRIPT'
on run argv
    set accName to item 1 of argv
    set folName to item 2 of argv

    tell application "Notes"
        try
            set noteList to every note in folder folName of account accName
            set noteInfo to {}
            repeat with nte in noteList
                set noteName to name of nte
                set noteMod to modification date of nte
                set noteBody to body of nte
                set preview to ""
                if length of noteBody > 0 then
                    if length of noteBody > 80 then
                        set preview to text 1 thru 80 of noteBody
                    else
                        set preview to noteBody
                    end if
                end if
                set preview to my stripTags(preview)
                set preview to my replaceText(preview, return, " ")
                set end of noteInfo to noteName & " | " & (noteMod as string) & " | " & preview
            end repeat
            set AppleScript's text item delimiters to linefeed
            return noteInfo as string
        on error errMsg
            return "Error: " & errMsg
        end try
    end tell
end run

on replaceText(txt, srch, repl)
    set AppleScript's text item delimiters to srch
    set txtItems to text items of txt
    set AppleScript's text item delimiters to repl
    set txt to txtItems as string
    set AppleScript's text item delimiters to ""
    return txt
end replaceText

on stripTags(txt)
    set resultText to ""
    set inTag to false
    repeat with ch in characters of txt
        if ch is "<" then
            set inTag to true
        else if ch is ">" then
            set inTag to false
        else if inTag is false then
            set resultText to resultText & ch
        end if
    end repeat
    return resultText
end stripTags
APPLESCRIPT
