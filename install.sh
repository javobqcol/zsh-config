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
        if install_pkg "$pkg"; then
            echo "[✓] Installed: $pkg"
        else
            echo "[✗] Failed to install: $pkg"
        fi
    done
fi

echo
echo "[*] Final check: Zsh..."

if ! need_cmd zsh; then
    echo "[!] ERROR: Zsh still not installed."
    echo "[!] Please install it manually and run this script again."
    exit 1
fi

echo "[OK] Zsh is available"

echo
echo "[*] Installing Meslo Nerd Font..."

FONT_DIR="$HOME/.local/share/fonts"
URL_BASE="https://github.com/ryanoasis/nerd-fonts/raw/HEAD/patched-fonts/Meslo/M/regular/complete"

# Tipos de fuentes Meslo requeridas por Powerlevel10k
FONTS=(
    "Meslo%20LGS%20NF%20Regular.ttf"
    "Meslo%20LGS%20NF%20Bold.ttf"
    "Meslo%20LGS%20NF%20Italic.ttf"
    "Meslo%20LGS%20NF%20Bold%20Italic.ttf"
)

# Asegurar que el directorio de fuentes existe
mkdir -p "$FONT_DIR"

FONT_INSTALLED=false

for font in "${FONTS[@]}"; do
    # Decodificar el nombre del archivo para guardarlo sin el '%20'
    FONT_NAME=$(echo "$font" | sed 's/%20/ /g')
    
    if [ ! -f "$FONT_DIR/$FONT_NAME" ]; then
        echo "[+] Descargando $FONT_NAME..."
        # Se usa curl -L por si hay redirecciones en GitHub
        if curl -fLo "$FONT_DIR/$FONT_NAME" "$URL_BASE/$font"; then
            FONT_INSTALLED=true
        else
            echo "[!] Error al descargar $FONT_NAME"
        fi
    else
        echo "[OK] $FONT_NAME ya está instalada"
    fi
done

# Refrescar la caché de fuentes si se instaló alguna nueva
if [ "$FONT_INSTALLED" = true ]; then
    if need_cmd fc-cache; then
        echo "[+] Actualizando la caché de fuentes del sistema..."
        fc-cache -f "$FONT_DIR"
        echo "[✓] Fuentes actualizadas con éxito"
    else
        echo "[!] Advertencia: 'fc-cache' no encontrado. Es posible que debas reiniciar la terminal para ver los cambios."
    fi
fi

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
        echo "[✓] Installed: $name"
    else
        echo "[OK] $name already installed"
    fi
}

# Core plugins (incluyen en Oh My Zsh)
echo "[*] Core plugins (built-in)..."
for plugin in git vi-mode extract colored-man-pages command-not-found sudo copyfile copypath web-search debian archlinux; do
    echo "[✓] $plugin available (built-in)"
done

# Plugins externos que necesitan clonarse
echo "[*] External plugins..."
install_plugin zsh-autosuggestions \
    https://github.com/zsh-users/zsh-autosuggestions

install_plugin zsh-syntax-highlighting \
    https://github.com/zsh-users/zsh-syntax-highlighting

install_plugin zsh-history-substring-search \
    https://github.com/zsh-users/zsh-history-substring-search

# Instalar fzf (búsqueda fuzzy) - opcional pero muy útil
echo "[*] Installing fzf (fuzzy finder)..."
if [ ! -d "$HOME/.fzf" ]; then
    git clone --depth 1 https://github.com/junegunn/fzf.git "$HOME/.fzf"
    "$HOME/.fzf/install" --all --no-update-rc --no-bash --no-fish 2>/dev/null || true
    echo "[✓] fzf installed"
else
    echo "[OK] fzf already installed"
fi

echo
echo "[*] Backing up current config..."

TS=$(date +%Y%m%d-%H%M%S)

[ -f "$HOME/.zshrc" ] && cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$TS" && echo "[OK] Backed up .zshrc"
[ -f "$HOME/.p10k.zsh" ] && cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$TS" && echo "[OK] Backed up .p10k.zsh"

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

ZSH_PATH=$(command -v zsh)
if [ "$SHELL" = "$ZSH_PATH" ]; then
    echo "[OK] Zsh already default shell"
else
    echo "Changing shell from $SHELL to $ZSH_PATH..."
    if chsh -s "$ZSH_PATH"; then
        echo "[✓] Shell changed successfully"
    else
        echo "[!] Could not change shell automatically"
        echo "[*] Run this manually: chsh -s $ZSH_PATH"
    fi
fi

echo
echo "======================================="
echo " ✓ INSTALLATION COMPLETE"
echo "======================================="
echo
echo "Next steps:"
echo "1. Close this terminal and open a new one"
echo "2. If you want to customize the prompt, run: p10k configure"
echo
echo "Installed plugins:"
echo "  • Autosuggestions: Press → to accept suggestion"
echo "  • Syntax highlighting: Real-time syntax validation"
echo "  • History search: Press ↑↓ on typed command to search"
echo "  • Extract: extract archive.tar.gz"
echo "  • Sudo: Press ESC+ESC to prepend sudo"
echo "  • Fzf: Ctrl+R (history), Ctrl+T (files)"
echo "  • Copyfile: copyfile file.txt"
echo "  • copypath: copypath (copies current directory)"
echo "  • Web search: google 'query'"
echo "  • Git: Multiple git aliases available"
echo
