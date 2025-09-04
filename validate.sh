#!/bin/bash
# Code validation script for fuzzy-goggles firmware
# Validates code quality without requiring hardware build tools

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

print_status() { echo -e "${BLUE}[INFO]${NC} $1"; }
print_success() { echo -e "${GREEN}[SUCCESS]${NC} $1"; }
print_warning() { echo -e "${YELLOW}[WARNING]${NC} $1"; }
print_error() { echo -e "${RED}[ERROR]${NC} $1"; }

# Check source code structure
check_structure() {
    print_status "Checking project structure..."
    
    local issues=0
    
    # Check required files exist
    local required_files=(
        "src/main.cpp"
        "src/main.h"
        "src/BambuBus.cpp"
        "src/BambuBus.h"
        "platformio.ini"
    )
    
    for file in "${required_files[@]}"; do
        if [[ ! -f "$file" ]]; then
            print_error "Missing required file: $file"
            ((issues++))
        fi
    done
    
    # Check source code has reasonable structure
    if [[ ! -d "src" ]]; then
        print_error "Missing src/ directory"
        ((issues++))
    fi
    
    local src_files=$(find src/ -name "*.cpp" -o -name "*.h" | wc -l)
    if [[ $src_files -lt 5 ]]; then
        print_warning "Very few source files found ($src_files)"
    else
        print_success "Found $src_files source files"
    fi
    
    if [[ $issues -eq 0 ]]; then
        print_success "Project structure looks good"
    else
        print_error "Found $issues structural issues"
        return 1
    fi
}

# Check code syntax without compilation
check_syntax() {
    print_status "Checking C++ syntax..."
    
    local issues=0
    
    # Basic syntax checks for common issues
    while IFS= read -r -d '' file; do
        local filename=$(basename "$file")
        
        # Check for basic syntax issues
        if grep -q "^#include.*<.*>.*//.*" "$file"; then
            print_warning "Possible malformed include in $filename"
        fi
        
        # Check for unmatched braces (simple check)
        local open_braces=$(grep -o '{' "$file" | wc -l)
        local close_braces=$(grep -o '}' "$file" | wc -l)
        if [[ $open_braces -ne $close_braces ]]; then
            print_warning "Unmatched braces in $filename (${open_braces} open, ${close_braces} close)"
            ((issues++))
        fi
        
        # Check for Arduino-style functions
        if grep -q "void setup()" "$file"; then
            print_success "Found Arduino setup() function in $filename"
        fi
        
        if grep -q "void loop()" "$file"; then
            print_success "Found Arduino loop() function in $filename"
        fi
        
    done < <(find src/ -name "*.cpp" -print0)
    
    if [[ $issues -eq 0 ]]; then
        print_success "Basic syntax checks passed"
    else
        print_warning "Found $issues potential syntax issues"
    fi
}

# Check code style
check_style() {
    print_status "Checking code style..."
    
    local issues=0
    
    # Check for consistent indentation
    while IFS= read -r -d '' file; do
        local filename=$(basename "$file")
        
        # Check for mixed tabs and spaces
        if grep -q $'\t' "$file" && grep -q '^    ' "$file"; then
            print_warning "Mixed tabs and spaces in $filename"
            ((issues++))
        fi
        
        # Check for very long lines
        local long_lines=$(awk 'length > 120' "$file" | wc -l)
        if [[ $long_lines -gt 0 ]]; then
            print_warning "$long_lines lines longer than 120 characters in $filename"
        fi
        
    done < <(find src/ -name "*.cpp" -o -name "*.h" -print0)
    
    if [[ $issues -eq 0 ]]; then
        print_success "Code style checks passed"
    else
        print_warning "Found $issues style issues"
    fi
}

# Check for embedded-specific patterns
check_embedded_patterns() {
    print_status "Checking embedded development patterns..."
    
    local arduino_includes=0
    local ch32_includes=0
    local interrupt_handlers=0
    
    while IFS= read -r -d '' file; do
        if grep -q "#include.*Arduino\.h" "$file"; then
            ((arduino_includes++))
        fi
        
        if grep -q "#include.*ch32v" "$file"; then
            ((ch32_includes++))
        fi
        
        if grep -q "interrupt.*fast" "$file"; then
            ((interrupt_handlers++))
        fi
        
    done < <(find src/ -name "*.cpp" -o -name "*.h" -print0)
    
    print_success "Found $arduino_includes Arduino framework includes"
    print_success "Found $ch32_includes CH32V specific includes"
    print_success "Found $interrupt_handlers interrupt handlers"
    
    if [[ $arduino_includes -gt 0 && $ch32_includes -gt 0 ]]; then
        print_success "Detected Arduino framework on CH32V platform"
    else
        print_warning "Could not confirm Arduino framework setup"
    fi
}

# Check configuration files
check_config() {
    print_status "Checking configuration files..."
    
    if [[ -f "platformio.ini" ]]; then
        if grep -q "ch32v" "platformio.ini"; then
            print_success "PlatformIO configured for CH32V"
        else
            print_warning "PlatformIO config may not be for CH32V"
        fi
    else
        print_error "Missing platformio.ini"
        return 1
    fi
    
    if [[ -f ".clang-format" ]]; then
        print_success "Code formatting configuration found"
    else
        print_warning "No code formatting configuration"
    fi
    
    if [[ -f "Makefile" ]]; then
        print_success "Makefile found for build automation"
    fi
}

# Check documentation
check_docs() {
    print_status "Checking documentation..."
    
    local docs_score=0
    
    if [[ -f "README.md" ]]; then
        local readme_size=$(wc -c < "README.md")
        if [[ $readme_size -gt 1000 ]]; then
            print_success "Comprehensive README.md found ($readme_size bytes)"
            ((docs_score++))
        else
            print_warning "README.md is quite short ($readme_size bytes)"
        fi
    else
        print_error "Missing README.md"
    fi
    
    if [[ -f "src/README.md" ]]; then
        print_success "Source documentation found"
        ((docs_score++))
    fi
    
    if [[ -d ".github" ]]; then
        print_success "GitHub configuration directory found"
        ((docs_score++))
    fi
    
    print_status "Documentation score: $docs_score/3"
}

# Main validation function
main() {
    print_status "Starting code validation for fuzzy-goggles firmware..."
    echo
    
    local test_results=()
    
    check_structure && test_results+=("✓ Structure") || test_results+=("✗ Structure")
    echo
    
    check_syntax && test_results+=("✓ Syntax") || test_results+=("✗ Syntax")
    echo
    
    check_style && test_results+=("✓ Style") || test_results+=("✗ Style")
    echo
    
    check_embedded_patterns && test_results+=("✓ Embedded") || test_results+=("✗ Embedded")
    echo
    
    check_config && test_results+=("✓ Config") || test_results+=("✗ Config")
    echo
    
    check_docs && test_results+=("✓ Docs") || test_results+=("✗ Docs")
    echo
    
    print_status "Validation Summary:"
    for result in "${test_results[@]}"; do
        if [[ $result == ✓* ]]; then
            print_success "$result"
        else
            print_error "$result"
        fi
    done
    
    local passed=$(echo "${test_results[@]}" | grep -o "✓" | wc -l)
    local total=${#test_results[@]}
    
    echo
    print_status "Overall: $passed/$total checks passed"
    
    if [[ $passed -eq $total ]]; then
        print_success "All validation checks passed!"
        return 0
    else
        print_warning "Some validation checks failed or had warnings"
        return 1
    fi
}

# Run main function
main "$@"