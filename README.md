# lacktorget-team

Shared Claude config and tooling for Kenny + Johannes.

## Mac setup (one-liner)

```bash
bash <(curl -fsSL https://raw.githubusercontent.com/kennyolofsson23-netizen/lacktorget-team/main/scripts/setup-mac.sh)
```

## What it installs

- `~/.claude/settings.json` — dangerouslySkipPermissions, Next.js permissions
- `~/.claude/CLAUDE.md` — personal instructions
- `~/.claude/.mcp.json` — context7 MCP
- `~/.claude/agents/` — feature-builder, error-detective, code-reviewer (TypeScript/Next.js)
- Clones `lacktorget-intel` to `~/work/lacktorget-intel`

## Agents

| Agent | Use |
|-------|-----|
| `feature-builder` | Build a new feature end-to-end with tests |
| `error-detective` | Diagnose a stack trace or bug |
| `code-reviewer` | PASS/FAIL review before deploying |

Use with: `/agent feature-builder` or `claude --agent feature-builder`

## Adding Fortnox / Extend ERP / WordPress

When ready, add MCP servers to `dotfiles/.mcp.json` and re-run the setup script.
