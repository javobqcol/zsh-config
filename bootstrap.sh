#!/usr/bin/env bash
set -e

# Intentar HTTPS primero, fallback a SSH
REPO_HTTPS="https://github.com/javobqcol/zsh-config.git"
REPO_SSH="git@github.com:javobqcol/zsh-config.git"
TMPDIR=$(mktemp -d)

echo "[+] Clonando configuración..."

if git clone "$REPO_HTTPS" "$TMPDIR" 2>/dev/null; then
    echo "[OK] Clonado vía HTTPS"
elif git clone "$REPO_SSH" "$TMPDIR" 2>/dev/null; then
    echo "[OK] Clonado vía SSH"
else
    echo "[!] Error: No se pudo clonar el repositorio"
    rm -rf "$TMPDIR"
    exit 1
fi

cd "$TMPDIR"

echo "[+] Ejecutando instalador..."
bash install.sh

# Limpiar si todo fue bien
echo "[+] Limpiando archivos temporales..."
cd ~
rm -rf "$TMPDIR"

echo "[✓] ¡Instalación completada!"
