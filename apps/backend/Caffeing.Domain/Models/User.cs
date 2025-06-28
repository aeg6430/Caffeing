using Caffeing.Domain.ValueObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Domain.Models
{
    public class User
    {
        public Guid UserId { get; set; }
        public string Provider { get; set; }
        public string ProviderId { get; set; }
        public string? Email { get; set; }
        public string? Name { get; set; }
        public string Role { get; set; }
        public DateTime CreatedTime { get; set; }
        public DateTime ModifiedTime { get; set; }
    }
}
