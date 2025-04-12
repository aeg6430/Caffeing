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
            services.AddScoped<DapperContext>();
            services.AddScoped<ITestRepository, TestRepository>();
            services.AddScoped<ITestService, TestService>();       
        }
    }
}
