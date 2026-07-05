#!/usr/bin/env bash
set -euo pipefail
TARGET_FILE="$HOME/Library/Keyboard Layouts/Czech AltGr.keylayout"
rm -f "$TARGET_FILE"
echo "Removed $TARGET_FILE"
echo "Remove the input source from System Settings if it is still listed, then log out/in if needed."
