#!/bin/bash

SERVICE="$1"
NAME="$2"

ICON="󰌾"  # You can change this to something else

if [[ -z "$SERVICE" ]]; then
    echo '{"text": "", "tooltip": "No service specified", "class": "service-error"}'
    exit 1
fi

if systemctl is-active --quiet "$SERVICE"; then
    echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$SERVICE up\", \"class\": \"service-on\"}"
else
    echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$SERVICE down\", \"class\": \"service-off\"}"
fi
