using Caffeing.Infrastructure.Entities.Keywords;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface IKeywordRepository
    {
        Task<IEnumerable<KeywordResponse>> GetKeywords();
    }
}
