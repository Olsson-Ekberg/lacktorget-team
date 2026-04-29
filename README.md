# lacktorget-team

Shared Claude config and tooling for the Olsson-Ekberg team.

## Setup — one-liner per platform

**Mac (Johannes):**
```bash
bash <(curl -fsSL https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main/scripts/setup-mac.sh)
```

**Windows (Kenny) — run PowerShell as Administrator:**
```powershell
irm https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main/scripts/setup-windows.ps1 | iex
```

## What it installs

- `~/.claude/settings.json` — dangerouslySkipPermissions, Next.js permissions
- `~/.claude/CLAUDE.md` — personal instructions
- `~/.claude/.mcp.json` — context7 MCP
- `~/.claude/agents/` — feature-builder, error-detective, code-reviewer (TypeScript/Next.js)
- `~/.claude/commands/` — wrap-up, checkpoint, fix-issue, orchestrate, tdd, test-fix
- Clones `lacktorget-intel` to `~/work/lacktorget-intel`

## Agents

| Agent | Use |
|-------|-----|
| `feature-builder` | Build a new feature end-to-end with tests |
| `error-detective` | Diagnose a stack trace or bug |
| `code-reviewer` | PASS/FAIL review before deploying |

## Commands (`/command-name` in Claude)

| Command | Use |
|---------|-----|
| `/wrap-up` | End session with summary, learnings, handoff note |
| `/checkpoint` | Save mid-session progress snapshot |
| `/fix-issue` | Read GitHub issue → branch → fix → PR |
| `/orchestrate` | Break complex task into tracked sub-tasks |
| `/tdd` | Red-Green-Refactor cycle for a feature |
| `/test-fix` | Diagnose and fix failing tests |

## Adding Fortnox / Extend ERP / WordPress

When ready, add MCP servers to `dotfiles/.mcp.json` and re-run the setup script.
