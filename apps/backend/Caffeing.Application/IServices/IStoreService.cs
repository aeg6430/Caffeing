using Caffeing.Application.Contracts.Stores;
using Caffeing.Application.Dtos;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.IServices
{
    namespace Caffeing.Application.Services
    {

        public interface IStoreService
        {
            Task<IEnumerable<StoreDto>> GetAllAsync();
            Task<StoreDto> GetByRequestAsync(StoreRequest storeRequest);
        }
    }
}
