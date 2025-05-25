using Caffeing.Application.Auth;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

namespace Caffeing.WebAPI
{
    public static class FirebaseInitializer
    {
        public static IServiceCollection AddFirebase(this IServiceCollection services, IConfiguration configuration)
        {
            if (FirebaseApp.DefaultInstance == null)
            {
                var env = Environment.GetEnvironmentVariable("ASPNETCORE_ENVIRONMENT");
                GoogleCredential credential;
                AppOptions options = new();

                if (env == "Development")
                {
                    var path = Environment.GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS");
                    if (string.IsNullOrWhiteSpace(path))
                    {
                        throw new InvalidOperationException("GOOGLE_APPLICATION_CREDENTIALS is not set in development.");
                    }
                    if (!File.Exists(path))
                    {
                        throw new InvalidOperationException($"Credential file not found at: {path}");
                    }

                    credential = GoogleCredential.FromFile(path);
                    options.Credential = credential;
                }
                else
                {
                    credential = GoogleCredential.GetApplicationDefault();
                    var projectId = configuration["Firebase:ProjectId"];
                    if (string.IsNullOrWhiteSpace(projectId))
                    {
                        throw new InvalidOperationException("Firebase:ProjectId is not set in production.");
                    }

                    options.Credential = credential;
                    options.ProjectId = projectId;
                }

                FirebaseApp.Create(options);
            }

            services.AddSingleton(FirebaseApp.DefaultInstance);
            services.AddSingleton<IFirebaseAuthProviderService, FirebaseAuthProviderService>();

            return services;
        }
    }
}
