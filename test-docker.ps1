# Docker Installation Verification Script

Write-Host "Testing Docker Installation..." -ForegroundColor Green

# Test Docker command
Write-Host "`nChecking Docker version..." -ForegroundColor Yellow
try {
    $dockerVersion = docker --version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker found: $dockerVersion" -ForegroundColor Green
    } else {
        Write-Host "✗ Docker command not found" -ForegroundColor Red
        Write-Host "  Make sure Docker Desktop is installed and running" -ForegroundColor Yellow
        exit 1
    }
} catch {
    Write-Host "✗ Docker not available" -ForegroundColor Red
    exit 1
}

# Test Docker Compose
Write-Host "`nChecking Docker Compose..." -ForegroundColor Yellow
try {
    $composeVersion = docker compose version 2>$null
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker Compose found: $composeVersion" -ForegroundColor Green
    } else {
        Write-Host "✗ Docker Compose not found" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Docker Compose not available" -ForegroundColor Red
    exit 1
}

# Test with a simple container
Write-Host "`nTesting Docker with hello-world container..." -ForegroundColor Yellow
try {
    $output = docker run --rm hello-world 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker is working correctly!" -ForegroundColor Green
        Write-Host "✓ Can pull and run containers" -ForegroundColor Green
    } else {
        Write-Host "✗ Docker test failed" -ForegroundColor Red
        Write-Host "Output: $output" -ForegroundColor Yellow
    }
} catch {
    Write-Host "✗ Could not test Docker" -ForegroundColor Red
}

Write-Host "`n=== Docker Installation Check Complete ===" -ForegroundColor Green
Write-Host "If all tests passed, you're ready to run:" -ForegroundColor Cyan
Write-Host "  docker-compose up --build" -ForegroundColor White
