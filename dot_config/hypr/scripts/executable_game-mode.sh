#!/bin/bash

ACTION=$1
APPID=$2

if [ "$ACTION" == "1" ]; then
	noctalia msg power-set performance
	noctalia msg notification-dnd-set on
	hyprctl keyword animations:enabled 0

	echo "Gaming mode start for AppID: $APPID"
elif [ "$ACTION" == "0" ]; then
	noctalia msg power-set balanced
	noctalia msg notification-dnd-set off
	hyprctl keyword animations:enabled 1

	echo "Gaming mode stopped for AppID: $APPID"
fi
