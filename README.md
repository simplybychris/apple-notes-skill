# Apple Notes Skill for Claude Code

Folder-scoped Apple Notes integration for Claude Code on macOS.

Create, read, update, delete and list notes, but only within a folder you explicitly choose. Claude can't access your other notes, can't browse everything, can't delete outside scope.

## Why folder-scoped?

Most Apple Notes integrations give full access to all your notes. This one doesn't.

You pick a folder. Claude works only in that folder. The folder name is saved to `config.json` so Claude remembers it between sessions without asking again.

## How it works

1. First time: Claude asks which folder to use
2. You pick one (e.g. "Work Notes")
3. Claude saves the choice to `config.json`
4. From now on, Claude works only in that folder, every session, without asking
5. Want to change it? Tell Claude explicitly

## Installation

Clone and copy to your project:

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git
cp -r apple-notes-skill/.claude /path/to/your/project/.claude
cp -r apple-notes-skill/scripts /path/to/your/project/.claude/skills/apple-notes/scripts
chmod +x /path/to/your/project/.claude/skills/apple-notes/scripts/*.sh
```

Or install user-wide (all projects):

```bash
cp -r apple-notes-skill/.claude/skills/apple-notes ~/.claude/skills/
cp -r apple-notes-skill/scripts ~/.claude/skills/apple-notes/scripts
chmod +x ~/.claude/skills/apple-notes/scripts/*.sh
```

### Permissions

First run triggers a macOS permission dialog. Go to System Settings > Privacy & Security > Automation and enable Notes for your terminal app.

## Usage

Talk to Claude naturally:

```
"Dodaj notatkę z podsumowaniem spotkania"
"Zapisz ten scenariusz do Apple Notes"
"Pokaż mi wszystkie notatki"
"Edytuj notatkę 'Projekt X' i dodaj sekcję o budżecie"
"Usuń notatkę 'Draft v1'"
"Save this as a note called 'Meeting Summary'"
"What notes do I have?"
"Update 'TODO' with the new task list"
```

Claude handles script calls, HTML formatting and folder scoping automatically.

## Scripts

| Script | Purpose |
|--------|---------|
| `get-config.sh <dir>` | Read saved folder config |
| `set-config.sh <dir> <folder> [account]` | Save folder config |
| `list-accounts.sh` | Show accounts |
| `list-folders.sh [account]` | Show folders |
| `create-folder.sh <name> [account]` | Create folder |
| `list-notes.sh <folder> [account]` | List notes in folder |
| `create-note.sh <folder> <title> [content] [account]` | Create note |
| `get-note.sh <folder> <name> [account]` | Read note |
| `update-note.sh <folder> <name> <content> [account]` | Update note |
| `delete-note.sh <folder> <name> [account]` | Delete note |

Every note operation requires `<folder>` as the first argument. No default.

## Security

**Folder-scoped**: works only in the folder you choose. Saved to `config.json`, persistent between sessions.

**No injection**: all parameters via AppleScript `argv`, no shell interpolation.

**Pure AppleScript**: no network calls, no file system access outside Notes.app.

**Confirm deletes**: skill requires user confirmation before deletion.

## Config persistence

Folder choice is stored in `config.json` next to `SKILL.md`:

```json
{"folder":"Scenariusze","account":"iCloud"}
```

Claude reads this on every session start. No re-asking. To change, tell Claude or edit the file manually.

## Content format

Apple Notes uses HTML. Claude formats automatically, but for manual control:

```html
<div><h1>Heading</h1></div>
<div><p>Text with <b>bold</b> and <i>italic</i>.</p></div>
<div><ul><li>Item 1</li><li>Item 2</li></ul></div>
```

## Requirements

- macOS with Apple Notes
- Claude Code CLI
- Automation permission for Notes

## License

MIT
