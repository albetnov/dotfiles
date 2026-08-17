# Dotfiles (Desktop Edition)

Welcome to the Hyprland Dotfiles (Desktop Edition)!

Finally moving to Hyprland. I planned this for a while... but kept putting it off because, let's be honest, it's cumbersome. I was on Fedora before, and their Hyprland packages aren't exactly bleeding-edge unless you start wrestling with git coprs, and who has time for that?

However, since my main desktop is already rocking CachyOS, I decided to drag my other devices onto CachyOS as well... for "uniformity" or whatever the hell you want to call it. So, this guide is Arch-based. Enjoy.

> This version extends the main [Hyprland Branch](https://github.com/albetnov/dotfiles/tree/hyprland) with desktop-focused gaming optimizations, dedicated `DP-2` display configurations, SteamTinkerLaunch integration, and OBS Studio bindings.

## Setup

Follow the base setup from the [Hyprland Branch](https://github.com/albetnov/dotfiles/tree/hyprland).

For gaming and desktop tooling, install the following:

```bash
sudo pacman -S gamescope cliphist obs-cmd
paru -S steamtinkerlaunch
steamtinkerlaunch compat add
```

## Installing the Dotfiles

Run Chezmoi to apply the configs:

```bash
chezmoi init --apply albetnov
```

Once that's done, restart your Hyprland session.

> **Note:** The Hyprland configuration has been migrated to **Lua**.
> The primary config file is `~/.config/hypr/hyprland.lua` along with `~/.config/hypr/lua/colors.lua` (the legacy `hyprland.conf` remains available as reference).

## Desktop-Specific Configurations

### Display & Gaming Tweaks
- **Display Output**: Configured for single display `DP-2` (`1920x1080@60Hz`).
- **Tearing & Direct Scanout**: `allow_tearing = true`, `render { direct_scanout = true }`.
- **Immediate Tearing Rules**: Window rules applied for `steam` and `gamescope` (`immediate = true`).
- **Game Mode Script**: `~/.config/hypr/scripts/game-mode.sh` to toggle Noctalia performance mode, DND, and disable Hyprland animations during gameplay.

### OBS Studio Keybindings (`obs-cmd`)

| Shortcut | Action |
| :--- | :--- |
| **SUPER** + **F8** | Toggle Recording |
| **SUPER** + **F9** | Toggle Pause/Resume Recording |
| **SUPER** + **F10** | Save Replay Buffer |
| **SUPER** + **F11** | Switch Scene to "Screen" |
| **SUPER** + **SHIFT** + **F8** | Create Chapter Marker |
