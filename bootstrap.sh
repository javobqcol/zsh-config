#!/bin/bash

set -e

REPO="https://github.com/javobqcol/zsh-config.git"
TMPDIR=$(mktemp -d)

git clone "$REPO" "$TMPDIR"

bash "$TMPDIR/install.sh"
