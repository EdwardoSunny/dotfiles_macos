#!/bin/bash
# Install packages, symlink configs into ~/.config, apply macOS settings.
# Safe to re-run.
set -euo pipefail

DOTFILES="$(cd "$(dirname "$0")" && pwd)"

echo "==> Homebrew packages"
brew bundle --file="$DOTFILES/Brewfile"

echo "==> Linking configs"
mkdir -p "$HOME/.config"
for name in aerospace alacritty karabiner sketchybar; do
  target="$HOME/.config/$name"
  if [ -e "$target" ] && [ ! -L "$target" ]; then
    backup="$target.backup.$(date +%Y%m%d%H%M%S)"
    mv "$target" "$backup"
    echo "    moved existing $target to $backup"
  fi
  ln -sfn "$DOTFILES/$name" "$target"
  echo "    $target -> $DOTFILES/$name"
done

echo "==> macOS settings"
# Auto-hide the native menu bar (SketchyBar takes its place).
defaults write NSGlobalDomain _HIHideMenuBar -bool true
# Mission Control: group windows by app (AeroSpace recommends this).
defaults write com.apple.dock expose-group-apps -bool true
killall Dock SystemUIServer 2>/dev/null || true

echo "==> Starting AeroSpace (it starts SketchyBar)"
open -a AeroSpace

echo "Done. Grant AeroSpace Accessibility access if prompted."
