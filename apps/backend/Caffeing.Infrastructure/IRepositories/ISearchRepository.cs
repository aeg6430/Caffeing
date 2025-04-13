using Caffeing.Infrastructure.Entities.Search;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface ISearchRepository
    {
        Task<SearchResponse> SearchStores(SearchRequest searchRequest);
    }
}
