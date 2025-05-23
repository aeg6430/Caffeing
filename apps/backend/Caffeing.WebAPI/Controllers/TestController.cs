using Caffeing.Application.IServices.Caffeing.Application.Services;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/test")]
    [ApiController]
    [Authorize]
    public class TestController : ControllerBase
    {
        private readonly ILogger<TestController> _logger;

        public TestController(
            ILogger<TestController> logger
         )
        {
            _logger = logger;
        }

        // GET api/test
        [HttpGet]
        public async Task<IActionResult> GetData()
        {
            try
            {
                return Ok();
            }
            catch (Exception e)
            {
                return BadRequest("Internal server error");
            }
        }
    }
}
