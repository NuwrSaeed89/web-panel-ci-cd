# Brother Admin Panel - Setup Script for PowerShell
# This script sets up the development environment

param(
    [switch]$SkipChecks,
    [switch]$SkipCodeGen,
    [switch]$SkipAnalysis
)

# Set error action preference
$ErrorActionPreference = "Stop"

# Colors for output
$Red = "Red"
$Green = "Green"
$Yellow = "Yellow"
$Blue = "Blue"
$White = "White"

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

function Write-Error {
    param([string]$Message)
    Write-Host "[ERROR] $Message" -ForegroundColor $Red
}

# Header
Write-Host "🏪 Brother Admin Panel - Development Setup" -ForegroundColor $White
Write-Host "==========================================" -ForegroundColor $White
Write-Host ""

# Check if Flutter is installed
function Test-Flutter {
    Write-Status "Checking Flutter installation..."
    try {
        $flutterVersion = flutter --version | Select-Object -First 1
        Write-Success "Flutter found: $flutterVersion"
        return $true
    }
    catch {
        Write-Error "Flutter is not installed. Please install Flutter first."
        Write-Status "Visit: https://flutter.dev/docs/get-started/install"
        return $false
    }
}

# Check if Dart is installed
function Test-Dart {
    Write-Status "Checking Dart installation..."
    try {
        $dartVersion = dart --version | Select-Object -First 1
        Write-Success "Dart found: $dartVersion"
        return $true
    }
    catch {
        Write-Error "Dart is not installed. Please install Dart first."
        return $false
    }
}

# Check if Firebase CLI is installed
function Test-Firebase {
    Write-Status "Checking Firebase CLI installation..."
    try {
        $firebaseVersion = firebase --version
        Write-Success "Firebase CLI found: v$firebaseVersion"
        return $true
    }
    catch {
        Write-Warning "Firebase CLI is not installed."
        Write-Status "You can install it with: npm install -g firebase-tools"
        Write-Status "Or visit: https://firebase.google.com/docs/cli"
        return $false
    }
}

# Install dependencies
function Install-Dependencies {
    Write-Status "Installing Flutter dependencies..."
    try {
        flutter pub get
        Write-Success "Dependencies installed successfully"
        return $true
    }
    catch {
        Write-Error "Failed to install dependencies"
        return $false
    }
}

# Generate code
function Generate-Code {
    if ($SkipCodeGen) {
        Write-Warning "Skipping code generation as requested"
        return $true
    }
    
    Write-Status "Generating code with build_runner..."
    try {
        flutter packages pub run build_runner build --delete-conflicting-outputs
        Write-Success "Code generated successfully"
        return $true
    }
    catch {
        Write-Warning "Code generation failed, but continuing..."
        return $false
    }
}

# Run analysis
function Run-Analysis {
    if ($SkipAnalysis) {
        Write-Warning "Skipping code analysis as requested"
        return $true
    }
    
    Write-Status "Running code analysis..."
    try {
        flutter analyze
        Write-Success "Code analysis completed"
        return $true
    }
    catch {
        Write-Warning "Code analysis found issues, but continuing..."
        return $false
    }
}

# Setup complete
function Show-SetupComplete {
    Write-Host ""
    Write-Host "🎉 Setup completed successfully!" -ForegroundColor $Green
    Write-Host ""
    Write-Host "🚀 Next steps:" -ForegroundColor $White
    Write-Host "  1. Run the app: flutter run -d chrome --web-port=8080"
    Write-Host "  2. Or use Makefile: make run-web"
    Write-Host "  3. Generate code: make build"
    Write-Host "  4. Watch for changes: make watch"
    Write-Host ""
    Write-Host "📚 Documentation:" -ForegroundColor $White
    Write-Host "  - Clean Architecture: CLEAN_ARCHITECTURE_README.md"
    Write-Host "  - Firebase Setup: FIREBASE_STORAGE_README.md"
    Write-Host "  - Makefile: make help"
    Write-Host ""
}

# Main setup function
function Start-Setup {
    Write-Status "Starting setup process..."
    Write-Host ""
    
    if (-not $SkipChecks) {
        if (-not (Test-Flutter)) { exit 1 }
        if (-not (Test-Dart)) { exit 1 }
        Test-Firebase | Out-Null
        Write-Host ""
    }
    
    if (-not (Install-Dependencies)) { exit 1 }
    Write-Host ""
    
    Generate-Code | Out-Null
    Write-Host ""
    
    Run-Analysis | Out-Null
    Write-Host ""
    
    Show-SetupComplete
}

# Run main setup function
try {
    Start-Setup
}
catch {
    Write-Error "Setup failed: $($_.Exception.Message)"
    exit 1
}
