using Caffeing.Infrastructure.Entities;
using System.Threading.Tasks;
namespace Caffeing.Infrastructure.Test.IRepositories
{
    public interface ITestRepository
    {
        public Task<TestResponse> Get();
    }
}
