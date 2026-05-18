#!/bin/bash

NETWORK_ID="$1"
NAME="${2:-ZeroTier}"

ICON="󰒋"

if [[ -z "$NETWORK_ID" ]]; then
    echo '{"text": "", "tooltip": "No network ID specified", "class": "service-error"}'
    exit 1
fi

status=$(zerotier-cli get "$NETWORK_ID" status 2>/dev/null)

case "$status" in
    OK)
        echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$NAME connected ($status)\", \"class\": \"service-on\"}"
        ;;
    "")
        echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$NAME not joined\", \"class\": \"service-off\"}"
        ;;
    *)
        echo "{\"text\": \"$ICON $NAME\", \"tooltip\": \"$NAME $status\", \"class\": \"service-error\"}"
        ;;
esac
