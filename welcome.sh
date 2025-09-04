#!/bin/bash
# Project health check and quick start script for fuzzy-goggles

set -e

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}"
    echo "=================================================="
    echo "  fuzzy-goggles CH32V Firmware Project"
    echo "  Bambu Lab AMS Controller"
    echo "=================================================="
    echo -e "${NC}"
}

print_section() {
    echo -e "\n${BLUE}--- $1 ---${NC}"
}

print_success() {
    echo -e "${GREEN}✓${NC} $1"
}

print_info() {
    echo -e "${YELLOW}ℹ${NC} $1"
}

check_prerequisites() {
    print_section "Checking Prerequisites"
    
    # Check if git is available
    if command -v git &> /dev/null; then
        print_success "Git is installed"
    else
        echo "❌ Git is required but not installed"
        exit 1
    fi
    
    # Check if python is available
    if command -v python3 &> /dev/null || command -v python &> /dev/null; then
        print_success "Python is installed"
    else
        echo "❌ Python is required but not installed"
        exit 1
    fi
    
    # Check if PlatformIO is available
    if command -v pio &> /dev/null; then
        print_success "PlatformIO is installed ($(pio --version))"
    else
        print_info "PlatformIO not found - install with: pip install platformio"
    fi
}

show_project_info() {
    print_section "Project Information"
    
    echo "📁 Project: CH32V203F8P6 Microcontroller Firmware"
    echo "🎯 Purpose: Bambu Lab AMS (Automatic Material System) Controller"
    echo "⚡ Platform: WCH CH32V RISC-V (Arduino Framework)"
    echo "🔧 Programmer: WCH-Link Debugger"
    
    print_section "Hardware Features"
    echo "• Multi-channel RGB LED control (5 channels)"
    echo "• BambuBus communication protocol"
    echo "• Motion control with AS5600 magnetic encoders"
    echo "• Flash storage for configuration"
    echo "• ADC/DMA operations"
    echo "• Debug logging via UART"
}

show_quick_commands() {
    print_section "Quick Start Commands"
    
    echo "Setup Development Environment:"
    echo "  ./dev.sh setup          # Install dependencies and setup"
    echo ""
    echo "Build and Upload:"
    echo "  ./dev.sh build          # Build firmware"
    echo "  ./dev.sh upload         # Upload to hardware (needs WCH-Link)"
    echo "  make monitor            # View serial output"
    echo ""
    echo "Code Quality:"
    echo "  ./validate.sh           # Validate code quality (6 checks)"
    echo "  ./dev.sh format         # Format code with clang-format"
    echo "  ./dev.sh analyze        # Run static code analysis"
    echo ""
    echo "Development:"
    echo "  ./dev.sh info           # Show detailed project information"
    echo "  ./dev.sh help           # Show all available commands"
    echo "  make help               # Show Makefile targets"
}

run_validation() {
    print_section "Running Project Validation"
    
    if [[ -x "./validate.sh" ]]; then
        echo "Running comprehensive validation..."
        ./validate.sh
    else
        echo "❌ Validation script not found or not executable"
        exit 1
    fi
}

show_next_steps() {
    print_section "Next Steps"
    
    echo "1. 📖 Read EXAMPLE.md for detailed examples and tutorials"
    echo "2. 🔧 Install PlatformIO: pip install platformio"
    echo "3. ⚙️  Setup environment: ./dev.sh setup"
    echo "4. 🔨 Build firmware: ./dev.sh build"
    echo "5. 📤 Upload to hardware: ./dev.sh upload (requires WCH-Link)"
    echo ""
    echo "📚 Documentation:"
    echo "   • README.md - Project overview and development guide"
    echo "   • EXAMPLE.md - Quick start examples and code modifications"
    echo "   • src/README.md - Detailed source code documentation"
    echo ""
    echo "🔗 Related Projects:"
    echo "   • Bambu-Bus Protocol: https://github.com/Bambu-Research-Group/Bambu-Bus.git"
    echo "   • BMCU Wiki: https://github.com/xwzkj/bmcu-wiki.git"
}

main() {
    print_header
    
    check_prerequisites
    show_project_info
    show_quick_commands
    
    echo ""
    read -p "Run project validation? (y/N): " -n 1 -r
    echo ""
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        run_validation
    else
        print_info "Skipping validation. Run './validate.sh' manually when ready."
    fi
    
    show_next_steps
    
    echo ""
    print_success "Welcome to fuzzy-goggles! Happy coding! 🚀"
}

main "$@"