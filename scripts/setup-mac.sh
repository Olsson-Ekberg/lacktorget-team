#!/usr/bin/env bash
# Lacktorget team — Mac setup (Kenny or Johannes)
# bash <(curl -fsSL https://raw.githubusercontent.com/kennyolofsson23-netizen/lacktorget-team/main/scripts/setup-mac.sh)
set -euo pipefail

GREEN='\033[0;32m'; YELLOW='\033[1;33m'; NC='\033[0m'
ok()   { echo -e "${GREEN}  [ok]${NC} $*"; }
warn() { echo -e "${YELLOW}  [!]${NC} $*"; }

REPO_RAW="https://raw.githubusercontent.com/kennyolofsson23-netizen/lacktorget-team/main"

echo ""
echo "==> Lacktorget team — Mac setup"
echo ""

# 1. Homebrew
echo "==> Step 1: Homebrew"
if ! command -v brew &>/dev/null; then
  warn "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  eval "$(/opt/homebrew/bin/brew shellenv 2>/dev/null || /usr/local/bin/brew shellenv)"
fi
ok "brew $(brew --version | head -1)"

# 2. GitHub CLI
echo ""
echo "==> Step 2: GitHub CLI"
if ! command -v gh &>/dev/null; then brew install gh; fi
ok "gh $(gh --version | head -1)"

# 3. Node
echo ""
echo "==> Step 3: Node.js"
if ! command -v node &>/dev/null; then brew install node; fi
ok "node $(node --version)"

# 4. Claude Code
echo ""
echo "==> Step 4: Claude Code"
if ! command -v claude &>/dev/null; then npm install -g @anthropic-ai/claude-code; fi
ok "claude installed"

# 5. GitHub auth
echo ""
echo "==> Step 5: GitHub login"
if ! gh auth status &>/dev/null; then
  warn "Logging in to GitHub..."
  gh auth login
fi
ok "logged in as $(gh api user --jq .login)"

# 6. ~/.claude config
echo ""
echo "==> Step 6: Claude config (~/.claude)"
mkdir -p ~/.claude ~/.claude/agents

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

# 7. Clone projects
echo ""
echo "==> Step 7: Clone lacktorget-intel"
mkdir -p ~/work
if [ -d ~/work/lacktorget-intel ]; then
  warn "~/work/lacktorget-intel exists — pulling latest..."
  git -C ~/work/lacktorget-intel pull
else
  gh repo clone kennyolofsson23-netizen/lacktorget-intel ~/work/lacktorget-intel
fi
ok "lacktorget-intel ready"

# 8. Install deps
echo ""
echo "==> Step 8: npm install"
cd ~/work/lacktorget-intel && npm install
ok "dependencies installed"

echo ""
echo "================================================================"
echo " Done! Start working:"
echo ""
echo "   cd ~/work/lacktorget-intel && claude"
echo "================================================================"
echo ""
