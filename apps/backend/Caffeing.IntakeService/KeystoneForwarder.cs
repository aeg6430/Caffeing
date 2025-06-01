using Google.Apis.Auth.OAuth2;
using Microsoft.Extensions.Hosting;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Headers;
using System.Net.Http.Json;
using System.Reflection.Metadata;
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

        public KeystoneForwarder(
            HttpClient httpClient, 
            string endpoint,
            IHostEnvironment env
        )
        {
            _httpClient = httpClient;
            _endpoint = endpoint;
            _env = env;
        }

        public async Task<bool> ForwardAsync(SuggestionData suggestionData)
        {
            try
            {
                if (!_env.IsDevelopment())
                {
                    GoogleCredential credential = await GoogleCredential.GetApplicationDefaultAsync();

                    if (credential.UnderlyingCredential is not ServiceAccountCredential sac) 
                    {
                        throw new InvalidOperationException("Expected a service account credential.");
                    }

                    string idToken = await GenerateIdTokenAsync(sac, _endpoint);

                    _httpClient.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", idToken);
                }

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
    
    private async Task<string> GenerateIdTokenAsync(ServiceAccountCredential sac, string audience)
        {
            var tokenUrl = $"https://iamcredentials.googleapis.com/v1/projects/-/serviceAccounts/{sac.Id}:generateIdToken";

            var payload = new
            {
                audience,
                includeEmail = true
            };

            using var requestClient = new HttpClient();
            var accessToken = await sac.GetAccessTokenForRequestAsync();

            requestClient.DefaultRequestHeaders.Authorization =
                new AuthenticationHeaderValue("Bearer", accessToken);

            var json = new StringContent(JsonSerializer.Serialize(payload), Encoding.UTF8, "application/json");

            var response = await requestClient.PostAsync(tokenUrl, json);
            response.EnsureSuccessStatusCode();

            var jsonResponse = await response.Content.ReadAsStringAsync();
            using var doc = JsonDocument.Parse(jsonResponse);
            return doc.RootElement.GetProperty("token").GetString()!;
        }
     }
}


