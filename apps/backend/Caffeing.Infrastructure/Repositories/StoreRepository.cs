using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Stores;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Caffeing.Infrastructure.Repositories
{
    public class StoreRepository : IStoreRepository
    {
        private readonly ILogger<StoreRepository> _logger;
        private readonly DapperContext _context;

        public StoreRepository(
            ILogger<StoreRepository> logger,
            DapperContext context
        )
        {
            _logger = logger;
            _context = context;
        }

        public async Task<StoreEntity> GetStoreResult(StoreCriteria storeCriteria)
        {
            string query =
                @"
                    SELECT 
                    store_id AS StoreID, 
                    name AS Name,
                    latitude AS Latitude,  
                    longitude AS Longitude, 
                    address AS Address, 
                    contact_number AS ContactNumber, 
                    business_hours AS BusinessHours
	                FROM stores
                    WHERE store_id = @StoreID
                ";
            var parameters = new StoreCriteria
            {
               StoreID = storeCriteria.StoreID,
            };
            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<StoreEntity>(query, parameters, commandType: CommandType.Text);

                return result.FirstOrDefault();  
            }
        }
    }
}
