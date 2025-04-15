using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using Caffeing.Application.Dtos;
using Caffeing.Application.Enums;
using Caffeing.Application.IServices.Caffeing.Application.Services;
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

        public async Task<IEnumerable<KeywordDto>> GetKeywordsAsync()
        {
            var entities = await _repository.GetKeywords();

            return entities
                .Select(e =>
                {
                    var enumValue = ParseKeywordType(e.KeywordType);

                    return new
                    {
                        e.KeywordId,
                        e.KeywordName,
                        EnumValue = enumValue,
                        TypeNames = ConvertKeywordTypeToNames(enumValue)
                    };
                })
                .Select(x => new KeywordDto
                {
                    KeywordId = x.KeywordId,
                    KeywordName = x.KeywordName,
                    KeywordType = x.TypeNames
                });
        }


        /// <summary>
        /// Retrieves keyword data from the repository using a single query and maps it into a format suitable for UI consumption.
        /// The 'KeywordType' field in the database is stored as a comma-separated string of enum flag values (e.g., "1,2").
        /// This method parses those values into a combined [Flags] enum of <see cref="Caffeing.Application.Enums.KeywordType"/>,
        /// then extracts and resolves each set flag into its corresponding human-readable name (e.g., "StoreInfo", "Search").
        /// Only keywords that include the 'Search' flag will be returned.
        /// </summary>
        /// <returns>
        /// A list of <see cref="KeywordDto"/> objects with the 'KeywordType' field containing readable flag names.
        /// </returns>

        public async Task<IEnumerable<KeywordDto>> GetKeywordsOptionsAsync()
        {
            var entities = await _repository.GetKeywords();

            return entities
                .Select(e =>
                {
                    var enumValue = ParseKeywordType(e.KeywordType);

                    return new
                    {
                        e.KeywordId,
                        e.KeywordName,
                        EnumValue = enumValue,
                        TypeNames = ConvertKeywordTypeToNames(enumValue)
                    };
                })
                .Where(x => x.EnumValue.HasFlag(KeywordType.Search)) 
                .Select(x => new KeywordDto
                {
                    KeywordId = x.KeywordId,
                    KeywordName = x.KeywordName,
                    KeywordType = x.TypeNames
                });
        }

        private KeywordType ParseKeywordType(string keywordTypeFlags)
        {
            if (string.IsNullOrWhiteSpace(keywordTypeFlags))
                return KeywordType.None;

            var flagValue = keywordTypeFlags
                .Split(',', StringSplitOptions.RemoveEmptyEntries)
                .Select(int.Parse)
                .Aggregate(0, (acc, val) => acc | val);

            return (KeywordType)flagValue;
        }

        private List<string> ConvertKeywordTypeToNames(KeywordType enumValue)
        {
            return Enum.GetValues(typeof(KeywordType))
                .Cast<KeywordType>()
                .Where(flag => enumValue.HasFlag(flag) && flag != KeywordType.None)
                .Select(flag => flag.ToString())
                .ToList();
        }
    }
}

