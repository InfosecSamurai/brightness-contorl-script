#!/bin/bash

# Check if a level has been provided
if [ -z "$1" ]; then
    echo "Usage: $0 <level (0-100)>"
    exit 1
fi

LEVEL=$1

# Validate input
if ! [[ "$LEVEL" =~ ^[0-9]+$ ]] || [ "$LEVEL" -lt 0 ] || [ "$LEVEL" -gt 100 ]; then
    echo "Error: Level must be an integer between 0 and 100."
    exit 1
fi

# Set volume using amixer (for Linux)
amixer set Master "$LEVEL%"
echo "Volume set to $LEVEL%"
