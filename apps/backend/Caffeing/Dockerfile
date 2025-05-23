# Use official .NET 8 ASP.NET runtime image as base
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Use official .NET 8 SDK image to build the app
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy the solution file and restore dependencies
COPY Caffeing.sln ./
COPY Caffeing.WebAPI/*.csproj Caffeing.WebAPI/
COPY Caffeing.Application/*.csproj Caffeing.Application/
COPY Caffeing.Infrastructure/*.csproj Caffeing.Infrastructure/
COPY Caffeing.IntakeService/*.csproj Caffeing.IntakeService/
RUN dotnet restore ./Caffeing.WebAPI/Caffeing.WebAPI.csproj

# Copy the full source and build
COPY . ./
WORKDIR /src/Caffeing.WebAPI
RUN dotnet publish -c Release -o /app/publish --no-restore --self-contained true --runtime linux-x64

# Final stage
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./Caffeing.WebAPI"]
