#!/bin/bash

NETWORK_ID="$1"

if [[ -z "$NETWORK_ID" ]]; then
    notify-send "ZeroTier" "No network ID provided"
    exit 1
fi

status=$(zerotier-cli get "$NETWORK_ID" status 2>/dev/null)

if [[ -n "$status" ]]; then
    if zerotier-cli leave "$NETWORK_ID" >/dev/null; then
        notify-send "ZeroTier" "Left $NETWORK_ID"
    else
        notify-send "ZeroTier" "Failed to leave $NETWORK_ID"
    fi
else
    if zerotier-cli join "$NETWORK_ID" >/dev/null; then
        notify-send "ZeroTier" "Joined $NETWORK_ID"
    else
        notify-send "ZeroTier" "Failed to join $NETWORK_ID"
    fi
fi
