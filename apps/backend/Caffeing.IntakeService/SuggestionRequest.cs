using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public class SuggestionRequest
    {
        public SuggestionData Data { get; set; }  
        public string Token { get; set; }         
    }

    public class SuggestionData
    {
        public string Name { get; set; }
        public string BusinessHours { get; set; }
        public string Address { get; set; }
        public string GoogleMapsLink { get; set; }
        public string Website { get; set; }
        public string Description { get; set; }
    }
}
