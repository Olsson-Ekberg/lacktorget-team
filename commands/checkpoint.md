Save a session checkpoint capturing current progress, decisions, and next steps.

## Steps

1. Gather current session state (`git diff --stat`, `git log --oneline -5`, background processes).
2. Summarize work completed — files changed, features/bugs, tests, dependencies.
3. Document open questions and pending decisions.
4. List concrete next steps in priority order.
5. Save checkpoint to `.claude/checkpoints/<timestamp>.md`.
6. Update `CLAUDE.md` session notes with a brief summary.
7. Stage and commit meaningful uncommitted changes.

## Format

A markdown file with sections: Completed, Current State (branch, uncommitted changes, test status), Open Questions, Next Steps, Context for Next Session.

## Rules

- Save before switching tasks, ending sessions, or risky operations.
- Keep under 50 lines.
- Never include secrets.
- Clean up files older than 30 days.
