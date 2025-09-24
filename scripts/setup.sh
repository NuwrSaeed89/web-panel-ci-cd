#!/bin/bash

# Brother Admin Panel - Setup Script
# This script sets up the development environment

set -e

echo "🏪 Brother Admin Panel - Development Setup"
echo "=========================================="

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

# Check if Flutter is installed
check_flutter() {
    print_status "Checking Flutter installation..."
    if command -v flutter &> /dev/null; then
        FLUTTER_VERSION=$(flutter --version | head -n 1)
        print_success "Flutter found: $FLUTTER_VERSION"
    else
        print_error "Flutter is not installed. Please install Flutter first."
        print_status "Visit: https://flutter.dev/docs/get-started/install"
        exit 1
    fi
}

# Check if Dart is installed
check_dart() {
    print_status "Checking Dart installation..."
    if command -v dart &> /dev/null; then
        DART_VERSION=$(dart --version | head -n 1)
        print_success "Dart found: $DART_VERSION"
    else
        print_error "Dart is not installed. Please install Dart first."
        exit 1
    fi
}

# Check if Firebase CLI is installed
check_firebase() {
    print_status "Checking Firebase CLI installation..."
    if command -v firebase &> /dev/null; then
        FIREBASE_VERSION=$(firebase --version)
        print_success "Firebase CLI found: v$FIREBASE_VERSION"
    else
        print_warning "Firebase CLI is not installed."
        print_status "You can install it with: npm install -g firebase-tools"
        print_status "Or visit: https://firebase.google.com/docs/cli"
    fi
}

# Install dependencies
install_dependencies() {
    print_status "Installing Flutter dependencies..."
    flutter pub get
    print_success "Dependencies installed successfully"
}

# Generate code
generate_code() {
    print_status "Generating code with build_runner..."
    flutter packages pub run build_runner build --delete-conflicting-outputs
    print_success "Code generated successfully"
}

# Run analysis
run_analysis() {
    print_status "Running code analysis..."
    flutter analyze
    print_success "Code analysis completed"
}

# Setup complete
setup_complete() {
    echo ""
    echo "🎉 Setup completed successfully!"
    echo ""
    echo "🚀 Next steps:"
    echo "  1. Run the app: flutter run -d chrome --web-port=8080"
    echo "  2. Or use Makefile: make run-web"
    echo "  3. Generate code: make build"
    echo "  4. Watch for changes: make watch"
    echo ""
    echo "📚 Documentation:"
    echo "  - Clean Architecture: CLEAN_ARCHITECTURE_README.md"
    echo "  - Firebase Setup: FIREBASE_STORAGE_README.md"
    echo "  - Makefile: make help"
    echo ""
}

# Main setup function
main() {
    echo "Starting setup process..."
    echo ""
    
    check_flutter
    check_dart
    check_firebase
    echo ""
    
    install_dependencies
    echo ""
    
    generate_code
    echo ""
    
    run_analysis
    echo ""
    
    setup_complete
}

# Run main function
main "$@"
