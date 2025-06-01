using Google.Apis.Auth.OAuth2;
using Google.Cloud.Iam.Credentials.V1;
using Microsoft.Extensions.Hosting;
using System;
using System.Net.Http.Headers;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public class KeystoneForwarder : IForwarder
    {
        private readonly HttpClient _httpClient;
        private readonly string _endpoint;
        private readonly IHostEnvironment _env;

        public KeystoneForwarder(HttpClient httpClient, string endpoint, IHostEnvironment env)
        {
            _httpClient = httpClient;
            _endpoint = endpoint;
            _env = env;
        }

        public async Task<bool> ForwardAsync(SuggestionData suggestionData)
        {
            try
            {
                string idToken = await GetIdentityTokenAsync(_endpoint);

                _httpClient.DefaultRequestHeaders.Authorization =
                    new AuthenticationHeaderValue("Bearer", idToken);

                var json = JsonSerializer.Serialize(suggestionData);
                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await _httpClient.PostAsync(_endpoint, content);

                return response.IsSuccessStatusCode;
            }
            catch (Exception e)
            {
                Console.Error.WriteLine($"Error forwarding JSON: {e.Message}");
                return false;
            }
        }

        private async Task<string> GetIdentityTokenAsync(string audience)
        {
            GoogleCredential credential = await GoogleCredential.GetApplicationDefaultAsync();

            if (credential.UnderlyingCredential is ServiceAccountCredential sac)
            {
                var client = new IAMCredentialsClientBuilder().Build();

                var request = new GenerateIdTokenRequest
                {
                    Name = $"projects/-/serviceAccounts/{sac.Id}",
                    Audience = audience,
                    IncludeEmail = true
                };

                var response = await client.GenerateIdTokenAsync(request);
                return response.Token;
            }

            throw new InvalidOperationException("Could not obtain a valid Service Account Credential.");
        }
    }
}
