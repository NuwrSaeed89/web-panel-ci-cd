@echo off
REM Brother Admin Panel - Clean Script for Windows
REM This script cleans the project and removes generated files

echo 🧹 Brother Admin Panel - Clean Script
echo =====================================
echo.

echo [INFO] Cleaning Flutter project...
flutter clean
if %errorlevel% equ 0 (
    echo [SUCCESS] Flutter project cleaned
) else (
    echo [WARNING] Failed to clean Flutter project
)

echo [INFO] Cleaning generated files...
for /r lib %%f in (*.freezed.dart *.g.dart *.gr.dart *.config.dart *.mocks.dart) do (
    if exist "%%f" (
        del "%%f" 2>nul
        echo   Removed: %%~nxf
    )
)
echo [SUCCESS] Generated files cleaned

echo [INFO] Cleaning build directories...
if exist "build" rmdir /s /q "build" 2>nul
if exist ".dart_tool" rmdir /s /q ".dart_tool" 2>nul
if exist "coverage" rmdir /s /q "coverage" 2>nul
echo [SUCCESS] Build directories cleaned

echo [INFO] Reinstalling dependencies...
flutter pub get
if %errorlevel% equ 0 (
    echo [SUCCESS] Dependencies reinstalled
) else (
    echo [WARNING] Failed to reinstall dependencies
)

echo.
echo [SUCCESS] Clean completed!
echo.
echo 🚀 Next steps:
echo   1. Generate code: flutter packages pub run build_runner build
echo   2. Or use Makefile: make build
echo   3. Run the app: flutter run -d chrome --web-port=8080
echo.

pause
