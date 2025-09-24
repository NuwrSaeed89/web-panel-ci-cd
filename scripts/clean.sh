#!/bin/bash

# Brother Admin Panel - Clean Script for Linux/macOS
# This script cleans the project and removes generated files

set -e

echo "🧹 Brother Admin Panel - Clean Script"
echo "====================================="
echo ""

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

# Clean Flutter
print_status "Cleaning Flutter project..."
if flutter clean; then
    print_success "Flutter project cleaned"
else
    print_warning "Failed to clean Flutter project"
fi

# Clean generated files
print_status "Cleaning generated files..."
find lib/ -name "*.freezed.dart" -o -name "*.g.dart" -o -name "*.gr.dart" -o -name "*.config.dart" -o -name "*.mocks.dart" 2>/dev/null | xargs rm -f 2>/dev/null || true
print_success "Generated files cleaned"

# Clean build directories
print_status "Cleaning build directories..."
rm -rf build .dart_tool coverage 2>/dev/null || true
print_success "Build directories cleaned"

# Reinstall dependencies
print_status "Reinstalling dependencies..."
if flutter pub get; then
    print_success "Dependencies reinstalled"
else
    print_warning "Failed to reinstall dependencies"
fi

echo ""
print_success "Clean completed!"
echo ""
echo "🚀 Next steps:"
echo "  1. Generate code: flutter packages pub run build_runner build"
echo "  2. Or use Makefile: make build"
echo "  3. Run the app: flutter run -d chrome --web-port=8080"
echo ""
