using Microsoft.EntityFrameworkCore;
using DotNetSqlApp.Data;
using DotNetSqlApp.Services;
using DotNetSqlApp.Models;

var builder = WebApplication.CreateBuilder(args);

// Add services to the container
builder.Services.AddControllers();
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();

// Add Entity Framework with connection string
builder.Services.AddDbContext<ApplicationDbContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("DefaultConnection")));

// Add our custom services
builder.Services.AddScoped<IProductService, ProductService>();

var app = builder.Build();

// Ensure database is created and test connection
using (var scope = app.Services.CreateScope())
{
    var context = scope.ServiceProvider.GetRequiredService<ApplicationDbContext>();
    var productService = scope.ServiceProvider.GetRequiredService<IProductService>();
    var logger = scope.ServiceProvider.GetRequiredService<ILogger<Program>>();
    
    try
    {
        logger.LogInformation("Creating database if it doesn't exist...");
        await context.Database.EnsureCreatedAsync();
        logger.LogInformation("Database is ready!");

        // Test database connection with sample operations
        logger.LogInformation("Testing database connection...");
        
        // Check if we already have sample data
        var existingProducts = await productService.GetAllProductsAsync();
        logger.LogInformation("Found {ProductCount} existing products", existingProducts.Count());

        // Add a test product if database is empty
        if (!existingProducts.Any())
        {
            logger.LogInformation("Adding sample products...");
            
            var sampleProducts = new[]
            {
                new Product { Name = "Sample Product 1", Description = "Test product for database verification", Price = 29.99m },
                new Product { Name = "Sample Product 2", Description = "Another test product", Price = 49.99m }
            };

            foreach (var product in sampleProducts)
            {
                var created = await productService.CreateProductAsync(product);
                logger.LogInformation("Created product: {ProductName} (ID: {ProductId})", created.Name, created.Id);
            }
        }

        // Verify we can read the data
        var allProducts = await productService.GetAllProductsAsync();
        logger.LogInformation("Database verification successful! Total products: {ProductCount}", allProducts.Count());
        
        foreach (var product in allProducts.Take(3)) // Log first 3 products
        {
            logger.LogInformation("Product: {ProductId} - {ProductName} - ${ProductPrice:F2}", 
                product.Id, product.Name, product.Price);
        }
    }
    catch (Exception ex)
    {
        logger.LogError(ex, "Database connection failed: {ErrorMessage}", ex.Message);
        logger.LogError("Make sure Azure SQL Database is configured correctly. Check connection string in Azure Portal.");
        // Don't throw - let the app start so you can see logs in Azure
    }
}

// Configure the HTTP request pipeline
if (app.Environment.IsDevelopment())
{
    app.UseSwagger();
    app.UseSwaggerUI();
}

app.UseHttpsRedirection();
app.UseAuthorization();
app.MapControllers();

app.Run();
