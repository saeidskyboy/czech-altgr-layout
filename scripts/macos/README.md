# macOS scripts

This folder contains the macOS current-user installer.

## Testing note

This macOS script has not been end-to-end tested on macOS from this development machine.

The only end-to-end tested installer/environment so far is:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

## Run

One-command clone and install from the private GitHub repo:

```bash
zsh -c 'set -e; repo="saeidskyboy/czech-altgr-layout"; dir="$HOME/.local/share/czech-altgr-layout"; if ! command -v gh >/dev/null 2>&1; then if command -v brew >/dev/null 2>&1; then brew install gh; else echo "Install GitHub CLI first or install Homebrew: https://brew.sh" >&2; exit 1; fi; fi; gh auth status --hostname github.com >/dev/null || { echo "Run first: gh auth login --hostname github.com" >&2; exit 1; }; mkdir -p "$(dirname "$dir")"; rm -rf "$dir"; gh repo clone "$repo" "$dir"; cd "$dir"; ./install.sh'
```

From the repository root on macOS:

```bash
./install.sh
```

Or directly:

```bash
scripts/macos/install.sh
```

## Uninstall

```bash
scripts/macos/uninstall.sh
```

## What it touches

```text
~/Library/Keyboard Layouts/Czech AltGr.keylayout
```

After installation, add the layout manually in:

```text
System Settings -> Keyboard -> Text Input -> Input Sources
```

Plain macOS `.keylayout` files map the general Option layer; they cannot reliably restrict mappings to Right Option only.

## Prerequisites

The installer uses the committed `.keylayout` file directly. If regeneration is
needed and `python3` is missing, it installs Python with Homebrew when `brew` is
available; otherwise it asks you to install Python 3 or Homebrew.
