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
        Task<StoreEntity> GetStoreResult(StoreCriteria storeCriteria);
    }
}
