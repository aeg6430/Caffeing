using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Auth
{
    public interface IFirebaseAuthProviderService
    {
        Task<OAuthUserInfo> VerifyIdTokenAndGetUserInfoAsync(string idToken);
    }
}
