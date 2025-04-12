using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Test.IRepositories;
using Dapper;
using Microsoft.Extensions.Logging;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
namespace Caffeing.Infrastructure.Test.Repositories
{
    public class TestRepository : ITestRepository
    {
        private readonly ILogger<TestRepository> _logger;
        private readonly DapperContext _context;

        public TestRepository(
            ILogger<TestRepository> logger,
            DapperContext context
        )
        {
            _logger = logger;
            _context = context;
        }

        public async Task<TestResponse> Get()
        {
            string query =
                @"
                    SELECT *
                    FROM Test
                ";
            using (var connection = _context.CreateConnection())
            {
                var result = await connection.QueryAsync<TestResponse>(query, commandType: CommandType.Text);
                return result.FirstOrDefault();  
            }
        }
    }
}
