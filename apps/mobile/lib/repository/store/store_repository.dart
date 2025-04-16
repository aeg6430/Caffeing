import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/store/store_request_model.dart';

class StoreRepository {
  final ApiService apiService;

  StoreRepository({required this.apiService});

  Future<dynamic> getStore(StoreRequestModel store) async {
    return await apiService.getStore(store);
  }
}
