# Quick Start Example

This example shows how to get started with the fuzzy-goggles CH32V firmware project.

## Prerequisites Setup

1. **Install PlatformIO** (if not already installed):
   ```bash
   pip install platformio
   ```

2. **Clone and setup the project**:
   ```bash
   git clone https://github.com/MillionthOdin16/fuzzy-goggles.git
   cd fuzzy-goggles
   ./dev.sh setup
   ```

## Basic Development Workflow

### 1. Build the firmware
```bash
./dev.sh build
# OR
make build
```

### 2. Upload to hardware (requires WCH-Link)
```bash
./dev.sh upload
# OR  
make upload
```

### 3. Monitor serial output
```bash
make monitor
```

### 4. Code quality checks
```bash
./validate.sh        # Comprehensive validation
./dev.sh format      # Format code
./dev.sh analyze     # Static analysis
```

## Project Structure

```
fuzzy-goggles/
├── src/                    # Source code
│   ├── main.cpp           # Main application (RGB control, setup/loop)
│   ├── BambuBus.cpp       # Communication protocol
│   ├── Motion_control.cpp # Stepper motor control
│   ├── Flash_saves.cpp    # Non-volatile storage
│   └── ...                # Other modules
├── test/                  # Unit tests
├── .github/              # CI/CD workflows
└── platformio.ini        # Build configuration
```

## Hardware Configuration

### RGB LED Channels
- **Channel 1** (PA11): 2 LEDs for material 1
- **Channel 2** (PA8): 2 LEDs for material 2  
- **Channel 3** (PB1): 2 LEDs for material 3
- **Channel 4** (PB0): 2 LEDs for material 4
- **Main Board** (PD1): 1 status LED

### Key Components
- **Microcontroller**: CH32V203F8P6 (RISC-V, 64KB Flash, 20KB RAM)
- **Programmer**: WCH-Link debugger
- **Sensors**: AS5600 magnetic position encoders
- **LEDs**: WS2812B/NeoPixel RGB strips

## Example Code Modifications

### 1. Change RGB Brightness
Edit `src/main.cpp`, function `RGB_Set_Brightness()`:
```cpp
void RGB_Set_Brightness() {
    strip_PD1.setBrightness(50);        // Main board (0-255)
    strip_channel[0].setBrightness(25); // Channel 1 (0-255)
    // ... adjust other channels
}
```

### 2. Modify LED Count
Edit `src/main.cpp`, modify defines:
```cpp
#define LED_PA11_NUM 4  // Change from 2 to 4 LEDs
#define LED_PA8_NUM 4   // Change from 2 to 4 LEDs
```

### 3. Add Debug Output
Use the existing debug system:
```cpp
#include "Debug_log.h"

void my_function() {
    DEBUG_MY("Custom debug message\n");
}
```

## Troubleshooting

### Build Issues
```bash
# Clean and retry
make clean
make build

# Check project structure
./validate.sh
```

### Upload Issues
1. Verify WCH-Link is connected
2. Check USB cable and drivers
3. Ensure correct board selection in platformio.ini

### Development Environment
```bash
# Show project info
./dev.sh info

# Check all tools
./dev.sh help
```

## Next Steps

1. **Customize for your hardware**: Modify LED counts and pin assignments
2. **Extend BambuBus protocol**: Add new message types
3. **Add sensors**: Integrate additional AS5600 encoders
4. **Improve motion control**: Add acceleration profiles
5. **Flash storage**: Add configuration parameters

## Resources

- [CH32V Reference Manual](https://www.wch.cn/products/CH32V203.html)
- [Arduino CH32V Documentation](https://github.com/Community-PIO-CH32V/platform-ch32v)
- [WCH-Link Programmer Guide](https://www.wch.cn/products/WCH-Link.html)
- [AS5600 Sensor Datasheet](https://ams.com/as5600)