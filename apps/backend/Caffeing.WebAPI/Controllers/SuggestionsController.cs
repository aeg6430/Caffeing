using Caffeing.IntakeService;
using Microsoft.AspNetCore.Http;
using Microsoft.AspNetCore.Mvc;

namespace Caffeing.WebAPI.Controllers
{
    [ApiController]
    [Route("suggestions")]
    public class SuggestionsController : ControllerBase
    {
        private readonly IntakeHandler _intakeHandler;

        public SuggestionsController(IntakeHandler intakeHandler)
        {
            _intakeHandler = intakeHandler;
        }

        [HttpPost("submit")]
        public async Task<IActionResult> SubmitSuggestion([FromBody] SuggestionRequest request)
        {

            var success = await _intakeHandler.HandleAsync(request);

            if (success)
            {
                return Ok(new { message = "Suggestion has been successfully submitted." });
            }

            return BadRequest(new { message = "There was an error submitting the suggestion. Please try again later." });
        }
    }
}
