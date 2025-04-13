using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Contracts.Search
{
    public class SearchRequest
    {
        public string Query { get; set; }
        public Guid[] KeywordIds { get; set; }
        public Guid StoreID { get; set; }
        public int Offset { set; get; } = 0;
        public int PageNumber { get; set; } = 1;
        public int PageSize { get; set; } = 10;
        public string ? SortBy { get; set; }
        public bool SortDescending { get; set; } = false;
    }
}
