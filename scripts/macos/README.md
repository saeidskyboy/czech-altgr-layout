# macOS scripts

This folder contains the macOS current-user installer.

## Testing note

This macOS script has not been end-to-end tested on macOS from this development machine.

The only end-to-end tested installer/environment so far is:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

## Run

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
