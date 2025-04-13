using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Keywords
{
    public class KeywordResponseBase
    {
        public Guid KeywordID { get; set; }
        public string KeywordName { get; set; }
        public List<int> KeywordType { get; set; }
    }
    public class KeywordResponse : KeywordResponseBase
    {
        public List<int> KeywordType { get; set; }
    }
}
