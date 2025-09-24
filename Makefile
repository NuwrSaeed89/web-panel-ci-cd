# Makefile for Brother Admin Panel
# Simplifies common development tasks

.PHONY: help install clean build run test analyze format

# Default target
help:
	@echo "🏪 Brother Admin Panel - Development Commands"
	@echo ""
	@echo "📦 Package Management:"
	@echo "  install     Install dependencies"
	@echo "  upgrade     Upgrade dependencies"
	@echo "  clean       Clean project"
	@echo ""
	@echo "🔨 Build & Run:"
	@echo "  build       Generate code with build_runner"
	@echo "  watch       Watch for changes and generate code"
	@echo "  run-web     Run on web (Chrome)"
	@echo "  run-android Run on Android"
	@echo "  run-ios     Run on iOS"
	@echo ""
	@echo "🧪 Testing & Quality:"
	@echo "  test        Run tests"
	@echo "  analyze     Analyze code"
	@echo "  format      Format code"
	@echo ""
	@echo "🚀 Deployment:"
	@echo "  build-web   Build for web"
	@echo "  build-apk   Build APK for Android"
	@echo "  deploy      Deploy to Firebase"

# Package Management
install:
	@echo "📦 Installing dependencies..."
	flutter pub get

upgrade:
	@echo "⬆️ Upgrading dependencies..."
	flutter pub upgrade

clean:
	@echo "🧹 Cleaning project..."
	flutter clean
	flutter pub get

# Build & Run
build:
	@echo "🔨 Generating code..."
	flutter packages pub run build_runner build --delete-conflicting-outputs

watch:
	@echo "👀 Watching for changes..."
	flutter packages pub run build_runner watch --delete-conflicting-outputs

run-web:
	@echo "🌐 Running on web..."
	flutter run -d chrome --web-port=8080

run-android:
	@echo "📱 Running on Android..."
	flutter run -d android

run-ios:
	@echo "🍎 Running on iOS..."
	flutter run -d ios

# Testing & Quality
test:
	@echo "🧪 Running tests..."
	flutter test

analyze:
	@echo "🔍 Analyzing code..."
	flutter analyze

format:
	@echo "✨ Formatting code..."
	dart format lib/
	dart format test/

# Deployment
build-web:
	@echo "🌐 Building for web..."
	flutter build web --release

build-apk:
	@echo "📱 Building APK..."
	flutter build apk --release

deploy:
	@echo "🚀 Deploying to Firebase..."
	firebase deploy

# Development shortcuts
dev: install build run-web
quick: build run-web
full: clean install build test analyze run-web
