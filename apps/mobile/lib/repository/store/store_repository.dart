import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/store/store_request_model.dart';

class StoreRepository {
  final ApiService apiService;

  StoreRepository({required this.apiService});

  Future<dynamic> getAllStore() async {
    return await apiService.getAllStore();
  }

  Future<dynamic> getStoreByRequest(StoreRequestModel store) async {
    return await apiService.getStoreByRequest(store);
  }
}
