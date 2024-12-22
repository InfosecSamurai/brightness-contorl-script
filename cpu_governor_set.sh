#!/bin/bash

# Function to display usage information
usage() {
    echo "Usage: $0 <governor (e.g., performance, powersave, ondemand, conservative)>"
    exit 1
}

# Check if a governor has been provided
if [ -z "$1" ]; then
    usage
fi

GOVERNOR=$1

# List of valid governors (modify as needed)
VALID_GOVERNORS=("performance" "powersave" "ondemand" "conservative")

# Check if the provided governor is valid
if [[ ! " ${VALID_GOVERNORS[@]} " =~ " ${GOVERNOR} " ]]; then
    echo "Error: Invalid governor '$GOVERNOR'. Valid options are: ${VALID_GOVERNORS[*]}"
    exit 1
fi

# Set CPU governor (requires root privileges)
if echo "$GOVERNOR" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null; then
    echo "CPU governor changed to $GOVERNOR"
else
    echo "Error: Failed to change CPU governor."
    exit 1
fi
