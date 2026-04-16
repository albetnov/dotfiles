# Dotfiles

Welcome to the Hyprland Dotfiles!

Finally moving to Hyprland. I planned this for a while... but kept putting it off because, let's be honest, it's cumbersome. I was on Fedora before, and their Hyprland packages aren't exactly bleeding-edge unless you start wrestling with git coprs, and who has time for that?

However, since my main desktop is already rocking CachyOS, I decided to drag my other devices onto CachyOS as well... for "uniformity" or whatever the hell you want to call it. So, this guide is Arch-based. Enjoy.

## Setup

First and foremost, grab [CachyOS](https://cachyos.org/) and install it.

CachyOS *does* have a Hyprland option during installation. However, I personally always keep a backup DE in place, just in case Hyprland decides to break when I have absolutely zero time to troubleshoot it. Two is better than one here. Grab KDE. These dotfiles assume you have a KDE-ish environment lurking underneath Hyprland—basically, we're assuming KDE apps exist on your system. Qt is just good, okay? You *could* figure out exactly which KDE apps/services are used here and install them independently, but I prefer having a fully functional fallback DE for when things inevitably go sideways (fixing things is a choice, but it still takes time... so yeah).

Next, glance at the [Hyprland Master Tutorial](https://wiki.hypr.land/Getting-Started/Master-Tutorial/). Just install Hyprland from the installation guide, configure your NVIDIA or VM drivers if you're burdened with those, and that's it. You don't have to follow the rest of the master tutorial, because *this* guide is your new master tutorial. It's highly opinionated anyway—if you wanted to configure your own Hyprland from scratch, you wouldn't be reading this. Kitty is also optional. Not sure why they list it like a mandatory recommendation over there; you can configure whatever terminal you actually want. 

Next, you'll want the desktop portal:

```bash
sudo pacman -S xdg-desktop-portal-hyprland
```

*This should automatically resolve dependencies... hopefully.*

Add the [Chaotic AUR](https://aur.chaotic.cx/). <-- Optional, but recommended.

Install the Polkit Agent:

```bash
sudo pacman -S hyprpolkitagent
```

Install the fix for Wayland desktop sharing on electron shit-apps (this one's from the AUR):

```bash
paru -S xwaylandvideobridge
```

*(Note: Any additional duct-tape configurations for electron garbage are already baked into these dotfiles.)*

Install Noctalia:

```bash
paru -S noctalia-shell
```

**DO NOT** start Noctalia yet.

Install Starship:

```bash
curl -sS https://starship.rs/install.sh | sh
```

Next, some nice shell utilities that I highly recommend:

```bash
sudo pacman -S dua-cli procs zoxide bat
```

Hypridle for, well, idling:

```bash
sudo pacman -S hypridle
```

And Zellij, as well as Neovim:

```bash
sudo pacman -S zellij nvim
```

Optionally, Cava for audio visualization: 
`sudo pacman -S cava`

For your screenshot needs:

```bash
sudo pacman -S grim slurp satty hyprpicker
```

## Installing the Dotfiles

Run Chezmoi to apply the configs:

```bash
chezmoi init --apply albetnov
```

Once that's done, restart your Hyprland session.

## Configuration (The Fun Part)

Once you've applied the dotfiles, you'll inevitably need to tweak the actual `hyprland.conf` because my hardware isn't your hardware. 

### Monitors

By default, Hyprland tries to be smart about your monitors. However, my recommendation is to don't let it guess; hardcode them so it knows exactly where to push your pixels. Open your config and adjust the monitor section:

```bash
################
### MONITORS ###
################

# See https://wiki.hypr.land/Configuring/Monitors/
# monitor=,preferred,auto,auto
monitor = HDMI-A-1, 1920x1080@60, 0x0, 1
monitor = eDP-1, 1920x1080@60, 1920x0, 1
```

*Adjust the ports (`HDMI-A-1`, `eDP-1`), resolutions, and refresh rates to match your actual physical setup.*

### Workspace Dynamic Switcher

Hyprland's default multi-monitor workspace logic can be mildly infuriating. If you have a dual monitor setup, you probably want workspace 1 locked to your primary monitor and workspace 2 on the secondary one. 

To force Hyprland into submission and make sure your workspaces don't scramble themselves when you plug things in, we use a script. Add this to your config:

```bash
# Workspace Dynamic Switcher Script
exec-once = ~/.config/hypr/scripts/hyprland-switcher.sh
```

*Note: Comment this line out if you don't need it, or if you actually enjoy chaos when managing your external displays.*

## Keybindings

The primary modifier key (`$mainMod`) is set to the **SUPER** (Windows) key. 

*Note: Many of these shell bindings rely on Noctalia's IPC. If nothing happens when you press them, Noctalia probably crashed again. See the bottom of the table for the restart bind.*

### Apps & Launchers

| Shortcut | Action |
| :--- | :--- |
| **SUPER** + **SPACE** | Toggle App Launcher |
| **SUPER** + **V** | Clipboard History Launcher |
| **SUPER** + **.** | Emoji Picker |
| **SUPER** + **Tab** | Window Switcher Launcher |
| **SUPER** + **Return** | Open Terminal |
| **SUPER** + **E** | Open File Manager |
| **SUPER** + **B** | Open Web Browser |

### Noctalia Shell Controls

| Shortcut | Action |
| :--- | :--- |
| **SUPER** + **S** | Toggle Control Center |
| **SUPER** + **,** | Toggle Settings |
| **SUPER** + **N** | Toggle Notification History |
| **SUPER** + **SHIFT** + **N** | Toggle Do Not Disturb (DND) |
| **SUPER** + **W** | Toggle Desktop Widgets |
| **SUPER** + **D** | Toggle Dock |
| **SUPER** + **Escape** | Toggle Session Menu |
| **SUPER** + **L** | Lock Screen |
| **SUPER** + **SHIFT** + **D** | Toggle Dark Mode |
| **SUPER** + **SHIFT** + **I** | Toggle Idle Inhibitor (Keep awake) |
| **SUPER** + **SHIFT** + **W** | Randomize Wallpaper |
| **SUPER** + **SHIFT** + **R** | **Restart Noctalia** *(Use when it inevitably crashes)* |

### Window Management & Focus

| Shortcut | Action |
| :--- | :--- |
| **SUPER** + **Q** | Kill Active Window |
| **SUPER** + **F** | Toggle Fullscreen |
| **SUPER** + **SHIFT** + **SPACE** | Toggle Floating & Center Window |
| **SUPER** + **P** | Toggle Pseudo Tiling |
| **SUPER** + **J** | Toggle Split Direction |
| **SUPER** + **\\** | Swap Split |
| **SUPER** + **Arrow Keys** | Move Focus (Left/Right/Up/Down) |
| **SUPER** + **SHIFT** + **H/J/K/L** | Move Window (Vim directional keys) |
| **SUPER** + **CTRL** + **H/J/K/L** | Resize Active Window |

### Workspaces & Window Groups

| Shortcut | Action |
| :--- | :--- |
| **SUPER** + **1-9** | Switch to Workspace 1-9 |
| **SUPER** + **SHIFT** + **1-9** | Move Active Window to Workspace 1-9 |
| **SUPER** + **Scroll** | Cycle through Workspaces |
| **SUPER** + **M** | Minimize Window (Move to special workspace) |
| **SUPER** + **SHIFT** + **M** | Toggle Minimized Windows (Special workspace) |
| **SUPER** + **T** | Toggle Window Group (Sway-style tabbed) |
| **SUPER** + **[** / **]** | Cycle Active Group backward/forward |
| **SUPER** + **SHIFT** + **T** | Move window into neighboring group |
| **SUPER** + **CTRL** + **T** | Move window out of group |

### Media & System Controls

| Shortcut | Action |
| :--- | :--- |
| **Vol Up / Vol Down** | Increase/Decrease Volume |
| **Mute Key** | Mute Audio Output |
| **Mic Mute Key** | Mute Microphone Input |
| **Brightness Up/Down** | Increase/Decrease Screen Brightness |
| **Play/Pause/Next/Prev** | Media Controls via IPC |

### Screenshots (Grimblast)

*Screenshots are automatically saved to `~/Pictures/Screenshots`. Ensure the directory exists, or Grimblast will just silently fail and leave you wondering where your image went.*

| Shortcut | Action |
| :--- | :--- |
| **Print** | Save Screen to File |
| **SUPER** + **Print** | Save Selected Area to File |
| **SUPER** + **ALT** + **Print** | Save Active Window to File |
| **SHIFT** + **Print** | Copy Screen to Clipboard |
| **SUPER** + **SHIFT** + **Print** | Copy Selected Area to Clipboard |
| **CTRL** + **Print** | Copy & Save Selected Area |
| **SUPER** + **CTRL** + **ALT** + **Print** | Edit Selected Area (Opens in GIMP/Editor) |

## Issues

This guide is probably incomplete because I likely forgot half the steps I actually took to get this working. In that case, feel free to raise a new issue.

## Wallpaper

All the wallpapers are collected from https://wallhaven.cc
