using Caffeing.Domain.ValueObjects;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Domain.Models
{
    public class User
    {
        public UserId Id { get; }
        public Provider Provider { get; }
        public ProviderId ProviderId { get; }
        public Email? Email { get; }
        public UserName? Name { get; }
        public UserRole Role { get; }
        public DateTime CreatedTime { get; }
        public DateTime ModifiedTime { get; }

        public User(
            UserId id,
            Provider provider,
            ProviderId providerId,
            Email? email,
            UserName? name,
            UserRole role,
            DateTime createdTime,
            DateTime modifiedTime
         )
        {
            Id = id;
            Provider = provider;
            ProviderId = providerId;
            Email = email;
            Name = name;
            Role = role;
            CreatedTime = createdTime;
            ModifiedTime = modifiedTime;
        }
    }
}
