---
name: session-resume
description: Load prior work context from .ai-context/ and synthesize a session briefing so work continues without losing history.
triggers:
  - "resume"
  - "resume session"
  - "what were we doing"
  - "pick up where we left off"
  - "load context"
  - "what's the status"
  - "show tasks"
  - "continue from last session"
  - "resume <project name>"
---

# Session Resume

Load prior work context from `.ai-context/` so the current session continues
without losing history. Works with any AI tool that wrote the context.

## Step 1 — Check for Context

```bash
ls .ai-context/context.db 2>/dev/null || echo "NOT_INIT"
```

If not found: ask user if they want to initialize with `aictx init`, or if
the project is in a different directory.

## Step 2 — Load Context

```bash
aictx resume
```

Parse the output. It contains:
- **Last sessions** — what was done, which AI tool did it
- **In progress** — tasks actively being worked
- **Open tasks** — backlog
- **Blocked** — waiting on something
- **Key decisions** — do NOT re-debate these

## Step 3 — Synthesize for User

After running `aictx resume`, produce a brief spoken summary:

```
Last session [date]: <what was done>
Currently in progress: <task if any>
Next up: <highest priority open task>
Blockers: <if any>
```

Keep it to 3-5 lines. Don't dump the raw output — synthesize it.

## Step 4 — Confirm Direction

Ask: "Want to continue with [next task], or is there something else?"

Only one question. Don't ask multiple clarifiers upfront.

## Step 5 — Start Work

Once direction confirmed:
- Mark the chosen task `in_progress`: `aictx todo start <id>`
- Begin the work
- Run `aictx watch` in a separate terminal for live monitoring (optional)

## Live Monitoring

If the user wants a dashboard:

```bash
aictx watch   # terminal UI, auto-refreshes every 5s, q to quit
```

Shows todos by status, recent sessions, live stats.

## If .ai-context/ Missing

Fallback — read the project's memory files if they exist:
- `~/.claude/projects/<encoded-path>/memory/` — Claude's auto-memory
- `CLAUDE.md` — project instructions
- `docs/` — any specs or plans

Then suggest: `aictx init` to start tracking going forward.

## Cross-AI Context

If resuming from a different AI's session:
```bash
cat .ai-context/current.md
```

The markdown export is human-readable and works even without the CLI.
AI_TOOL tag in sessions shows which tool made each entry (claude/gemini/cursor/chatgpt).
