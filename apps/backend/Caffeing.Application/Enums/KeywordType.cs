using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Enums
{
    [Flags]
    public enum KeywordType
    {
        None = 0,
        StoreInfo = 1,
        Search = 2
    }
}
