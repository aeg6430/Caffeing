using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Auth
{
    public interface IAuthService
    {
        Task<UserDto> LoginWithProviderAsync(ProviderLoginRequest request);
    }
}
