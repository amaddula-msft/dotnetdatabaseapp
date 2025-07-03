<!-- Use this file to provide workspace-specific custom instructions to Copilot. For more details, visit https://code.visualstudio.com/docs/copilot/copilot-customization#_use-a-githubcopilotinstructionsmd-file -->

# .NET SQL Database Application Instructions

This workspace contains a .NET console application that demonstrates database operations using Entity Framework Core with SQL Server in Docker containers.

## Project Context

- **Framework**: .NET 9.0
- **Database**: SQL Server (containerized)
- **ORM**: Entity Framework Core
- **Architecture**: Repository pattern with service layer
- **Dependencies**: Microsoft.Extensions for DI and configuration

## Key Patterns

- Use async/await for all database operations
- Follow the repository pattern implemented in `ProductService`
- Use dependency injection for service registration
- Configure Entity Framework with fluent API in `ApplicationDbContext`
- Handle database connection failures gracefully

## Code Conventions

- Use nullable reference types appropriately
- Follow SOLID principles
- Use proper exception handling
- Implement soft deletes where applicable
- Use meaningful variable and method names

## Database Guidelines

- Always use parameterized queries through EF Core
- Implement proper data validation with attributes
- Use migrations for schema changes
- Consider performance implications of queries
- Use appropriate data types (decimal for money, UTC for dates)

## Docker Best Practices

- Use official Microsoft images
- Implement health checks for services
- Use volumes for persistent data
- Configure proper networking between containers
- Follow the principle of least privilege for security
