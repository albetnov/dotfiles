# Dotfiles

Welcome to my Dotfiles. This repository currently holds configuration of my Fedora Setup:

- Ghostty
- nvim
- Sway

## Sway Setup

In case I forget on how to use this config...

- [1] Get latest fedora workstation (yes, the gnome one)
- Run `sudo dnf group install sway-desktop-envrionment`
- [2] Fix gnome-keyring: ["Using gnome-keyring-daemon outside desktop environments (KDE, GNOME, XFCE, ...)"](https://wiki.archlinux.org/title/GNOME/Keyring)
- [3] Mask Gnome Portal: `systemctl --user mask xdg-desktop-portal-gnome`
- Do steps here to ensure everything work properly [XDG Desktop Portal WLR Troubleshoots](https://github.com/emersion/xdg-desktop-portal-wlr/wiki/%22It-doesn't-work%22-Troubleshooting-Checklist)
- Install utilities if not available: `sudo dnf install brightnessctl pactl grimshot`
- Install ghostty:
    ```bash 
    dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

    dnf install ghostty
    ```
- Replace touchpad configuration (if using touchpad), should simply change it's name by looking at: `swaymsg -t get_inputs`
- Install waybar `sudo dnf install waybar`
- Setup tray support for waybar: `sudo dnf install libappindicator-gtk3`
- [4] Install rofi wayland `sudo dnf install rofi-wayland` [Rofi Wayland]( https://github.com/lbonn/rofi)
- [5] Install some hyprland utilities `sudo dnf copr enable solopasha/hyprland -y && sudo dnf install hyprlock hypridle`
- Optional utility but included in the configs: `sudo dnf install fastfetch`
- Install kanshi for multi monitor setup and scaling `sudo dnf install kanshi -y && systemctl --user enable --now kanshi`
- [6] Setup notification daemon: `sudo dnf copr enable erikreider/SwayNotificationCenter -y && sudo dnf install swayosd`
- Yet another utilities (bluetooth & sound): `sudo dnf install blueman pavucontrol`

That's all I can remember of, I am not sure if I misses some steps, but here it goes.

> [1] You can also start from Fedora Sway Spin, I personally just prefer Gnome. If you do start from Sway Spin you might would spent more time on adjusting rather than creating/installing
>
> [2] Follow the instructions, it should suffice. Additionally, if you use GDM or SDDM that automate PAM, Gnome-keyring should work out of the box but might prompt for password when first access after boot.
>
> [3] This service annoy me so much, I thought sway getting slower after logout, turn out this portal thingy conflicted with Gnome ones, masking it alone seems to not fix. A config `$HOME/.config/xdg-desktop-portal/sway-portals.conf` is needed, hence why I included them. That being said, if you don't want/need other functionalities such as file picker, etc you can mask `gnome-portal-desktop-gtk` and `sway-portals.conf` is not longer required.
>
> [4] Right now, a lot of things relaying on Rofi (the applets). The rofi preset is basically from [https://github.com/adi1090x/rofi](https://github.com/adi1090x/rofi). Might need to trim it down... I plan to move the applets to native app which I plan to develop in the future until I have more free-time lol
> 
> [5] I chose hyprland utilities for locking and idling just because they look more aesthethic in my opinion, if you aim for simpler then `swayidle` and `swaylock` already enough. If you choose to go with hyprland utilities as well, then both swayidle and swaylock can be optionally removed.
>
> [6] I chose this notification daemon because it did more than just showing notification. However, it lacks customization. You can choose dunst or mako for alternative.
