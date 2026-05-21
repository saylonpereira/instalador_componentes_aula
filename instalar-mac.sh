#!/bin/bash
# instalar-mac.sh — Instala Python, Node.js e Claude Code no macOS

set -euo pipefail

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[0;36m'
NC='\033[0m'

step()  { echo -e "\n${CYAN}=========================================="; echo "  $1"; echo -e "==========================================${NC}"; }
ok()    { echo -e "  ${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[AVISO]${NC} $1"; }
fail()  { echo -e "  ${RED}[ERRO]${NC} $1"; }

# ── Homebrew ──────────────────────────────────────────────────────────────────
step "Verificando Homebrew"
if command -v brew &>/dev/null; then
    ok "Homebrew ja instalado."
else
    echo "  Instalando Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Adiciona Homebrew ao PATH (Apple Silicon: /opt/homebrew, Intel: /usr/local)
    if [[ -f /opt/homebrew/bin/brew ]]; then
        eval "$(/opt/homebrew/bin/brew shellenv)"
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    fi
    ok "Homebrew instalado."
fi

# ── Sublime Text ─────────────────────────────────────────────────────────────
step "Instalando Sublime Text 4"
if brew list --cask sublime-text &>/dev/null; then
    ok "Sublime Text ja instalado."
else
    brew install --cask sublime-text
    ok "Sublime Text instalado."
fi

# ── Python ────────────────────────────────────────────────────────────────────
step "Instalando Python"
if brew list python &>/dev/null; then
    ok "Python ja instalado."
else
    brew install python
    ok "Python instalado."
fi

# ── PostgreSQL ───────────────────────────────────────────────────────────────
step "Instalando PostgreSQL"
if brew list postgresql@16 &>/dev/null; then
    ok "PostgreSQL ja instalado."
else
    brew install postgresql@16
    brew services start postgresql@16
    ok "PostgreSQL instalado e iniciado."
fi

# ── Node.js ───────────────────────────────────────────────────────────────────
step "Instalando Node.js (LTS)"
if brew list node &>/dev/null; then
    ok "Node.js ja instalado."
else
    brew install node
    ok "Node.js instalado."
fi

# ── Claude Code ───────────────────────────────────────────────────────────────
step "Instalando Claude Code (npm)"
if command -v npm &>/dev/null; then
    npm install -g @anthropic-ai/claude-code
    ok "Claude Code instalado."
else
    fail "npm nao encontrado. Tente fechar e abrir o terminal, depois execute este script novamente."
    exit 1
fi

# ── Verificacao final ─────────────────────────────────────────────────────────
step "Verificando instalacoes"

for cmd in python3 node npm claude; do
    if command -v "$cmd" &>/dev/null; then
        version=$("$cmd" --version 2>&1)
        ok "$cmd: $version"
    else
        fail "$cmd nao encontrado no PATH."
    fi
done

echo -e "\n\n${GREEN}=========================================="
echo "  Instalacao concluida!"
echo -e "==========================================${NC}"
echo "  Abra um novo terminal para garantir que"
echo "  todos os programas estejam no PATH."
echo ""
read -rp "Pressione ENTER para fechar..."
