# Brother Admin Panel - Clean Script for PowerShell
# This script cleans the project and removes generated files

# Set error action preference
$ErrorActionPreference = "Continue"

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"

# Function to print colored output
function Write-Status {
    param([string]$Message)
    Write-Host "[INFO] $Message" -ForegroundColor $Blue
}

function Write-Success {
    param([string]$Message)
    Write-Host "[SUCCESS] $Message" -ForegroundColor $Green
}

function Write-Warning {
    param([string]$Message)
    Write-Host "[WARNING] $Message" -ForegroundColor $Yellow
}

# Header
Write-Host "🧹 Brother Admin Panel - Clean Script" -ForegroundColor White
Write-Host "=====================================" -ForegroundColor White
Write-Host ""

# Clean Flutter
Write-Status "Cleaning Flutter project..."
try {
    flutter clean
    Write-Success "Flutter project cleaned"
}
catch {
    Write-Warning "Failed to clean Flutter project"
}

# Clean generated files
Write-Status "Cleaning generated files..."
$generatedFiles = Get-ChildItem -Path "lib" -Recurse -Include "*.freezed.dart", "*.g.dart", "*.gr.dart", "*.config.dart", "*.mocks.dart" -ErrorAction SilentlyContinue
foreach ($file in $generatedFiles) {
    try {
        Remove-Item $file.FullName -Force
        Write-Host "  Removed: $($file.Name)" -ForegroundColor $Yellow
    }
    catch {
        Write-Warning "Failed to remove: $($file.Name)"
    }
}
Write-Success "Generated files cleaned"

# Clean build directories
Write-Status "Cleaning build directories..."
$buildDirs = @("build", ".dart_tool", "coverage")
foreach ($dir in $buildDirs) {
    if (Test-Path $dir) {
        try {
            Remove-Item $dir -Recurse -Force
            Write-Host "  Removed: $dir" -ForegroundColor $Yellow
        }
        catch {
            Write-Warning "Failed to remove: $dir"
        }
    }
}
Write-Success "Build directories cleaned"

# Reinstall dependencies
Write-Status "Reinstalling dependencies..."
try {
    flutter pub get
    Write-Success "Dependencies reinstalled"
}
catch {
    Write-Warning "Failed to reinstall dependencies"
}

Write-Host ""
Write-Success "Clean completed!"
Write-Host ""
Write-Host "🚀 Next steps:" -ForegroundColor White
Write-Host "  1. Generate code: flutter packages pub run build_runner build"
Write-Host "  2. Or use Makefile: make build"
Write-Host "  3. Run the app: flutter run -d chrome --web-port=8080"
Write-Host ""
