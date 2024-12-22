#!/bin/bash

# Check if nmcli is installed
if ! command -v nmcli &> /dev/null; then
    echo "Error: nmcli is not installed. Please install NetworkManager to use this script."
    exit 1
fi

# Check the current Wi-Fi status
STATUS=$(nmcli radio wifi)

# Check for errors in the status command
if [ $? -ne 0 ]; then
    echo "Error: Failed to retrieve Wi-Fi status. Please check your NetworkManager configuration."
    exit 1
fi

if [ "$STATUS" == "enabled" ]; then
    nmcli radio wifi off
    if [ $? -eq 0 ]; then
        echo "Wi-Fi turned off."
    else
        echo "Error: Failed to turn off Wi-Fi."
        exit 1
    fi
elsex
    nmcli radio wifi on
    if [ $? -eq 0 ]; then
        echo "Wi-Fi turned on."
    else
        echo "Error: Failed to turn on Wi-Fi."
        exit 1
    fi
fi
