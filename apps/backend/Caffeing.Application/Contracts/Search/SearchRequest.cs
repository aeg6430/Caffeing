using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Contracts.Search
{
    public class SearchRequest
    {
        public string? Query { get; set; }
        public Guid[] ?KeywordIds { get; set; }
        public int ?PageNumber { get; set; } 
        public int ?PageSize { get; set; }
    }
}
