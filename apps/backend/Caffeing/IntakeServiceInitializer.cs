using Caffeing.IntakeService;

namespace Caffeing.WebAPI
{
    public static class IntakeServiceInitializer
    {
        public static IServiceCollection AddIntakeService(this IServiceCollection services, IConfiguration configuration)
        {
            var turnstileSecret = configuration["Turnstile:SecretKey"]
                     ?? throw new InvalidOperationException("Missing Turnstile:SecretKey");

            var keystoneEndpoint = configuration["Keystone:Endpoint"]
                                   ?? throw new InvalidOperationException("Missing Keystone:Endpoint");

            services.AddHttpClient<Verifier>();
            services.AddScoped<Verifier>(provider =>
            {
                var httpClient = provider.GetRequiredService<HttpClient>();
                return new Verifier(httpClient, turnstileSecret);  
            });

            services.AddScoped<IForwarder>(provider =>
            {
                var httpClient = provider.GetRequiredService<HttpClient>();
                return new KeystoneForwarder(httpClient, keystoneEndpoint); 
            });

            services.AddScoped<IntakeHandler>();

            return services;
        }
     }
}
