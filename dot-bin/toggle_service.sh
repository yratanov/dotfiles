#!/bin/bash

SERVICE="$1"

if [[ -z "$SERVICE" ]]; then
    notify-send "Service Toggle" "No service name provided"
    exit 1
fi

if systemctl is-active --quiet "$SERVICE"; then
    sudo -n /usr/bin/systemctl stop "$SERVICE" && notify-send "Service" "$SERVICE stopped"
else
    sudo -n /usr/bin/systemctl start "$SERVICE" && notify-send "Service" "$SERVICE started"
fi
