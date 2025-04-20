using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;
using Microsoft.Extensions.Logging;
using Caffeing.Application.Auth;
using Caffeing.Domain.Enums;
using System.Text.Json;
namespace Caffeing.WebAPI.Controllers
{
    [Route("api/auth")]
    [ApiController]
    public class AuthController : ControllerBase
    {
        private readonly ILogger<AuthController> _logger;
        private readonly IAuthService _authService;

        public AuthController(
            ILogger<AuthController> logger,
            IAuthService authService
         )
        {
            _logger = logger;
            _authService = authService;
        }

        // POST: api/auth/login
        [HttpPost("login")]
        public async Task<IActionResult> Login([FromBody] ProviderLoginRequest request)
        {
            try
            {
                var userDto = await _authService.LoginWithProviderAsync(request);

                _logger.LogInformation("User successfully logged in with provider request: {@Request}", request);
                return Ok(userDto);
            }
            catch (Exception e)
            {
                _logger.LogError(e, "Login failed due to unexpected error.");
                return StatusCode(500, "Internal server error occurred while processing your request.");
            }
        }
    }
}
