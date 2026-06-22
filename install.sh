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

```
if need_cmd pacman; then
    sudo pacman -S --needed --noconfirm "$pkg"

elif need_cmd apt; then
    sudo apt update
    sudo apt install -y "$pkg"

elif need_cmd dnf; then
    sudo dnf install -y "$pkg"

elif need_cmd zypper; then
    sudo zypper install -y "$pkg"

elif need_cmd apk; then
    sudo apk add "$pkg"

else
    echo "[!] Unsupported package manager"
    return 1
fi
```

}

install_meslo_font() {

```
echo
echo "[*] Checking Meslo Nerd Font..."

if fc-list 2>/dev/null | grep -qi "Meslo.*Nerd"; then
    echo "[OK] Meslo Nerd Font already installed"
    return 0
fi

echo "[*] Installing Meslo Nerd Font..."

local FONT_DIR="$HOME/.local/share/fonts"
local TMP_DIR

TMP_DIR=$(mktemp -d)

mkdir -p "$FONT_DIR"

curl -fsSL \
    -o "$TMP_DIR/Meslo.zip" \
    https://github.com/ryanoasis/nerd-fonts/releases/latest/download/Meslo.zip

unzip -oq "$TMP_DIR/Meslo.zip" -d "$TMP_DIR/fonts"

find "$TMP_DIR/fonts" \
    -type f \
    -name "*.ttf" \
    -exec cp {} "$FONT_DIR/" \;

fc-cache -f "$FONT_DIR" >/dev/null 2>&1 || true

rm -rf "$TMP_DIR"

echo "[✓] Meslo Nerd Font installed"
```

}

echo "[*] Checking required tools..."

MISSING=()

for cmd in zsh git curl unzip fc-cache; do
if need_cmd "$cmd"; then
echo "[OK] $cmd"
else
echo "[MISSING] $cmd"
MISSING+=("$cmd")
fi
done

echo

if [ ${#MISSING[@]} -ne 0 ]; then

```
echo "Installing missing dependencies..."

for pkg in "${MISSING[@]}"; do

    realpkg="$pkg"

    case "$pkg" in
        fc-cache)
            realpkg="fontconfig"
        ;;
    esac

    if install_pkg "$realpkg"; then
        echo "[✓] Installed: $realpkg"
    else
        echo "[✗] Failed: $realpkg"
    fi
done
```

fi

echo
echo "[*] Verifying zsh..."

if ! need_cmd zsh; then
echo "[!] zsh not found"
exit 1
fi

echo "[OK] zsh available"

echo
echo "[*] Installing Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
RUNZSH=no CHSH=no sh -c 
"$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
echo "[OK] Oh My Zsh already installed"
fi

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

echo
echo "[*] Installing Powerlevel10k..."

if [ ! -d "$ZSH_CUSTOM/themes/powerlevel10k" ]; then

```
git clone --depth=1 \
    https://github.com/romkatv/powerlevel10k.git \
    "$ZSH_CUSTOM/themes/powerlevel10k"
```

else
echo "[OK] Powerlevel10k already installed"
fi

install_meslo_font

echo
echo "[*] Installing plugins..."

install_plugin() {

```
local name="$1"
local repo="$2"

if [ ! -d "$ZSH_CUSTOM/plugins/$name" ]; then

    git clone --depth=1 \
        "$repo" \
        "$ZSH_CUSTOM/plugins/$name"

    echo "[✓] Installed: $name"

else
    echo "[OK] $name already installed"
fi
```

}

install_plugin 
zsh-autosuggestions 
https://github.com/zsh-users/zsh-autosuggestions

install_plugin 
zsh-syntax-highlighting 
https://github.com/zsh-users/zsh-syntax-highlighting

install_plugin 
zsh-history-substring-search 
https://github.com/zsh-users/zsh-history-substring-search

echo
echo "[*] Installing fzf..."

if [ ! -d "$HOME/.fzf" ]; then

```
git clone --depth=1 \
    https://github.com/junegunn/fzf.git \
    "$HOME/.fzf"

"$HOME/.fzf/install" \
    --all \
    --no-update-rc \
    --no-bash \
    --no-fish || true

echo "[✓] fzf installed"
```

else
echo "[OK] fzf already installed"
fi

echo
echo "[*] Backing up existing config..."

TS=$(date +%Y%m%d-%H%M%S)

[ -f "$HOME/.zshrc" ] && 
cp "$HOME/.zshrc" "$HOME/.zshrc.bak.$TS"

[ -f "$HOME/.p10k.zsh" ] && 
cp "$HOME/.p10k.zsh" "$HOME/.p10k.zsh.bak.$TS"

echo
echo "[*] Installing configuration..."

cp .zshrc "$HOME/.zshrc"

if [ -f ".p10k.zsh" ]; then

```
cp .p10k.zsh "$HOME/.p10k.zsh"
```

else

cat > "$HOME/.p10k.zsh" << 'EOF'
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
echo "[*] Setting default shell..."

ZSH_PATH=$(command -v zsh)

if [ "$SHELL" != "$ZSH_PATH" ]; then

```
if chsh -s "$ZSH_PATH"; then
    echo "[✓] Default shell changed"
else
    echo "[!] Run manually:"
    echo "    chsh -s $ZSH_PATH"
fi
```

else

```
echo "[OK] zsh already default shell"
```

fi

echo
echo "======================================="
echo " Installation completed successfully"
echo "======================================="
echo
echo "Restart your terminal."
echo "Run 'p10k configure' if you want to customize Powerlevel10k."
