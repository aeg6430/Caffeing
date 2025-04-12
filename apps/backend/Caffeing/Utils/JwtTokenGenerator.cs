using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace Caffeing.WebAPI.Utils
{
    public class JwtTokenGenerator
    {
        private readonly IConfiguration _configuration;

        public JwtTokenGenerator(IConfiguration configuration)
        {
            _configuration = configuration;
        }

        public string GenerateJwtToken(string userId)
        {
            var symmetricSecurityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_configuration["Jwt:Key"]));
            var signingCredentials = new SigningCredentials(symmetricSecurityKey, SecurityAlgorithms.HmacSha256);

            var claims = new[]
            {
            new Claim(ClaimTypes.NameIdentifier, userId),
            new Claim(JwtRegisteredClaimNames.Sub, userId),
            new Claim(JwtRegisteredClaimNames.Jti, Guid.NewGuid().ToString())
        };

            var expirationTimeInMinutes = int.Parse(_configuration["Jwt:ExpiresInMinutes"]);

            var jwtSecurityToken = new JwtSecurityToken(
                issuer: _configuration["Jwt:Issuer"],
                audience: _configuration["Jwt:Audience"],
                claims: claims,
                expires: DateTime.Now.AddMinutes(expirationTimeInMinutes),
                signingCredentials: signingCredentials
            );

            var tokenHandler = new JwtSecurityTokenHandler();
            return tokenHandler.WriteToken(jwtSecurityToken);
        }
    }
}
