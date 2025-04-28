import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:flutter/material.dart';

class SelectedStoreViewModel extends ChangeNotifier {
  StoreResponseModel? _selectedStore;

  StoreResponseModel? get selectedStore => _selectedStore;

  void selectStore(StoreResponseModel store) {
    _selectedStore = store;
    notifyListeners();
  }

  void clearSelectedStore() {
    _selectedStore = null;
    notifyListeners();
  }
}
