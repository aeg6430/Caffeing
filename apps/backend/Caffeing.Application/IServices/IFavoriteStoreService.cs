using Caffeing.Application.Contracts.FavoriteStores;
using Caffeing.Application.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.IServices
{
    public interface IFavoriteStoreService
    {
         Task AddAsync(AddFavoriteStoreRequest addFavoriteStoreRequest);
         Task<IEnumerable<StoreDto>> GetFavoriteStoresAsync(); 
         Task RemoveAsync(RemoveFavoriteStoreRequest request);
    }
}
