# Quick Start Script for Docker
# Run this after cloning the repository

Write-Host "=== .NET SQL Database App - Docker Setup ===" -ForegroundColor Green
Write-Host "This will start the application with Docker containers" -ForegroundColor Cyan

# Check if Docker is running
Write-Host "`nChecking Docker..." -ForegroundColor Yellow
try {
    docker info > $null 2>&1
    if ($LASTEXITCODE -ne 0) {
        Write-Host "X Docker is not running" -ForegroundColor Red
        Write-Host "Please start Docker Desktop and try again" -ForegroundColor Yellow
        exit 1
    }
    Write-Host "✓ Docker is running" -ForegroundColor Green
} catch {
    Write-Host "X Docker not found. Please install Docker Desktop" -ForegroundColor Red
    exit 1
}

# Start the application
Write-Host "`nStarting application with Docker Compose..." -ForegroundColor Yellow
Write-Host "This will:" -ForegroundColor Cyan
Write-Host "  1. Build the .NET application container" -ForegroundColor White
Write-Host "  2. Start SQL Server container" -ForegroundColor White  
Write-Host "  3. Wait for database to be ready" -ForegroundColor White
Write-Host "  4. Run the application" -ForegroundColor White
Write-Host ""

docker compose up --build

Write-Host "`n=== Finished ===" -ForegroundColor Green
Write-Host "To stop and cleanup:" -ForegroundColor Cyan
Write-Host "  docker compose down" -ForegroundColor White
