#!/bin/bash

# Remove existing nvidia_0 symlink if it exists
if [ -L /sys/class/backlight/nvidia_0 ]; then
    sudo rm /sys/class/backlight/nvidia_0
fi

# Create a new symlink to intel_backlight
sudo ln -s /sys/class/backlight/intel_backlight /sys/class/backlight/nvidia_0

echo "Brightness symlink updated to use intel_backlight."
