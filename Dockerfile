# Use the official .NET SDK image for building
FROM mcr.microsoft.com/dotnet/sdk:9.0 AS build
WORKDIR /app

# Copy project file and restore dependencies
COPY DotNetSqlApp.csproj ./
RUN dotnet restore DotNetSqlApp.csproj

# Copy source code
COPY . ./

# Build the application
RUN dotnet publish DotNetSqlApp.csproj -c Release -o out

# Use the official .NET runtime image for running
FROM mcr.microsoft.com/dotnet/aspnet:9.0
WORKDIR /app

# Copy the published application
COPY --from=build /app/out .

# Expose port 8080 (Azure App Service uses this port)
EXPOSE 8080

# Set the entry point
ENTRYPOINT ["dotnet", "DotNetSqlApp.dll"]
