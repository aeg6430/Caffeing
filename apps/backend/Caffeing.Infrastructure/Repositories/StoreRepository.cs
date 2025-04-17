using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Keywords;
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
            string sql = @"
        SELECT 
            s.store_id AS StoreId, 
            s.name AS Name,
            s.latitude AS Latitude,  
            s.longitude AS Longitude, 
            s.address AS Address, 
            s.contact_number AS ContactNumber, 
            s.business_hours AS BusinessHours,

            k.keyword_id AS KeywordId,
            k.keyword_name AS KeywordName,
            k.keyword_type AS KeywordType

        FROM stores s
        LEFT JOIN store_keywords sk ON s.store_id = sk.store_id
        LEFT JOIN keywords k ON sk.keyword_id = k.keyword_id
        WHERE s.store_id = @StoreId
    ";

            var storeDict = new Dictionary<Guid, StoreEntity>();

            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<StoreEntity, KeywordEntity, StoreEntity>(
                    sql,
                    (store, keyword) =>
                    {
                        if (!storeDict.TryGetValue(store.StoreId, out var currentStore))
                        {
                            currentStore = store;
                            currentStore.Keywords = new List<KeywordEntity>();
                            storeDict.Add(currentStore.StoreId, currentStore);
                        }

                        if (keyword != null && !currentStore.Keywords.Any(k => k.KeywordId == keyword.KeywordId))
                        {
                            currentStore.Keywords.Add(keyword);
                        }

                        return currentStore;
                    },
                    param: new { storeCriteria.StoreId },
                    splitOn: "KeywordId"
                );

                return result.FirstOrDefault();
            }
        }
    }
}
