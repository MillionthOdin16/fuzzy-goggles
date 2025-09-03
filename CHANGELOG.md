# Changelog

All notable changes to the fuzzy-goggles CH32V firmware project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- Comprehensive project documentation including README.md, CONTRIBUTING.md
- GitHub Copilot instructions for development guidance
- Source code documentation in src/README.md
- Project gitignore configuration
- Related projects and resources section with references to:
  - Bambu-Bus Protocol repository for official protocol specification
  - BMCU Wiki for technical documentation and system details
  - Alternative BMCU implementations for development reference
  - BMCU370 project for hardware-specific examples

### Changed
- Improved general documentation structure and accessibility
- Enhanced development workflow documentation
- Updated BambuBus protocol references to link to official specification
- Expanded technical context with ecosystem project references

### Fixed
- Build artifact management with proper gitignore

## [0.1.0] - Initial Release

### Added
- CH32V203F8P6 microcontroller firmware for Bambu Lab AMS controller
- Multi-channel RGB LED control (5 channels: 4 filament + 1 main board)
- BambuBus communication protocol implementation (version 5)
- AS5600 magnetic encoder integration for precision filament positioning
- ADC with DMA for high-performance sensor data acquisition
- Flash storage system for configuration and calibration data persistence
- Comprehensive debug logging and diagnostic capabilities
- Motion control system for stepper motor coordination
- 64-bit timestamp and timing utilities
- Modified Adafruit NeoPixel library optimized for CH32V timing
- Arduino framework compatibility with PlatformIO build system

### Hardware Support
- CH32V203F8P6 RISC-V microcontroller
- WS2812B RGB LED strips
- AS5600 magnetic position encoders
- WCH-Link programmer/debugger interface
- Multi-channel filament detection and control

### Communication Features
- BambuBus protocol for printer integration
- Serial communication at 115200 baud
- Real-time filament status reporting
- Motion command processing with CRC validation
- Error detection and recovery mechanisms

### Development Tools
- PlatformIO project configuration
- Arduino framework integration
- Comprehensive build system
- Hardware debugging support
- Serial monitoring capabilities

---

## Release Notes

### Version 0.1.0 - Initial Release
This represents the initial firmware implementation for the CH32V-based AMS controller. The firmware provides complete functionality for automatic material system control including LED status indication, filament detection, motion control, and communication with Bambu Lab printers.

**Key Features:**
- Complete AMS controller functionality
- Multi-channel LED status system
- Precision motion control with encoder feedback  
- Non-volatile configuration storage
- Real-time diagnostic capabilities
- BambuBus protocol compatibility

**Hardware Requirements:**
- CH32V203F8P6 microcontroller
- WCH-Link programmer for development
- Compatible AMS controller board
- RGB LED strips for status indication
- AS5600 encoders for position feedback

**Development Status:**
- Core firmware functionality complete
- Extensive testing on target hardware
- Production-ready for compatible hardware
- Comprehensive documentation and setup guides

**Known Limitations:**
- Requires specific CRC libraries not included in repository
- Platform installation requires internet connectivity
- Hardware-specific timing requirements for LED control
- Build process can take 15+ minutes on first compilation

**Next Steps:**
- Community feedback integration
- Performance optimization opportunities
- Extended feature development
- Enhanced documentation and tutorials

---

## Development Notes

### Versioning Strategy
- **Major Version**: Significant architectural changes or breaking changes
- **Minor Version**: New features and functionality additions  
- **Patch Version**: Bug fixes and minor improvements

### Release Process
1. Code review and testing on hardware
2. Documentation updates
3. Version tagging and release notes
4. Binary compilation and distribution
5. Community notification and support

### Contribution Guidelines
See [CONTRIBUTING.md](CONTRIBUTING.md) for detailed information on:
- Development workflow and setup
- Testing requirements and procedures
- Code style and architectural guidelines
- Pull request process and review criteria

### Hardware Validation
All releases undergo comprehensive hardware validation including:
- Multi-channel LED functionality testing
- BambuBus communication protocol verification
- Motion control precision and reliability testing
- Flash storage integrity and persistence validation
- Power cycling and fault recovery testing
- Extended operation stress testing

This changelog will be updated with each release to track progress and changes.