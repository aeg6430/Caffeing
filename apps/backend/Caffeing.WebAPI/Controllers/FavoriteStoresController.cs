using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using Caffeing.Application.IServices;
using System.Threading.Tasks;
using Caffeing.Application.Contracts.FavoriteStores;
using System.ComponentModel.DataAnnotations;
using Microsoft.AspNetCore.Mvc.ModelBinding;

namespace Caffeing.WebAPI.Controllers
{
    [ApiController]
    [Route("favorites/stores")]
    [Authorize] 
    public class FavoriteStoresController : ControllerBase
    {
        private readonly IFavoriteStoreService _favoriteStoreService;

        public FavoriteStoresController(IFavoriteStoreService favoriteStoreService)
        {
            _favoriteStoreService = favoriteStoreService;
        }

        /// <summary>
        /// Get current user's favorite stores
        /// </summary>
        [HttpGet]
        public async Task<IActionResult> GetFavorites()
        {
            var stores = await _favoriteStoreService.GetFavoriteStoresAsync();
            return Ok(stores);
        }

        /// <summary>
        /// Add a store to favorites
        /// </summary>
        [HttpPost]
        public async Task<IActionResult> AddFavorite([FromQuery] AddFavoriteStoreRequest request)
        {
            if (!Guid.TryParse(request.StoreId.ToString(), out var storeId))
            {
                return BadRequest("Invalid Store ID.");
            }
            await _favoriteStoreService.AddAsync(request);
            return Ok(new { message = "Store added to favorites." });
        }

        /// <summary>
        /// Remove a store from favorites
        /// </summary>
        [HttpDelete]
        public async Task<IActionResult> RemoveFavorite([FromQuery ] RemoveFavoriteStoreRequest request)
        {
            if (!Guid.TryParse(request.StoreId.ToString(), out var storeId))
            {
                return BadRequest("Invalid Store ID.");
            }
            await _favoriteStoreService.RemoveAsync(request);
            return Ok(new { message = "Store removed from favorites." });
        }
    }
}
