using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.Test.IServices.Caffeing.Application.Test.Services;
using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Test.IRepositories;

namespace Caffeing.Application.Test.Services
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

