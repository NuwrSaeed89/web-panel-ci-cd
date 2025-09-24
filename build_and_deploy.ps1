Write-Host "Building Flutter Web Application..." -ForegroundColor Green

# Clean previous builds
Write-Host "Cleaning previous builds..." -ForegroundColor Yellow
flutter clean

# Get dependencies
Write-Host "Getting dependencies..." -ForegroundColor Yellow
flutter pub get

# Build for web
Write-Host "Building for web..." -ForegroundColor Yellow
flutter build web --release --no-tree-shake-icons

# Check if build was successful
if ($LASTEXITCODE -eq 0) {
    Write-Host "Build successful!" -ForegroundColor Green
    Write-Host ""
    Write-Host "Files are ready in build/web/ directory" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "You can now:" -ForegroundColor Cyan
    Write-Host "1. Upload build/web/ contents to your web server" -ForegroundColor White
    Write-Host "2. Use Firebase Hosting: firebase deploy" -ForegroundColor White
    Write-Host "3. Use Netlify: drag build/web/ to netlify.com" -ForegroundColor White
    Write-Host "4. Use Vercel: vercel --prod build/web" -ForegroundColor White
    Write-Host ""
    Read-Host "Press Enter to continue"
} else {
    Write-Host "Build failed! Please check the errors above." -ForegroundColor Red
    Read-Host "Press Enter to continue"
}

