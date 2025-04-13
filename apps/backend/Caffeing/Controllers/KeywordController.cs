using Caffeing.Application.IServices.Caffeing.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/keywords")]
    [ApiController]
    //[Authorize]
    public class KeywordController : ControllerBase
    {
        private readonly ILogger<KeywordController> _logger;
        private readonly IKeywordService _keywordService;

        public KeywordController(
            ILogger<KeywordController> logger,
            IKeywordService keywordService
         )
        {
            _logger = logger;
            _keywordService = keywordService;
        }

        // GET api/keywords
        [HttpGet]
        public async Task<IActionResult> GetKeywordsAsync()
        {
            try
            {
                var result = await _keywordService.GetKeywordsAsync();

                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Failed to get keywords result");
                return BadRequest("Internal server error");
            }
        }

        // GET api/keywords/options
        [HttpGet("options")]
        public async Task<IActionResult> GetKeywordsOptionsAsync()
        {
            try
            {
                var result = await _keywordService.GetKeywordsOptionsAsync();

                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Failed to get keywords options result");
                return BadRequest("Internal server error");
            }
        }
    }
}
