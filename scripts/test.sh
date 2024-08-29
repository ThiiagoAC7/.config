#!/bin/bash

# all connected displays
XRANDR_OUTPUT=$(xrandr | grep " connected ")

# primary display
PRIMARY_DISPLAY=$(echo "$XRANDR_OUTPUT" | grep " primary" | awk '{print $1}')

# HDMI display
HDMI_DISPLAY=$(echo "$XRANDR_OUTPUT" | grep "HDMI" | awk '{print $1}')

echo "Primary display: $PRIMARY_DISPLAY"
echo "HDMI display: $HDMI_DISPLAY"
