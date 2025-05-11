using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Text.Json;
using System.Threading.Tasks;

namespace Caffeing.IntakeService
{
    public class Request
    {
        public string Data { get; set; } = default!;
        public string Token { get; set; } = default!;
    }
}
