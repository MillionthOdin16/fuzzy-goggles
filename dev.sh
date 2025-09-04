#!/bin/bash
# Development utility script for fuzzy-goggles firmware

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if PlatformIO is installed
check_platformio() {
    if ! command -v pio &> /dev/null; then
        print_error "PlatformIO is not installed!"
        print_status "Install it with: pip install platformio"
        print_status "Or visit: https://platformio.org/install"
        exit 1
    fi
    print_success "PlatformIO is installed"
}

# Setup development environment
setup() {
    print_status "Setting up development environment..."
    check_platformio
    
    print_status "Installing CH32V platform..."
    pio pkg install -g --platform https://github.com/Community-PIO-CH32V/platform-ch32v.git
    
    print_status "Installing library dependencies..."
    pio lib install
    
    print_success "Development environment setup complete!"
}

# Build firmware
build() {
    print_status "Building firmware..."
    pio run -e ch32v203f8p6
    print_success "Build completed!"
}

# Upload firmware
upload() {
    print_status "Uploading firmware..."
    print_warning "Make sure WCH-Link debugger is connected!"
    pio run -e ch32v203f8p6 -t upload
    print_success "Upload completed!"
}

# Clean build artifacts
clean() {
    print_status "Cleaning build artifacts..."
    pio run -t clean
    rm -rf .pio/
    print_success "Clean completed!"
}

# Format code
format() {
    print_status "Formatting code..."
    if command -v clang-format &> /dev/null; then
        find src/ -name "*.cpp" -o -name "*.h" | xargs clang-format -i --style=file
        print_success "Code formatting completed!"
    else
        print_warning "clang-format not found. Install it for automatic code formatting."
    fi
}

# Run static analysis
analyze() {
    print_status "Running static code analysis..."
    pio check -e ch32v203f8p6
    print_success "Static analysis completed!"
}

# Show project information
info() {
    print_status "Project Information:"
    echo "  Name: fuzzy-goggles"
    echo "  Platform: WCH CH32V RISC-V"
    echo "  Board: CH32V203F8P6"
    echo "  Framework: Arduino"
    echo "  Purpose: Bambu Lab AMS Controller Firmware"
    echo ""
    print_status "Hardware Features:"
    echo "  - Multi-channel RGB LED control (5 channels)"
    echo "  - BambuBus communication protocol"
    echo "  - Motion control with AS5600 magnetic encoders"
    echo "  - Flash storage for configuration"
    echo "  - ADC/DMA operations"
    echo "  - Debug logging"
    echo ""
    print_status "Development Tools:"
    echo "  - Build: make build or ./dev.sh build"
    echo "  - Upload: make upload or ./dev.sh upload"
    echo "  - Monitor: make monitor"
    echo "  - Format: ./dev.sh format"
    echo "  - Analyze: ./dev.sh analyze"
}

# Show help
help() {
    echo "fuzzy-goggles development script"
    echo ""
    echo "Usage: $0 [command]"
    echo ""
    echo "Commands:"
    echo "  setup     Setup development environment"
    echo "  build     Build firmware"
    echo "  upload    Upload firmware to device"
    echo "  clean     Clean build artifacts"
    echo "  format    Format source code"
    echo "  analyze   Run static code analysis"
    echo "  info      Show project information"
    echo "  help      Show this help"
    echo ""
    echo "Hardware Requirements:"
    echo "  - CH32V203F8P6 microcontroller board"
    echo "  - WCH-Link debugger/programmer"
    echo "  - USB connection for serial communication"
}

# Main command dispatcher
case "${1:-help}" in
    setup)
        setup
        ;;
    build)
        build
        ;;
    upload)
        upload
        ;;
    clean)
        clean
        ;;
    format)
        format
        ;;
    analyze)
        analyze
        ;;
    info)
        info
        ;;
    help|--help|-h)
        help
        ;;
    *)
        print_error "Unknown command: $1"
        help
        exit 1
        ;;
esac