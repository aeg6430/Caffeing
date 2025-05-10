using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http.Json;
using System.Reflection.Metadata;
using System.Text;
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

        public async Task<bool> ForwardAsync(Request request)
        {
            var jsonContent = GetJsonContent(request);
            var response = await _httpClient.PostAsync(_endpoint, jsonContent);

            return response.IsSuccessStatusCode;
        }

        private StringContent GetJsonContent(Request request)
        {
            var json = request.Data.RootElement.GetRawText();
            return new StringContent(json, Encoding.UTF8, "application/json");
        }
    }
}


