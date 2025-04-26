import 'package:caffeing/models/request/favorite/store/favorite_store_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/repository/favorite/store/favorite_store_repository.dart';
import 'package:caffeing/view_model/favorite/store/favorite_store_result.dart';
import 'package:flutter/widgets.dart';

enum FavoriteStoreStatus {
  idle,
  dataAvailable,
  dataUnavailable,
  loading,
  error,
  tokenInvalid,
}

class FavoriteStoreViewModel extends ChangeNotifier {
  final FavoriteStoreRepository favoriteStoreRepository;

  bool _isInternetConnected = false;
  bool _isServerReachable = false;
  bool get isServerReachable => _isServerReachable;
  bool get isInternetConnected => _isInternetConnected;
  FavoriteStoreViewModel({required this.favoriteStoreRepository});

  FavoriteStoreStatus _status = FavoriteStoreStatus.idle;
  FavoriteStoreStatus get status => _status;
  List<StoreResponseModel> _storeList = [];
  List<StoreResponseModel> get storeList => _storeList;

  Future<FavoriteStoreResult> getFavoriteStores() async {
    try {
      _status = FavoriteStoreStatus.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      final result =
          await favoriteStoreRepository.getFavoriteStores()
              as List<StoreResponseModel>;

      if (result != null) {
        _storeList = result;
        _status = FavoriteStoreStatus.dataAvailable;
        notifyListeners();
        return FavoriteStoreResult(stores: result);
      } else {
        _status = FavoriteStoreStatus.dataUnavailable;
      }
      return FavoriteStoreResult(stores: storeList);
    } catch (error) {
      debugPrint('Error during get favorite stores: $error');
      _status = FavoriteStoreStatus.error;
      return FavoriteStoreResult();
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> add(FavoriteStoreRequestModel request) async {
    try {
      await favoriteStoreRepository.addFavoriteStore(request);
      _status = FavoriteStoreStatus.dataAvailable;
      await getFavoriteStores();
      notifyListeners();
    } catch (error) {
      debugPrint('Error during add favorite store: $error');
    }
  }

  Future<void> remove(FavoriteStoreRequestModel request) async {
    try {
      await favoriteStoreRepository.removeFavoriteStore(request);
      _storeList.removeWhere((store) => store.storeId == request.storeId);
      _status =
          _storeList.isEmpty
              ? FavoriteStoreStatus.dataUnavailable
              : FavoriteStoreStatus.dataAvailable;
      await getFavoriteStores();
      notifyListeners();
    } catch (error) {
      debugPrint('Error during remove favorite store: $error');
    }
  }
}
