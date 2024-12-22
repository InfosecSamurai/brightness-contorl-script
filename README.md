# 🛠️ Linux Utility Scripts

## 🌐 Overview

If you encounter issues with changing brightness using your keyboard shortcuts, this repository contains scripts designed to enhance control over various system settings, including brightness, volume, screen resolution, CPU governor, night mode, and Wi-Fi management.

### 💡 Brightness Control Script 

This script creates a symlink to the Intel backlight settings, making it easier to manage brightness on Linux systems where default keybindings may not work.

#### 📜 Script Details

#### `set_brightness_symlink.sh`
This script does the following:
- ❌ Removes the existing `nvidia_0` symlink (if it exists).
- ➡️ Creates a new symlink pointing to `intel_backlight`.

---

### 🔧 Additional Scripts
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

# Change resolution using xrandr (for Linux)
xrandr -s $RESOLUTION
echo "Resolution changed to $RESOLUTION"
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

# Toggle night mode (example using redshift)
if pgrep -x "redshift" > /dev/null; then
    killall redshift
    echo "Night mode disabled."
else
    redshift -O 4500K
    echo "Night mode enabled."
fi
```

---

### 📶 Wi-Fi Toggle Script
**Script Name**: `wifi_toggle.sh`  
**Description**: Toggles the Wi-Fi on or off.

```bash
#!/bin/bash

# Check the current Wi-Fi status
STATUS=$(nmcli radio wifi)

if [ "$STATUS" == "enabled" ]; then
    nmcli radio wifi off
    echo "Wi-Fi turned off."
else
    nmcli radio wifi on
    echo "Wi-Fi turned on."
fi
```

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
For questions or suggestions, reach out to [your email or GitHub profile link].

### Enhancements Made:
1. **Section Dividers**: Used `---` to separate different scripts, enhancing readability.
2. **Consistent Formatting**: Kept consistent formatting for script names and descriptions.
3. **Clarity**: Clear headings and bulleted lists for easy navigation and understanding.
4. **Repository Name**: Updated the clone command with the new repository name `linux-utility-scripts`.
