import 'dart:async';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {
  final Completer<GoogleMapController> mapController = Completer();

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

  void resetMapController() {
    if (mapController.isCompleted) return;
    mapController.completeError(
      StateError('MapController was reset unexpectedly'),
    );
  }
}
