# Ubuntu / GNOME installer
## Tested environment

End-to-end tested on:
```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

Run from the repository root:
```bash
./install.sh
```
Or directly:
```bash
scripts/ubuntu/install.sh
```
## What it touches
The Ubuntu installer creates/updates these system files:
```text
/usr/share/X11/xkb/symbols/xr_us_cz_altgr
/usr/share/X11/xkb/rules/evdev.xml
/usr/share/X11/xkb/rules/base.xml
/usr/share/ibus/component/simple.xml
```
It backs up existing files before editing:
```text
<file>.bak.YYYYMMDD-HHMMSS
```
It also configures GNOME input sources:
```text
[('xkb', 'us'), ('xkb', 'xr_us_cz_altgr')]
```
## Verify only
```bash
scripts/ubuntu/install.sh --verify-only
```
## Avoid changing GNOME settings
```bash
scripts/ubuntu/install.sh --no-gsettings
```
## Refresh
Usually IBus restart is enough. If the top bar or applications are stale:
1. Press `Super + Space` to switch away/back.
2. Open a new terminal or app window.
3. If still stale, log out and log back in once.
