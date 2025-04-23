using Caffeing.Domain.Enums;
using Caffeing.Domain.Models;
using Caffeing.Domain.ValueObjects;
using Caffeing.Infrastructure.Entities.Users;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.IRepositories
{
    public interface IUserRepository
    {
        Task CreateAsync(UserEntity user, IDbConnection connection, IDbTransaction transaction);
        Task<UserEntity?> GetByProviderAsync(string provider, string providerId);
    }
}
