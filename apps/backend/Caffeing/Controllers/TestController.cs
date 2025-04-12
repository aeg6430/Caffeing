using Caffeing.Application.IServices.Caffeing.Application.Services;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/test")]
    [ApiController]
    //[Authorize]
    public class TestController : ControllerBase
    {
        private readonly ILogger<TestController> _logger;
        private readonly ITestService _testService;

        public TestController(
            ILogger<TestController> logger,
            ITestService testService
         )
        {
            _logger = logger;
            _testService = testService;
        }

        // GET api/test
        [HttpGet]
        public async Task<IActionResult> GetData()
        {
            try
            {
                var result = await _testService.GetDataAsync();

                if (result == null)
                {
                    return NotFound();
                }

                return Ok(result);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Failed to get test result");
                return BadRequest("Internal server error");
            }
        }
    }
}
