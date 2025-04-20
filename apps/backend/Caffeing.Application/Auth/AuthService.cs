using Caffeing.Application.Jwt;
using Caffeing.Domain.Enums;
using Caffeing.Domain.Models;
using Caffeing.Domain.ValueObjects;
using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.IRepositories;
using System;
using System.Threading.Tasks;

namespace Caffeing.Application.Auth
{
    /// <summary>
    /// Provides authentication services using Firebase ID tokens and generates JWT tokens for application use.
    /// </summary>
    public class AuthService : IAuthService
    {
        private readonly IUserRepository _userRepository;
        private readonly IJwtTokenService _jwtTokenService;
        private readonly IFirebaseAuthProviderService _firebaseAuthService;
        private readonly DapperContext _context;
        public AuthService(
            IUserRepository userRepository,
            IJwtTokenService jwtTokenService,
            IFirebaseAuthProviderService firebaseAuthService,
            DapperContext context
        )
        {
            _userRepository = userRepository;
            _jwtTokenService = jwtTokenService;
            _firebaseAuthService = firebaseAuthService;
            _context = context;
        }
        /// <summary>
        /// Authenticates a user using a Firebase ID token provided by an OAuth provider (e.g., Google),
        /// retrieves or creates the user in the system, and generates a JWT token for access.
        /// </summary>
        /// <param name="request">The provider login request containing the Firebase ID token.</param>
        /// <returns>A <see cref="UserDto"/> object containing user information and a generated JWT token.</returns>
        /// <exception cref="InvalidOperationException">Thrown when the Firebase token is invalid or the provider is unsupported.</exception>
        public async Task<UserDto> LoginWithProviderAsync(ProviderLoginRequest request)
        {
            var oauthUserInfo = await _firebaseAuthService.VerifyIdTokenAndGetUserInfoAsync(request.IdToken);

            if (oauthUserInfo == null) 
            {
                throw new InvalidOperationException("Invalid Firebase token or user information.");
            }
            var providerType = ConvertToProviderType(oauthUserInfo.Provider);

            

            try
            {
                _context.Begin();

                var user = await _userRepository.GetByProviderAsync(oauthUserInfo.Provider, oauthUserInfo.ProviderId);

                if (user == null)
                {
                    user = new User(
                        id: new UserId(Guid.NewGuid()),
                        provider: new Provider(providerType),
                        providerId: new ProviderId(oauthUserInfo.ProviderId),
                        email: new Email(oauthUserInfo.Email),
                        name: new UserName(oauthUserInfo.Name),
                        role: new UserRole(UserRoleType.User),
                        createdTime: DateTime.UtcNow,
                        modifiedTime: DateTime.UtcNow
                    );

                    await _userRepository.CreateAsync(user, _context.Connection, _context.Transaction);
                }
                _context.Commit();
                var tokenPayload = new JwtTokenPayload
                {
                    UserId = user.Id,
                    Email = user.Email,
                    Role = user.Role.ToString(),
                };
                var token = _jwtTokenService.GenerateToken(tokenPayload);

                var userDto = new UserDto
                {
                    Id = user.Id,
                    Name = user.Name,
                    Email = user.Email,
                    Role = user.Role.ToString(),
                    Token = token
                };

                return userDto;
            }
            catch (Exception e)
            {
                _context.Rollback();
                throw;
            }
            finally 
            {
                _context.Dispose();
            }         
        }
        private ProviderType ConvertToProviderType(string provider)
        {
            return provider.ToLower() switch
            {
                "google.com" => ProviderType.Google,
                _ => throw new InvalidOperationException($"Unsupported provider: {provider}")
            };
        }
    }
}
