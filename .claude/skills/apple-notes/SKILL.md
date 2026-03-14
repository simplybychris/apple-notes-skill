---
name: apple-notes
description: Manage notes in Apple Notes on macOS. Folder-scoped — works only within a folder the user explicitly chooses. Full CRUD (create, read, update, delete, list). Use when user asks to save, read, edit, or manage notes in Apple Notes.
---

# Apple Notes Skill

Folder-scoped Apple Notes integration for macOS. You can only operate within a folder the user explicitly tells you to use.

## Folder Setup (MUST DO FIRST)

Before ANY note operation, you MUST know which folder to use. You cannot assume a default. The user MUST tell you.

### First-time setup:

1. Run `list-folders.sh` to show available folders
2. Ask the user: "W jakim folderze mam pracować z notatkami?"
3. User picks a folder (e.g. "Scenariusze")
4. Use ONLY that folder for all operations going forward
5. If the folder doesn't exist, offer to create it with `create-folder.sh`

### After setup:

The folder is set. Don't ask again. Don't change it. Don't suggest switching. If the user wants a different folder, they will tell you explicitly.

## Scripts

All scripts are in the `scripts/` directory relative to this skill. Every script that operates on notes takes `<folder>` as the FIRST argument — there is no default.

### Discovery

```bash
# List accounts
SKILL_DIR/scripts/list-accounts.sh

# List folders
SKILL_DIR/scripts/list-folders.sh [account]

# List notes in the working folder
SKILL_DIR/scripts/list-notes.sh "<folder>" [account]
```

### CRUD

```bash
# Create
SKILL_DIR/scripts/create-note.sh "<folder>" "<title>" "[content]" [account]

# Read
SKILL_DIR/scripts/get-note.sh "<folder>" "<note_name>" [account]

# Update (full replacement — to append: read first, combine, then update)
SKILL_DIR/scripts/update-note.sh "<folder>" "<note_name>" "<new_content>" [account]

# Delete
SKILL_DIR/scripts/delete-note.sh "<folder>" "<note_name>" [account]

# Create folder
SKILL_DIR/scripts/create-folder.sh "<folder_name>" [account]
```

## Rules

1. **NEVER operate outside the chosen folder.** Every script requires folder as first arg, always use the one the user picked.
2. **NEVER assume a default folder.** Ask once, then keep using it. Don't keep asking.
3. **NEVER change the folder on your own.** Only the user can switch folders.
4. **Use HTML for content**, not Markdown. Wrap in `<div>` tags:
   ```html
   <div><h1>Title</h1></div>
   <div><p>Text with <b>bold</b> and <i>italic</i>.</p></div>
   <div><ul><li>Item 1</li><li>Item 2</li></ul></div>
   ```
5. **Special characters are safe.** All scripts use `argv` parameter passing.
6. **Account defaults to "iCloud".** If user has a different account, `list-accounts.sh` will show it.
7. **Before deleting, always confirm with the user.** Deletion is permanent.

## Security

- **Folder-scoped**: operates only in the folder the user explicitly picks
- **No browsing**: won't read notes outside the working folder
- **No injection**: all parameters passed via AppleScript `argv`
- **No network**: scripts are pure AppleScript, no external calls
- **User-driven**: destructive actions require user confirmation
