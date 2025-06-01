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
        private readonly string _serviceAccountEmail;
        private readonly string _iapClientId;

        public KeystoneForwarder(
            HttpClient httpClient,
            string endpoint,
            IHostEnvironment env,
            string serviceAccountEmail,
            string iapClientId
         )
        {
            _httpClient = httpClient;
            _endpoint = endpoint;
            _env = env;
            _serviceAccountEmail = serviceAccountEmail;
            _iapClientId = iapClientId;
        }

        public async Task<bool> ForwardAsync(SuggestionData suggestionData)
        {
            try
            {
                if (!_env.IsDevelopment())
                {
                    string idToken = await GetIdentityTokenAsync();
                    Console.WriteLine($"Identity Token Retrieved: {idToken.Substring(0, 20)}..."); 
                    _httpClient.DefaultRequestHeaders.Authorization =
                        new AuthenticationHeaderValue("Bearer", idToken);
                }
                var json = JsonSerializer.Serialize(suggestionData);

                Console.WriteLine($"Sending Request to: {_endpoint}");
                Console.WriteLine($"Request Payload: {json}");

                var content = new StringContent(json, Encoding.UTF8, "application/json");
                var response = await _httpClient.PostAsync(_endpoint, content);

                Console.WriteLine($"Response Status Code: {response.StatusCode}");
                Console.WriteLine($"Response Content: {await response.Content.ReadAsStringAsync()}");

                return response.IsSuccessStatusCode;
            }
            catch (Exception e)
            {
                Console.Error.WriteLine($"Error forwarding JSON: {e.Message}");
                return false;
            }
        }

        private async Task<string> GetIdentityTokenAsync()
        {
            var client = new IAMCredentialsClientBuilder().Build();
            var request = new GenerateIdTokenRequest
            {
                Name = $"projects/-/serviceAccounts/{_serviceAccountEmail}",
                Audience = _iapClientId,  
                IncludeEmail = true
            };

            var response = await client.GenerateIdTokenAsync(request);
            return response.Token;
        }
    }
}
