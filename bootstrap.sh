#!/usr/bin/env bash
set -e

REPO="git@github.com:javobqcol/zsh-config.git"
TMPDIR=$(mktemp -d)

echo "[+] Clonando configuración..."
git clone "$REPO" "$TMPDIR"

cd "$TMPDIR"

echo "[+] Ejecutando instalador..."
bash install.sh
