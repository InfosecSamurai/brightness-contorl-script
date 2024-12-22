# 🛠️ Linux Utility Scripts

## 🌐 Overview

If you encounter issues with changing brightness using your keyboard shortcuts, this repository contains scripts designed to enhance control over various system settings, including brightness, volume, screen resolution, CPU governor, night mode, and Wi-Fi management.

### 📜 Script(s) Details
```
brightness_symlink.sh
volume_control.sh
resolution_changer.sh
cpu_governor.sh
night_mode_toggle.sh
toggle_wifi.sh
```
---

## 💡 Brightness Control Script 

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

## 🔊 Volume Control Script
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

## 🖥️ Screen Resolution Changer Script
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

```bash
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
```

### Improvements Made

1. **Usage Function**: 
   - Added a `usage` function to provide clear instructions for how to use the script.

2. **Valid Governor Check**: 
   - Implemented a check to validate the provided governor against a predefined list of valid governors. An error message is shown if the user inputs an invalid governor.

3. **Error Handling on `tee` Command**: 
   - The script now checks whether the `tee` command successfully executed and gives feedback if it fails.

### How to Use the Updated Script

1. **Save the script** to a file, e.g., `set_cpu_governor.sh`.
2. **Make it executable**:
   ```bash
   chmod +x set_cpu_governor.sh
   ```
3. **Run the script with a valid governor** (requires root privileges):
   ```bash
   ./set_cpu_governor.sh performance
   ```

### Note
- Ensure that the script is executed with sufficient privileges (it may prompt for a password depending on your system's configuration), as it modifies system files.
- The list of valid governors can be adjusted based on the governors supported by your CPU and system configuration. You can typically check which governors are available on your system by looking into `/sys/devices/system/cpu/cpu*/cpufreq/scaling_available_governors`.
---

## 🌙 Night Mode Toggle Script
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

---

## 📶 Wi-Fi Toggle Script
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
