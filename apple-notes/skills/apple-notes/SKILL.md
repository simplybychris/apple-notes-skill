---
name: apple-notes
description: Manage notes in Apple Notes on macOS. Folder-scoped — works only within a folder the user explicitly chooses. Full CRUD (create, read, update, delete, list). Use when user asks to save, read, edit, or manage notes in Apple Notes.
---

# Apple Notes Skill

Folder-scoped Apple Notes integration for macOS. You can only operate within a folder the user explicitly tells you to use.

## Folder Setup

Before any note operation, check if a folder is already configured:

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/get-config.sh "${CLAUDE_PLUGIN_ROOT}"
```

**If it returns JSON** (e.g. `{"folder":"Scenariusze","account":"iCloud"}`):
The folder is set. Use it. Don't ask again. Don't change it.

**If it returns `NOT_CONFIGURED`:**
1. Run `list-folders.sh` to show available folders
2. Ask the user: "W jakim folderze Apple Notes mam pracować?"
3. User picks a folder
4. Save it:
```bash
${CLAUDE_PLUGIN_ROOT}/scripts/set-config.sh "${CLAUDE_PLUGIN_ROOT}" "<folder>" [account]
```
5. If the folder doesn't exist, offer to create it with `create-folder.sh`, then save config

**The config persists between sessions.** Don't ask again unless the user explicitly says to change it.

**You MUST NOT:**
- Change the folder on your own
- Assume a default folder if config doesn't exist
- Operate outside the configured folder

## Scripts

All paths use `${CLAUDE_PLUGIN_ROOT}` which resolves to the plugin's root directory.

### Config

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/get-config.sh "${CLAUDE_PLUGIN_ROOT}"
${CLAUDE_PLUGIN_ROOT}/scripts/set-config.sh "${CLAUDE_PLUGIN_ROOT}" "<folder>" [account]
```

### Discovery

```bash
${CLAUDE_PLUGIN_ROOT}/scripts/list-accounts.sh
${CLAUDE_PLUGIN_ROOT}/scripts/list-folders.sh [account]
${CLAUDE_PLUGIN_ROOT}/scripts/list-notes.sh "<folder>" [account]
```

### CRUD

```bash
# Create
${CLAUDE_PLUGIN_ROOT}/scripts/create-note.sh "<folder>" "<title>" "[content]" [account]

# Read
${CLAUDE_PLUGIN_ROOT}/scripts/get-note.sh "<folder>" "<note_name>" [account]

# Update (full replacement — to append: read first, combine, then update)
${CLAUDE_PLUGIN_ROOT}/scripts/update-note.sh "<folder>" "<note_name>" "<new_content>" [account]

# Delete (always confirm with user first)
${CLAUDE_PLUGIN_ROOT}/scripts/delete-note.sh "<folder>" "<note_name>" [account]

# Create folder
${CLAUDE_PLUGIN_ROOT}/scripts/create-folder.sh "<folder_name>" [account]
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
- Config persisted in `config.json` in the plugin root
- No injection: all parameters via AppleScript `argv`
- No network: pure AppleScript, no external calls
- User-driven: destructive actions require confirmation
