# dotfiles (macOS)

Minimal tiling setup: [AeroSpace](https://github.com/nikitabobko/AeroSpace) + [SketchyBar](https://github.com/FelixKratz/SketchyBar) + [Alacritty](https://alacritty.org) + [Karabiner-Elements](https://karabiner-elements.pqrs.org/). Monochrome (black/white/gray) colors, JetBrainsMono Nerd Font.

## Layout

```
aerospace/aerospace.toml    window manager config
alacritty/alacritty.toml    terminal config
karabiner/karabiner.json    caps lock -> esc (tap) / option (hold)
sketchybar/                 bar: sketchybarrc, colors.sh, plugins/*.sh
Brewfile                    packages
install.sh                  installs packages, symlinks configs, applies macOS settings
```

Each folder is symlinked to `~/.config/<name>`, so edits in this repo apply right away.

## Install

```sh
git clone git@github.com:EdwardoSunny/dotfiles_macos.git ~/dotfiles
~/dotfiles/install.sh
```

Then:

1. Install Alacritty from [releases](https://github.com/alacritty/alacritty/releases) (the Homebrew cask is disabled).
2. Grant **AeroSpace** Accessibility access (System Settings → Privacy & Security → Accessibility).
3. Open **Karabiner-Elements** and approve its driver extension and Input Monitoring prompts.

`install.sh` moves an existing non-symlink `~/.config/<name>` to `~/.config/<name>.backup.<timestamp>`.

## Keybindings (AeroSpace)

`alt` = Option. Holding **Caps Lock** also acts as Option (Karabiner), so `caps+1` switches workspace, `caps+shift+h` moves a window, etc. Tapping Caps Lock sends Escape.

| Keys | Action |
| --- | --- |
| `alt-enter` | new Alacritty window |
| `alt-h/j/k/l` | focus left/down/up/right |
| `alt-shift-h/j/k/l` | move window |
| `alt-1..9` | switch workspace |
| `alt-shift-1..9` | move window to workspace |
| `alt-tab` | previous workspace |
| `alt-shift-tab` | move workspace to next monitor |
| `alt-minus` / `alt-equal` | shrink / grow |
| `alt-/` | tiles layout (toggle horizontal/vertical) |
| `alt-,` | accordion layout |
| `alt-f` | fullscreen |
| `alt-shift-space` | toggle floating |
| `alt-shift-;` | service mode: `esc` reload config, `r` reset layout, `f` float, `backspace` close others |

These `alt` (Option) combos are taken over system-wide, so the Option characters on those keys (e.g. `™`, `–`, `≠`) can't be typed while AeroSpace runs.

FaceTime, System Settings and Calculator always float.

## Bar

Translucent black, rounded SketchyBar at the top edge: workspaces (click to switch; focused one is a white pill) and focused app on the left; background-app tray, Wi-Fi, volume, battery, clock on the right. On the notched built-in display it fills the menu-bar strip so the notch sits inside it.

The tray shows a gray glyph for each background app while it's running; click to open it. Edit the `TRAY` list in `sketchybar/sketchybarrc` to add apps (name, Nerd Font glyph, bundle id, process pattern). The native macOS status icons can't be mirrored on macOS 26: Control Center hosts all third-party ones under the same window name.

Hovering the top edge still reveals the native macOS menu bar (app menus, status icons) on top of SketchyBar. That's macOS auto-hide behavior and can't be turned off; "Show menu bar background" makes it cover the bar cleanly instead of overlapping text.

## macOS settings applied by install.sh

| Setting | Undo |
| --- | --- |
| Always auto-hide menu bar | System Settings → Menu Bar → "Automatically hide and show the menu bar" → Never |
| Menu bar background on hover | System Settings → Menu Bar → "Show menu bar background" → off |
| Hide desktop widgets | `defaults write com.apple.WindowManager StandardHideWidgets -bool false && killall WindowManager` |
| Mission Control: group windows by app | `defaults write com.apple.dock expose-group-apps -bool false && killall Dock` |
| Auto-hide Dock | `defaults write com.apple.dock autohide -bool false && killall Dock` |
| ctrl+cmd drag moves windows | `defaults delete -g NSWindowShouldDragOnGesture` |
| No window-open animations | `defaults delete -g NSAutomaticWindowAnimationsEnabled` |

## Uninstall

```sh
osascript -e 'quit app "AeroSpace"'; sketchybar --exit
brew uninstall --cask aerospace karabiner-elements && brew uninstall sketchybar
rm ~/.config/{aerospace,sketchybar,karabiner}   # symlinks only
```

Undo the macOS settings above as well.
