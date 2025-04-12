using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Entities.Search;
using Caffeing.Infrastructure.IRepositories;

namespace Caffeing.Application.Services
{
    public class SearchService : ISearchService
    {
        private readonly ISearchRepository _repository;

        public SearchService(ISearchRepository repository)
        {
            _repository = repository;
        }

        public async Task<SearchResponse> SearchStoresAsync(SearchRequest searchRequest)
        {
            return await _repository.SearchStores(searchRequest);
        }
    }
}

