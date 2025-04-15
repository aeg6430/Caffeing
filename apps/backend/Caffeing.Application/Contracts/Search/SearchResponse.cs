using Caffeing.Application.Dtos;
using Caffeing.Infrastructure.Entities.Stores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Contracts.Search
{
    public class SearchResponse
    {
        public List<SearchDto> Stores { get; set; }
        public bool IsMatched { get; set; }
        public int TotalStoresCount { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
    }
}
