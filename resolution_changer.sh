#!/bin/bash

# Check if a resolution has been provided
if [ -z "$1" ]; then
    echo "Usage: $0 <resolution (e.g., 1920x1080)>"
    exit 1
fi

RESOLUTION=$1

# Validate input format (e.g., 1920x1080)
if ! [[ "$RESOLUTION" =~ ^[0-9]+x[0-9]+$ ]]; then
    echo "Error: Resolution must be in the format WIDTHxHEIGHT (e.g., 1920x1080)."
    exit 1
fi

# Change resolution using xrandr (for Linux)
xrandr -s "$RESOLUTION"

# Check if the command was successful
if [ $? -eq 0 ]; then
    echo "Resolution changed to $RESOLUTION"
else
    echo "Error: Failed to change resolution to $RESOLUTION. Please check the available resolutions."
    exit 1
fi
