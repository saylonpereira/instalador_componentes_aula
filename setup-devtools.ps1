#Requires -RunAsAdministrator
# setup-devtools.ps1 — Instala Python, Node.js e Claude Code

$ErrorActionPreference = "Continue"

function Write-Step {
    param($Message)
    Write-Host "`n==========================================" -ForegroundColor DarkCyan
    Write-Host "  $Message" -ForegroundColor Cyan
    Write-Host "==========================================" -ForegroundColor DarkCyan
}

function Write-Ok   { param($M) Write-Host "  [OK] $M" -ForegroundColor Green }
function Write-Warn { param($M) Write-Host "  [AVISO] $M" -ForegroundColor Yellow }
function Write-Fail { param($M) Write-Host "  [ERRO] $M" -ForegroundColor Red }

# ── Verificar winget ───────────────────────────────────────────────────────────
Write-Step "Verificando winget"
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Fail "winget nao encontrado."
    Write-Host "  Instale o 'App Installer' pela Microsoft Store e tente novamente." -ForegroundColor Yellow
    Read-Host "`nPressione ENTER para sair"
    exit 1
}
Write-Ok "winget disponivel."

# ── Funcao de instalacao ───────────────────────────────────────────────────────
function Install-WithWinget {
    param(
        [string]$DisplayName,
        [string]$WingetId
    )
    Write-Step "Instalando $DisplayName"
    winget install --id $WingetId -e --accept-source-agreements --accept-package-agreements --silent
    $code = $LASTEXITCODE
    # -1978335189 (0x8A150021) = ja instalado — tudo bem
    if ($code -eq 0 -or $code -eq -1978335189) {
        Write-Ok "$DisplayName instalado com sucesso."
    } else {
        Write-Warn "$DisplayName retornou codigo $code. Verifique se foi instalado corretamente."
    }
}

# ── Instalacoes ────────────────────────────────────────────────────────────────
Install-WithWinget "Sublime Text 4" "SublimeHQ.SublimeText.4"
Install-WithWinget "Python 3.12"    "Python.Python.3.12"
Install-WithWinget "PostgreSQL 17"   "PostgreSQL.PostgreSQL.17"
Install-WithWinget "Node.js (LTS)"  "OpenJS.NodeJS.LTS"

# ── Atualizar PATH na sessao atual ─────────────────────────────────────────────
Write-Step "Atualizando variaveis de ambiente"
$machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
$userPath    = [System.Environment]::GetEnvironmentVariable("Path", "User")
$env:Path    = "$machinePath;$userPath"
Write-Ok "PATH atualizado na sessao."

# ── Instalar Claude Code via npm ───────────────────────────────────────────────
Write-Step "Instalando Claude Code (npm)"

$npm = Get-Command npm -ErrorAction SilentlyContinue
if (-not $npm) {
    Write-Fail "npm nao encontrado no PATH."
    Write-Host "  Reinicie o computador e execute novamente este script." -ForegroundColor Yellow
} else {
    npm install -g @anthropic-ai/claude-code
    if ($LASTEXITCODE -eq 0) {
        Write-Ok "Claude Code instalado com sucesso."
    } else {
        Write-Fail "Falha ao instalar Claude Code."
        Write-Host "  Tente manualmente: npm install -g @anthropic-ai/claude-code" -ForegroundColor Yellow
    }
}

# ── Verificacao final ──────────────────────────────────────────────────────────
Write-Step "Verificando instalacoes"

$checks = @(
    @{ Name = "Python";      Cmd = "python"; Args = "--version" },
    @{ Name = "Node.js";     Cmd = "node";   Args = "--version" },
    @{ Name = "npm";         Cmd = "npm";    Args = "--version" },
    @{ Name = "Claude Code"; Cmd = "claude"; Args = "--version" }
)

foreach ($check in $checks) {
    $bin = Get-Command $check.Cmd -ErrorAction SilentlyContinue
    if ($bin) {
        $ver = & $check.Cmd $check.Args 2>&1
        Write-Ok "$($check.Name): $ver"
    } else {
        Write-Fail "$($check.Name) nao encontrado no PATH."
    }
}

# ── Resumo final ───────────────────────────────────────────────────────────────
Write-Host "`n`n==========================================" -ForegroundColor DarkGreen
Write-Host "  Instalacao concluida!" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor DarkGreen
Write-Host "  Reinicie o terminal para garantir que todos" -ForegroundColor White
Write-Host "  os programas estejam no PATH corretamente." -ForegroundColor White
Write-Host ""

Read-Host "Pressione ENTER para fechar"
