import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/favorite/store/favorite_store_request_model.dart';

class FavoriteStoreRepository {
  final ApiService apiService;

  FavoriteStoreRepository({required this.apiService});

  Future<List<dynamic>> getFavoriteStores() async {
    return await apiService.getFavoriteStores();
  }

  Future<void> addFavoriteStore(FavoriteStoreRequestModel request) async {
    return await apiService.addFavoriteStore(request);
  }

  Future<void> removeFavoriteStore(FavoriteStoreRequestModel request) async {
    return await apiService.removeFavoriteStore(request);
  }
}
