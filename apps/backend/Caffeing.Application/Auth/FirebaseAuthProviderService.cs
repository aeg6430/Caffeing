using FirebaseAdmin.Auth;
using FirebaseAdmin;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Auth
{
    public class FirebaseAuthProviderService : IFirebaseAuthProviderService
    {
        private readonly FirebaseApp _firebaseApp;

        public FirebaseAuthProviderService(FirebaseApp firebaseApp)
        {
            _firebaseApp = firebaseApp;
        }

        public async Task<OAuthUserInfo?> VerifyIdTokenAndGetUserInfoAsync(string idToken)
        {
            var firebaseAuth =  FirebaseAuth.GetAuth(_firebaseApp);
            try
            {
                var decodedToken = await firebaseAuth.VerifyIdTokenAsync(idToken);

                var userRecord = await firebaseAuth.GetUserAsync(decodedToken.Uid);

                return new OAuthUserInfo
                {
                    Email = userRecord.Email,
                    Name = userRecord.DisplayName,
                    ProviderId = userRecord.Uid, 
                    Provider = "firebase"
                };
            }
            catch (FirebaseAuthException e) when (e.AuthErrorCode == AuthErrorCode.ExpiredIdToken)
            {
                throw new InvalidOperationException("Token has expired.", e);
            }
            catch (FirebaseAuthException e)
            {
                throw new InvalidOperationException($"Firebase authentication failed: {e.AuthErrorCode}", e);
            }
            catch (Exception e)
            {
                throw new InvalidOperationException("Invalid or expired token.", e);
            }
        }
    }

}
