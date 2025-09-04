# Makefile for fuzzy-goggles CH32V firmware
# Provides convenient commands for PlatformIO-based development

.PHONY: all build upload clean monitor test format check help

# Default target
all: build

# Build the firmware
build:
	@echo "Building firmware for CH32V203F8P6..."
	pio run -e ch32v203f8p6

# Upload firmware to device
upload:
	@echo "Uploading firmware via WCH-Link..."
	pio run -e ch32v203f8p6 -t upload

# Build debug version
debug:
	@echo "Building debug version..."
	pio run -e debug

# Clean build artifacts
clean:
	@echo "Cleaning build artifacts..."
	pio run -t clean
	rm -rf .pio/

# Start serial monitor
monitor:
	@echo "Starting serial monitor at 115200 baud..."
	pio device monitor --baud 115200

# Run static code analysis
check:
	@echo "Running static code analysis..."
	pio check -e ch32v203f8p6

# Format code
format:
	@echo "Formatting code with clang-format..."
	find src/ -name "*.cpp" -o -name "*.h" | xargs clang-format -i --style=file

# Run unit tests (native environment)
test:
	@echo "Running unit tests..."
	pio test -e test

# Install dependencies
install:
	@echo "Installing PlatformIO and dependencies..."
	pip install platformio
	pio pkg install -g --platform https://github.com/Community-PIO-CH32V/platform-ch32v.git
	pio lib install

# Show board information
info:
	@echo "Board: CH32V203F8P6"
	@echo "Platform: WCH CH32V RISC-V"
	@echo "Framework: Arduino"
	@echo "Upload: WCH-Link debugger"
	pio boards ch32v203f8p6

# Show help
help:
	@echo "Available targets:"
	@echo "  build    - Build firmware for CH32V203F8P6"
	@echo "  upload   - Upload firmware via WCH-Link"
	@echo "  debug    - Build debug version"
	@echo "  clean    - Clean build artifacts"
	@echo "  monitor  - Start serial monitor"
	@echo "  check    - Run static code analysis"
	@echo "  format   - Format code with clang-format"
	@echo "  test     - Run unit tests"
	@echo "  install  - Install PlatformIO and dependencies"
	@echo "  info     - Show board information"
	@echo "  help     - Show this help message"