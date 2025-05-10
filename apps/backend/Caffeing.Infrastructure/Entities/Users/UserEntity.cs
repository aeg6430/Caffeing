using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Users
{
    public class UserEntity
    {
        public string UserId { get; set; }
        public string Provider { get; set; } = default!;
        public string ProviderId { get; set; } = default!;
        public string? Email { get; set; }
        public string? Name { get; set; }
        public string Role { get; set; } 
        public DateTime CreatedTime { get; set; }
        public DateTime ModifiedTime { get; set; }
    }
}
