﻿using Caffeing.Application.Jwt;
using Caffeing.Domain.Enums;
using Caffeing.Domain.Models;
using Caffeing.Domain.ValueObjects;
using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Users;
using Caffeing.Infrastructure.IRepositories;
using MySqlX.XDevAPI.Common;
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
            var providerId = ConvertToProviderId(oauthUserInfo.ProviderId);


            try

            {
                _context.Begin();

                var user = await _userRepository.GetByProviderAsync(oauthUserInfo.Provider, oauthUserInfo.ProviderId);

                if (user == null)
                {
                    user = new UserEntity {
                        UserId = Guid.NewGuid().ToString(),
                        Provider =  Provider.FromString(oauthUserInfo.Provider).ToString(),
                        ProviderId = new ProviderId(oauthUserInfo.ProviderId),
                        Email = new Email(oauthUserInfo.Email),
                        Name = new UserName(oauthUserInfo.Name),
                        Role = new UserRole(UserRoleType.User).ToString(),
                        CreatedTime = DateTime.UtcNow,
                        ModifiedTime =  DateTime.UtcNow
                    };

                    await _userRepository.CreateAsync(user, _context.Connection, _context.Transaction);
                }
                else
                {
                    var updated = false;

                    if (user.Name.ToString() != oauthUserInfo.Name)
                    {
                        user.Name = new UserName(oauthUserInfo.Name);
                        updated = true;
                    }

                    if (updated)
                    {
                        user.ModifiedTime = DateTime.UtcNow;
                        await _userRepository.UpdateAsync(user, _context.Connection, _context.Transaction);
                    }
                }
                _context.Commit();
                var tokenPayload = new JwtTokenPayload
                {
                    UserId = Guid.Parse(user.UserId),
                    Email = user.Email,
                    Role = user.Role.ToString(),
                };
                var token = _jwtTokenService.GenerateToken(tokenPayload);

                var userDto = new UserDto
                {
                    UserId = Guid.Parse(user.UserId),
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
                "firebase" => ProviderType.firebase,
                _ => throw new InvalidOperationException($"Unsupported provider: {provider}")
            };
        }

        private ProviderId ConvertToProviderId(string providerId)
        {
            if (string.IsNullOrWhiteSpace(providerId))
            {
                throw new ArgumentException("ProviderId cannot be null or empty.", nameof(providerId));
            }

            return new ProviderId(providerId);
        }

    }
}
