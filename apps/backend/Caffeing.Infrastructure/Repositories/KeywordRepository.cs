using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
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

        public async Task<IEnumerable<KeywordResponse>> GetKeywords()
        {

            string query = @"
                SELECT 
                keyword_id AS KeywordID, 
                keyword_name AS KeywordName
	            FROM keywords;
            ";
            
            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<KeywordResponse>(
                    query,
                    commandType: CommandType.Text
                );

                return result;
            }
        }
    }
}
