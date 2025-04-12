using Caffeing.Infrastructure.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.IServices
{
    namespace Caffeing.Application.Services
    {
        public interface ITestService
        {
            Task<TestResponse> GetDataAsync();
        }
    }

}
