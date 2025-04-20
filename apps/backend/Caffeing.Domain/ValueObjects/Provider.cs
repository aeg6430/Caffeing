using Caffeing.Domain.Enums;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Domain.ValueObjects
{
    public readonly struct Provider : IEquatable<Provider>
    {
        public ProviderType Value { get; }

        public Provider(ProviderType value)
        {
            Value = value;
        }

        public static implicit operator ProviderType(Provider provider) => provider.Value;
        public override string ToString() => Value.ToString();

        public bool Equals(Provider other) => Value == other.Value;
        public override bool Equals(object? obj) => obj is Provider other && Equals(other);
        public override int GetHashCode() => Value.GetHashCode();
    }
}
