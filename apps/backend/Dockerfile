# Base runtime image
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# SDK image for build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copy everything in Caffeing directory, preserving structure
COPY Caffeing/ Caffeing/
COPY Caffeing.Application/*.csproj Caffeing.Application/
COPY Caffeing.Infrastructure/*.csproj Caffeing.Infrastructure/
COPY Caffeing.Domain/*.csproj Caffeing.Domain/
COPY Caffeing.IntakeService/*.csproj Caffeing.IntakeService/

# Restore using the solution
RUN dotnet restore ./Caffeing/Caffeing.sln

# Copy the full source and build
COPY . ./
WORKDIR /src/Caffeing.WebAPI
RUN dotnet publish -c Release -o /app/publish --no-restore --self-contained true --runtime linux-x64

# Final image
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["./Caffeing.WebAPI"]
