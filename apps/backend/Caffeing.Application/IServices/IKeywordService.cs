using Caffeing.Infrastructure.Entities;
using Caffeing.Infrastructure.Entities.Keywords;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Caffeing.Application.IServices
{
    namespace Caffeing.Application.Services
    {
        public interface IKeywordService
        {
            Task<IEnumerable<KeywordEntity>> GetKeywordsAsync();
            Task<IEnumerable<KeywordEntity>> GetKeywordsOptionsAsync();
        }
    }
}
