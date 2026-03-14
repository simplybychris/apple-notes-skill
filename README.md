# Apple Notes Skill for Claude Code

Folder-scoped Apple Notes integration for Claude Code on macOS.

Create, read, update, delete and list notes, but only within a folder you explicitly choose. Claude can't access your other notes, can't browse everything, can't delete outside scope. Every script requires folder name as the first argument with no default.

## How it works

1. First time you use the skill, Claude asks which folder to use
2. You pick a folder (e.g. "Work Notes")
3. Claude works only in that folder from now on
4. The folder stays set until you explicitly change it

## Installation

**Project-local** (recommended):

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git
cp -r apple-notes-skill/.claude /path/to/your/project/.claude
cp -r apple-notes-skill/scripts /path/to/your/project/.claude/skills/apple-notes/scripts
chmod +x /path/to/your/project/.claude/skills/apple-notes/scripts/*.sh
```

**User-wide** (available in all projects):

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git
cp -r apple-notes-skill/.claude/skills/apple-notes ~/.claude/skills/
cp -r apple-notes-skill/scripts ~/.claude/skills/apple-notes/scripts
chmod +x ~/.claude/skills/apple-notes/scripts/*.sh
```

### Permissions

First run triggers a macOS permission dialog. Go to **System Settings > Privacy & Security > Automation** and enable **Notes** for your terminal app.

## Usage Examples

Just talk to Claude naturally:

```
"Dodaj notatkę z podsumowaniem dzisiejszego spotkania"
"Zapisz ten scenariusz do Apple Notes"
"Pokaż mi wszystkie notatki w tym folderze"
"Edytuj notatkę 'Projekt X' i dodaj sekcję o budżecie"
"Usuń notatkę 'Draft v1'"
"Stwórz nowy folder 'Klienci'"
"What notes do I have?"
"Save this as a note called 'Meeting Summary'"
"Update the note 'TODO' with the new task list"
```

Claude handles the script calls, HTML formatting and folder scoping automatically.

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

**Folder-scoped**: operates only in the folder you choose. No default folder, must be set by user. Once set, it stays until explicitly changed.

**No injection**: all parameters passed via AppleScript `argv`, no shell interpolation.

**Pure AppleScript**: no network calls, no file system access. Scripts only talk to Notes.app.

**User confirms deletes**: skill instructions require confirmation before any deletion.

## Content format

Apple Notes uses HTML internally. Claude handles formatting automatically, but if you need manual control:

```html
<div><h1>Heading</h1></div>
<div><p>Paragraph with <b>bold</b> and <i>italic</i>.</p></div>
<div><ul><li>Item 1</li><li>Item 2</li></ul></div>
```

## Requirements

- macOS with Apple Notes
- Claude Code CLI
- Automation permission for Notes

## License

MIT
