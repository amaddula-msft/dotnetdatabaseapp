#!/bin/bash
# Setup Script for Linux/Mac

echo "Setting up .NET SQL Database Application..."

# Check if .NET is installed
if command -v dotnet &> /dev/null; then
    echo "✓ .NET SDK found: $(dotnet --version)"
else
    echo "✗ .NET SDK not found. Please install .NET 9.0 SDK from:"
    echo "  https://dotnet.microsoft.com/download/dotnet/9.0"
    exit 1
fi

# Restore packages
echo "Restoring NuGet packages..."
dotnet restore

if [ $? -eq 0 ]; then
    echo "✓ Packages restored successfully"
else
    echo "✗ Failed to restore packages"
    exit 1
fi

# Build the project
echo "Building the project..."
dotnet build

if [ $? -eq 0 ]; then
    echo "✓ Build successful"
else
    echo "✗ Build failed"
    exit 1
fi

echo ""
echo "=== Setup Complete! ==="
echo "To run the application:"
echo "  dotnet run"
echo ""
echo "To run with Docker (if installed):"
echo "  docker-compose up --build"
