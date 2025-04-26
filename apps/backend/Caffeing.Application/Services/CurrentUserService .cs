using Caffeing.Application.IServices;
using Microsoft.AspNetCore.Http;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Services
{
    public class CurrentUserService : ICurrentUserService
    {
        private readonly IHttpContextAccessor _httpContextAccessor;

        public Guid UserId { get; }

        public CurrentUserService(
            IHttpContextAccessor httpContextAccessor
         )
        {
            _httpContextAccessor = httpContextAccessor;

            var userIdClaim = _httpContextAccessor.HttpContext?.User?.FindFirst(ClaimTypes.NameIdentifier)?.Value;

            if (string.IsNullOrEmpty(userIdClaim))
            {
                throw new UnauthorizedAccessException("User ID claim is missing in the token.");
            }

            UserId = Guid.Parse(userIdClaim);
        }
    }
}
