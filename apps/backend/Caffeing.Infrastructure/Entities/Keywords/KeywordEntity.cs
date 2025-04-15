using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Keywords
{
    public class KeywordEntityBase
    {
        public Guid KeywordId { get; set; }
        public string KeywordName { get; set; }
        public List<int> KeywordType { get; set; }
    }
    public class KeywordEntity :  KeywordEntityBase
    {
        public List<int> KeywordType { get; set; }
    }
}
