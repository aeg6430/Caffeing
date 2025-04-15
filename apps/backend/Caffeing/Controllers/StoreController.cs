using Caffeing.Application.Contracts.Stores;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/stores")]
    [ApiController]
    //[Authorize]
    public class StoreController : ControllerBase
    {
        private readonly ILogger<StoreController> _logger;
        private readonly IStoreService _storeService;

        public StoreController(
            ILogger<StoreController> logger,
            IStoreService storeService
         )
        {
            _logger = logger;
            _storeService = storeService;
        }

        // GET api/stores/{id}
        [HttpGet]
        public async Task<IActionResult> SearchStoresAsync([FromQuery] StoreRequest storeRequest)
        {
            try
            {
                if (!Guid.TryParse(storeRequest.StoreId, out Guid parsedStoreId))
                {
                    return BadRequest("Invalid StoreId format.");
                }

                storeRequest.StoreId = parsedStoreId.ToString();

                var result = await _storeService.GetStoreResultAsync(storeRequest);

                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Failed to get store result");
                return BadRequest("Internal server error");
            }
        }
    }
}
