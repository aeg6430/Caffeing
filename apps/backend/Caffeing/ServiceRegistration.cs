using Caffeing.Application.Auth;
using Caffeing.Application.IServices;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Application.Services;
using Caffeing.Infrastructure.Contexts;
using Caffeing.Infrastructure.IRepositories;
using Caffeing.Infrastructure.Repositories;
using Microsoft.Extensions.DependencyInjection;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.WebAPI
{
    public static class ServiceRegistration
    {
        public static void AddServices(this IServiceCollection services)
        {
            services.AddScoped<ICurrentUserService, CurrentUserService>();
            services.AddScoped<DapperContext>();

            services.AddScoped<ITestRepository, TestRepository>();
            services.AddScoped<ITestService, TestService>();

            services.AddScoped<ISearchRepository, SearchRepository>();
            services.AddScoped<ISearchService, SearchService>();

            services.AddScoped<IKeywordRepository, KeywordRepository>();
            services.AddScoped<IKeywordService, KeywordService>();

            services.AddScoped<IStoreRepository, StoreRepository>();
            services.AddScoped<IStoreService, StoreService>();

            services.AddScoped<IUserRepository, UserRepository>();
            services.AddScoped<IAuthService, AuthService>();

            services.AddScoped<IFavoriteStoreRepository, FavoriteStoreRepository>();
            services.AddScoped<IFavoriteStoreService, FavoriteStoreService>();
        }
    }
}
