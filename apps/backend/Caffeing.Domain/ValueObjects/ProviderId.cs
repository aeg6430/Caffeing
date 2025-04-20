using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Domain.ValueObjects
{
    public readonly struct ProviderId
    {
        public string Value { get; }

        public ProviderId(string value)
        {
            if (string.IsNullOrWhiteSpace(value))
                throw new ArgumentException("ProviderId cannot be null or empty.");

            Value = value;
        }

        public static implicit operator string(ProviderId id) => id.Value;
        public override string ToString() => Value;
    }
}
