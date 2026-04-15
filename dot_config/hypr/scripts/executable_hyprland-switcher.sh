#!/bin/bash

if hyprctl monitors | grep -q "HDMI-A-1"; then
    hyprctl keyword workspace 1,monitor:HDMI-A-1,default:true
    hyprctl keyword workspace 2,monitor:eDP-1,default:true
    hyprctl dispatch moveworkspacetomonitor 1 HDMI-A-1
    hyprctl dispatch moveworkspacetomonitor 2 eDP-1
    hyprctl dispatch workspace 1
else
    hyprctl keyword workspace 1,monitor:eDP-1,default:true
    hyprctl dispatch moveworkspacetomonitor 1 eDP-1
    hyprctl dispatch workspace 1
fi
