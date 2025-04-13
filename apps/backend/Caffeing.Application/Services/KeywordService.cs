using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.Enums;
using Caffeing.Application.IServices.Caffeing.Application.Services;
using Caffeing.Infrastructure.Entities.Keywords;
using Caffeing.Infrastructure.IRepositories;
using Caffeing.Infrastructure.Repositories;

namespace Caffeing.Application.Services
{
    public class KeywordService : IKeywordService
    {
        private readonly IKeywordRepository _repository;

        public KeywordService(IKeywordRepository repository)
        {
            _repository = repository;
        }

        public async Task<IEnumerable<KeywordEntity>> GetKeywordsAsync()
        {
            return await _repository.GetKeywords();
        }


        /// <summary>
        /// Retrieves keyword data from the repository and maps it into a format suitable for UI consumption.
        /// The 'Type' field in the database is stored as a list of stringified enum integer values (e.g., ["1", "2"]).
        /// This method combines those values into a single [Flags] enum from the <see cref="Caffeing.Application.Enums.KeywordType"/> enum,
        /// and then splits the resulting enum into a list of human-readable flag names (e.g., ["StoreInfo", "Search"]).
        /// /// </summary>
        /// <returns>
        /// A list of <see cref="KeywordEntity"/> objects with only the 'Search' flag (if set) resolved to string names.
        /// </returns>
        public async Task<IEnumerable<KeywordEntity>> GetKeywordsOptionsAsync()
        {
            var entities = await _repository.GetKeywords();

            return entities
                .Where(e => e.KeywordType.Contains(2))
                .Select(e =>
            {
                var keywordTypeFlags = e.KeywordType; 

                // Convert int flags to the human-readable string names:
                var types = Enum.GetValues(typeof(KeywordType))
                    .Cast<KeywordType>()
                    .Where(flag => keywordTypeFlags.Contains((int)flag))
                    .Select(flag => flag.ToString()) 
                    .ToList();

                return new KeywordEntity
                {
                    KeywordID = e.KeywordID,
                    KeywordName = e.KeywordName,
                    KeywordType = keywordTypeFlags 
                };
            });
        }
    }
}

