using Caffeing.Application.Contracts.FavoriteStores;
using Caffeing.Application.Dtos;
using Caffeing.Application.IServices;
using Caffeing.Infrastructure.Entities.FavoriteStores;
using Caffeing.Infrastructure.IRepositories;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Visus.Cuid;

namespace Caffeing.Application.Services
{
    public class FavoriteStoreService : IFavoriteStoreService
    {
        private readonly ICurrentUserService _currentUser;
        private readonly IFavoriteStoreRepository _favoriteStoreRepository;
        private readonly IStoreRepository _storeRepository; 
        public FavoriteStoreService(
            ICurrentUserService currentUser,
            IFavoriteStoreRepository favoriteStoreRepository,
            IStoreRepository storeRepository
         )
        {
            _currentUser = currentUser;
            _favoriteStoreRepository = favoriteStoreRepository;
            _storeRepository = storeRepository;
        }

        public async Task AddAsync(AddFavoriteStoreRequest addFavoriteStoreRequest)
        {
            var request = new FavoriteStoreCriteria
            {
                UserId = _currentUser.UserId.ToString(),
                StoreId = addFavoriteStoreRequest.StoreId.ToString()            
            };
             await _favoriteStoreRepository.AddFavoriteStoreAsync(request);
        }

        public async Task<IEnumerable<StoreDto>> GetFavoriteStoresAsync()
        {

            var favoriteStoreEntities = await _favoriteStoreRepository.GetStoreIdsAsync(_currentUser.UserId.ToString());
            var storeIds = favoriteStoreEntities.Select(favoriteStore => favoriteStore.StoreId).ToList();
            var storeEntities = await _storeRepository.GetByIdsAsync(storeIds);
            var result = storeEntities.Select(storeEntity => new StoreDto
            {
                StoreId = Guid.Parse(storeEntity.StoreId),
                Name = storeEntity.Name,
                Latitude = storeEntity.Latitude,
                Longitude = storeEntity.Longitude,
                Address = storeEntity.Address,
                ContactNumber = storeEntity.ContactNumber,
                BusinessHours = storeEntity.BusinessHours,
                Keywords = storeEntity.Keywords.Select(k => new KeywordDto
                {
                    KeywordId = Guid.Parse(k.KeywordId),
                    KeywordName = k.KeywordName,
                    KeywordType = k.KeywordType.Split(',').ToList()
                }).ToList()
            });

            return result;
        }

        public async Task RemoveAsync(RemoveFavoriteStoreRequest removeFavoriteStoreRequest)
        {
            var request = new FavoriteStoreCriteria
            {
                UserId = _currentUser.UserId.ToString(),
                StoreId = removeFavoriteStoreRequest.StoreId.ToString(),
            };
            await _favoriteStoreRepository.RemoveFavoriteStoreAsync(request);
        }
    }
}
