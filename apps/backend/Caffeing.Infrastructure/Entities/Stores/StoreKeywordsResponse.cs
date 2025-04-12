using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Stores
{
    public class StoreKeywordsResponse
    {
        public Guid StoreID { get; set; }
        public List<String> StoreKeywords { get; set; }
    }
}
