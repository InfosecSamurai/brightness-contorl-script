#!/bin/bash

# Check if redshift is installed
if ! command -v redshift &> /dev/null; then
    echo "Error: redshift is not installed. Please install it to use this script."
    exit 1
fi

# Toggle night mode (example using redshift)
if pgrep -x "redshift" > /dev/null; then
    killall redshift
    echo "Night mode disabled."
else
    # Set night mode temperature; change the value as per your preference
    redshift -O 4500K
    if [ $? -eq 0 ]; then
        echo "Night mode enabled."
    else
        echo "Error: Failed to enable night mode. Please check your redshift configuration."
        exit 1
    fi
fi
