using Caffeing.Infrastructure.Entities.Search;
using Caffeing.Infrastructure.Entities.Stores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface ISearchRepository
    {
        Task<IEnumerable<StoreRow>> GetSearchResult(SearchCriteria searchCriteria);
    }
}
