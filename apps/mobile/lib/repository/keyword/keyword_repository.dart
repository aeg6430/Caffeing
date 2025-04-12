import 'package:caffeing/data/network/api_service.dart';

class KeywordRepository {
  final ApiService apiService;

  KeywordRepository({required this.apiService});

  Future<dynamic> getKeywords() async {
    return await apiService.keywords();
  }
}
