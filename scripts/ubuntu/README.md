rn# Ubuntu / GNOME scripts

This folder contains the Ubuntu/GNOME native installer.

## Tested environment

End-to-end tested on:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

## Run

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
