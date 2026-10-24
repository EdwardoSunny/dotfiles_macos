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
| `mod+h/j/k/l` or arrows | focus left/down/up/right (crosses monitors, wraps, like i3) |
| `mod+shift+h/j/k/l` or arrows | move window (onto the next monitor at the edge, like i3) |
| `mod+shift+w` / `mod+shift+v` | split horizontal / vertical |
| `mod+f` | fullscreen |
| `mod+s` / `mod+w` / `mod+e` | stacking / tabbed approximations (overlapping accordions) / toggle tiled split |
| `mod+shift+space` | toggle floating |
| `mod+1..9`, `mod+0` | switch to workspace 1–10 |
| `mod+shift+1..9`, `mod+shift+0` | move window to workspace 1–10 |
| `mod+r` | resize mode: `h/l` width −/+, `j/k` height −/+, arrows, `enter`/`esc`/`mod+r` to exit |
| `mod+shift+c` | reload config |
| `mod+shift+;`, then `r` | reset and balance the current workspace's tiled layout |
| `mod+shift+;`, then `f` / `esc` | toggle focused window floating / reload config; return to normal mode |
| `mod+ctrl+l` | lock (sleeps display) |
| `mod+shift+a` / `mod+shift+n` | Sound / Wi-Fi settings (i3: audio / network pickers) |
| `mod+shift+s` | screenshot a region to the clipboard (i3: flameshot) |
| `mod+shift+t` / `mod+shift+esc` | Handy: toggle / cancel transcription |
| hold `alt+enter` | Handy push-to-talk dictation (same as Linux) |

Not available on macOS: i3's `mod+a` (focus parent; AeroSpace has no equivalent), `mod+shift+r` (restart), `mod+shift+e` (exit). Moving floating windows with `mod+drag` is `ctrl+cmd+drag` here.

Handy shortcuts are set in the Handy app (`~/Library/Application Support/com.pais.handy/settings_store.json`, not in this repo) to match Linux: transcribe `option+enter` (= `alt+enter`), post-processing `ctrl+shift+space`. Because held Caps Lock is Option here, `caps+enter` also dictates.

These Option combos are taken over system-wide, so the Option characters on those keys (e.g. `™`, `é`, `≠`) can't be typed while AeroSpace runs.

FaceTime, System Settings and Calculator always float.

### Tiling and overlapping windows

The config keeps AeroSpace's standard tiled layout, auto orientation and accordion padding, with i3 bindings, existing gaps and SketchyBar integration. Both tree normalizations remain disabled to preserve i3's explicit split containers; enabling default flattening would undo `mod+shift+w/v`.

Floating windows are outside the tiling tree: focus the overlapping window and press `mod+shift+space` to tile it again. `mod+shift+w/v` prepares a split for the next window; it does not turn floating windows into tiles. `mod+e` changes the existing tiled container's layout. `mod+s/w` intentionally overlaps windows using AeroSpace's accordion approximation of i3 stacking/tabbed layouts.

For tangled tiled containers, press `mod+shift+;`, then `r` to flatten the workspace, select tiles and balance sizes. This does not unfloat windows or exit macOS native fullscreen. Exit native fullscreen first; use `mod+f` for AeroSpace-managed fullscreen instead.

## Bar

Translucent black, rounded SketchyBar at the top edge: workspaces (click to switch; focused one is a white pill) and focused app on the left; background-app tray, Wi-Fi, volume, battery, clock on the right. On the notched built-in display it fills the menu-bar strip so the notch sits inside it.

The tray shows a gray glyph for each background app while it's running (1Password, Google Drive, Tailscale, Cisco Secure Client, Handy, Karabiner). Edit the `TRAY` list in `sketchybar/sketchybarrc` to add apps (name, Nerd Font glyph, app bundle id, bundle id owning the menu bar icon, process pattern).

Clicks open the real macOS menus, so the native menu bar is rarely needed:

| Click | Opens |
| --- | --- |
| focused app name | that app's menus (Apple, File, Edit, …) in a popup; click one to open it |
| tray icon | that app's own menu bar menu (falls back to opening the app) |
| Wi-Fi / battery / clock | the macOS Wi-Fi / Battery / Notification Center panels |
| volume | Control Center; scroll over it to change volume |
| workspace number | switch to it |

This goes through `sketchybar/helpers/menubar.swift` (built by `install.sh`): it briefly forces the hidden menu bar on-screen but invisible and presses the item through the Accessibility API, the same trick FelixKratz's SketchyBar menus helper uses. It needs Accessibility permission, which it inherits from AeroSpace because AeroSpace starts SketchyBar. If SketchyBar is started some other way, clicks on menus do nothing.

Hovering the top edge still reveals the native macOS menu bar on top of SketchyBar. That's macOS auto-hide behavior and can't be turned off; "Show menu bar background" makes it cover the bar cleanly instead of overlapping text.

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
