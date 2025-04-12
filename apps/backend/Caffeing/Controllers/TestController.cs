using Caffeing.Application.Test.IServices.Caffeing.Application.Test.Services;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [Route("api/test")]
    [ApiController]
    //[Authorize]
    public class TestController : ControllerBase
    {
        private readonly ITestService _testService;

        public TestController(ITestService testService)
        {
            _testService = testService;
        }

        // GET api/test
        [HttpGet]
        public async Task<IActionResult> GetData()
        {
            try
            {
                var response = await _testService.GetDataAsync();

                return Ok(response);

            }
            catch (Exception e)
            {

                return BadRequest(e.Message);
            }
        }
    }
}
