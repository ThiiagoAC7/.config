#!/usr/bin/env bash

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

dir="$HOME/.config/polybar"

echo "---" | tee -a /tmp/polybar.log 
# polybar -q gray -c "$dir/grayblocks/config.ini"  2>&1 | tee -a /tmp/polybar.log & disown
polybar main 2>&1 | tee -a /tmp/polybar.log & disown

echo "Bars launched..."
