using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Auth
{
    public class OAuthUserInfo
    {
        public string Email { get; set; }
        public string Name { get; set; }
        public string ProviderId { get; set; }
        public string Provider { get; set; }
    }
}
