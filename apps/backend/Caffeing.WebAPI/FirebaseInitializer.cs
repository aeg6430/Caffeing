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
                }
                else
                {
                    credential = GoogleCredential.GetApplicationDefault();
                }

                FirebaseApp.Create(new AppOptions
                {
                    Credential = credential
                });
            }

            services.AddSingleton(FirebaseApp.DefaultInstance);
            services.AddSingleton<IFirebaseAuthProviderService, FirebaseAuthProviderService>();

            return services;
        }
    }
}
