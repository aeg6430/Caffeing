using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.Dtos
{
    public class KeywordDto
    {
        public string KeywordId { get; set; }
        public string KeywordName { get; set; }
        public List<string> KeywordType { get; set; }
    }
}
