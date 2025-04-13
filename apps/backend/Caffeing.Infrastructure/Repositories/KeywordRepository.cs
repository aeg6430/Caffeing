using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
using MySqlX.XDevAPI.Common;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Caffeing.Infrastructure.Repositories
{
    public class KeywordRepository : IKeywordRepository
    {
        private readonly ILogger<KeywordRepository> _logger;
        private readonly DapperContext _context;

        public KeywordRepository(
            ILogger<KeywordRepository> logger,
            DapperContext context
        )
        {
            _logger = logger;
            _context = context;
        }

        /// <summary>
        /// Retrieves keyword data from the database and merges basic information with keyword type flags.
        /// The base information (ID and name) and the keyword types (stored as integer arrays) are queried separately 
        /// for simplicity and clarity, then combined into full <see cref="KeywordEntity"/> objects.
        /// </summary>
        /// <returns>
        /// A collection of <see cref="KeywordEntity"/> instances containing keyword IDs, names, and associated keyword types.
        /// </returns>

        public async Task<IEnumerable<KeywordEntity>> GetKeywords()
        {
            string baseQuery = @"
                SELECT 
                    keyword_id AS KeywordID, 
                    keyword_name AS KeywordName
                FROM keywords;
            ";

            string typeQuery = @"
                SELECT 
                    keyword_id AS KeywordID,
                    keyword_type AS KeywordType 
                FROM keywords;
            ";

            using (var connection = _context.CreateConnection())
            {
                // Query the base data and cast to KeywordResponseBase
                var baseResults = await connection.QueryAsync<KeywordEntityBase>(baseQuery);

                // Query the keyword_type column separately
                var typeResults = await connection.QueryAsync<(Guid KeywordID, int[] KeywordType)>(typeQuery);

                // Merge both results into full KeywordResponse
                var result = baseResults.Select(baseItem =>
                {
                    var types = typeResults.FirstOrDefault(x => x.KeywordID == baseItem.KeywordID).KeywordType?.ToList() ?? new List<int>();

                    return new KeywordEntity
                    {
                        KeywordID = baseItem.KeywordID,
                        KeywordName = baseItem.KeywordName,
                        KeywordType = types
                    };
                });

                return result;
            }
        }
    }
}
