#!/bin/bash

echo "==============================================="
echo "  Building Brother Admin Panel for Desktop"
echo "==============================================="

echo ""
echo "Cleaning project..."
flutter clean

echo ""
echo "Getting dependencies..."
flutter pub get

echo ""
echo "Detecting platform and building..."

if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "Building for Linux..."
    flutter build linux --release
    echo ""
    echo "You can find the Linux executable at:"
    echo "build/linux/x64/release/bundle/brother_admin_panel"
elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "Building for macOS..."
    flutter build macos --release
    echo ""
    echo "You can find the macOS app at:"
    echo "build/macos/Build/Products/Release/brother_admin_panel.app"
else
    echo "Unsupported platform: $OSTYPE"
    exit 1
fi

echo ""
echo "==============================================="
echo "  Build completed successfully!"
echo "==============================================="
