using Caffeing.Domain.ValueObjects;
using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.FavoriteStores;
using Caffeing.Infrastructure.Entities.UserFavoriteStores;
using Caffeing.Infrastructure.Entities.Users;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Repositories
{
    public class FavoriteStoreRepository : IFavoriteStoreRepository
    {
        private readonly ILogger<FavoriteStoreRepository> _logger;
        private readonly DapperContext _context;

        public FavoriteStoreRepository(
            ILogger<FavoriteStoreRepository> logger,
            DapperContext context
        ) 
        { 
            _logger = logger;
            _context = context;
        }

        public async Task AddFavoriteStoreAsync(FavoriteStoreCriteria favoriteStoreCriteria)
        {
            string sql = @"
            INSERT INTO favorite_store (user_id, store_id)
            VALUES (@UserId, @StoreId)
            ";
            var parameters = new FavoriteStoreCriteria
            {
                UserId = favoriteStoreCriteria.UserId,
                StoreId = favoriteStoreCriteria.StoreId,
            };
            using (var connection = _context.CreateConnection())
            {
                await connection.ExecuteAsync(sql, parameters);
            }
        }

        public async Task<IEnumerable<FavoriteStoreEntity>> GetStoreIdsAsync(Guid userId)
        {
            string query = @"
                SELECT 
                    user_id AS UserId, 
                    store_id AS StoreId
                FROM favorite_store
                WHERE 
                    user_id = @UserId
            ";
            var parameters = new  
            {
                UserId = userId
            };
            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<FavoriteStoreEntity>(query, parameters);

                return result;
            }
         }

        public async Task RemoveFavoriteStoreAsync(FavoriteStoreCriteria favoriteStoreCriteria)
        {
            string sql = @"
            DELETE FROM favorite_store
            WHERE user_id = @UserId AND store_id = @StoreId
            ";
            var parameters = new FavoriteStoreCriteria
            {
                UserId = favoriteStoreCriteria.UserId,
                StoreId = favoriteStoreCriteria.StoreId,
            };
            using (var connection = _context.CreateConnection())
            {
                await connection.ExecuteAsync(sql,parameters);
            }
        }
    }
}
