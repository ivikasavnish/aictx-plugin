# aictx — Cross-AI Session Context Plugin

Persist work state across AI tools. Never start cold again.

Works with Claude Code, Cursor, Gemini CLI, ChatGPT — any AI reads the same context.

## What It Does

- Tracks todos, decisions, session history in `.ai-context/context.db` (SQLite, per-project)
- Exports `.ai-context/current.md` — plain markdown any AI can paste or read
- Live terminal dashboard (`aictx watch`)
- Two Claude Code skills: `/session-save` and `/session-resume`

## Install CLI

```bash
curl -fsSL https://raw.githubusercontent.com/ivikasavnish/aictx-plugin/main/scripts/install.sh | bash
```

Or build from source:
```bash
git clone https://github.com/ivikasavnish/aictx
cd aictx && go build -o ~/.local/bin/aictx .
```

## Quick Start

```bash
cd your-project
aictx init
aictx todo add "implement auth"
aictx save "set up project, added db schema"
aictx watch          # live dashboard
```

## Claude Code Skills

After installing plugin:
- `/session-resume` — load context at start of session
- `/session-save` — save state at end of session

## Cross-AI Usage

```bash
# Gemini CLI
gemini < .ai-context/current.md

# Cursor — add to .cursorrules:
# "Read .ai-context/current.md at session start"

# ChatGPT — paste current.md contents
cat .ai-context/current.md | pbcopy
```

## Commands

```
aictx init                       init in current directory
aictx save [summary]             save session snapshot
aictx resume                     print context for AI
aictx export                     write .ai-context/current.md

aictx todo add <text> [priority]
aictx todo start|done|block|open <id>
aictx todo list [status]

aictx decide <text> [context]    record key decision
aictx log [n]                    session history
aictx set <key> <value>          set project/url metadata
aictx watch                      live TUI dashboard
```

## Source

- Plugin: https://github.com/ivikasavnish/aictx-plugin
- CLI: https://github.com/ivikasavnish/aictx
- Company: [Servloci Private Ltd](https://servloci.in)
