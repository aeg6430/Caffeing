using Microsoft.Extensions.Options;
using Caffeing.WebAPI;
using Caffeing.Infrastructure;
using Caffeing.Application.Jwt;
using FirebaseAdmin;
using Google.Apis.Auth.OAuth2;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;
using System.Text;

public class Startup
{
    private readonly IConfiguration _configuration;

    public Startup(IConfiguration configuration)
    {
        _configuration = configuration;
    }

    public void ConfigureServices(IServiceCollection services)
    {
        services.AddFirebase(_configuration);
        services.AddIntakeService(_configuration);
        services.AddHttpClient();
        services.AddHttpContextAccessor();
        var jwtConfig = _configuration.GetSection("Jwt").Get<JwtConfig>();
        services.AddSingleton(jwtConfig);
        services.AddScoped<IJwtTokenService, JwtTokenGenerator>();
        var key = Encoding.UTF8.GetBytes(jwtConfig.Key);

        services.AddAuthentication(options =>
        {
            options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
            options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
        })
        .AddJwtBearer(options =>
        {
            options.TokenValidationParameters = new TokenValidationParameters
            {
                ValidateIssuer = true,
                ValidateAudience = true,
                ValidateLifetime = true,
                ValidateIssuerSigningKey = true,

                ValidIssuer = jwtConfig.Issuer,
                ValidAudience = jwtConfig.Audience,
                IssuerSigningKey = new SymmetricSecurityKey(key)
            };
        });

        


        services.Configure<DatabaseSettings>(_configuration.GetSection("Database"));
        services.AddSingleton(sp => sp.GetRequiredService<IOptions<DatabaseSettings>>().Value);
        services.AddScoped<TransactionContext>();
        services.AddServices();
        services.AddControllers();
        services.AddEndpointsApiExplorer();
        services.AddSwaggerGen();
        var corsSettings = _configuration.GetSection("Cors");
        services.AddCors(options =>
        {
            options.AddPolicy("CorsPolicy", builder =>
            {
                builder.WithOrigins(corsSettings.GetSection("AllowedOrigins").Get<string[]>())
                       .WithMethods(corsSettings.GetSection("AllowedMethods").Get<string[]>())
                       .WithHeaders(corsSettings.GetSection("AllowedHeaders").Get<string[]>());
            });
        });
    }

    public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
    {
        if (env.IsDevelopment())
        {
            app.UseSwagger();
            app.UseSwaggerUI();
        }
        app.UseCors("CorsPolicy");
        app.UseHttpsRedirection();
        app.UseRouting();

        app.UseAuthentication();
        app.UseAuthorization();

        app.UseEndpoints(endpoints =>
        {
            endpoints.MapControllers();
        });
    }
}