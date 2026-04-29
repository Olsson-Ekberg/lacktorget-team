#!/usr/bin/env bash
# Lacktorget team — Mac setup (Kenny or Johannes)
# bash <(curl -fsSL https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main/scripts/setup-mac.sh)
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}  [ok]${NC} $*"; }
warn() { echo -e "${YELLOW}  [!]${NC} $*"; }

REPO_RAW="https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main"
NODE_VERSION="v22.20.0"
GH_VERSION="2.92.0"

echo ""
echo "==> Lacktorget team — Mac setup"
echo ""

# 1. Node.js — install from official .pkg (bypasses Homebrew, which fails on Tier 2 macOS configs)
echo "==> Step 1: Node.js"
if ! command -v node &>/dev/null; then
  warn "Installing Node.js ${NODE_VERSION}..."
  curl -fsSL "https://nodejs.org/dist/${NODE_VERSION}/node-${NODE_VERSION}.pkg" -o /tmp/node.pkg
  sudo installer -pkg /tmp/node.pkg -target /
fi
ok "node $(node --version)"

# 2. GitHub CLI — install from official .pkg
echo ""
echo "==> Step 2: GitHub CLI"
if ! command -v gh &>/dev/null; then
  warn "Installing gh ${GH_VERSION}..."
  curl -fsSL "https://github.com/cli/cli/releases/download/v${GH_VERSION}/gh_${GH_VERSION}_macOS_universal.pkg" -o /tmp/gh.pkg
  sudo installer -pkg /tmp/gh.pkg -target /
fi
ok "gh $(gh --version | head -1)"

# 3. Claude Code — sudo required for global npm install on macOS
echo ""
echo "==> Step 3: Claude Code"
if ! command -v claude &>/dev/null; then
  warn "Installing Claude Code..."
  sudo npm install -g @anthropic-ai/claude-code
fi
ok "claude installed"

# 4. GitHub auth
echo ""
echo "==> Step 4: GitHub login"
if ! gh auth status &>/dev/null; then
  warn "Logging in to GitHub..."
  gh auth login
fi
ok "logged in as $(gh api user --jq .login)"

# 5. Auto-accept any pending repo invitations (so the clone in step 8 works)
echo ""
echo "==> Step 5: Accept pending repo invitations"
INVITES=$(gh api user/repository_invitations --jq '.[].id' 2>/dev/null || echo "")
if [ -n "$INVITES" ]; then
  for id in $INVITES; do
    gh api "user/repository_invitations/$id" -X PATCH && ok "accepted invitation $id"
  done
else
  ok "no pending invitations"
fi

# 6. ~/.claude config
echo ""
echo "==> Step 6: Claude config (~/.claude)"
mkdir -p ~/.claude ~/.claude/agents ~/.claude/commands

curl -fsSL "$REPO_RAW/dotfiles/settings.json" > ~/.claude/settings.json
ok "settings.json written"

curl -fsSL "$REPO_RAW/dotfiles/CLAUDE.md" > ~/.claude/CLAUDE.md
ok "CLAUDE.md written"

curl -fsSL "$REPO_RAW/dotfiles/.mcp.json" > ~/.claude/.mcp.json
ok ".mcp.json written"

for agent in feature-builder error-detective code-reviewer; do
  curl -fsSL "$REPO_RAW/agents/$agent.md" > ~/.claude/agents/$agent.md
  ok "agent: $agent"
done

for cmd in wrap-up checkpoint fix-issue orchestrate tdd test-fix; do
  curl -fsSL "$REPO_RAW/commands/$cmd.md" > ~/.claude/commands/$cmd.md
  ok "command: $cmd"
done

# 7. Plugins
echo ""
echo "==> Step 7: Claude plugins"
claude plugin marketplace add obra/superpowers-marketplace 2>&1 | grep -E "Successfully|already" || true
claude plugin marketplace add nextlevelbuilder/ui-ux-pro-max-skill 2>&1 | grep -E "Successfully|already" || true

for plugin in \
  "feature-dev@claude-plugins-official" \
  "frontend-design@claude-plugins-official" \
  "code-review@claude-plugins-official" \
  "pr-review-toolkit@claude-plugins-official" \
  "security-guidance@claude-plugins-official" \
  "hookify@claude-plugins-official" \
  "ralph-loop@claude-plugins-official" \
  "typescript-lsp@claude-plugins-official" \
  "commit-commands@claude-plugins-official" \
  "superpowers@superpowers-marketplace" \
  "ui-ux-pro-max@ui-ux-pro-max-skill"; do
  claude plugin install "$plugin" 2>&1 | grep -E "Successfully|already" || true
  ok "plugin: $plugin"
done

# 8. Clone projects
echo ""
echo "==> Step 8: Clone lacktorget-intel"
mkdir -p ~/work
if [ -d ~/work/lacktorget-intel ]; then
  warn "~/work/lacktorget-intel exists — pulling latest..."
  git -C ~/work/lacktorget-intel pull
else
  gh repo clone Olsson-Ekberg/lacktorget-intel ~/work/lacktorget-intel
fi
ok "lacktorget-intel ready"

# 9. Install deps
echo ""
echo "==> Step 9: npm install"
cd ~/work/lacktorget-intel && npm install
ok "dependencies installed"

echo ""
echo "================================================================"
echo " Done! Start working:"
echo ""
echo "   cd ~/work/lacktorget-intel && claude"
echo "================================================================"
echo ""
