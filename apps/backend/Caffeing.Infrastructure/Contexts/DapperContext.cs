using Microsoft.Extensions.Logging;

namespace Caffeing.Infrastructure.Contexts
{
    public class DapperContext : TransactionContext
    {
        public DapperContext(DatabaseSettings settings, ILogger<TransactionContext>? logger = null)
            : base(settings, logger)
        {
        }
    }
}
