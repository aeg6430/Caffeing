using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Entities.Search;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.IServices
{
    namespace Caffeing.Application.Services
    {
        public interface ISearchService
        {
            Task<SearchResponse> SearchStoresAsync(SearchRequest searchRequest);
        }
    }
}
