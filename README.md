# dotfiles (macOS)

Minimal tiling setup: [AeroSpace](https://github.com/nikitabobko/AeroSpace) + [SketchyBar](https://github.com/FelixKratz/SketchyBar) + [Alacritty](https://alacritty.org) + [Karabiner-Elements](https://karabiner-elements.pqrs.org/). Monochrome (black/white/gray) colors, JetBrainsMono Nerd Font.

## Layout

```
aerospace/aerospace.toml    window manager config
alacritty/alacritty.toml    terminal config
karabiner/karabiner.json    caps lock -> esc (tap) / option (hold); option+space -> spotlight
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

## Keybindings (same as i3)

Bindings mirror the i3 config in [x11-dotfiles](https://github.com/EdwardoSunny/x11-dotfiles). `mod` = held **Caps Lock** on both: xremap makes it Super for i3, Karabiner makes it Option (`alt`) for AeroSpace. Tapping Caps Lock sends Escape on both. Option itself also works as `mod` here.

| Keys | Action |
| --- | --- |
| `mod+shift+enter` | new terminal |
| `mod+q` | close window |
| `mod+space` | launcher (Spotlight, via Karabiner; i3: rofi) |
| `mod+h/j/k/l` or arrows | focus left/down/up/right |
| `mod+shift+h/j/k/l` or arrows | move window |
| `mod+shift+w` / `mod+shift+v` | split horizontal / vertical |
| `mod+f` | fullscreen |
| `mod+s` / `mod+w` / `mod+e` | stacking / tabbed / toggle split (AeroSpace: v_accordion / h_accordion / tiles) |
| `mod+shift+space` | toggle floating |
| `mod+1..9`, `mod+0` | switch to workspace 1–10 |
| `mod+shift+1..9`, `mod+shift+0` | move window to workspace 1–10 |
| `mod+r` | resize mode: `h/l` width −/+, `j/k` height −/+, arrows, `enter`/`esc`/`mod+r` to exit |
| `mod+shift+c` | reload config |
| `mod+ctrl+l` | lock (sleeps display) |
| `mod+shift+a` / `mod+shift+n` | Sound / Wi-Fi settings (i3: audio / network pickers) |
| `mod+shift+t` / `mod+shift+esc` | Handy: toggle / cancel transcription |

Not available on macOS: i3's `mod+a` (focus parent; AeroSpace has no equivalent), `mod+shift+r` (restart), `mod+shift+e` (exit), Print (use `cmd+shift+4`). Moving floating windows with `mod+drag` is `ctrl+cmd+drag` here.

Handy's post-processing shortcut is set to `ctrl+shift+space` in the Handy app (same as Linux), so it doesn't clash with `mod+shift+space`.

These Option combos are taken over system-wide, so the Option characters on those keys (e.g. `™`, `é`, `≠`) can't be typed while AeroSpace runs.

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
