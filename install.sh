#!/bin/bash

set -euo pipefail

echo "[+] Instalando Oh My Zsh..."

if [ ! -d "$HOME/.oh-my-zsh" ]; then
    RUNZSH=no CHSH=no sh -c \
    "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi

echo "[+] Instalando Powerlevel10k..."

mkdir -p ~/.oh-my-zsh/custom/themes

if [ ! -d ~/.oh-my-zsh/custom/themes/powerlevel10k ]; then
    git clone \
      https://github.com/romkatv/powerlevel10k.git \
      ~/.oh-my-zsh/custom/themes/powerlevel10k
fi

echo "[+] Instalando plugins..."

mkdir -p ~/.oh-my-zsh/custom/plugins

install_plugin() {
    local name="$1"
    local repo="$2"

    if [ ! -d ~/.oh-my-zsh/custom/plugins/$name ]; then
        git clone "$repo" \
          ~/.oh-my-zsh/custom/plugins/$name
    fi
}

install_plugin zsh-autosuggestions \
    https://github.com/zsh-users/zsh-autosuggestions

install_plugin zsh-syntax-highlighting \
    https://github.com/zsh-users/zsh-syntax-highlighting

install_plugin zsh-history-substring-search \
    https://github.com/zsh-users/zsh-history-substring-search

echo "[+] Backup..."

[ -f ~/.zshrc ] && cp ~/.zshrc ~/.zshrc.bak.$(date +%F-%H%M%S)
[ -f ~/.p10k.zsh ] && cp ~/.p10k.zsh ~/.p10k.zsh.bak.$(date +%F-%H%M%S)

echo "[+] Copiando configuración..."

cp .zshrc ~/.zshrc
cp .p10k.zsh ~/.p10k.zsh

echo
echo "======================================="
echo " ZSH INSTALADO"
echo "======================================="
