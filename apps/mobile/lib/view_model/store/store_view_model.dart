import 'package:caffeing/data/network/network_utils.dart';
import 'package:caffeing/models/request/store/store_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/repository/store/store_repository.dart';
import 'package:caffeing/view_model/store/store_list_result.dart';
import 'package:caffeing/view_model/store/store_result.dart';
import 'package:flutter/widgets.dart';

enum StoreStatus {
  idle,
  dataAvailable,
  dataUnavailable,
  loading,
  error,
  tokenInvalid,
}

class StoreViewModel extends ChangeNotifier {
  final StoreRepository storeRepository;

  bool _isInternetConnected = false;
  bool _isServerReachable = false;
  bool get isServerReachable => _isServerReachable;
  bool get isInternetConnected => _isInternetConnected;

  StoreViewModel({required this.storeRepository});

  StoreStatus _status = StoreStatus.idle;
  StoreStatus get status => _status;

  List<StoreResponseModel> _storeList = [];
  List<StoreResponseModel> get storeList => _storeList;

  List<StoreResponseModel> _mapStoreList = [];
  List<StoreResponseModel> get mapStoreList => _mapStoreList;

  StoreResponseModel? _storeByRequestData;
  StoreResponseModel? get storeByRequestData => _storeByRequestData;

  Future<StoreListResult> getAllStore() async {
    try {
      _status = StoreStatus.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
      final result =
          await storeRepository.getAllStore() as List<StoreResponseModel>;

      if (result != null) {
        _storeList = result;
        _mapStoreList = List.from(result);
        _status = StoreStatus.dataAvailable;
        notifyListeners();
        return StoreListResult(stores: result);
      } else {
        _status = StoreStatus.dataUnavailable;
      }
      return StoreListResult(stores: storeList);
    } catch (error) {
      debugPrint('Error during get all store: $error');
      _status = StoreStatus.error;
      return StoreListResult();
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<StoreResult> getStoreByRequest(StoreRequestModel storeRequest) async {
    try {
      _status = StoreStatus.loading;
      notifyListeners();

      _isInternetConnected = await NetworkUtils.isInternetConnected();
      _isServerReachable = await NetworkUtils.isBackendServerReachable();

      if (_isInternetConnected && _isServerReachable) {
        final storeResult = await storeRepository.getStoreByRequest(
          storeRequest,
        );
        if (storeResult != null) {
          _status = StoreStatus.dataAvailable;
          _storeByRequestData = storeResult;
          notifyListeners();
          return StoreResult(store: storeResult);
        } else {
          _status = StoreStatus.dataUnavailable;
        }
      }
    } catch (error) {
      debugPrint('Error during get store: $error');
      _status = StoreStatus.error;
      return StoreResult();
    } finally {
      notifyListeners();
    }
    return StoreResult();
  }
}
