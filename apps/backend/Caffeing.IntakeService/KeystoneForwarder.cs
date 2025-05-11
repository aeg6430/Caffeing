using System;
using System.Collections.Generic;
using System.Linq;
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

        public KeystoneForwarder(HttpClient httpClient, string endpoint)
        {
            _httpClient = httpClient;
            _endpoint = endpoint;
        }

        public async Task<bool> ForwardAsync(string jsonData)
        {
            if (string.IsNullOrWhiteSpace(jsonData))
            {
                throw new ArgumentException("JSON data cannot be null or empty.", nameof(jsonData));
            }


            var jsonContent = new StringContent(jsonData, Encoding.UTF8, "application/json");
            try
            {
                var response = await _httpClient.PostAsync(_endpoint, jsonContent);
                return response.IsSuccessStatusCode;
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine($"Error forwarding JSON: {ex.Message}");
                return false;
            }
        }
    }
}


