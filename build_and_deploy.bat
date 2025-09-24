@echo off
echo Building Flutter Web Application...

REM Clean previous builds
echo Cleaning previous builds...
flutter clean

REM Get dependencies
echo Getting dependencies...
flutter pub get

REM Build for web
echo Building for web...
flutter build web --release --no-tree-shake-icons

REM Check if build was successful
if %ERRORLEVEL% EQU 0 (
    echo Build successful!
    echo.
    echo Files are ready in build/web/ directory
    echo.
    echo You can now:
    echo 1. Upload build/web/ contents to your web server
    echo 2. Use Firebase Hosting: firebase deploy
    echo 3. Use Netlify: drag build/web/ to netlify.com
    echo 4. Use Vercel: vercel --prod build/web
    echo.
    pause
) else (
    echo Build failed! Please check the errors above.
    pause
)

