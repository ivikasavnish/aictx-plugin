---
name: session-save
description: Save current session state to .ai-context/ using the aictx CLI for cross-AI context persistence.
triggers:
  - "save session"
  - "save context"
  - "save progress"
  - "checkpoint"
  - "save what we did"
  - "end session"
  - "wrap up"
  - "note down tasks"
  - "update context"
---

# Session Save

Persist the current session's work to `.ai-context/` using the `aictx` CLI.
Enables any AI (Claude, Gemini, Cursor, ChatGPT) to resume exactly where work left off.

## Step 1 — Check Initialization

```bash
ls .ai-context/context.db 2>/dev/null || echo "NOT_INIT"
```

If not initialized:
```bash
aictx init
aictx set url "<git remote or project URL>"
```

## Step 2 — Write Session Summary

Write a 1-3 sentence summary covering:
- What was built/fixed/decided this session
- Current state (working? broken? partial?)
- Immediate next step

Keep it dense — this is what the next AI reads cold.

```bash
AI_TOOL=claude aictx save "<summary>"
```

## Step 3 — Sync Todos

For tasks mentioned this session not already tracked:

```bash
aictx todo add "<task text>" [priority 0-5]
aictx todo start <id>     # if actively working on it
aictx todo done <id>      # if completed this session
aictx todo block <id>     # if stuck/waiting
```

## Step 4 — Record Key Decisions

For architectural or approach decisions made this session:

```bash
aictx decide "<decision>" "<why — constraint or reason>"
```

Only record non-obvious decisions that future sessions should NOT re-debate.

## Step 5 — Export Markdown

```bash
aictx export
```

Exports `.ai-context/current.md` — human-readable, pasteable into any AI that doesn't have the CLI.

## Step 6 — Confirm

Run `aictx resume` to verify the saved state looks correct, then report back to the user:
- Session saved ✓
- N open tasks
- Path to current.md for cross-AI use

## Cross-AI Portability

`.ai-context/current.md` is plain markdown any AI can read:
- **Cursor**: include `.ai-context/current.md` in context
- **Gemini CLI**: `gemini < .ai-context/current.md`
- **ChatGPT**: paste file contents at start of conversation
- **Claude (next session)**: run `/session-resume`
