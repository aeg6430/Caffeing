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
        /// Retrieves keyword data from the repository using a single query and maps it into a format suitable for UI consumption.
        /// The 'KeywordType' field in the database is stored as a comma-separated string of enum flag values (e.g., "1,2").
        /// This method parses those values into a combined [Flags] enum of <see cref="Caffeing.Application.Enums.KeywordType"/>,
        /// then extracts and resolves each set flag into its corresponding human-readable name (e.g., "StoreInfo", "Search").
        /// Only keywords that include the 'Search' flag will be returned.
        /// </summary>
        /// <returns>
        /// A list of <see cref="KeywordEntity"/> objects with the 'KeywordType' field containing readable flag names.
        /// </returns>

        public async Task<IEnumerable<KeywordEntity>> GetKeywordsOptionsAsync()
        {
            var entities = await _repository.GetKeywords();

            return entities
                .Where(e => e.KeywordType.Split(',').Contains("2")) 
                .Select(e =>
                {
                    var keywordTypeFlags = e.KeywordType;

                    var flagValue = keywordTypeFlags
                        .Split(',', StringSplitOptions.RemoveEmptyEntries)
                        .Select(int.Parse)
                        .Aggregate(0, (acc, val) => acc | val); 

                    var enumValue = (KeywordType)flagValue;

                    var types = Enum.GetValues(typeof(KeywordType))
                        .Cast<KeywordType>()
                        .Where(flag => enumValue.HasFlag(flag))
                        .Select(flag => flag.ToString())
                        .ToList();

                    return new KeywordEntity
                    {
                        KeywordId = e.KeywordId,
                        KeywordName = e.KeywordName,
                        KeywordType = string.Join(", ", types) 
                    };
                });
        }
    }
}

