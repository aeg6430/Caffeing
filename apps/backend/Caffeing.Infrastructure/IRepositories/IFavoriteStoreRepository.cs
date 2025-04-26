using Caffeing.Infrastructure.Entities.FavoriteStores;
using Caffeing.Infrastructure.Entities.UserFavoriteStores;
using Caffeing.Infrastructure.Entities.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface IFavoriteStoreRepository
    {
        Task AddFavoriteStoreAsync(FavoriteStoreCriteria favoriteStoreCriteria);
        Task<IEnumerable<FavoriteStoreEntity>> GetStoreIdsAsync(Guid userId);
        Task RemoveFavoriteStoreAsync(FavoriteStoreCriteria favoriteStoreCriteria);
    }
}
