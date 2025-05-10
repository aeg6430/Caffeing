using Caffeing.Domain.Enums;
using Caffeing.Domain.Models;
using Caffeing.Domain.ValueObjects;
using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.Entities.Users;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Repositories
{
    public class UserRepository : IUserRepository
    {
        private readonly ILogger<UserRepository> _logger;
        private readonly DapperContext _context;

        public UserRepository(
            ILogger<UserRepository> logger,
            DapperContext context
        )
        {
            _logger = logger;
            _context = context;
        }

        public async Task CreateAsync(UserEntity user, IDbConnection connection, IDbTransaction transaction)
        {
            string insert = @"
            INSERT INTO app_user (
                user_id, provider, provider_id,
                email, name, role,
                created_time, modified_time
            ) VALUES (
                @UserId, @Provider, @ProviderId,
                @Email, @Name, @Role,
                @CreatedTime, @ModifiedTime
            )";
            var parameters = new
            {
                UserId = user.UserId,
                Provider = user.Provider,
                ProviderId = user.ProviderId,
                Email = user.Email,
                Name = user.Name,
                Role = user.Role,
                CreatedTime = user.CreatedTime,
                ModifiedTime = user.ModifiedTime
            };

            await connection.ExecuteAsync(insert, parameters, transaction);
        }

        public async Task<UserEntity?> GetByProviderAsync(string provider, string providerId)
        {
            string query = @"
            SELECT 
                user_id AS userId,
                provider,
                provider_id AS providerId,
                email,
                name,
                role,
                created_time AS createdTime,
                modified_time AS modifiedTime
            FROM app_user
            WHERE 
                provider = @Provider
            AND
                provider_id = @ProviderId
            ";

            var parameters = new
            {
                Provider = provider,
                ProviderId = providerId
            };

            using var connection = _context.CreateConnection();

            var result = await connection.QueryFirstOrDefaultAsync<UserEntity>(query, parameters);
            
            return result;
        }
    }
}
