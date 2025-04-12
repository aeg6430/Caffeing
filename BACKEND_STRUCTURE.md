# Caffeing Backend Structure

This is the directory structure of the **Caffeing** backend project, which is split into multiple layers: **WebAPI**, **Application**, **Infrastructure**, and **Tests**.

## Project Tree

```
Caffeing
│
├── Caffeing.WebAPI              # Web API layer, provides API endpoints
│   ├── Controllers              # Handles HTTP requests and calls application services
│   ├── Program.cs               # Configures and starts the ASP.NET Core application
│   ├── Startup.cs               # Configures application services, middleware, and pipeline
│   ├── appsettings.json         # Configuration file storing application settings 
│   ├── ServiceRegistration.cs   # Registers services and references services from other layers
│   └── Utils                    # Utility classes specific to WebAPI (e.g., helpers, extensions)
│
├── Caffeing.Application         # Application layer, contains business logic and services
│   ├── Services                 # Defines application services (e.g., TestService)
│   └── IServices                # Defines application layer interfaces (e.g., ITestService)
│
├── Caffeing.Infrastructure      # Infrastructure layer, handles database and external dependencies
│   ├── Contexts                 # Manages database-specific contexts (e.g., DapperContext, DbContext)
│   ├── Entities                 # Defines application layer entities (e.g., TestResponse)
│   ├── Repositories             # Defines interactions with the database (e.g., TestRepository)
│   └── IRepositories            # Defines interfaces for data access (e.g., ITestRepository)
│
├── Caffeing.sln                 # Solution file, contains all projects
└── Caffeing.Tests               # Unit testing project, tests the application and infrastructure layers
    ├── UnitTests                # Contains unit test code
    └── TestHelpers              # Contains test utilities and configurations
```