# dotfiles (macOS)

Minimal tiling setup: [AeroSpace](https://github.com/nikitabobko/AeroSpace) + [SketchyBar](https://github.com/FelixKratz/SketchyBar) + [Alacritty](https://alacritty.org) + [Karabiner-Elements](https://karabiner-elements.pqrs.org/). Rosé Pine colors, JetBrainsMono Nerd Font.

## Layout

```
aerospace/aerospace.toml    window manager config
alacritty/alacritty.toml    terminal config
karabiner/karabiner.json    caps lock -> esc (tap) / ctrl (hold)
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

## macOS settings applied by install.sh

| Setting | Undo |
| --- | --- |
| Auto-hide menu bar | `defaults write NSGlobalDomain _HIHideMenuBar -bool false && killall SystemUIServer` |
| Mission Control: group windows by app | `defaults write com.apple.dock expose-group-apps -bool false && killall Dock` |

## Uninstall

```sh
osascript -e 'quit app "AeroSpace"'; sketchybar --exit
brew uninstall --cask aerospace karabiner-elements && brew uninstall sketchybar
rm ~/.config/{aerospace,sketchybar,karabiner}   # symlinks only
```

Undo the macOS settings above as well.
