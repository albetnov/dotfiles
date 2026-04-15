# ~/.config/hypr/scripts/kde-cache.sh
#!/bin/bash
rm -f ~/.cache/ksycoca6_*
XDG_MENU_PREFIX=plasma- kbuildsycoca6 --noincremental
