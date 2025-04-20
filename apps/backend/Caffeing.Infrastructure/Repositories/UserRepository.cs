using Caffeing.Domain.Models;
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

        public async Task CreateAsync(User user, IDbConnection connection, IDbTransaction transaction)
        {
            string insert = @"
            INSERT INTO users (
                id, provider, provider_id,
                email, name, role,
                created_time, modified_time
            ) VALUES (
                @Id, @Provider, @ProviderId,
                @Email, @Name, @Role,
                @CreatedDate, @ModifiedDate
            )";
            var parameters = new
            {
                Id = user.Id.Value,
                Provider = user.Provider.Value,
                ProviderId = user.ProviderId.Value,
                Email = user.Email?.Value,
                Name = user.Name?.Value,
                Role = user.Role.ToString(),
                CreatedDate = user.CreatedDate,
                ModifiedDate = user.ModifiedDate
            };

            await connection.ExecuteAsync(insert, parameters, transaction);
        }

        public async Task<User?> GetByProviderAsync(string provider, string providerId)
        {
            string query = @"
            SELECT 
                id, provider, provider_id,
                email, name, role,
                created_time, modified_time
            FROM users
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
            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryFirstOrDefaultAsync<User>(query, parameters);

                return result;
            }
        }
    }
}
