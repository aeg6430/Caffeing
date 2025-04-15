using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Infrastructure.Entities.Keywords
{
    public class KeywordEntity
    {
        public Guid KeywordId { get; set; }
        public string KeywordName { get; set; }
        public string KeywordType { get; set; }
    }
}
