Mine dotfiles

Managed with [GNU Stow](https://www.gnu.org/software/stow/) — each top-level directory is a
package whose internal path mirrors `$HOME` (e.g. `hypr/.config/hypr/...` -> `~/.config/hypr`).

## New machine setup

```
git clone https://github.com/broisnischal/dotfiles.git ~/dotfiles
~/dotfiles/install.sh
```

`install.sh` installs GNU Stow if missing, then symlinks every package into `$HOME`. Any real
(non-symlink) file it would overwrite gets moved into `~/.dotfiles-backup-<timestamp>/` first, so
it's safe to re-run at any time — already-linked files are left untouched.

`~/.ssh` is intentionally **not** managed here — keys are never committed to this repo. Restore
them manually or via a password manager on a new machine.

## Packages

| Package | Covers |
|---|---|
| `hypr`, `waybar`, `walker`, `mako` | Omarchy/Hyprland desktop config |
| `omarchy` | Custom `brotheme` theme + hooks (other stock themes are left unmanaged) |
| `zsh`, `bash`, `git` | Shell + git config |
| `cursor` | Cursor editor settings/keybindings + `.cursorrules` |
| `claude` | Claude Code `settings.json` only (never credentials/history/sessions) |
| `nvim`, `starship`, `tmux`, `tsc`, `vscode`, `node` | Editor/terminal misc |

#### Auto Show/Hide Dock (macOS)

<aside>
🔗 Paste the following commands into your terminal app
</aside>

keep smooth animation time, but remove delay:
`defaults write com.apple.dock autohide-delay -float 0; killall Dock`

instantly reveal:
`defaults write com.apple.dock autohide-time-modifier -int 0; killall Dock`

restore default behavior:
`defaults delete com.apple.dock autohide-delay; killall Dock`
