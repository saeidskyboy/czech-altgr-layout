# macOS installer
Run from the repository root:
```bash
./install.sh
```
Or directly:
```bash
scripts/macos/install.sh
```
## Implementation
The installer generates and installs a native macOS keyboard layout file:
```text
~/Library/Keyboard Layouts/Czech AltGr.keylayout
```
Then add it manually in:
```text
System Settings -> Keyboard -> Text Input -> Input Sources
```
If the layout does not appear immediately, log out and log back in once.
## Limitation
Plain macOS `.keylayout` files map the general Option layer. They cannot reliably
restrict the mapping to Right Option only. This means `Option + E` and
`Right Option + E` can both produce `ě` when this layout is active.
## Uninstall
```bash
scripts/macos/uninstall.sh
```
