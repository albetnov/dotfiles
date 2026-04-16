#!/bin/bash

ACTION=$1
APPID=$2

if [ "$ACTION" == "1" ]; then
	qs -c noctalia-shell ipc call powerProfile enableNoctaliaPerformance
	qs -c noctalia-shell ipc call notifications enableDND
	hyprctl keyword animations:enabled 0

	echo "Gaming mode start for AppID: $APPID"
elif [ "$ACTION" == "0" ]; then
	qs -c noctalia-shell ipc call powerProfile disableNoctaliaPerformance
	qs -c noctalia-shell ipc call notifications disableDND
	hyprctl keyword animations:enabled 1

	echo "Gaming mode stopped for AppID: $APPID"
fi
