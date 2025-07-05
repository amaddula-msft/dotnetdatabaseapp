# Azure App Service Deployment Guide

## 🚀 Your Web API is Ready for Deployment!

Your `DotNetSqlApp-Deploy.zip` file contains everything needed to deploy to Azure App Service.

## 📋 Prerequisites

1. **Azure Account** - Sign up at [portal.azure.com](https://portal.azure.com)
2. **Azure SQL Database** - You'll need to create this first
3. **.NET 9 SDK** - Installed on your development machine

## 📦 Step 0: Create Your Deployment Package

Before deploying to Azure, you need to create the deployment ZIP file from your source code:

### **1. Restore NuGet Packages**
```powershell
dotnet restore DotNetSqlApp.csproj
```
This downloads all the required dependencies for your project.

### **2. Publish the Application**
```powershell
dotnet publish DotNetSqlApp.csproj -c Release -o ./publish
```
This creates a production-ready build in the `./publish` folder with:
- Optimized code (Release configuration)
- All dependencies included
- Ready for deployment files

### **3. Create Deployment ZIP**
```powershell
Compress-Archive -Path .\publish\* -DestinationPath .\DotNetSqlApp-Deploy.zip -Force
```
This creates `DotNetSqlApp-Deploy.zip` containing all files needed for Azure App Service.

### **What Gets Published:**
- ✅ `DotNetSqlApp.dll` - Your compiled application
- ✅ `appsettings.json` - Local configuration
- ✅ `appsettings.Production.json` - Production configuration
- ✅ `web.config` - IIS configuration for Azure
- ✅ All .NET runtime dependencies
- ✅ Entity Framework libraries

💡 **Tip**: Run these commands from your project root directory (where `DotNetSqlApp.csproj` is located).

## 🗄️ Step 1: Create Azure SQL Database

1. Go to [Azure Portal](https://portal.azure.com)
2. Click **"Create a resource"** → **"Databases"** → **"SQL Database"**
3. Fill in the details:
   - **Database name**: `SampleDb`
   - **Server**: Create new server with:
     - Server name: `your-unique-server-name`
     - Admin login: `sqladmin`
     - Password: `YourSecurePassword123!`
     - Location: Choose your preferred region
   - **Pricing tier**: Basic (for testing) or Standard
4. Click **"Review + create"** → **"Create"**

## 🌐 Step 2: Create Azure App Service

1. In Azure Portal, click **"Create a resource"** → **"Web App"**
2. Fill in the details:
   - **App name**: `your-unique-app-name` (this will be your URL)
   - **Resource Group**: Use the same as your SQL Database
   - **Runtime stack**: **.NET 9 (STS)**
   - **Operating System**: **Windows**
   - **Region**: Same as your SQL Database
   - **Pricing tier**: Free F1 (for testing) or Basic B1
3. Click **"Review + create"** → **"Create"**

## 🔗 Step 3: Configure Connection String

### 🔧 **Important: Why Configure Connection String in Azure Portal?**

Your deployment package contains two configuration files:
- **`appsettings.json`** - Contains LocalDB connection for local development
- **`appsettings.Production.json`** - Has **empty** connection string for production

**Why empty in Production?** 
- ✅ **Security**: No passwords stored in code
- ✅ **Flexibility**: Different environments can use different databases
- ✅ **Azure Best Practice**: Azure App Service automatically injects the connection string

When deployed to Azure:
1. Azure sets `ASPNETCORE_ENVIRONMENT=Production`
2. Your app loads `appsettings.Production.json` (with empty connection)
3. Azure **overrides** it with the connection string you configure below

### 🔗 **Configure Your Azure SQL Connection:**

1. Go to your App Service in Azure Portal
2. Navigate to **"Configuration"** → **"Connection strings"**
3. Click **"+ New connection string"**
4. Add:
   - **Name**: `DefaultConnection`
   - **Value**: `Server=tcp://your-server-name.database.windows.net,1433;Initial Catalog=SampleDb;Persist Security Info=False;User ID=sqladmin;Password=YourSecurePassword123!;MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;`
   - **Type**: **SQLAzure**
5. Click **"OK"** → **"Save"**

💡 **Replace `your-server-name`, `sqladmin`, and `YourSecurePassword123!` with your actual Azure SQL Database details.**

## 📦 Step 4: Deploy Your Application

### Option A: Azure Portal Upload
1. In your App Service, go to **"Deployment Center"**
2. Choose **"Local Git"** or **"ZIP Deploy"**
3. For ZIP Deploy:
   - Go to `https://your-app-name.scm.azurewebsites.net/ZipDeployUI`
   - Drag and drop your `DotNetSqlApp-Deploy.zip` file
   - Wait for deployment to complete

### Option B: Manual File Upload
1. In your App Service, go to **"Advanced Tools"** → **"Go"** (Kudu)
2. Navigate to **"Debug console"** → **"CMD"**
3. Go to `site/wwwroot/`
4. Delete existing files (if any)
5. Drag and drop all files from your `publish` folder

## 🔧 Step 5: Configure Application Settings (Optional)

1. In App Service → **"Configuration"** → **"Application settings"**
2. Add these settings:
   - `ASPNETCORE_ENVIRONMENT`: `Production`
   - `WEBSITE_RUN_FROM_PACKAGE`: `1` (if using ZIP deploy)

## 🧪 Step 6: Test Your Deployment

### 🔍 **Verify Database Connection Testing:**

Your application automatically tests the database connection on startup. Here's how to verify it's working:

#### **1. Check Application Startup Logs:**
1. Go to **Azure Portal** → Your App Service
2. Navigate to **"Monitoring"** → **"Log stream"**
3. Look for these log messages during startup:
   ```
   Creating database if it doesn't exist...
   Database is ready!
   Testing database connection...
   Found 0 existing products
   Adding sample products...
   Created product: Sample Product 1 (ID: 1)
   Created product: Sample Product 2 (ID: 2)
   Database verification successful! Total products: 2
   Product: 1 - Sample Product 1 - $29.99
   Product: 2 - Sample Product 2 - $49.99
   ```

#### **2. Test the API Endpoints:**
1. **Visit Swagger UI**: `https://your-app-name.azurewebsites.net/swagger`
2. **Test GET endpoint**: `https://your-app-name.azurewebsites.net/api/products`
   - Should return the 2 sample products created during startup
3. **Test individual endpoints**:
   - `GET /api/products` - Get all products
   - `POST /api/products` - Create a product
   - `GET /api/products/{id}` - Get specific product
   - `PUT /api/products/{id}` - Update product
   - `DELETE /api/products/{id}` - Delete product

#### **3. What Success Looks Like:**
- ✅ **Logs show**: Database creation and sample data insertion
- ✅ **API returns**: JSON array with 2 sample products
- ✅ **Swagger UI**: Loads and shows all API endpoints
- ✅ **No errors**: In Log stream or when calling endpoints

#### **4. If Database Connection Fails:**
You'll see error logs like:
```
Database connection failed: [specific error message]
Make sure Azure SQL Database is configured correctly...
```

**Common fixes:**
- Check connection string in Azure Portal Configuration
- Verify Azure SQL Database firewall allows Azure services
- Confirm database server and credentials are correct

## 🔍 API Testing Examples

### Using Browser (GET requests):
```
https://your-app-name.azurewebsites.net/api/products
```

### Using PowerShell:
```powershell
# Get all products
Invoke-RestMethod -Uri "https://your-app-name.azurewebsites.net/api/products" -Method GET

# Create a product
$body = @{
    name = "Test Product"
    description = "Created via API"
    price = 19.99
} | ConvertTo-Json

Invoke-RestMethod -Uri "https://your-app-name.azurewebsites.net/api/products" -Method POST -Body $body -ContentType "application/json"
```

### Using curl:
```bash
# Get all products
curl https://your-app-name.azurewebsites.net/api/products

# Create a product
curl -X POST https://your-app-name.azurewebsites.net/api/products \
  -H "Content-Type: application/json" \
  -d '{"name":"Test Product","description":"Created via API","price":19.99}'
```

## 🚨 Troubleshooting

### **Publishing Issues:**
1. **"Specify which project or solution file to use"**: 
   - Make sure you're in the correct directory (where `DotNetSqlApp.csproj` is located)
   - Use the full project name: `dotnet restore DotNetSqlApp.csproj`

2. **"Package restore failed"**: 
   - Check your internet connection
   - Clear NuGet cache: `dotnet nuget locals all --clear`
   - Try restore again

3. **"Publish failed"**: 
   - Ensure project builds successfully: `dotnet build DotNetSqlApp.csproj`
   - Check for compilation errors in your code

### **Configuration Issues:**
1. **"Connection string is null"**: 
   - Check that you added `DefaultConnection` in Azure Portal Connection Strings
   - Verify the connection string name matches exactly (case-sensitive)
   - Make sure `ASPNETCORE_ENVIRONMENT` is set to `Production`

2. **Database connection issues**: 
   - Verify connection string values (server name, username, password)
   - Check Azure SQL Database firewall settings (allow Azure services)
   - Test connection string format

3. **Application not starting**: 
   - Check Application Insights or Log Stream in Azure Portal
   - Verify .NET 9 runtime is selected in App Service

4. **500 errors**: 
   - Temporarily set `ASPNETCORE_ENVIRONMENT` to `Development` for detailed errors
   - Check Log Stream for specific error messages

### **How Configuration Works:**
- **Local Development**: Uses `appsettings.json` with LocalDB
- **Azure Production**: Uses `appsettings.Production.json` + Azure Portal connection string
- **Azure automatically** overrides any connection string with Portal configuration

## 🎯 What You've Built

✅ **Web API** with CRUD operations for products  
✅ **Entity Framework Core** with Azure SQL Database  
✅ **Automatic Database Testing** - Verifies connection on startup  
✅ **Sample Data Creation** - Adds test products if database is empty  
✅ **Comprehensive Logging** - Shows database operations in Azure logs  
✅ **Swagger/OpenAPI** documentation  
✅ **Production-ready** deployment package  
✅ **Azure App Service** compatible

### **🔧 Built-in Database Verification:**
- **Startup Testing**: Automatically tests database connection when app starts
- **Sample Data**: Creates 2 test products if database is empty
- **Operation Logging**: Logs all database operations for troubleshooting
- **Error Handling**: Graceful handling of connection failures

Your API endpoints:
- `GET /api/products` - List all products
- `POST /api/products` - Create new product
- `GET /api/products/{id}` - Get product by ID
- `PUT /api/products/{id}` - Update product
- `DELETE /api/products/{id}` - Soft delete product

## 📁 Files in Your Deployment Package

- `DotNetSqlApp.dll` - Your main application
- `appsettings.json` - Configuration file
- `web.config` - IIS configuration
- All necessary .NET runtime dependencies

**Your deployment file: `DotNetSqlApp-Deploy.zip`** is ready to upload! 🎉
