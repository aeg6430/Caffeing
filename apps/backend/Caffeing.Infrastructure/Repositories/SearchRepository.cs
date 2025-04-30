using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Search;
using Caffeing.Infrastructure.Entities.Stores;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
namespace Caffeing.Infrastructure.Repositories
{
    public class SearchRepository : ISearchRepository
    {
        private readonly ILogger<SearchRepository> _logger;
        private readonly DapperContext _context;

        public SearchRepository(
            ILogger<SearchRepository> logger,
            DapperContext context
        )
        {
            _logger = logger;
            _context = context;
        }



        public async Task<IEnumerable<StoreRow>> GetSearchResult (SearchCriteria searchCriteria)
        {

            string query = @"
                SELECT s.store_id AS storeid,
                       s.name, 
                       s.latitude, 
                       s.longitude
                FROM stores s
                LEFT JOIN store_keywords k 
                  ON s.store_id = k.store_id
                  AND (
                        @KeywordIds IS NULL 
                        OR array_length(@KeywordIds, 1) = 0 
                        OR k.keyword_id = ANY(@KeywordIds)
                  )
                WHERE (@Query IS NULL OR LOWER(s.name) ILIKE LOWER(@Query))
                GROUP BY s.store_id    
                HAVING 
                (
                    COALESCE(array_length(@KeywordIds, 1), 0) = 0 
                    OR COUNT(DISTINCT k.keyword_id) = array_length(@KeywordIds, 1)
                )
                LIMIT @PageSize OFFSET @Offset
            ";

            var parameters = new SearchCriteria
            {
                Query = string.IsNullOrEmpty(searchCriteria.Query) ? null : $"%{searchCriteria.Query}%",
                KeywordIds = searchCriteria.KeywordIds != null && searchCriteria.KeywordIds.Length > 0
                ? searchCriteria.KeywordIds
                : new Guid[] { },
                PageSize = searchCriteria.PageSize,
                Offset = searchCriteria.Offset
            };

            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<StoreRow>(query, parameters);

                return result;
            }
        }
    }
}
