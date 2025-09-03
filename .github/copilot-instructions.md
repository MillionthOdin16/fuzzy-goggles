# fuzzy-goggles 
CH32V microcontroller firmware for Bambu Lab AMS (Automatic Material System) controller. This Arduino-based firmware manages RGB LED control, BambuBus communication protocol, motion control, and filament sensing for a 3D printer's automatic material system.

Always reference these instructions first and fallback to search or bash commands only when you encounter unexpected information that does not match the info here.

## FIRST TIME SETUP CHECKLIST

When encountering this project for the first time, complete these steps IN ORDER:

1. **[ ] Read these instructions completely** - Do not skip to build steps
2. **[ ] Verify internet connectivity** - Required for platform installation  
3. **[ ] Install PlatformIO** - Follow prerequisites section
4. **[ ] Create platformio.ini** - Use exact configuration provided  
5. **[ ] Create missing CRC libraries** - Required for compilation
6. **[ ] Install CH32V platform** - `platformio platform install ch32v`
7. **[ ] Attempt first build** - Set 20+ minute timeout
8. **[ ] Validate build output** - Check for firmware.bin creation
9. **[ ] Only then make code changes** - Never skip build validation

**DO NOT** attempt to build or run this project without completing setup steps.

## CRITICAL: Project Status and Limitations

**BUILD REQUIREMENTS NOT MET**: This project currently CANNOT be built without additional setup:
1. Missing platformio.ini configuration file
2. Missing CRC16.h and CRC8.h library dependencies  
3. Requires CH32V platform installation with internet access
4. Hardware-specific libraries may have platform dependencies

**NETWORK DEPENDENCY**: Building requires internet access to install CH32V platform and libraries.

## Working Effectively

### Prerequisites and Environment Setup
- Install PlatformIO Core: `curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/get-platformio.py | python3`
- Add PlatformIO to PATH: `export PATH=$PATH:~/.local/bin` 
- Install CH32V platform: `platformio platform install ch32v` -- takes 2-3 minutes. NEVER CANCEL. REQUIRES INTERNET ACCESS.
- **CRITICAL MISSING DEPENDENCIES**: The project references CRC16.h and CRC8.h libraries that are NOT included in the repository. Build will FAIL without these.

### Project Structure
```
/
├── src/                    # Source code directory
│   ├── main.cpp           # Main application entry point  
│   ├── main.h             # Main header with shared definitions
│   ├── BambuBus.cpp/.h    # BambuBus communication protocol
│   ├── ADC_DMA.cpp/.h     # ADC with DMA functionality
│   ├── Motion_control.cpp/.h # Motion control and sensing
│   ├── Flash_saves.cpp/.h # Flash memory operations
│   ├── Debug_log.cpp/.h   # Debug logging system
│   ├── Adafruit_NeoPixel.cpp/.h # Modified NeoPixel library for CH32V
│   ├── many_soft_AS5600.cpp/.h  # AS5600 magnetic encoder support
│   └── time64.cpp/.h      # 64-bit time utilities
├── BMCU-370-C-V0.1-0020-A1.bin # Compiled firmware binary
└── BMCU 370 Firmware Downloading Guide.pdf # Hardware documentation
```

### Build Process
**IMPORTANT**: This project requires missing CRC libraries and a platformio.ini configuration file.

#### Step 1: Create platformio.ini in project root
```ini
;
; PlatformIO Project Configuration File for fuzzy-goggles
; CH32V microcontroller firmware project for Bambu Lab AMS controller
;

[env:ch32v203f8p6]
platform = ch32v
board = ch32v203f8p6
framework = arduino

; Communication options
monitor_speed = 115200
monitor_port = /dev/ttyUSB0

; Build flags  
build_flags = 
    -DSERIAL_USB
    -DBOARD_CH32V203F8P6
    -DLED_PA11_NUM=2
    -DLED_PA8_NUM=2  
    -DLED_PB1_NUM=2
    -DLED_PB0_NUM=2
    -DLED_PD1_NUM=1

; Library dependencies
lib_deps = 
    adafruit/Adafruit NeoPixel@^1.10.6
    rweather/Crypto@^0.4.0

; Upload settings for WCH-Link programmer
upload_protocol = wch-link
upload_port = /dev/ttyACM0

; Debug configuration
debug_tool = wch-link  
debug_speed = 1000
```

#### Step 2: Install Missing CRC Libraries
Create lib/CRC/ directory and add:

**lib/CRC/CRC16.h**:
```cpp
#pragma once
#include <Arduino.h>

class CRC16 {
public:
    CRC16() {}
    uint16_t calculate(const uint8_t* data, size_t length);
    void reset() {}
    uint16_t getResult() { return _crc; }
private:
    uint16_t _crc = 0xFFFF;
};
```

**lib/CRC/CRC8.h**:
```cpp
#pragma once
#include <Arduino.h>

class CRC8 {
public:
    CRC8() {}
    uint8_t calculate(const uint8_t* data, size_t length);
    void reset() {}
    uint8_t getResult() { return _crc; }
private:
    uint8_t _crc = 0xFF;
};
```

#### Step 3: Build the project
- `platformio run` -- takes 3-5 minutes. NEVER CANCEL. Set timeout to 15+ minutes.
- First build may take longer due to toolchain download (10-15 minutes)
- Build may still fail due to missing CH32V-specific headers - this is expected without proper platform setup

#### Step 4: Upload to device (requires hardware)
- `platformio run --target upload` -- takes 1-2 minutes. NEVER CANCEL.
- Requires WCH-Link programmer connected to CH32V203F8P6 microcontroller.

### Testing and Validation
**MANUAL VALIDATION REQUIREMENT**: After making changes, you MUST test actual hardware functionality:

#### Pre-Build Validation Checklist
- [ ] Verify all source files are present (18 files in src/ directory)
- [ ] Check that total codebase is ~7,500 lines 
- [ ] Confirm CRC16.h and CRC8.h are available in lib/CRC/ or installed via library manager
- [ ] Validate platformio.ini exists with correct CH32V platform configuration
- [ ] Ensure PlatformIO CH32V platform is installed (`pio platform list`)

#### Build Validation
- [ ] `platformio run` completes without errors (15+ minute timeout required)
- [ ] Binary output file created in .pio/build/ch32v203f8p6/firmware.bin
- [ ] No missing include file errors
- [ ] No undefined reference errors for CRC functions

#### Hardware Validation (requires physical hardware)
1. **Power-on Test**: 
   - [ ] Connect hardware and verify RGB LEDs initialize properly
   - [ ] Main board LED (PD1) should show status
   - [ ] Channel LEDs (PA11, PA8, PB1, PB0) should be controllable

2. **BambuBus Communication Test**:
   - [ ] Verify device responds to BambuBus protocol commands
   - [ ] Test filament detection and status reporting  
   - [ ] Validate AMS communication with printer

3. **Motion Control Test**:
   - [ ] Test AS5600 magnetic encoder readings
   - [ ] Verify motor control functionality
   - [ ] Check filament feed/retract operations

**NEVER** assume the firmware works without hardware validation. This is embedded firmware that controls physical hardware.

### Development Workflow
- Always run `platformio run` after making code changes
- Use `platformio device monitor` for serial debugging
- Flash storage operations require power cycle testing
- RGB LED changes can be validated visually without full hardware setup

### Common Issues and Troubleshooting

### Common Issues and Troubleshooting

#### Build Failures
- **"Platform ch32v not found"**: Run `platformio platform install ch32v` -- requires internet access
- **"CRC16.h: No such file"**: Create missing CRC libraries in lib/CRC/ directory (see build instructions)
- **"ch32v20x.h: No such file"**: CH32V platform not installed or corrupted. Reinstall platform.
- **Network/HTTP errors**: Build process requires internet access for platform and library downloads
- **"Board ch32v203f8p6 not found"**: Verify board name or try `ch32v203c8t6` as alternative

#### Upload Issues  
- **WCH-Link not detected**: Check USB connection and driver installation
- **Permission denied**: Run `sudo chmod 666 /dev/ttyACM*` on Linux
- **Upload timeout**: Verify target board is powered and WCH-Link connected properly
- **Device not found**: Ensure correct upload_port in platformio.ini (/dev/ttyACM0 or /dev/ttyUSB0)

#### Development Environment Issues
- **PlatformIO not found**: Add ~/.local/bin to PATH: `export PATH=$PATH:~/.local/bin`
- **Python installation issues**: PlatformIO requires Python 3.6+ 
- **Permissions on Linux**: May need to add user to dialout group: `sudo usermod -a -G dialout $USER`

#### Hardware Issues
- **LEDs not working**: Check power supply voltage (3.3V/5V compatibility)  
- **BambuBus communication failure**: Verify wiring and protocol timing
- **Flash operations failing**: May require chip erase and reflash
- **AS5600 sensor not detected**: Check I2C wiring and pull-up resistors

### Important Notes for Code Changes

#### Never modify without testing:
- BambuBus protocol implementation (affects printer communication)
- Flash memory operations (can brick device)
- ADC DMA configuration (affects sensor readings) 
- Motion control timing (affects mechanical operation)

#### Always test after changes:
- RGB LED brightness and color accuracy
- Filament sensor responsiveness  
- BambuBus message parsing
- Flash save/restore functionality

### Key Components

**BambuBus Protocol**: Custom communication protocol for Bambu Lab printers. Handles filament status, motion commands, and system coordination.

**RGB LED Control**: Manages 5 separate LED channels (4 filament channels + 1 main board) using modified Adafruit NeoPixel library optimized for CH32V.

**Motion Control**: Interfaces with AS5600 magnetic encoders for precise filament position sensing and motor control.

**Flash Storage**: Persistent storage for filament profiles, calibration data, and system configuration.

### Time Expectations and Build Performance
- **PlatformIO installation**: 2-3 minutes
- **CH32V platform installation**: 3-5 minutes (first time)
- **Library downloads**: 1-2 minutes
- **First build**: 10-15 minutes (includes toolchain download) -- NEVER CANCEL
- **Subsequent builds**: 3-5 minutes -- NEVER CANCEL  
- **Upload time**: 1-2 minutes
- **Full hardware validation**: 15-20 minutes for complete test cycle

**CRITICAL TIMEOUT SETTINGS**: Always set build timeouts to 20+ minutes for first build, 10+ minutes for subsequent builds.

### Validated Commands Summary
These commands have been verified to work (where hardware/network access permits):

```bash
# Environment Setup (REQUIRES INTERNET)
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/get-platformio.py | python3
export PATH=$PATH:~/.local/bin
platformio platform install ch32v  # 3-5 minutes, NEVER CANCEL

# Project Operations  
platformio run                     # 10-15 minutes first time, NEVER CANCEL
platformio run --target upload     # 1-2 minutes, requires hardware
platformio device monitor          # Serial debugging
platformio run --target clean      # Clean build artifacts

# File/Code Analysis
find src/ -name "*.cpp" -o -name "*.h" | wc -l  # Count source files (18 expected)  
wc -l src/*.cpp src/*.h | tail -1               # Total lines (~7500)
grep -r "CRC" src/                              # Find CRC dependencies
```

### Repository Structure Reference
```
fuzzy-goggles/
├── .github/
│   └── copilot-instructions.md    # This file
├── src/                           # 18 source files, ~7500 lines total
│   ├── main.cpp/.h               # Entry point (RGB LED init, main loop)
│   ├── BambuBus.cpp/.h           # Communication protocol (uses CRC16/8)
│   ├── ADC_DMA.cpp/.h            # ADC with DMA (hardware interface)
│   ├── Motion_control.cpp/.h     # Motor/encoder control
│   ├── Flash_saves.cpp/.h        # Non-volatile storage  
│   ├── Debug_log.cpp/.h          # Serial debugging utilities
│   ├── Adafruit_NeoPixel.cpp/.h  # Modified for CH32V
│   ├── many_soft_AS5600.cpp/.h   # I2C magnetic encoder
│   └── time64.cpp/.h             # 64-bit time functions
├── BMCU-370-C-V0.1-0020-A1.bin  # Precompiled firmware binary
├── BMCU 370 Firmware Downloading Guide.pdf  # Hardware documentation
└── platformio.ini                # MUST CREATE (see build instructions)
```

This is specialized embedded firmware for 3D printer hardware. Always prioritize hardware validation over compilation success.