using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.IRepositories;

namespace Caffeing.Application.Services
{
    public class TestService : ITestService
    {
        private readonly ITestRepository _repository;

        public TestService(ITestRepository repository)
        {
            _repository = repository;
        }

        public async Task<TestResponse> GetDataAsync()
        {
            return await _repository.Get();
        }
    }
}

