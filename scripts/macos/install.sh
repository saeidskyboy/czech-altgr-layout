#!/usr/bin/env bash
set -euo pipefail
if [ "$(uname -s)" != "Darwin" ]; then
  echo "This installer must be run on macOS." >&2
  exit 2
fi
ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
GENERATOR="$ROOT_DIR/layouts/macos/generate-keylayout.py"
LAYOUT_FILE="$ROOT_DIR/layouts/macos/Czech AltGr.keylayout"
TARGET_DIR="$HOME/Library/Keyboard Layouts"
TARGET_FILE="$TARGET_DIR/Czech AltGr.keylayout"

ensure_python3_if_needed() {
  if command -v python3 >/dev/null 2>&1; then
    return 0
  fi

  if [ -f "$LAYOUT_FILE" ]; then
    return 0
  fi

  if command -v brew >/dev/null 2>&1; then
    echo "Python 3 is required to generate the keylayout and is missing. Installing python via Homebrew."
    brew install python
    return 0
  fi

  cat >&2 <<'ERROR'
Python 3 is required to generate the keylayout, but python3 and Homebrew were not found.
Install Python 3 or Homebrew, then rerun this script.
ERROR
  exit 1
}

ensure_python3_if_needed

if command -v python3 >/dev/null 2>&1; then
  python3 "$GENERATOR" >/dev/null
fi

if [ ! -f "$LAYOUT_FILE" ]; then
  echo "Missing generated layout file: $LAYOUT_FILE" >&2
  exit 1
fi

mkdir -p "$TARGET_DIR"
cp "$LAYOUT_FILE" "$TARGET_FILE"
cat <<DONE
Installed macOS keyboard layout:
  $TARGET_FILE
Next steps:
1. Log out and log back in if macOS does not show the new layout immediately.
2. Open System Settings -> Keyboard -> Text Input -> Input Sources.
3. Add "Czech AltGr".
4. Switch to it from the macOS input menu.
Note: macOS .keylayout files map the Option layer generally. This cannot be
limited to Right Option only using a plain .keylayout file.
DONE
