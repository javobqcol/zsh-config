#!/usr/bin/env bash

set -euo pipefail

echo "======================================="
echo "  ZSH CONFIG INSTALLER (portable)"
echo "======================================="
echo

need_cmd() {
    command -v "$1" >/dev/null 2>&1
}

install_pkg() {
    local pkg="$1"

    if need_cmd pacman; then
        sudo pacman -S --needed "$pkg"
    elif need_cmd apt; then
        sudo apt install -y "$pkg"
    elif need_cmd dnf; then
        sudo dnf install -y "$pkg"
    else
        echo "[!] No package manager supported found. Install manually: $pkg"
        return 1
    fi
}

echo "[*] Checking required base tools..."

MISSING=()

for cmd in zsh git curl; do
    if need_cmd "$cmd"; then
        echo "[OK] $cmd"
    else
        echo "[MISSING] $cmd"
        MISSING+=("$cmd")
    fi
done

echo

if [ ${#MISSING[@]} -ne 0 ]; then
    echo "======================================="
    echo " Missing required packages:"
    printf ' - %s\n' "${MISSING[@]}"
    echo "======================================="
    echo
    echo "Trying to install automatically..."
    echo

    for pkg in "${MISSING[@]}"; do
        install_pkg "$pkg" || true
    done
fi

echo
echo "[*] Checking Zsh..."

if ! need_cmd zsh; then
    echo "[!] Zsh still not installed. Install it manually."
    exit 1
fi

echo "[OK] Zsh is available"

echo
echo "[*] Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "[OK] Oh My Zsh already installed"
fi

echo
echo "[*] Installing Powerlevel10k..."

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then
    git clone --depth=1 \
        https://github.com/romkatv/powerlevel10k.git \
        "$ZSH_CUSTOM/themes/powerlevel10k"
else
    echo "[OK] Powerlevel10k already installed"
fi

echo
echo "[*] Installing plugins..."

install_plugin() {
    local name="$1"
    local repo="$2"

    if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then
        git clone --depth=1 "$repo" "$ZSH_CUSTOM/plugins/$name"
    else
        echo "[OK] $name already installed"
    fi
}

install_plugin zsh-autosuggestions \
    https://github.com/zsh-users/zsh-autosuggestions

install_plugin zsh-syntax-highlighting \
    https://github.com/zsh-users/zsh-syntax-highlighting

install_plugin zsh-history-substring-search \
    https://github.com/zsh-users/zsh-history-substring-search

echo
echo "[*] Backing up current config..."

TS=$(date +%Y%m%d-%H%M%S)

[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$TS"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$TS"

echo
echo "[*] Installing your config..."

cp .zshrc "$HOME/.zshrc"

# Crear .p10k.zsh si no existe
if [ -f ".p10k.zsh" ]; then
    cp .p10k.zsh "$HOME/.p10k.zsh"
else
    echo "[!] .p10k.zsh no encontrado, se creará configuración minimal"
    cat > "$HOME/.p10k.zsh" << 'EOF'
# Configuración minimal de Powerlevel10k
# Ejecuta: p10k configure
# para personalizar tu prompt
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  dir
  vcs
)
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status
)
EOF
fi

echo
echo "[*] Setting Zsh as default shell..."

if [ "$SHELL" != "$(command -v zsh)" ]; then
    echo "Changing shell..."
    chsh -s "$(command -v zsh)" || echo "[!] Could not change shell automatically"
else
    echo "[OK] Zsh already default shell"
fi

echo
echo "======================================="
echo " DONE"
echo " Open a new terminal"
echo "======================================="
