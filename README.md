# Czech AltGr Layout
Cross-platform setup for a custom Czech input method that keeps normal English-US
key positions and adds Czech letters on the Right Alt / AltGr layer.
## Goal
Default typing stays English (US). The Czech characters are added through an
extra modifier layer:
| Shortcut | Output |
|---|---|
| Right Alt / AltGr + E | ě |
| Shift + Right Alt / AltGr + E | Ě |
| Right Alt / AltGr + S | š |
| Shift + Right Alt / AltGr + S | Š |
| Right Alt / AltGr + C | č |
| Shift + Right Alt / AltGr + C | Č |
| Right Alt / AltGr + R | ř |
| Shift + Right Alt / AltGr + R | Ř |
| Right Alt / AltGr + T | ť |
| Shift + Right Alt / AltGr + T | Ť |
| Right Alt / AltGr + D | ď |
| Shift + Right Alt / AltGr + D | Ď |
| Right Alt / AltGr + N | ň |
| Shift + Right Alt / AltGr + N | Ň |
| Right Alt / AltGr + O | ó |
| Shift + Right Alt / AltGr + O | Ó |
| Right Alt / AltGr + Z | ž |
| Shift + Right Alt / AltGr + Z | Ž |
| Right Alt / AltGr + Y | ý |
| Shift + Right Alt / AltGr + Y | Ý |
| Right Alt / AltGr + A | á |
| Shift + Right Alt / AltGr + A | Á |
| Right Alt / AltGr + I | í |
| Shift + Right Alt / AltGr + I | Í |
| Right Alt / AltGr + U | ú |
| Shift + Right Alt / AltGr + U | Ú |
| Right Alt / AltGr + J | ů |
| Shift + Right Alt / AltGr + J | Ů |
| Right Alt / AltGr + ' | é |
| Shift + Right Alt / AltGr + ' | É |
## Tested status

End-to-end tested so far:

```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```

The Windows 11 and macOS scripts are separated by OS and are provided as
best-effort installers, but they have not yet been end-to-end tested on those
operating systems from this development machine.

## Quick install

### Ubuntu / GNOME Linux
```bash
./install.sh
```
Direct OS-specific script:

```bash
scripts/ubuntu/install.sh
```

This installs a native XKB layout named `Czech`, registers it with IBus/GNOME,
and configures GNOME input sources as:
```text
English (US)
Czech
```
### macOS
```bash
./install.sh
```
Direct OS-specific script:

```bash
scripts/macos/install.sh
```

This installs a native `.keylayout` file into `~/Library/Keyboard Layouts/`.
You still need to add it in:
```text
System Settings -> Keyboard -> Text Input -> Input Sources
```
macOS `.keylayout` files usually map the general Option layer, not exclusively
Right Option.
### Windows 11
Run PowerShell from the repository root:
```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install.ps1
```
Direct OS-specific script:

```powershell
.\scripts\windows11\install.ps1
```

The Windows installer uses AutoHotkey v2 because creating and signing a native
Windows keyboard-layout DLL/MSKLC installer is not practical from a portable
script. The script installs or locates AutoHotkey, writes a startup script, and
runs it for the current user.
## Repository structure
```text
.
├── install.sh                         # Linux/macOS dispatcher
├── install.ps1                        # Windows dispatcher
├── scripts/
│   ├── ubuntu/                        # Ubuntu/GNOME native XKB + IBus scripts
│   ├── windows11/                     # Windows 11 AutoHotkey scripts
│   └── macos/                         # macOS .keylayout scripts
├── layouts/
│   └── macos/generate-keylayout.py    # Generates Czech AltGr.keylayout
└── docs/
    ├── ubuntu.md
    ├── windows.md
    └── macos.md
```
## Safety notes
- Ubuntu installer backs up system files before editing them.
- Ubuntu installer is idempotent and avoids duplicate XKB/IBus registrations.
- Windows installer affects only the current user and can be removed from Startup.
- macOS installer affects only the current user.
