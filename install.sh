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
# Always auto-hide the native menu bar (SketchyBar takes its place).
# _HIHideMenuBar does the hiding; the notification applies it without logging out.
# AutoHideMenuBarOption=0 keeps System Settings → Menu Bar showing "Always" (macOS 26).
defaults write NSGlobalDomain _HIHideMenuBar -bool true
defaults write com.apple.controlcenter AutoHideMenuBarOption -int 0
osascript -l JavaScript -e "ObjC.import('Foundation'); \$.NSDistributedNotificationCenter.defaultCenter.postNotificationNameObjectUserInfoDeliverImmediately('AppleInterfaceMenuBarHidingChangedNotification', \$(), \$(), true)" >/dev/null
# Mission Control: group windows by app (AeroSpace recommends this).
defaults write com.apple.dock expose-group-apps -bool true
# Auto-hide the Dock (move the mouse to the bottom edge to show it).
defaults write com.apple.dock autohide -bool true
# Move any window by holding ctrl+cmd and dragging anywhere in it (Alacritty has no title bar).
defaults write -g NSWindowShouldDragOnGesture -bool true
# No window-opening animations, so tiling feels instant.
defaults write -g NSAutomaticWindowAnimationsEnabled -bool false
killall Dock 2>/dev/null || true

echo "==> Starting AeroSpace (it starts SketchyBar)"
open -a AeroSpace

echo "Done. Grant AeroSpace Accessibility access if prompted."
