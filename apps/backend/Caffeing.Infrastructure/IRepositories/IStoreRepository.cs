using Caffeing.Infrastructure.Entities.Stores;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface IStoreRepository
    {
        Task<IEnumerable<StoreEntity>> GetAllAsync();
        Task<StoreEntity> GetByRequestAsync(StoreCriteria storeCriteria);
        Task<IEnumerable<StoreEntity>> GetByIdsAsync(IEnumerable<Guid> storeIds);
    }
}
