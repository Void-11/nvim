#!/usr/bin/env bash
set -euo pipefail

# Installer for nvim-unified-ide
# This script sets NVIM_APPNAME and launches Neovim to bootstrap plugins.

APPNAME="nvim-unified-ide"
if [ "${NVIM_APPNAME:-}" != "$APPNAME" ]; then
  echo "Setting NVIM_APPNAME=$APPNAME for this session"
  export NVIM_APPNAME="$APPNAME"
fi

# Basic tool hints (non-fatal)
need() { command -v "$1" >/dev/null 2>&1 || echo "[hint] Install $1"; }
need git
need node
need python3
need cmake
need make
need rg
need fd

# Launch Neovim; lazy.nvim + mason will install everything on first run
exec nvim "$@"
