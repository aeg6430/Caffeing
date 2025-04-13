using Caffeing.Application.Contracts.Search;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/search")]
    [ApiController]
    //[Authorize]
    public class SearchController : ControllerBase
    {
        private readonly ILogger<SearchController> _logger;
        private readonly ISearchService _searchService;

        public SearchController(
            ILogger<SearchController> logger,
            ISearchService searchService
         )
        {
            _logger = logger;
            _searchService = searchService;
        }

        // POST api/search
        [HttpPost]
        public async Task<IActionResult> SearchStoresAsync([FromBody] SearchRequest searchRequest)
        {
            try
            {
                var result = await _searchService.GetSearchResultAsync(searchRequest);

                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Failed to get search result");
                return BadRequest("Internal server error");
            }
        }
    }
}
