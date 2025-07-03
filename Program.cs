using Microsoft.Extensions.DependencyInjection;
using Microsoft.Extensions.Hosting;
using Microsoft.Extensions.Configuration;
using Microsoft.EntityFrameworkCore;
using DotNetSqlApp.Data;
using DotNetSqlApp.Services;
using DotNetSqlApp.Models;

// Create host builder with dependency injection and configuration
var builder = Host.CreateApplicationBuilder(args);

// Add configuration
builder.Configuration.AddJsonFile("appsettings.json", optional: false, reloadOnChange: true);
builder.Configuration.AddEnvironmentVariables();

// Determine which connection string to use
var connectionString = builder.Configuration.GetConnectionString("DefaultConnection");

// If running in Docker, the environment variable will override the appsettings.json
var envConnectionString = Environment.GetEnvironmentVariable("ConnectionStrings__DefaultConnection");
if (!string.IsNullOrEmpty(envConnectionString))
{
    connectionString = envConnectionString;
    Console.WriteLine("Using Docker SQL Server connection string");
}
else
{
    Console.WriteLine("Using LocalDB connection string from appsettings.json");
}

// Add Entity Framework
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(connectionString));

// Add services
builder.Services.AddScoped<IProductService, ProductService>();

var host = builder.Build();

// Ensure database is created and run migrations
using (var scope = host.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    try
    {
        Console.WriteLine("Ensuring database is created...");
        await context.Database.EnsureCreatedAsync();
        Console.WriteLine("Database is ready!");
    }
    catch (Exception ex)
    {
        Console.WriteLine($"Database connection failed: {ex.Message}");
        Console.WriteLine("Make sure SQL Server container is running. See README.md for instructions.");
        return;
    }
}

// Demo operations
using (var scope = host.Services.CreateScope())
{
    var productService = scope.ServiceProvider.GetRequiredService<IProductService>();

    Console.WriteLine("\n=== .NET SQL Database Demo ===\n");

    // List existing products
    Console.WriteLine("Existing products:");
    var products = await productService.GetAllProductsAsync();
    foreach (var product in products)
    {
        Console.WriteLine($"- {product.Id}: {product.Name} - ${product.Price:F2}");
    }

    // Create a new product
    Console.WriteLine("\nCreating a new product...");
    var newProduct = new Product
    {
        Name = "Dynamic Product",
        Description = "Created at runtime",
        Price = 99.99m
    };

    var createdProduct = await productService.CreateProductAsync(newProduct);
    Console.WriteLine($"Created product: {createdProduct.Name} (ID: {createdProduct.Id})");

    // List products again
    Console.WriteLine("\nUpdated product list:");
    products = await productService.GetAllProductsAsync();
    foreach (var product in products)
    {
        Console.WriteLine($"- {product.Id}: {product.Name} - ${product.Price:F2} (Created: {product.CreatedAt:yyyy-MM-dd})");
    }

    // Update the product
    Console.WriteLine($"\nUpdating product {createdProduct.Id}...");
    createdProduct.Price = 79.99m;
    createdProduct.Description = "Updated at runtime";
    await productService.UpdateProductAsync(createdProduct.Id, createdProduct);
    Console.WriteLine($"Updated product price to ${createdProduct.Price:F2}");

    // Get specific product
    var updatedProduct = await productService.GetProductByIdAsync(createdProduct.Id);
    if (updatedProduct != null)
    {
        Console.WriteLine($"Retrieved product: {updatedProduct.Name} - ${updatedProduct.Price:F2}");
    }

    Console.WriteLine("\n=== Demo completed successfully! ===");
}
