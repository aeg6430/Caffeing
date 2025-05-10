using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public class Verifier
    {
        private readonly HttpClient _httpClient;
        private readonly string _secretKey;

        public Verifier(HttpClient httpClient, string secretKey)
        {
            _httpClient = httpClient;
            _secretKey = secretKey ?? throw new ArgumentNullException(nameof(secretKey));
        }

        public async Task<bool> VerifyAsync(string token)
        {
            var payload = new Dictionary<string, string>
            {
                ["secret"] = _secretKey,
                ["response"] = token
            };

            var content = new FormUrlEncodedContent(payload);
            var response = await _httpClient.PostAsync("https://challenges.cloudflare.com/turnstile/v0/siteverify", content);
            if (!response.IsSuccessStatusCode) 
            {
                return false;
            }

            var resultJson = await response.Content.ReadAsStringAsync();
            var result = JsonSerializer.Deserialize<TurnstileResponse>(resultJson);
            return result?.Success ?? false;
        }
    }
}
