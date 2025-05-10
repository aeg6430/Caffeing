using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.Contracts.Search;
using Caffeing.Application.Dtos;
using Caffeing.Application.IServices.Caffeing.Application.Services;
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

        private SearchCriteria ConvertToSearchCriteria(SearchRequest searchRequest)
        {
            return new SearchCriteria
            {
                Query = searchRequest.Query,
                KeywordIds = searchRequest.KeywordIds?
                .Select(id => id.ToString())
                .ToArray(),
                PageNumber = searchRequest.PageNumber ?? 1, 
                PageSize = searchRequest.PageSize ?? 5,    
                Offset = ((searchRequest.PageNumber ?? 1) - 1) * (searchRequest.PageSize ?? 5)
            };
        }

        public async Task<SearchResponse> GetSearchResultAsync(SearchRequest searchRequest)
        {
            var searchCriteria = ConvertToSearchCriteria(searchRequest);
            var storeWithKeywordsData = await _repository.GetSearchResult(searchCriteria);

            var stores = storeWithKeywordsData
                .GroupBy(x => x.StoreId)
                .Select(group => new SearchDto
                {
                    StoreId = Guid.Parse(group.Key),
                    Name = group.First().Name,
                    Latitude = group.First().Latitude,
                    Longitude = group.First().Longitude,

                }).ToList();

            var totalStoresCount = storeWithKeywordsData.Count();

            var response = new SearchResponse
            {
                Stores = stores,
                TotalStoresCount = stores.Count, 
                PageNumber = searchRequest.PageNumber??1,
                PageSize = searchRequest.PageSize??10,
                IsMatched = stores.Count > 0
            };
            return response;
        }
    }
}

