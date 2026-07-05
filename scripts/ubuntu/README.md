# Ubuntu / GNOME scripts

This folder contains the Ubuntu/GNOME native installer.

## Tested environment

End-to-end tested on:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

## Run

One-command clone and install from the private GitHub repo:

```bash
bash -c 'set -euo pipefail; repo="saeidskyboy/czech-altgr-layout"; dir="${XDG_DATA_HOME:-$HOME/.local/share}/czech-altgr-layout"; if ! command -v gh >/dev/null 2>&1 || ! command -v git >/dev/null 2>&1; then sudo apt-get update && sudo apt-get install -y git gh; fi; gh auth status --hostname github.com >/dev/null || { echo "Run first: gh auth login --hostname github.com" >&2; exit 1; }; mkdir -p "$(dirname "$dir")"; rm -rf "$dir"; gh repo clone "$repo" "$dir"; cd "$dir"; ./install.sh'
```

From the repository root:

```bash
./install.sh
```

Or directly:

```bash
scripts/ubuntu/install.sh
```

## Verify only

```bash
scripts/ubuntu/install.sh --verify-only
```

## What it touches

```text
/usr/share/X11/xkb/symbols/xr_us_cz_altgr
/usr/share/X11/xkb/rules/evdev.xml
/usr/share/X11/xkb/rules/base.xml
/usr/share/ibus/component/simple.xml
GNOME gsettings input-source configuration
```

The script creates timestamped backups before changing system files.

## Prerequisites

The installer checks and installs missing Ubuntu packages before continuing:

```text
python3
grep
x11-xkb-utils
libglib2.0-bin
ibus
```
