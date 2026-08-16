# Apple Notes Skill for Claude Code (or any other AI agent)

Folder-scoped Apple Notes integration for Claude Code, Google Antigravity, Codex, or any other AI agent on macOS.

Create, read, update, delete and list notes, but only within a folder you explicitly choose. The agent can't access your other notes, can't browse everything, can't delete outside scope.

## How it works

1. First time: The agent asks which folder to use
2. You pick one (e.g. "Work Notes")
3. The agent saves the choice to `config.json` and remembers it between sessions
4. From now on, the agent works only in that folder without asking again
5. To change the folder, tell the agent explicitly

## Installation

### Option 1: Claude Code Plugin Marketplace (recommended for Claude Code)

In Claude Code, run:

```
/plugin marketplace add simplybychris/apple-notes-skill
/plugin install apple-notes@simplybychris-apple-notes-skill
```

Done. The skill is available in all your conversations.

### Option 2: Google Antigravity

Install user-wide (global for all projects):

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git ~/.gemini/config/skills/apple-notes
cp ~/.gemini/config/skills/apple-notes/.claude/skills/apple-notes/SKILL.md ~/.gemini/config/skills/apple-notes/SKILL.md
chmod +x ~/.gemini/config/skills/apple-notes/scripts/*.sh
sed -i '' 's|SKILL_DIR|~/.gemini/config/skills/apple-notes|g' ~/.gemini/config/skills/apple-notes/SKILL.md
sed -i '' 's|\${CLAUDE_PLUGIN_ROOT}|~/.gemini/config/skills/apple-notes|g' ~/.gemini/config/skills/apple-notes/SKILL.md
```

Or workspace-level (`.agents/skills/`):

```bash
mkdir -p .agents/skills/apple-notes
git clone https://github.com/simplybychris/apple-notes-skill.git /tmp/apple-notes-skill
cp -r /tmp/apple-notes-skill/scripts .agents/skills/apple-notes/
cp /tmp/apple-notes-skill/.claude/skills/apple-notes/SKILL.md .agents/skills/apple-notes/
chmod +x .agents/skills/apple-notes/scripts/*.sh
sed -i '' 's|SKILL_DIR|./.agents/skills/apple-notes|g' .agents/skills/apple-notes/SKILL.md
sed -i '' 's|\${CLAUDE_PLUGIN_ROOT}|./.agents/skills/apple-notes|g' .agents/skills/apple-notes/SKILL.md
rm -rf /tmp/apple-notes-skill
```

### Option 3: Other AI Agents (Codex, Cursor, Open-Standard Agents)

This skill follows standard `SKILL.md` conventions and works with any skills-based AI agent supporting `.agents/skills/`:

```bash
# In your project's .agents directory:
mkdir -p .agents/skills/apple-notes
git clone https://github.com/simplybychris/apple-notes-skill.git /tmp/apple-notes-skill
cp -r /tmp/apple-notes-skill/scripts .agents/skills/apple-notes/
cp /tmp/apple-notes-skill/.claude/skills/apple-notes/SKILL.md .agents/skills/apple-notes/
chmod +x .agents/skills/apple-notes/scripts/*.sh
sed -i '' 's|SKILL_DIR|./.agents/skills/apple-notes|g' .agents/skills/apple-notes/SKILL.md
sed -i '' 's|\${CLAUDE_PLUGIN_ROOT}|./.agents/skills/apple-notes|g' .agents/skills/apple-notes/SKILL.md
rm -rf /tmp/apple-notes-skill
```

### Option 4: Manual copy (Claude Code)

Clone and copy to your project:

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git
cp -r apple-notes-skill/.claude /path/to/your/project/.claude
cp -r apple-notes-skill/scripts /path/to/your/project/.claude/skills/apple-notes/scripts
chmod +x /path/to/your/project/.claude/skills/apple-notes/scripts/*.sh
```

Or install user-wide (all projects):

```bash
git clone https://github.com/simplybychris/apple-notes-skill.git
cp -r apple-notes-skill/.claude/skills/apple-notes ~/.claude/skills/
cp -r apple-notes-skill/scripts ~/.claude/skills/apple-notes/scripts
chmod +x ~/.claude/skills/apple-notes/scripts/*.sh
```

### Permissions

First run triggers a macOS dialog. Go to System Settings > Privacy & Security > Automation and enable Notes for your terminal app or AI agent.

## Usage

Talk to your AI agent naturally:

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

The agent handles script calls, HTML formatting and folder scoping automatically.

## Scripts

| Script                                                | Purpose                  |
| ----------------------------------------------------- | ------------------------ |
| `get-config.sh <dir>`                                 | Read saved folder config |
| `set-config.sh <dir> <folder> [account]`              | Save folder config       |
| `list-accounts.sh`                                    | Show accounts            |
| `list-folders.sh [account]`                           | Show folders             |
| `create-folder.sh <name> [account]`                   | Create folder            |
| `list-notes.sh <folder> [account]`                    | List notes in folder     |
| `create-note.sh <folder> <title> [content] [account]` | Create note              |
| `get-note.sh <folder> <name> [account]`               | Read note                |
| `update-note.sh <folder> <name> <content> [account]`  | Update note              |
| `delete-note.sh <folder> <name> [account]`            | Delete note              |

Every note operation requires `<folder>` as the first argument. No default.

## Security

**Folder-scoped**: works only in the folder you choose. Saved to `config.json`, persistent between sessions.

**No injection**: all parameters via AppleScript `argv`, no shell interpolation.

**Pure AppleScript**: no network calls, no file system access outside Notes.app.

**Confirm deletes**: skill requires user confirmation before deletion.

## Config persistence

Folder choice is stored in `config.json` in the plugin/skill directory:

```json
{ "folder": "Scenariusze", "account": "iCloud" }
```

The agent reads this on every session start. No re-asking. To change, tell the agent or edit the file manually.

## Content format

Apple Notes uses HTML. The agent formats automatically, but for manual control:

```html
<div><h1>Heading</h1></div>
<div>
  <p>Text with <b>bold</b> and <i>italic</i>.</p>
</div>
<div>
  <ul>
    <li>Item 1</li>
    <li>Item 2</li>
  </ul>
</div>
```

## Requirements

- macOS with Apple Notes
- Claude Code, Google Antigravity, Codex, or any compatible AI agent
- Automation permission for Notes

## License

MIT
