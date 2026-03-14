---
name: apple-notes
description: Manage notes in Apple Notes on macOS. Folder-scoped — works only within a folder the user explicitly chooses. Full CRUD (create, read, update, delete, list). Use when user asks to save, read, edit, or manage notes in Apple Notes.
---

# Apple Notes Skill

Folder-scoped Apple Notes integration for macOS. You can only operate within a folder the user explicitly tells you to use.

## CRITICAL: Folder Setup (MUST DO FIRST)

**Before ANY note operation, you MUST ask the user which folder to use.**

You cannot assume a default folder. You cannot pick one yourself. The user MUST tell you.

### Setup flow:

1. Run `list-folders.sh` to show available folders
2. Ask the user: "Which folder should I work in?"
3. User picks a folder (e.g., "Scenariusze")
4. From now on, ALL operations use ONLY that folder
5. If the folder doesn't exist, offer to create it with `create-folder.sh`

```bash
# Step 1: Show folders
SKILL_DIR/scripts/list-folders.sh

# Step 2: User says "Scenariusze"
# Step 3: All subsequent commands use "Scenariusze" as first argument
```

**If the user wants to switch folders, they must explicitly say so.**

## Scripts

All scripts are in the repo root `scripts/` directory. Every script that operates on notes takes `<folder>` as the FIRST argument — there is no default.

Replace `SKILL_DIR` with the actual path to this skill's root directory.

### Discovery (safe, read-only)

**List accounts:**
```bash
SKILL_DIR/scripts/list-accounts.sh
```

**List folders:**
```bash
SKILL_DIR/scripts/list-folders.sh [account]
```

**List notes in the working folder:**
```bash
SKILL_DIR/scripts/list-notes.sh "<folder>" [account]
```
Returns: `name | modified_date | preview` per line.

### CRUD Operations

**Create note:**
```bash
SKILL_DIR/scripts/create-note.sh "<folder>" "<title>" "[content]" [account]
```

**Read note:**
```bash
SKILL_DIR/scripts/get-note.sh "<folder>" "<note_name>" [account]
```

**Update note (full replacement):**
```bash
SKILL_DIR/scripts/update-note.sh "<folder>" "<note_name>" "<new_content>" [account]
```
To append: first `get-note.sh`, combine content, then `update-note.sh`.

**Delete note:**
```bash
SKILL_DIR/scripts/delete-note.sh "<folder>" "<note_name>" [account]
```

**Create folder:**
```bash
SKILL_DIR/scripts/create-folder.sh "<folder_name>" [account]
```

## Rules

1. **NEVER operate outside the chosen folder** — every script requires folder as first arg, always use the one the user picked
2. **NEVER assume a default folder** — you must ask first
3. **NEVER access folders the user didn't authorize** — if you need to work in a different folder, ask
4. **Use HTML for content**, not Markdown:
   ```html
   <div><h1>Title</h1></div>
   <div><p>Text with <b>bold</b> and <i>italic</i>.</p></div>
   <div><ul><li>Item 1</li><li>Item 2</li></ul></div>
   ```
5. **Wrap content in `<div>` tags** — Apple Notes expects this
6. **Special characters are safe** — all scripts use `argv` parameter passing
7. **Account defaults to "iCloud"** — if user has a different account, `list-accounts.sh` will show it
8. **Before deleting, always confirm with the user** — deletion is permanent

## Security Model

This skill follows the principle of least privilege:

- **Folder-scoped**: operates only in the folder the user explicitly picks
- **No browsing**: can list folders to help the user choose, but won't read notes outside the working folder
- **No injection**: all parameters passed via AppleScript `argv` (no shell interpolation)
- **No network**: scripts are pure AppleScript, no external calls
- **User-driven**: every destructive action (delete) requires user confirmation
