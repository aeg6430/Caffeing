using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Search
{
    public class SearchCriteria
    {
        public string Query { get; set; }
        public Guid[] KeywordIds { get; set; }
        public int PageSize { get; set; }
        public int Offset { get; set; }
    }
}

