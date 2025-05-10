using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Search
{
    public class SearchCriteria
    {
        public string ?Query { get; set; }
        public string[] ?KeywordIds { get; set; }
        public int PageNumber { get; set; }
        public int PageSize { get; set; }
        public int Offset { get; set; } 
        

        // TODO: Implement sorting logic for this property
        //public string? SortBy { get; set; }

        // TODO: Implement sorting direction for this property (true = descending)
        //public bool SortDescending { get; set; } 
    }
}

