using Caffeing.Infrastructure.Entities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Test.IServices
{
    namespace Caffeing.Application.Test.Services
    {
        public interface ITestService
        {
            Task<TestResponse> GetDataAsync();
        }
    }

}
