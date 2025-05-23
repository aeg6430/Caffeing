# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy solution and project files
COPY Caffeing/Caffeing.sln Caffeing/
COPY Caffeing/Caffeing.WebAPI.csproj Caffeing/
COPY Caffeing.Application/*.csproj Caffeing.Application/
COPY Caffeing.Infrastructure/*.csproj Caffeing.Infrastructure/
COPY Caffeing.IntakeService/*.csproj Caffeing.IntakeService/
COPY Caffeing.Domain/*.csproj Caffeing.Domain/

# Restore using the solution
RUN dotnet restore ./Caffeing.sln

# Copy the full source and build
COPY . ./
WORKDIR /src/Caffeing.WebAPI
RUN dotnet publish -c Release -o /app/publish --no-restore --self-contained true --runtime linux-x64

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./Caffeing.WebAPI"]
