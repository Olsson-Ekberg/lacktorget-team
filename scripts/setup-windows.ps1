# Olsson-Ekberg team — Windows setup (Kenny)
# Run in PowerShell as Administrator:
# irm https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main/scripts/setup-windows.ps1 | iex
$ErrorActionPreference = "Stop"

$REPO_RAW = "https://raw.githubusercontent.com/Olsson-Ekberg/lacktorget-team/main"
$ClaudeDir = "$env:USERPROFILE\.claude"
$WorkDir   = "$env:USERPROFILE\work"

function ok   { param($msg) Write-Host "  [ok] $msg" -ForegroundColor Green }
function warn { param($msg) Write-Host "  [!]  $msg" -ForegroundColor Yellow }
function step { param($msg) Write-Host "`n==> $msg" -ForegroundColor Cyan }

Write-Host "`nOlsson-Ekberg team — Windows setup`n"

# 1. GitHub CLI
step "Step 1: GitHub CLI"
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
    warn "Installing GitHub CLI via winget..."
    winget install --id GitHub.cli --accept-package-agreements --accept-source-agreements
    $env:PATH += ";C:\Program Files\GitHub CLI"
} else {
    ok "gh already installed"
}
$ghPath = "C:\Program Files\GitHub CLI\gh.exe"
if (Test-Path $ghPath) {
    $env:PATH += ";C:\Program Files\GitHub CLI"
    ok "gh path set"
}

# 2. Node
step "Step 2: Node.js"
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    warn "Installing Node.js via winget..."
    winget install --id OpenJS.NodeJS.LTS --accept-package-agreements --accept-source-agreements
    warn "Node installed — you may need to restart PowerShell if npm commands fail"
} else {
    ok "node $(node --version)"
}

# 3. Claude Code
step "Step 3: Claude Code"
if (-not (Get-Command claude -ErrorAction SilentlyContinue)) {
    warn "Installing Claude Code..."
    npm install -g @anthropic-ai/claude-code
} else {
    ok "claude already installed"
}

# 4. GitHub auth
step "Step 4: GitHub login"
$authStatus = & $ghPath auth status 2>&1
if ($LASTEXITCODE -ne 0) {
    warn "Logging in to GitHub..."
    & $ghPath auth login
} else {
    $whoami = (& $ghPath api user --jq .login 2>&1)
    ok "logged in as $whoami"
}

# 5. ~/.claude config
step "Step 5: Claude config ($ClaudeDir)"
New-Item -ItemType Directory -Force -Path $ClaudeDir | Out-Null
New-Item -ItemType Directory -Force -Path "$ClaudeDir\agents" | Out-Null
New-Item -ItemType Directory -Force -Path "$ClaudeDir\commands" | Out-Null

Invoke-WebRequest "$REPO_RAW/dotfiles/settings.json" -OutFile "$ClaudeDir\settings.json" -UseBasicParsing
ok "settings.json written"

Invoke-WebRequest "$REPO_RAW/dotfiles/CLAUDE.md" -OutFile "$ClaudeDir\CLAUDE.md" -UseBasicParsing
ok "CLAUDE.md written"

Invoke-WebRequest "$REPO_RAW/dotfiles/.mcp.json" -OutFile "$ClaudeDir\.mcp.json" -UseBasicParsing
ok ".mcp.json written"

foreach ($agent in @("feature-builder", "error-detective", "code-reviewer")) {
    Invoke-WebRequest "$REPO_RAW/agents/$agent.md" -OutFile "$ClaudeDir\agents\$agent.md" -UseBasicParsing
    ok "agent: $agent"
}

foreach ($cmd in @("wrap-up", "checkpoint", "fix-issue", "orchestrate", "tdd", "test-fix")) {
    Invoke-WebRequest "$REPO_RAW/commands/$cmd.md" -OutFile "$ClaudeDir\commands\$cmd.md" -UseBasicParsing
    ok "command: $cmd"
}

# 6. Add gh to permanent PATH if not already there
step "Step 6: Permanent PATH for GitHub CLI"
$machinePath = [System.Environment]::GetEnvironmentVariable("PATH", "Machine")
if ($machinePath -notlike "*GitHub CLI*") {
    [System.Environment]::SetEnvironmentVariable("PATH", "$machinePath;C:\Program Files\GitHub CLI", "Machine")
    ok "Added GitHub CLI to system PATH"
} else {
    ok "GitHub CLI already in system PATH"
}

# Add gh to bash profile for Git Bash / Claude Code terminal
$bashrc = "$env:USERPROFILE\.bashrc"
if (-not (Test-Path $bashrc) -or -not (Select-String -Path $bashrc -Pattern "GitHub CLI" -Quiet)) {
    Add-Content $bashrc "`nexport PATH=`"`$PATH:/c/Program Files/GitHub CLI`""
    ok ".bashrc updated with gh path"
}

# 7. Clone project
step "Step 7: Clone lacktorget-intel"
New-Item -ItemType Directory -Force -Path $WorkDir | Out-Null
if (Test-Path "$WorkDir\lacktorget-intel") {
    warn "~/work/lacktorget-intel exists — pulling latest..."
    & $ghPath repo sync "$WorkDir\lacktorget-intel" 2>&1 | Out-Null
} else {
    & $ghPath repo clone Olsson-Ekberg/lacktorget-intel "$WorkDir\lacktorget-intel"
}
ok "lacktorget-intel ready at $WorkDir\lacktorget-intel"

# 8. npm install
step "Step 8: npm install"
Set-Location "$WorkDir\lacktorget-intel"
npm install
ok "dependencies installed"

Write-Host "`n================================================================"
Write-Host " Done! Start working:"
Write-Host ""
Write-Host "   cd ~/work/lacktorget-intel"
Write-Host "   claude"
Write-Host "================================================================`n"
