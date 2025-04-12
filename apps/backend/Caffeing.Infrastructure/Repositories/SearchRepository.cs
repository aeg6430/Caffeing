using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Entities.Search;
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

        public async Task<SearchResponse> SearchStores(SearchRequest searchRequest)
        {

            string query = @"
                SELECT s.store_id AS storeid,
                       s.name, 
                       s.latitude, 
                       s.longitude,
                       s.tags, 
                       ARRAY_AGG(k.keyword_id) AS keyword_ids
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
                COALESCE(array_length(@KeywordIds, 1), 0) = 0 
                OR COUNT(k.keyword_id) > 0
                LIMIT @PageSize OFFSET @Offset
            ";

            var parameters = new SearchRequest{
                Query = string.IsNullOrEmpty(searchRequest.Query) ? null : $"%{searchRequest.Query}%",
                KeywordIds = searchRequest.KeywordIds != null && searchRequest.KeywordIds.Length > 0
                ? searchRequest.KeywordIds
                : new Guid[] { },
                PageSize = searchRequest.PageSize,
                Offset = (searchRequest.PageNumber - 1) * searchRequest.PageSize,
            };

            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<StoresQueryResponse>(
                    query,
                    parameters,
                    commandType: CommandType.Text
                );

                var response = new SearchResponse
                {
                    Stores = result.ToList(),
                    TotalStoresCount = result.Count(),
                    IsFiltered = !string.IsNullOrEmpty(searchRequest.Query) || (searchRequest.KeywordIds?.Length > 0),
                    PageNumber = searchRequest.PageNumber,
                    PageSize = searchRequest.PageSize
                };

                return response;
            }
        }
    }
}
