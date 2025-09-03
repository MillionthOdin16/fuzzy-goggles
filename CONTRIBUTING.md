# Contributing to fuzzy-goggles

Thank you for your interest in contributing to the CH32V AMS Controller firmware project! This guide will help you get started with development and contribution.

## 🚀 Getting Started

### Development Environment Setup

1. **Install Prerequisites**:
   ```bash
   # Install PlatformIO Core
   curl -fsSL https://raw.githubusercontent.com/platformio/platformio-core/develop/scripts/get-platformio.py | python3
   export PATH=$PATH:~/.local/bin
   
   # Install CH32V platform (requires internet)
   platformio platform install ch32v
   ```

2. **Fork and Clone**:
   ```bash
   git clone https://github.com/your-username/fuzzy-goggles.git
   cd fuzzy-goggles
   ```

3. **Set Up Configuration** (see main README.md for detailed instructions):
   - Create `platformio.ini` 
   - Add required CRC libraries to `lib/CRC/`

4. **Verify Build**:
   ```bash
   platformio run  # Allow 15+ minutes for first build
   ```

## 🔧 Development Workflow

### Making Changes

1. **Create a Feature Branch**:
   ```bash
   git checkout -b feature/your-feature-name
   ```

2. **Make Your Changes**:
   - Edit source files in `src/`
   - Follow existing code style and conventions
   - Add appropriate comments and documentation

3. **Test Your Changes**:
   ```bash
   # Build firmware
   platformio run
   
   # Upload to hardware (if available)
   platformio run --target upload
   
   # Monitor serial output
   platformio device monitor
   ```

4. **Commit Your Changes**:
   ```bash
   git add .
   git commit -m "feat: brief description of changes"
   ```

### Testing Requirements

**⚠️ CRITICAL: Hardware Testing Required**

This is embedded firmware that controls physical hardware. All changes must be tested on actual hardware:

#### Minimum Testing Checklist
- [ ] **Power-On Test**: LEDs initialize correctly
- [ ] **Communication Test**: BambuBus protocol functions properly  
- [ ] **Motion Test**: Encoder readings and motor control work
- [ ] **Storage Test**: Flash operations complete successfully

#### Full Validation (when possible)
- [ ] **Integration Test**: Complete AMS functionality with printer
- [ ] **Stress Test**: Extended operation under normal conditions
- [ ] **Error Handling**: Proper response to fault conditions
- [ ] **Recovery Test**: System behavior after power loss/reset

### Code Guidelines

#### Style and Conventions
- **Language**: C++ with Arduino framework
- **Headers**: Use `#pragma once` for header guards  
- **Naming**: Follow existing camelCase/snake_case patterns
- **Comments**: Document complex algorithms and hardware interactions
- **Error Handling**: Always check return values and handle failures

#### Architecture Principles
- **Modularity**: Keep components separate and well-defined
- **Hardware Abstraction**: Use clear interfaces for hardware access
- **Real-Time Constraints**: Consider timing requirements for critical code
- **Resource Management**: Be mindful of memory and flash usage

## 🎯 Areas for Contribution

### High-Priority Areas
- **Protocol Extensions**: BambuBus feature enhancements
- **LED Effects**: New visual feedback patterns
- **Sensor Integration**: Additional sensor support
- **Performance Optimization**: Memory and timing improvements
- **Error Recovery**: Improved fault handling

### Documentation Improvements  
- **Code Documentation**: Inline comments and function descriptions
- **Hardware Guides**: Setup and wiring documentation
- **Troubleshooting**: Common issues and solutions
- **API Documentation**: Function interfaces and usage examples

### Testing and Quality
- **Test Coverage**: Automated testing where possible
- **Hardware Simulation**: Mock hardware for development
- **Performance Profiling**: Timing and memory analysis
- **Compatibility Testing**: Different hardware configurations

## 🚨 Critical Considerations

### What NOT to Change Without Deep Understanding
- **BambuBus Protocol**: Changes can break printer communication
- **Flash Operations**: Incorrect implementation can brick devices  
- **Motion Control Timing**: Affects mechanical operation safety
- **LED Timing**: Hardware-specific timing requirements

### Required Hardware Access
Many aspects of this project cannot be properly tested without:
- CH32V203F8P6 microcontroller board
- WCH-Link programmer/debugger  
- RGB LED strips (WS2812B compatible)
- AS5600 magnetic encoders
- Complete AMS hardware setup (ideal)

### Network Dependencies
- Initial platform installation requires internet access
- Library downloads need network connectivity
- Some debugging tools may require online resources

## 📋 Contribution Types

### Code Contributions
1. **Bug Fixes**: Address specific issues or incorrect behavior
2. **Feature Additions**: New functionality or capabilities
3. **Performance Improvements**: Optimization and efficiency enhancements
4. **Code Cleanup**: Refactoring and maintainability improvements

### Documentation Contributions
1. **Setup Guides**: Improved installation and configuration instructions
2. **API Documentation**: Function and class documentation
3. **Tutorials**: Step-by-step guides for common tasks
4. **Troubleshooting**: Solutions to common problems

### Testing Contributions
1. **Hardware Testing**: Validation on different hardware configurations
2. **Edge Case Testing**: Boundary conditions and error scenarios
3. **Performance Testing**: Timing and resource usage analysis
4. **Integration Testing**: Complete system functionality validation

## 🔍 Pull Request Process

### Before Submitting
- [ ] Code builds successfully (`platformio run`)
- [ ] Changes tested on hardware (when possible)
- [ ] Documentation updated for new features
- [ ] Commit messages follow conventional format
- [ ] No build artifacts or temporary files included

### Pull Request Guidelines
1. **Title**: Clear, concise description of changes
2. **Description**: Detailed explanation of what and why
3. **Testing**: Document testing performed and results
4. **Hardware**: Specify hardware used for testing
5. **Breaking Changes**: Highlight any compatibility impacts

### Review Process
- Code will be reviewed for functionality, safety, and style
- Hardware testing may be required by maintainers
- Documentation updates may be requested
- Multiple review rounds may be necessary

## 🆘 Getting Help

### Resources
- **Project README**: Complete setup and usage instructions
- **Source Documentation**: `src/README.md` for code organization
- **Hardware Guide**: `BMCU 370 Firmware Downloading Guide.pdf`
- **PlatformIO Docs**: https://docs.platformio.org/

### Communication
- **Issues**: Use GitHub issues for bug reports and feature requests
- **Discussions**: GitHub discussions for questions and ideas
- **Documentation**: Check existing documentation first

### Common Questions
- **Build Failures**: Usually platform installation or missing dependencies
- **Hardware Issues**: Verify wiring and power supply
- **Upload Problems**: Check WCH-Link connection and drivers
- **Protocol Issues**: Validate BambuBus implementation carefully

## 📚 Additional Resources

### Reference Documentation
- **[Bambu-Bus Protocol](https://github.com/Bambu-Research-Group/Bambu-Bus.git)** - Official protocol specification and reference implementation
- **[BMCU Wiki](https://github.com/xwzkj/bmcu-wiki.git)** - Comprehensive BMCU system documentation and technical details
- **[BMCU Alternative Implementation](https://github.com/karlingen/BMCU.git)** - Alternative firmware approaches and techniques
- **[BMCU370 Project](https://github.com/krrr/BMCU370.git)** - Hardware-specific implementation examples

### Development Tools
- **PlatformIO Documentation**: https://docs.platformio.org/
- **CH32V Resources**: WCH official documentation and examples
- **Arduino Framework**: Standard API reference and libraries

These resources provide essential context for understanding the broader ecosystem and can help guide development decisions, especially when working with BambuBus protocol implementation or hardware-specific features.

## 📄 Code of Conduct

### Professional Standards
- Be respectful and professional in all interactions
- Focus on technical merit and project improvement
- Welcome newcomers and help them learn
- Acknowledge and credit others' contributions

### Safety Considerations
- Hardware safety is paramount - incorrect firmware can damage equipment
- Test thoroughly before recommending changes to others
- Document any safety-critical aspects of changes
- Report security issues privately to maintainers

## 🏆 Recognition

Contributors will be acknowledged in:
- Commit history and git logs
- Release notes for significant contributions  
- Project documentation where appropriate
- Community recognition for outstanding contributions

Thank you for contributing to fuzzy-goggles! Your efforts help improve 3D printing technology and the open-source community.