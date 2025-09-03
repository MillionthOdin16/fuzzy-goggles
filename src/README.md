# Source Code Documentation

This directory contains the complete firmware source code for the CH32V203F8P6 AMS controller (~7,500 lines across 18 files).

## Core Components

### Application Entry Point
- **`main.cpp/.h`** - Application initialization, RGB LED setup, main control loop
  - RGB channel configuration and brightness control
  - System initialization and main execution loop
  - Hardware abstraction macros and timing utilities

### Communication System
- **`BambuBus.cpp/.h`** - Custom communication protocol for Bambu Lab printer integration
  - Protocol version 5 implementation with CRC validation
  - Filament status reporting and motion command processing
  - Message parsing and response generation

### Hardware Interface
- **`ADC_DMA.cpp/.h`** - High-performance analog-to-digital conversion with DMA
  - Multi-channel sensor data acquisition
  - DMA-accelerated data transfer for reduced CPU load
  - Calibration and filtering algorithms

- **`Adafruit_NeoPixel.cpp/.h`** - CH32V-optimized RGB LED control library
  - Modified Adafruit NeoPixel library for CH32V timing requirements
  - WS2812B LED strip control with precise timing
  - Multi-channel LED management

### Motion and Sensing
- **`Motion_control.cpp/.h`** - Stepper motor control and motion coordination
  - AS5600 magnetic encoder integration
  - Filament position tracking and motion commands
  - Multi-axis control and calibration routines

- **`many_soft_AS5600.cpp/.h`** - Software I2C interface for multiple AS5600 encoders
  - Multiple encoder support on shared I2C bus
  - Position reading and calibration functions
  - Error detection and recovery

### Storage and Persistence
- **`Flash_saves.cpp/.h`** - Non-volatile configuration storage
  - Filament profile storage and retrieval
  - Calibration data persistence
  - System configuration management

### Utilities and Support
- **`Debug_log.cpp/.h`** - Comprehensive logging and debugging system
  - Multi-level logging (ERROR, WARN, INFO, DEBUG)
  - Serial output formatting and timestamp generation
  - Runtime diagnostic information

- **`time64.cpp/.h`** - 64-bit timestamp and timing utilities
  - High-resolution system timing
  - Timestamp generation and conversion functions
  - Long-term timing support for motion control

## Hardware Configuration

The firmware is configured for the following hardware setup:

### LED Channels
- **PA11**: Channel 1 (2 LEDs) - Filament slot 1
- **PA8**: Channel 2 (2 LEDs) - Filament slot 2  
- **PB1**: Channel 3 (2 LEDs) - Filament slot 3
- **PB0**: Channel 4 (2 LEDs) - Filament slot 4
- **PD1**: Main board status (1 LED)

### I2C Devices
- Multiple AS5600 magnetic encoders for position sensing
- Configurable I2C addresses for multi-device support

### Communication
- Serial communication via USB or UART
- BambuBus protocol over designated pins
- Debug output at 115200 baud

## Build Dependencies

### Required Libraries
- **Arduino Framework** - Core functionality
- **Adafruit NeoPixel** - Base LED control (modified for CH32V)
- **CRC16/CRC8** - Data integrity validation (not included, must be added)

### Platform Requirements  
- **PlatformIO** - Build system and project management
- **CH32V Platform** - Microcontroller-specific toolchain
- **WCH-Link** - Programming and debugging interface

## Development Notes

### Timing Critical Code
- LED control timing is hardware-specific for CH32V
- Motion control requires precise timing for smooth operation
- BambuBus protocol has strict timing requirements

### Memory Considerations
- Flash storage functions require careful memory management
- Large data structures should be optimized for limited RAM
- Stack usage should be monitored for deep function calls

### Hardware Dependencies
- Many functions require specific hardware setup to test properly
- AS5600 encoders need proper magnet positioning for accurate readings
- LED channels must be connected to appropriate GPIO pins

## Testing and Validation

### Unit Testing
- Individual component testing recommended before integration
- Hardware-in-the-loop testing required for complete validation
- BambuBus protocol testing requires compatible printer or simulator

### Common Issues
- Timing issues with LED control on different clock speeds
- I2C communication failures with multiple AS5600 devices
- Flash storage corruption during power loss events
- BambuBus protocol version mismatches

## Code Organization

### Coding Standards
- C++ with Arduino framework conventions
- Header guards using `#pragma once`
- Consistent naming conventions for functions and variables
- Comprehensive error checking and validation

### Module Interaction
- Main.cpp coordinates all subsystems
- BambuBus handles external communication
- Motion_control manages physical movement
- Flash_saves provides persistent storage
- Debug_log enables runtime diagnostics