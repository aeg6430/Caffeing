using Caffeing.Infrastructure.Entities;
using System.Threading.Tasks;
namespace Caffeing.Infrastructure.IRepositories
{
    public interface ITestRepository
    {
        public Task<TestResponse> Get();
    }
}
