using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.Contracts.Search;
using Caffeing.Application.DTOs;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.Entities.Search;
using Caffeing.Infrastructure.Entities.Stores;
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
                KeywordIds = searchRequest.KeywordIds,
                PageSize = searchRequest.PageSize,
                Offset = searchRequest.Offset
            };
        }

        public async Task<SearchResponse> GetSearchResultAsync(SearchRequest searchRequest)
        {
            var searchCriteria = ConvertToSearchCriteria(searchRequest);
            var storeWithKeywordsData = await _repository.GetSearchResult(searchCriteria);

            var stores = storeWithKeywordsData
                .GroupBy(x => x.StoreID)
                .Select(group => new StoreDTO
                {
                    Store = new StoreEntity
                    {
                        StoreID = group.Key,
                        Name = group.First().Name,
                        Latitude = group.First().Latitude,
                        Longitude = group.First().Longitude,
                    },
                    
                }).ToList();

            var response = new SearchResponse
            {
                Stores = stores,
                TotalStoresCount = stores.Count, 
                PageNumber = searchRequest.PageNumber,
                PageSize = searchRequest.PageSize,
                IsMatched = stores.Count > 0
            };
            return response;
        }
    }
}

