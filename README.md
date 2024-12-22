# 🛠️ Linux Utility Scripts

## 🌐 Overview

If you encounter issues with changing brightness using your keyboard shortcuts, this repository contains scripts designed to enhance control over various system settings, including brightness, volume, screen resolution, CPU governor, night mode, and Wi-Fi management.

## 💡 Brightness Control Script 

This script creates a symlink to the Intel backlight settings, making it easier to manage brightness on Linux systems where default keybindings may not work.

### 📜 Script Details

```
set_brightness_symlink.sh
```
---
This script does the following:
- ❌ Removes the existing `nvidia_0` symlink (if it exists).
- ➡️ Creates a new symlink pointing to `intel_backlight`.

**Script Code**:
```bash
#!/bin/bash

# Define the symlink target and link paths
TARGET="/sys/class/backlight/intel_backlight"
LINK="/sys/class/backlight/nvidia_0"

# Check if the target exists
if [ ! -d "$TARGET" ]; then
    echo "Error: Target directory $TARGET does not exist."
    exit 1
fi

# Remove existing nvidia_0 symlink if it exists
if [ -L "$LINK" ]; then
    sudo rm "$LINK" && echo "Removed existing symlink $LINK."
else
    echo "No existing symlink found at $LINK."
fi

# Create a new symlink to intel_backlight
if sudo ln -s "$TARGET" "$LINK"; then
    echo "Brightness symlink updated to use intel_backlight."
else
    echo "Error: Failed to create symlink $LINK."
    exit 1
fi
```
This script effectively updates the brightness symlink from `nvidia_0` to `intel_backlight`. To enhance it, we can include error handling, checks to ensure that the source (`intel_backlight`) exists before creating the symlink, and more informative status messages. Here’s an improved version of your script:

### Features

1. **Target Existence Check**: 
   - Before attempting to create a symlink, the script now checks if the `intel_backlight` directory exists. If it doesn't, the script will exit with an error message.

2. **Verbose Feedback**: 
   - Added messages to indicate whether the existing symlink was removed, whether it existed at all, and whether the new symlink creation was successful or failed.

3. **Use of Variables**:
   - The target and link paths are assigned to variables for easier modification and better readability.

4. **Error Checking on `ln` Command**:
   - The script checks if the `ln` command was successful and provides feedback accordingly.

### How to Use the Script

1. **Save the script** to a file, e.g., `brightness_symlink.sh`.
2. **Make it executable**:
   ```bash
   chmod +x brightness_symlink.sh
   ```
3. **Run the script**:
   ```bash
   ./brightness_symlink.sh
   ```
---

## 🔧 Additional Scripts

In addition to the brightness control script, this repository includes several other scripts to help manage system settings:

### 🔊 Volume Control Script
**Script Name**: `volume_control.sh`  
**Description**: Adjusts the system's volume level directly from the command line.

```bash
#!/bin/bash

# Check if a level has been provided
if [ -z "$1" ]; then
    echo "Usage: $0 <level (0-100)>"
    exit 1
fi

LEVEL=$1

# Set volume using amixer (for Linux)
amixer set Master $LEVEL%
echo "Volume set to $LEVEL%"
```
#### How to Run the Script

Save the script to a file, e.g., `set_volume.sh.`
Make it executable with the command:

          
```
chmod +x set_volume.sh
```
    

Run the script with a level argument:

      
```
./set_volume.sh
```
---

### 🖥️ Screen Resolution Changer Script
**Script Name**: `resolution_changer.sh`  
**Description**: Changes the screen resolution based on user input.

```bash
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
```

#### How to Use the Script

Save the script to a file, for example, `change_resolution.sh`
Make it executable with the command:

          
```
chmod +x change_resolution.sh
```
    

Run the script with a resolution argument:

```
./change_resolution.sh 1920x1080
```
    
---

### ⚙️ CPU Governor Set Script
**Script Name**: `cpu_governor_set.sh`  
**Description**: Changes the CPU frequency governor for performance or power savings.

```bash
#!/bin/bash

# Check if a governor has been provided
if [ -z "$1" ]; then
    echo "Usage: $0 <governor (e.g., performance, powersave)>"
    exit 1
fi

GOVERNOR=$1

# Set CPU governor (requires root privileges)
echo $GOVERNOR | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor > /dev/null
echo "CPU governor changed to $GOVERNOR"
```

---

### 🌙 Night Mode Toggle Script
**Script Name**: `night_mode_toggle.sh`  
**Description**: Toggles night mode settings to reduce blue light on the screen.

```bash
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
```

### Enhancements Made

1. **Check for Installation**:
   - The script now checks if `redshift` is installed by using `command -v`. If it’s not installed, the script will prompt the user and exit.

2. **Error Handling**:
   - After attempting to enable night mode, the script checks if the command was successful (using the exit status `$?`). If not, it provides a clear error message.

3. **Improved Messages**:
   - The messages have been kept informative, guiding the user on what action has been taken or if there was an issue.

### How to Use the Script

1. **Save the script** to a file, for example, `toggle_night_mode.sh`.
2. **Make it executable** with the command:
   ```bash
   chmod +x toggle_night_mode.sh
   ```
3. **Run the script**:
   ```bash
   ./toggle_night_mode.sh
   ```

With these improvements, the script is more user-friendly and provides better feedback in case of errors.fd
---

### 📶 Wi-Fi Toggle Script
**Script Name**: `wifi_toggle.sh`  
**Description**: Toggles the Wi-Fi on or off.

```bash
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
else
    nmcli radio wifi on
    if [ $? -eq 0 ]; then
        echo "Wi-Fi turned on."
    else
        echo "Error: Failed to turn on Wi-Fi."
        exit 1
    fi
fi
```
Your script for toggling the Wi-Fi status using `nmcli` is already straightforward. 

```bash 
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
else
    nmcli radio wifi on
    if [ $? -eq 0 ]; then
        echo "Wi-Fi turned on."
    else
        echo "Error: Failed to turn on Wi-Fi."
        exit 1
    fi
fi
```

### Enhancements Made

1. **Check for Installation**:
   - The script now checks if `nmcli` is installed before attempting to use it, providing a clear error message if it's not.

2. **Error Handling**:
   - After checking the Wi-Fi status and toggling it, the script checks for errors on each command execution (`$?`). If a command fails, it reports an error and exits.

3. **Improved Messages**:
   - Enhanced messages give more insight into what went wrong if there are issues with the `nmcli` commands.

### How to Use the Script

1. **Save the script** to a file, for example, `toggle_wifi.sh`.
2. **Make it executable** with the command:
   ```bash
   chmod +x toggle_wifi.sh
   ```
3. **Run the script**:
   ```bash
   ./toggle_wifi.sh
   ```

This version of the script is more robust and user-friendly, ensuring better feedback and error handling when working with the Wi-Fi settings.
---

## 🚀 How to Use

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/InfosecSamurai/linux-utility-scripts.git
   cd linux-utility-scripts
   ```

2. **Run any of the scripts as needed**:
   ```bash
   ./set_brightness_symlink.sh
   ./volume_control.sh 50
   ./resolution_changer.sh 1920x1080
   ./cpu_governor_set.sh performance
   ./night_mode_toggle.sh
   ./wifi_toggle.sh
   ```

---

## 🤝 Additional Information

### 🛠️ Contributing
Contributions are welcome! Please follow these steps:
1. Fork the repository.
2. Create your feature branch with a descriptive name.
3. Commit your changes.
4. Push to the branch.
5. Create a pull request.

### 📄 License
This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

### 📬 Contact
For questions or suggestions, reach out to [Email](InfosecSamurai@onmail.com)
