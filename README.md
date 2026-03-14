# Apple Notes Skill for Claude Code

Folder-scoped Apple Notes integration for Claude Code on macOS. Full CRUD — create, read, update, delete, list notes — but only within a folder you explicitly choose.

## Why folder-scoped?

Most Apple Notes integrations give full access to all your notes. This one doesn't.

**You pick a folder. Claude works only in that folder.** Can't read your other notes. Can't delete things outside the scope you set. Every script requires the folder name as the first argument — there's no default to accidentally fall through to.

## How it works

1. Claude asks you which folder to use
2. You pick one (e.g., "Work Notes")
3. Claude can now create, read, edit, delete, and list notes — but only in that folder
4. Want to switch? Just say so

## Setup

### 1. Copy to your project

```bash
# Project-local (recommended)
cp -r .claude /path/to/your/project/.claude
cp -r scripts /path/to/your/project/.claude/skills/apple-notes/scripts
```

Or user-wide:
```bash
cp -r .claude/skills/apple-notes ~/.claude/skills/
```

### 2. Make scripts executable

```bash
chmod +x scripts/*.sh
```

### 3. Grant permissions

First time you run a script, macOS will ask for permission:

**System Settings > Privacy & Security > Automation > enable Notes** for your terminal app.

## Scripts

| Script | What it does |
|--------|-------------|
| `list-accounts.sh` | Show available accounts |
| `list-folders.sh [account]` | Show all folders |
| `create-folder.sh <name> [account]` | Create a new folder |
| `list-notes.sh <folder> [account]` | List notes in folder |
| `create-note.sh <folder> <title> [content] [account]` | Create a note |
| `get-note.sh <folder> <name> [account]` | Read a note |
| `update-note.sh <folder> <name> <content> [account]` | Replace note content |
| `delete-note.sh <folder> <name> [account]` | Delete a note |

Every note operation takes `<folder>` as the first argument. No default. No shortcut.

## Security

- **Folder-scoped** — operates only where you say
- **No default folder** — must be explicitly set by the user each session
- **argv parameter passing** — immune to shell injection
- **Pure AppleScript** — no network calls, no file system access
- **User confirms deletes** — skill instructions require confirmation before deletion

## Content format

Apple Notes uses HTML. When creating or updating:

```html
<div><h1>Heading</h1></div>
<div><p>Paragraph with <b>bold</b> and <i>italic</i>.</p></div>
<div><ul><li>Item 1</li><li>Item 2</li></ul></div>
```

Line breaks: `<br>` or separate `<div>` tags.

## Requirements

- macOS with Apple Notes
- Claude Code CLI
- Automation permission for Notes

## License

MIT
