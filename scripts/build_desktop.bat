@echo off
echo ===============================================
echo   Building Brother Admin Panel for Desktop
echo ===============================================

echo.
echo Cleaning project...
flutter clean

echo.
echo Getting dependencies...
flutter pub get

echo.
echo Building for Windows...
flutter build windows --release

echo.
echo ===============================================
echo   Build completed successfully!
echo ===============================================
echo.
echo You can find the Windows executable at:
echo build\windows\x64\runner\Release\brother_admin_panel.exe
echo.
pause
