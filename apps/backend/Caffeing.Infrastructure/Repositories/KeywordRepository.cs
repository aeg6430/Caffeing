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

        public async Task<IEnumerable<KeywordEntity>> GetKeywords()
        {
            string query = @"
                SELECT 
                    keyword_id AS KeywordId, 
                    keyword_name AS KeywordName,
                    keyword_type AS KeywordType 
                FROM keyword;
            ";

            using (var connection = _context.CreateConnection())
            {       
                var result = await connection.QueryAsync<KeywordEntity>(query);

                return result;
            }
        }
    }
}
