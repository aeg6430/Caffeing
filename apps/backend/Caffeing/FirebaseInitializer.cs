using Caffeing.Application.Auth;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;

namespace Caffeing.WebAPI
{
    public static class FirebaseInitializer
    {
        public static IServiceCollection AddFirebase(this IServiceCollection services, IConfiguration configuration)
        {
            var credentialsPath = Environment.GetEnvironmentVariable("GOOGLE_APPLICATION_CREDENTIALS");

            if (string.IsNullOrWhiteSpace(credentialsPath))
            {
                throw new InvalidOperationException("Firebase credentials path is not configured.");
            }

            if (!File.Exists(credentialsPath))
            {
                throw new InvalidOperationException($"Firebase credentials file not found at: {credentialsPath}");
            }

            if (FirebaseApp.DefaultInstance == null)
            {
                FirebaseApp.Create(new AppOptions
                {
                    Credential = GoogleCredential.FromFile(credentialsPath)
                });
            }
            services.AddSingleton(FirebaseApp.DefaultInstance);
            services.AddSingleton<IFirebaseAuthProviderService, FirebaseAuthProviderService>();

            return services;
        }
    }
}
