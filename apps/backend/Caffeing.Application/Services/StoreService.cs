using Caffeing.Application.Contracts.Search;
using Caffeing.Application.Contracts.Stores;
using Caffeing.Application.Dtos;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities.Search;
using Caffeing.Infrastructure.Entities.Stores;
using Caffeing.Infrastructure.IRepositories;
using static Dapper.SqlMapper;


namespace Caffeing.Application.Services
{
    public  class StoreService :  IStoreService
    {
        private readonly IStoreRepository _repository;

        public StoreService(IStoreRepository repository)
        {
            _repository = repository;
        }
        private StoreCriteria ConvertToStoreCriteria(StoreRequest storeRequest)
        {
            return new StoreCriteria
            {
                StoreId = Guid.Parse(storeRequest.StoreId)
            };
        }
        public async  Task<StoreResponse> GetStoreResultAsync(StoreRequest storeRequest)
        {
            var storeCriteria = ConvertToStoreCriteria(storeRequest);
            var entity = await _repository.GetStoreResult(storeCriteria);


            var dto = new StoreDto
            {
                StoreId = entity.StoreId,
                Name = entity.Name,
                Latitude = entity.Latitude,
                Longitude = entity.Longitude,
                Address = entity.Address,
                ContactNumber = entity.ContactNumber,
                BusinessHours = entity.BusinessHours
            };

            return new StoreResponse
            {
                Store = dto
            };
        }
    }
}
