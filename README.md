# .NET SQL Database Application with Docker

This is a sample .NET console application that demonstrates how to connect to a SQL Server database using Entity Framework Core, with the database running in a Docker container.

## 🚀 Quick Start (For Someone Cloning This Repo)

### **Option 1: One-Command Docker Setup (Recommended)**

1. **Install Docker Desktop** (one-time setup):
   - Download from: https://www.docker.com/products/docker-desktop/
   - Install and start Docker Desktop

2. **Clone this repository:**
   ```bash
   git clone <your-repo-url>
   cd <repo-name>
   ```

3. **Run the startup script:**
   ```powershell
   # Windows
   .\start-docker.ps1
   
   # Or run directly
   docker compose up --build
   ```

That's it! The application will:
- ✅ Build the .NET app in a container
- ✅ Start SQL Server in a container  
- ✅ Create the database and tables
- ✅ Run sample CRUD operations
- ✅ Show the results

### **Option 2: Local Development Setup**

If you prefer to run locally:

1. **Install .NET 9.0 SDK**
2. **Run setup script:**
   ```powershell
   .\setup.ps1
   ```
3. **Run the application:**
   ```bash
   dotnet run
   ```

## 📋 Prerequisites

### **For Docker Setup (Easiest)**
- Docker Desktop (includes everything needed)

### **For Local Development**
- [.NET 9.0 SDK](https://dotnet.microsoft.com/download/dotnet/9.0)
- SQL Server LocalDB (included with Visual Studio) OR SQL Server Express

## 🎯 What This Application Does

When you run the application, it will:

1. **Connect to SQL Server database** (automatically created)
2. **Create database tables** using Entity Framework migrations
3. **Seed sample data** (2 sample products)
4. **Demonstrate CRUD operations**:
   - 📖 **Read**: List all existing products
   - ➕ **Create**: Add a new product at runtime
   - ✏️ **Update**: Modify the product (change price)
   - 🔍 **Query**: Retrieve specific product by ID

**Sample Output:**
```
=== .NET SQL Database Demo ===

Existing products:
- 1: Sample Product 1 - $29.99
- 2: Sample Product 2 - $49.99

Creating a new product...
Created product: Dynamic Product (ID: 3)

Updated product list:
- 3: Dynamic Product - $99.99 (Created: 2025-07-02)
- 1: Sample Product 1 - $29.99 (Created: 2025-07-02)
- 2: Sample Product 2 - $49.99 (Created: 2025-07-02)

=== Demo completed successfully! ===
```

## 🛠️ Project Structure

```
├── Data/
│   └── ApplicationDbContext.cs    # Entity Framework context
├── Models/
│   └── Product.cs                 # Product entity model
├── Services/
│   └── ProductService.cs          # Business logic service
├── Program.cs                     # Main application entry point
├── appsettings.json              # Configuration file
├── docker-compose.yml            # Docker orchestration
├── Dockerfile                    # Container configuration for the app
└── README.md                     # This file
```

## Features

- **Entity Framework Core** with SQL Server provider
- **Repository pattern** with service layer
- **Dependency injection** using Microsoft.Extensions
- **Configuration management** with appsettings.json
- **Docker containerization** for both app and database
- **Sample CRUD operations** with product management

## Quick Start

### Option 1: Local Development (Easiest)

1. **Run the setup script:**
   ```powershell
   # Windows
   .\setup.ps1
   
   # Or manually
   dotnet restore && dotnet build
   ```

2. **Run the application:**
   ```bash
   dotnet run
   ```
   
   Uses SQL Server LocalDB (built into Windows with Visual Studio)

### Option 2: Docker Compose (Best for Consistency)

1. **Install Docker Desktop** if not already installed

2. **Start everything with one command:**
   ```bash
   docker-compose up --build
   ```
   
   This will:
   - Build the .NET application container
   - Start SQL Server in a container  
   - Run the application
   - Handle all networking automatically

### Option 3: Hybrid (Local App + Docker Database)

1. **Start only the database:**
   ```bash
   docker-compose up sqlserver -d
   ```

2. **Run the app locally:**
   ```bash
   dotnet run
   ```
   
   (Update connection string to use `DockerConnection` in appsettings.json)

## Database Operations

The application demonstrates:

1. **Database Creation**: Automatically creates the database and tables
2. **Seeding Data**: Inserts sample products during database creation
3. **Reading Data**: Retrieves and displays all products
4. **Creating Data**: Adds a new product at runtime
5. **Updating Data**: Modifies an existing product
6. **Querying Data**: Retrieves specific products by ID

## Configuration

### Connection String

The connection string is configured in `appsettings.json`:

```json
{
  "ConnectionStrings": {
    "DefaultConnection": "Server=localhost,1433;Database=SampleDb;User Id=sa;Password=YourPassword123;TrustServerCertificate=true;"
  }
}
```

### Docker Environment

When running with Docker Compose, the connection string is automatically adjusted to use the container name `sqlserver` instead of `localhost`.

## Development

### Adding Migrations

If you make changes to the models, create and apply migrations:

```bash
# Install EF tools (one time)
dotnet tool install --global dotnet-ef

# Add migration
dotnet ef migrations add YourMigrationName

# Update database
dotnet ef database update
```

### Stopping Services

To stop the Docker containers:
```bash
docker-compose down
```

To remove volumes (this will delete the database data):
```bash
docker-compose down -v
```

## Troubleshooting

### SQL Server Connection Issues

1. Make sure Docker is running
2. Wait for SQL Server to fully start (can take 30-60 seconds)
3. Check that port 1433 is not in use by another service

### Authentication Issues

The SQL Server container uses:
- Username: `sa`
- Password: `YourPassword123`

Make sure these match in your connection string.

## Deployment & Distribution

### For Different Computers

**Easy Distribution:**
1. **Share the project folder** (zip/git)
2. **Recipient runs:** `.\setup.ps1` (Windows) or `./setup.sh` (Linux/Mac)
3. **Run:** `dotnet run`

**Docker Distribution (Most Portable):**
1. **Recipient installs Docker Desktop only**
2. **Run:** `docker-compose up --build`
3. **Works identically** on Windows, Mac, Linux

**Production Deployment:**
- Publish to containers with `docker build`
- Deploy to cloud platforms (Azure, AWS, etc.)
- Use managed databases for production

### Why Docker?

Docker solves the **"It works on my machine"** problem:

- ✅ **Same environment everywhere** - No version conflicts
- ✅ **Easy setup** - One command to run everything  
- ✅ **Isolated dependencies** - Won't affect other software
- ✅ **Production-ready** - Same containers in dev and prod
- ✅ **Cross-platform** - Windows containers run on Linux hosts

## Security Notes

⚠️ **Important**: This example uses a simple password for demonstration. In production:

- Use strong passwords
- Store connection strings in secure configuration (Azure Key Vault, etc.)
- Use managed identities when possible
- Enable SSL/TLS connections
- Restrict network access

## Next Steps

This sample can be extended to:

- Add a Web API layer (ASP.NET Core)
- Implement authentication and authorization
- Add logging and monitoring
- Include unit and integration tests
- Deploy to cloud platforms (Azure, AWS, etc.)
