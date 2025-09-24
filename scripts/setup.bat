@echo off
REM Brother Admin Panel - Setup Script for Windows
REM This script sets up the development environment

echo 🏪 Brother Admin Panel - Development Setup
echo ==========================================
echo.

echo [INFO] Starting setup process...
echo.

REM Check if Flutter is installed
echo [INFO] Checking Flutter installation...
flutter --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Flutter is not installed. Please install Flutter first.
    echo [INFO] Visit: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('flutter --version') do (
        echo [SUCCESS] Flutter found: %%i
        goto :flutter_found
    )
)
:flutter_found

REM Check if Dart is installed
echo [INFO] Checking Dart installation...
dart --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [ERROR] Dart is not installed. Please install Dart first.
    pause
    exit /b 1
) else (
    for /f "tokens=*" %%i in ('dart --version') do (
        echo [SUCCESS] Dart found: %%i
        goto :dart_found
    )
)
:dart_found

REM Check if Firebase CLI is installed
echo [INFO] Checking Firebase CLI installation...
firebase --version >nul 2>&1
if %errorlevel% neq 0 (
    echo [WARNING] Firebase CLI is not installed.
    echo [INFO] You can install it with: npm install -g firebase-tools
    echo [INFO] Or visit: https://firebase.google.com/docs/cli
) else (
    for /f "tokens=*" %%i in ('firebase --version') do (
        echo [SUCCESS] Firebase CLI found: v%%i
        goto :firebase_found
    )
)
:firebase_found

echo.

REM Install dependencies
echo [INFO] Installing Flutter dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo [ERROR] Failed to install dependencies
    pause
    exit /b 1
)
echo [SUCCESS] Dependencies installed successfully
echo.

REM Generate code
echo [INFO] Generating code with build_runner...
flutter packages pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo [WARNING] Code generation failed, but continuing...
) else (
    echo [SUCCESS] Code generated successfully
)
echo.

REM Run analysis
echo [INFO] Running code analysis...
flutter analyze
if %errorlevel% neq 0 (
    echo [WARNING] Code analysis found issues, but continuing...
) else (
    echo [SUCCESS] Code analysis completed
)
echo.

REM Setup complete
echo.
echo 🎉 Setup completed successfully!
echo.
echo 🚀 Next steps:
echo   1. Run the app: flutter run -d chrome --web-port=8080
echo   2. Or use Makefile: make run-web
echo   3. Generate code: make build
echo   4. Watch for changes: make watch
echo.
echo 📚 Documentation:
echo   - Clean Architecture: CLEAN_ARCHITECTURE_README.md
echo   - Firebase Setup: FIREBASE_STORAGE_README.md
echo   - Makefile: make help
echo.

pause
