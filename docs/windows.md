# Windows 11 installer
Run from PowerShell in the repository root:
```powershell
Set-ExecutionPolicy -Scope Process Bypass -Force
.\install.ps1
```
Or directly:
```powershell
.\scripts\windows11\install.ps1
```
## Testing note
This Windows 11 script has **not** been end-to-end tested on Windows 11 from
this development machine.

The only end-to-end tested installer/environment so far is:
```text
Ubuntu 22.04 / GNOME / X11 / IBus / XKB
```
## Implementation
Windows native keyboard layouts normally require Microsoft Keyboard Layout
Creator/MSKLC output, compiled DLLs, and installer registration. That is not a
portable script-only approach.
This repository therefore uses AutoHotkey v2 for Windows 11:
- installs/locates AutoHotkey v2
- writes `%LOCALAPPDATA%\CzechAltGrLayout\CzechAltGr.ahk`
- creates a Startup shortcut for the current user
- starts the script immediately
## What it touches
Current-user files only:
```text
%LOCALAPPDATA%\CzechAltGrLayout\CzechAltGr.ahk
%APPDATA%\Microsoft\Windows\Start Menu\Programs\Startup\Czech AltGr Layout.lnk
```
If AutoHotkey is not installed, the script attempts:
```powershell
winget install --id AutoHotkey.AutoHotkey --exact --source winget --accept-package-agreements --accept-source-agreements
```
## Prerequisites

The one-command bootstrap installs `Git` with `winget` if it is missing. The
Windows installer itself installs or locates AutoHotkey v2 before creating and
running the current-user layout script.

## Uninstall
```powershell
.\scripts\windows11\uninstall.ps1
```
## Notes
AutoHotkey represents Windows AltGr as `<^>!`, which means Left Ctrl + Right Alt.
The hotkeys in the generated script use this AutoHotkey AltGr representation.
