using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.IRepositories;

namespace Caffeing.Application.Services
{
    public class KeywordService : IKeywordService
    {
        private readonly IKeywordRepository _repository;

        public KeywordService(IKeywordRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<KeywordResponse>> GetKeywordsAsync()
        {
            return await _repository.GetKeywords();
        }
    }
}

