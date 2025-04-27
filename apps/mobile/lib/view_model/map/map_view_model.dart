import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/widgets.dart';

class MapViewModel extends ChangeNotifier {
  List<StoreResponseModel> _mapStores = [];
  StoreSummaryResponseModel? _selectedStore;

  List<StoreResponseModel> get mapStores => _mapStores;
  StoreSummaryResponseModel? get selectedStore => _selectedStore;

  void updateMapStores(List<StoreResponseModel> stores) {
    _mapStores = stores;
    notifyListeners();
  }

  void updateSelectedStore(StoreSummaryResponseModel? store) {
    _selectedStore = store;
    notifyListeners();
  }
}
