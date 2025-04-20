using Caffeing.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Domain.ValueObjects
{
    public readonly struct UserRole
    {
        public UserRoleType Value { get; }

        public UserRole(UserRoleType value)
        {
            Value = value;
        }

        public static implicit operator UserRoleType(UserRole role) => role.Value;
        public override string ToString() => Value.ToString();
    }
}
