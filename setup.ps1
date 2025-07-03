# Setup Script for Windows

Write-Host "Setting up .NET SQL Database Application..." -ForegroundColor Green

# Check if .NET is installed
$dotnetVersion = dotnet --version 2>$null
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ .NET SDK found: $dotnetVersion" -ForegroundColor Green
} else {
    Write-Host "✗ .NET SDK not found. Please install .NET 9.0 SDK from:" -ForegroundColor Red
    Write-Host "  https://dotnet.microsoft.com/download/dotnet/9.0" -ForegroundColor Yellow
    exit 1
}

# Restore packages
Write-Host "Restoring NuGet packages..." -ForegroundColor Yellow
dotnet restore

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Packages restored successfully" -ForegroundColor Green
} else {
    Write-Host "✗ Failed to restore packages" -ForegroundColor Red
    exit 1
}

# Build the project
Write-Host "Building the project..." -ForegroundColor Yellow
dotnet build

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Build successful" -ForegroundColor Green
} else {
    Write-Host "✗ Build failed" -ForegroundColor Red
    exit 1
}

Write-Host "`n=== Setup Complete! ===" -ForegroundColor Green
Write-Host "To run the application:" -ForegroundColor Cyan
Write-Host "  dotnet run" -ForegroundColor White
Write-Host "`nTo run with Docker (if installed):" -ForegroundColor Cyan  
Write-Host "  docker-compose up --build" -ForegroundColor White
