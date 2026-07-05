#!/usr/bin/env bash
set -euo pipefail
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
OS="$(uname -s)"
case "$OS" in
  Linux)
    if [ -r /etc/os-release ]; then
      . /etc/os-release
      case "${ID_LIKE:-} ${ID:-}" in
        *ubuntu*|*debian*) exec "$ROOT_DIR/scripts/ubuntu/install.sh" "$@" ;;
      esac
    fi
    echo "Unsupported Linux distribution. This installer currently supports Ubuntu/GNOME-style XKB + IBus systems." >&2
    exit 2
    ;;
  Darwin)
    exec "$ROOT_DIR/scripts/macos/install.sh" "$@"
    ;;
  MINGW*|MSYS*|CYGWIN*)
    echo "Windows detected. Run this from PowerShell instead:" >&2
    echo "  Set-ExecutionPolicy -Scope Process Bypass -Force" >&2
    echo "  .\\install.ps1" >&2
    exit 2
    ;;
  *)
    echo "Unsupported OS: $OS" >&2
    exit 2
    ;;
esac
