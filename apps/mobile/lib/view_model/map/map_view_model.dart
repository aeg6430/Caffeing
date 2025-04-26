import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/material.dart';

class MapViewModel extends ChangeNotifier {
  StoreSummaryResponseModel? _selectedStore;

  StoreSummaryResponseModel? get selectedStore => _selectedStore;

  void updateSelectedStore(StoreSummaryResponseModel? store) {
    _selectedStore = store;
    notifyListeners();
  }
}
