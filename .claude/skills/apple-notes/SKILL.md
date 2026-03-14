---
name: apple-notes
description: Manage notes in Apple Notes on macOS. Folder-scoped — works only within a folder the user explicitly chooses. Full CRUD (create, read, update, delete, list). Use when user asks to save, read, edit, or manage notes in Apple Notes.
---

# Apple Notes Skill

Folder-scoped Apple Notes integration for macOS. You can only operate within a folder the user explicitly tells you to use.

## Folder Setup

Before any note operation, check if a folder is already configured:

```bash
SKILL_DIR/scripts/get-config.sh "SKILL_DIR"
```

**If it returns JSON** (e.g. `{"folder":"Scenariusze","account":"iCloud"}`):
The folder is set. Use it. Don't ask again. Don't change it.

**If it returns `NOT_CONFIGURED`:**
1. Run `list-folders.sh` to show available folders
2. Ask the user: "W jakim folderze Apple Notes mam pracować?"
3. User picks a folder
4. Save it:
```bash
SKILL_DIR/scripts/set-config.sh "SKILL_DIR" "<folder>" [account]
```
5. If the folder doesn't exist, offer to create it with `create-folder.sh`, then save config

**The config persists between sessions.** Don't ask again unless the user explicitly says to change it.

**You MUST NOT:**
- Change the folder on your own
- Assume a default folder if config doesn't exist
- Operate outside the configured folder

## Scripts

Replace `SKILL_DIR` with the actual path to the directory containing `scripts/`.

### Config

```bash
SKILL_DIR/scripts/get-config.sh "SKILL_DIR"
SKILL_DIR/scripts/set-config.sh "SKILL_DIR" "<folder>" [account]
```

### Discovery

```bash
SKILL_DIR/scripts/list-accounts.sh
SKILL_DIR/scripts/list-folders.sh [account]
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

# Delete (always confirm with user first)
SKILL_DIR/scripts/delete-note.sh "<folder>" "<note_name>" [account]

# Create folder
SKILL_DIR/scripts/create-folder.sh "<folder_name>" [account]
```

## Rules

1. **NEVER operate outside the configured folder.**
2. **NEVER assume a default folder.** Read config first, ask user if not set.
3. **NEVER change the folder on your own.** Only the user can change it.
4. **Use HTML for content**, wrap in `<div>` tags:
   ```html
   <div><h1>Title</h1></div>
   <div><p>Text with <b>bold</b> and <i>italic</i>.</p></div>
   ```
5. **Special characters are safe.** All scripts use `argv`.
6. **Before deleting, confirm with the user.**

## Security

- Folder-scoped: operates only in the configured folder
- Config persisted in `config.json` next to SKILL.md, not editable by Claude without user action
- No injection: all parameters via AppleScript `argv`
- No network: pure AppleScript, no external calls
- User-driven: destructive actions require confirmation
