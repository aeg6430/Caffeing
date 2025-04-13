import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/response/keyword/keyword_response_model.dart';

class KeywordRepository {
  final ApiService apiService;

  KeywordRepository({required this.apiService});

  Future<List<KeywordResponseModel>?> getKeywords() async {
    return await apiService.keywords();
  }

  Future<List<KeywordResponseModel>?> getKeywordsOptions() async {
    return await apiService.keywordsOptions();
  }
}
