using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.FavoriteStores
{
    public class FavoriteStoreCriteria
    {
        public Guid UserId { get; set; }
        public Guid StoreId { get; set; }
    }
}
