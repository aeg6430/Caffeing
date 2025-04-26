using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Contracts.FavoriteStores
{
    public class AddFavoriteStoreRequest
    {
        [Required]
        public Guid StoreId { get; set; }
    }
}
