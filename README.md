# fuzzy-goggles

CH32V203F8P6 microcontroller firmware for Bambu Lab AMS (Automatic Material System) controller. This firmware provides multi-channel RGB LED control, BambuBus communication protocol implementation, and motion control with magnetic encoders.

## 🚀 Quick Start

### Prerequisites
- [PlatformIO](https://platformio.org/install) (recommended) or Arduino IDE with CH32V support
- WCH-Link debugger/programmer
- CH32V203F8P6 development board

### Build and Upload

```bash
# Using the development script (recommended)
./dev.sh setup      # One-time setup
./dev.sh build      # Build firmware
./dev.sh upload     # Upload to device

# Or using Make
make install        # One-time setup
make build          # Build firmware
make upload         # Upload to device

# Or using PlatformIO directly
pio run -e ch32v203f8p6
pio run -e ch32v203f8p6 -t upload
```

## 🏗️ Architecture

### Hardware Features
- **Multi-Channel RGB Control**: 5 independent channels (PA11, PA8, PB1, PB0, PD1)
- **BambuBus Protocol**: Custom communication for 3D printer integration
- **Motion Control**: AS5600 magnetic encoder support for precision positioning
- **Flash Storage**: Non-volatile configuration and calibration data
- **ADC/DMA**: High-performance analog data acquisition
- **Debug Logging**: UART-based debugging and monitoring

### Software Components
- `main.cpp/h` - Main application logic and RGB control
- `BambuBus.cpp/h` - Communication protocol implementation
- `Motion_control.cpp/h` - Stepper motor and encoder control
- `Flash_saves.cpp/h` - Non-volatile storage management
- `ADC_DMA.cpp/h` - Analog data acquisition
- `Debug_log.cpp/h` - Logging and diagnostics
- `Adafruit_NeoPixel.cpp/h` - LED strip control library
- `many_soft_AS5600.cpp/h` - Magnetic encoder interface
- `time64.cpp/h` - High-resolution timing functions

## 🛠️ Development

### Environment Setup
```bash
# Install PlatformIO
pip install platformio

# Setup project
./dev.sh setup

# Or manually
pio platform install chipsalliance-wch-ch32v
pio lib install
```

### Development Commands
```bash
./dev.sh build      # Build firmware
./dev.sh upload     # Upload to device  
./dev.sh clean      # Clean build artifacts
./dev.sh format     # Format code
./dev.sh analyze    # Static code analysis
./dev.sh info       # Project information
```

### Code Quality
- **Formatting**: Uses clang-format with Google style
- **Analysis**: PlatformIO check with cppcheck
- **CI/CD**: GitHub Actions for automated builds
- **Testing**: GoogleTest framework for unit tests

## 📁 Project Structure

```
fuzzy-goggles/
├── src/                    # Source code
│   ├── main.cpp           # Main application
│   ├── BambuBus.cpp       # Communication protocol
│   ├── Motion_control.cpp # Motor control
│   └── ...                # Other modules
├── test/                  # Unit tests
├── .github/              # GitHub Actions CI/CD
├── platformio.ini        # Build configuration
├── Makefile             # Build automation
├── dev.sh               # Development script
└── README.md            # This file
```

## 🔧 Configuration

### Build Environments
- `ch32v203f8p6` - Release build for production
- `debug` - Debug build with symbols and logging
- `test` - Native unit tests

### Hardware Configuration
```cpp
// RGB LED channels
#define LED_PA11_NUM 2    // Channel 1
#define LED_PA8_NUM 2     // Channel 2  
#define LED_PB1_NUM 2     // Channel 3
#define LED_PB0_NUM 2     // Channel 4
#define LED_PD1_NUM 1     // Main board LED
```

## 🚨 Hardware Requirements

### Microcontroller
- **Model**: CH32V203F8P6
- **Architecture**: RISC-V 32-bit
- **Flash**: 64KB
- **RAM**: 20KB
- **Clock**: Up to 144MHz

### Programmer
- **WCH-Link**: Official WCH debugger/programmer
- **Connection**: SWD interface
- **Power**: 3.3V logic level

### External Components
- AS5600 magnetic position sensors
- WS2812B/NeoPixel RGB LED strips
- Various GPIO peripherals

## 📚 Documentation

See [src/README.md](src/README.md) for detailed component documentation.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests: `./dev.sh analyze`
5. Format code: `./dev.sh format`
6. Submit a pull request

## 📄 License

This project is part of the Bambu Lab ecosystem. See the [LICENSE](LICENSE) file for details.

## 🔗 Related Projects

- [Bambu-Bus Protocol](https://github.com/Bambu-Research-Group/Bambu-Bus.git) - Official protocol specification
- [BMCU Wiki](https://github.com/xwzkj/bmcu-wiki.git) - Technical documentation
- [BMCU Alternative](https://github.com/karlingen/BMCU.git) - Alternative implementations
- [BMCU370 Project](https://github.com/krrr/BMCU370.git) - Hardware-specific examples

## ⚡ Getting Help

1. Check the [Issues](https://github.com/MillionthOdin16/fuzzy-goggles/issues) page
2. Review the [src/README.md](src/README.md) for technical details
3. Run `./dev.sh info` for project information
4. Use `./dev.sh help` for development commands

---

**Note**: This is specialized embedded firmware requiring specific hardware for testing and validation. The build system supports cross-compilation and static analysis for development without hardware.