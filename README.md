# fuzzy-goggles

**CH32V Microcontroller Firmware for Bambu Lab AMS Controller**

An Arduino-based firmware project for the CH32V203F8P6 microcontroller that powers the Bambu Lab AMS (Automatic Material System) controller. This firmware manages multi-channel RGB LED control, BambuBus communication protocol, precision motion control, and filament sensing for 3D printer automatic material handling.

## 🎯 Project Overview

This firmware enables a CH32V microcontroller to function as an AMS controller for Bambu Lab 3D printers, providing:

- **Multi-Channel RGB LED Control**: 5 independent LED channels (4 filament channels + main board status)
- **BambuBus Communication**: Custom protocol for seamless printer integration
- **Precision Motion Control**: AS5600 magnetic encoder integration for accurate filament positioning
- **Filament Detection**: Advanced sensing and status reporting
- **Non-Volatile Storage**: Configuration and calibration data persistence
- **Real-Time Debugging**: Comprehensive logging and diagnostic capabilities

## 🏗️ Architecture

### Hardware Platform
- **Microcontroller**: CH32V203F8P6 (32-bit RISC-V)
- **Framework**: Arduino with PlatformIO
- **Peripherals**: ADC with DMA, I2C, SPI, multiple GPIO channels
- **Programming**: WCH-Link debugger/programmer

### Key Components
- **BambuBus Protocol** (`BambuBus.cpp/.h`) - Custom communication system
- **RGB LED Management** (`Adafruit_NeoPixel.cpp/.h`) - CH32V-optimized NeoPixel library
- **Motion Control** (`Motion_control.cpp/.h`) - Encoder-based filament positioning  
- **Flash Storage** (`Flash_saves.cpp/.h`) - Configuration persistence
- **ADC/DMA System** (`ADC_DMA.cpp/.h`) - High-performance sensor interface
- **Debug System** (`Debug_log.cpp/.h`) - Real-time diagnostics

## 📋 Features

### Multi-Channel LED Control
- **4 Filament Channels**: Individual RGB control per filament slot
- **Main Board Status**: Dedicated status indicator LED
- **Brightness Management**: Channel-specific brightness control
- **Color Mapping**: Filament type and status visualization

### Communication Protocol
- **BambuBus Integration**: Native protocol support for Bambu Lab printers (see [Bambu-Bus Protocol](https://github.com/Bambu-Research-Group/Bambu-Bus.git) for specification details)
- **Real-Time Status**: Filament presence, motion state, error reporting
- **Command Processing**: Motion commands, configuration updates
- **CRC Validation**: Data integrity verification with CRC16/CRC8 checksums

### Motion Control System  
- **AS5600 Encoder**: High-precision magnetic position sensing
- **Stepper Motor Control**: Precise filament feeding/retraction
- **Multi-Axis Support**: Independent channel control
- **Calibration System**: Automatic setup and adjustment

### Advanced Features
- **64-bit Timestamps**: High-resolution timing system
- **DMA-Accelerated ADC**: Efficient sensor data acquisition
- **Flash Configuration**: Non-volatile settings storage
- **Comprehensive Logging**: Multi-level debug output

## 🚀 Quick Start

### Prerequisites
- **PlatformIO Core** - Development environment
- **Internet Connection** - Required for platform/library installation
- **WCH-Link Programmer** - For uploading firmware to CH32V
- **CH32V203F8P6 Target Board** - AMS controller hardware

### Installation

1. **Install PlatformIO**:
```bash
curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/get-platformio.py | python3
export PATH=$PATH:~/.local/bin
```

2. **Install CH32V Platform**:
```bash
platformio platform install ch32v
```

3. **Clone Repository**:
```bash
git clone https://github.com/MillionthOdin16/fuzzy-goggles.git
cd fuzzy-goggles
```

4. **Create Configuration** (see [Development Setup](#development-setup) for details)

### Build and Upload

```bash
# Build firmware (10-15 minutes first time)
platformio run

# Upload to device (requires WCH-Link)  
platformio run --target upload

# Monitor serial output
platformio device monitor
```

## 🛠️ Development Setup

### Project Configuration

Create `platformio.ini` in the project root:

```ini
[env:ch32v203f8p6]
platform = ch32v
board = ch32v203f8p6
framework = arduino

monitor_speed = 115200
monitor_port = /dev/ttyUSB0

build_flags = 
    -DSERIAL_USB
    -DBOARD_CH32V203F8P6
    -DLED_PA11_NUM=2
    -DLED_PA8_NUM=2  
    -DLED_PB1_NUM=2
    -DLED_PB0_NUM=2
    -DLED_PD1_NUM=1

lib_deps = 
    adafruit/Adafruit NeoPixel@^1.10.6
    rweather/Crypto@^0.4.0

upload_protocol = wch-link
upload_port = /dev/ttyACM0

debug_tool = wch-link  
debug_speed = 1000
```

### Missing Dependencies

The project requires CRC libraries not included in the repository. Create `lib/CRC/` with:

**CRC16.h**:
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

**CRC8.h**:
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

### Development Workflow

1. **Make Changes**: Edit source files in `src/`
2. **Build**: `platformio run` (be patient, can take 10+ minutes)
3. **Test**: Upload and validate on hardware
4. **Debug**: Use `platformio device monitor` for serial output

## 📁 Project Structure

```
fuzzy-goggles/
├── src/                           # Source code (~7,500 lines)
│   ├── main.cpp/.h               # Application entry point
│   ├── BambuBus.cpp/.h           # Communication protocol  
│   ├── Adafruit_NeoPixel.cpp/.h  # LED control (CH32V-optimized)
│   ├── Motion_control.cpp/.h     # Motor and encoder control
│   ├── Flash_saves.cpp/.h        # Configuration storage
│   ├── ADC_DMA.cpp/.h            # Sensor interface
│   ├── Debug_log.cpp/.h          # Logging system
│   ├── many_soft_AS5600.cpp/.h   # Magnetic encoder support
│   └── time64.cpp/.h             # High-resolution timing
├── lib/                          # Local libraries (create as needed)
├── BMCU-370-C-V0.1-0020-A1.bin  # Pre-compiled firmware
├── BMCU 370 Firmware Downloading Guide.pdf  # Hardware documentation
└── platformio.ini               # Build configuration (create)
```

## 🔧 Configuration

### LED Channel Configuration
```cpp
#define LED_PA11_NUM 2    // Channel 1 LED count
#define LED_PA8_NUM  2    // Channel 2 LED count  
#define LED_PB1_NUM  2    // Channel 3 LED count
#define LED_PB0_NUM  2    // Channel 4 LED count
#define LED_PD1_NUM  1    // Main board LED count
```

### Build Flags
- `SERIAL_USB` - Enable USB serial communication
- `BOARD_CH32V203F8P6` - Target board specification
- `LED_*_NUM` - LED count per channel

## 🧪 Testing

### Hardware Requirements
- CH32V203F8P6 development board or AMS controller
- WCH-Link programmer/debugger
- Power supply (3.3V/5V depending on board)
- RGB LEDs (WS2812B compatible)
- AS5600 magnetic encoders (optional for full testing)

### Test Procedures

1. **Power-On Test**: Verify LED initialization and status indication
2. **Communication Test**: Validate BambuBus protocol functionality  
3. **Motion Test**: Check encoder readings and motor control
4. **Storage Test**: Verify flash read/write operations

### Serial Debugging
```bash
platformio device monitor --baud 115200
```

## ⚠️ Important Notes

### Build Considerations
- **First Build**: Can take 15+ minutes due to toolchain download
- **Internet Required**: Platform and library installation needs network access  
- **Timeout Settings**: Use generous timeouts (20+ minutes) for build processes
- **Hardware Validation**: Always test on actual hardware after changes

### Critical Components
- **BambuBus Protocol**: Modifications can affect printer communication
- **Flash Operations**: Incorrect implementation can brick the device
- **Motion Control**: Timing changes can cause mechanical issues
- **LED Control**: Channel configuration must match hardware

## 🔗 Related Projects and Resources

This project builds upon and relates to several other open-source initiatives in the Bambu Lab ecosystem:

### Protocol Documentation and Implementation
- **[Bambu-Bus Protocol](https://github.com/Bambu-Research-Group/Bambu-Bus.git)** - Reference implementation and documentation of the BambuBus communication protocol used in this firmware
- **[BMCU Wiki](https://github.com/xwzkj/bmcu-wiki.git)** - Comprehensive wiki documentation for BMCU (Bambu Lab Microcontroller Unit) systems and protocols

### Alternative Implementations  
- **[BMCU Alternative Implementation](https://github.com/karlingen/BMCU.git)** - Alternative approach to BMCU firmware development
- **[BMCU370 Project](https://github.com/krrr/BMCU370.git)** - Specialized implementation for BMCU370 controllers, closely related to this project's target hardware

These repositories provide valuable context, protocol specifications, and alternative approaches that complement this firmware implementation. Users interested in understanding the broader Bambu Lab ecosystem or contributing to protocol development should explore these resources.

## 🤝 Contributing

### Development Guidelines
1. **Test on Hardware**: Always validate changes on actual hardware
2. **Preserve Protocol**: Don't modify BambuBus implementation without understanding
3. **Document Changes**: Update relevant documentation
4. **Code Style**: Follow existing conventions and formatting

### Common Development Tasks
- **Adding LED Effects**: Modify RGB control functions in `main.cpp`
- **Protocol Extensions**: Extend BambuBus message handlers
- **Sensor Integration**: Add new sensor support via ADC/DMA system
- **Configuration Options**: Extend flash storage system

## 📚 Additional Resources

- **Hardware Guide**: `BMCU 370 Firmware Downloading Guide.pdf`
- **PlatformIO Docs**: https://docs.platformio.org/
- **CH32V Documentation**: WCH official documentation
- **Arduino Framework**: Standard Arduino API reference

## 📄 License

This project does not currently include a license file. Please contact the project maintainer for licensing information.

---

**Note**: This is embedded firmware for specialized 3D printer hardware. Ensure you have the appropriate hardware setup before attempting to build or deploy this firmware.