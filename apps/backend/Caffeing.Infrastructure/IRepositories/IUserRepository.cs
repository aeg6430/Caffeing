using Caffeing.Domain.Models;
using Caffeing.Infrastructure.Entities.Users;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface IUserRepository
    {
        Task CreateAsync(User user);
        Task<User?> GetByProviderAsync(string provider, string providerId);
    }
}
