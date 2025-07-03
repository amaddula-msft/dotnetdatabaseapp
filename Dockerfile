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
FROM mcr.microsoft.com/dotnet/runtime:9.0
WORKDIR /app

# Copy the published application (this should include appsettings.json)
COPY --from=build /app/out .

# Set the entry point
ENTRYPOINT ["dotnet", "DotNetSqlApp.dll"]
