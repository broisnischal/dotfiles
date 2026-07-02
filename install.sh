#!/usr/bin/env bash
# Bootstrap this dotfiles repo on a new machine.
# Safe to re-run: existing real files are backed up once, symlinks are left alone.
set -euo pipefail

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
EXCLUDE_DIRS='^(\.git|\.ssh)$'

echo "==> Dotfiles bootstrap from $DOTFILES_DIR"

if ! command -v stow >/dev/null 2>&1; then
  echo "==> Installing GNU Stow"
  if command -v omarchy >/dev/null 2>&1; then
    omarchy pkg add stow
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --needed --noconfirm stow
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update && sudo apt-get install -y stow
  elif command -v brew >/dev/null 2>&1; then
    brew install stow
  else
    echo "!! No supported package manager found. Install GNU Stow manually and re-run." >&2
    exit 1
  fi
fi

mapfile -t PACKAGES < <(find "$DOTFILES_DIR" -maxdepth 1 -mindepth 1 -type d -printf '%f\n' | grep -vE "$EXCLUDE_DIRS")

backed_up=0
mkdir -p "$BACKUP_DIR"

for pkg in "${PACKAGES[@]}"; do
  pkg_dir="$DOTFILES_DIR/$pkg"

  # Move aside any real (non-symlink) file/dir that would conflict with this package,
  # so stow can always link cleanly instead of erroring out.
  while IFS= read -r -d '' src; do
    rel="${src#"$pkg_dir"/}"
    target="$HOME/$rel"
    if [ -e "$target" ]; then
      # Skip if $target already resolves to this exact package file, whether
      # directly or via an already-stowed ancestor directory symlink.
      if [ "$(readlink -f "$target" 2>/dev/null)" = "$(readlink -f "$src" 2>/dev/null)" ]; then
        continue
      fi
      echo "  backing up existing ~/$rel"
      mkdir -p "$(dirname "$BACKUP_DIR/$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
      backed_up=1
    fi
  done < <(find "$pkg_dir" \( -type f -o -type l \) -print0)

  echo "==> Stowing $pkg"
  stow -v -t "$HOME" -d "$DOTFILES_DIR" "$pkg"
done

if [ "$backed_up" = 1 ]; then
  echo "==> Pre-existing files were backed up to $BACKUP_DIR"
else
  rmdir "$BACKUP_DIR" 2>/dev/null || true
fi

echo "==> Done. Open a new shell (or 'exec \$SHELL') to pick up zsh/bash changes."
echo "==> Note: ~/.ssh is intentionally NOT managed here. Restore keys manually or via a password manager."
