#!/bin/bash
# run this in background to "tickle" the compositor and GPU every 100ms

while true; do
    hyprctl notify -1 " " >/dev/null 2>&1
    sleep 0.1
done

