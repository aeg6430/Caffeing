using Caffeing.Application.Dtos;


namespace Caffeing.Application.IServices
{
    namespace Caffeing.Application.Services
    {
        public interface IKeywordService
        {
            Task<IEnumerable<KeywordDto>> GetKeywordsAsync();
            Task<IEnumerable<KeywordDto>> GetKeywordsOptionsAsync();
        }
    }
}
