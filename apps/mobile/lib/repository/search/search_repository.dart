import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/search/search_request_model.dart';

class SearchRepository {
  final ApiService apiService;

  SearchRepository({required this.apiService});

  Future<dynamic> search(SearchRequestModel search) async {
    return await apiService.search(search);
  }
}
