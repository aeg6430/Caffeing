import 'dart:async';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:flutter/widgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapViewModel extends ChangeNotifier {
  final Completer<GoogleMapController> mapController = Completer();

  List<StoreResponseModel> _mapStores = [];
  List<StoreSummaryResponseModel> _searchResults = [];
  StoreSummaryResponseModel? _selectedStore;
  String? _pendingStoreId;

  List<StoreResponseModel> get mapStores => _mapStores;
  List<StoreSummaryResponseModel> get searchResults => _searchResults;
  StoreSummaryResponseModel? get selectedStore => _selectedStore;

  void updateMapStores(List<StoreResponseModel> stores) {
    _mapStores = stores;
    notifyListeners();

    // Handle deferred deep link store selection
    if (_pendingStoreId != null) {
      _selectStoreById(_pendingStoreId!);
      _pendingStoreId = null;
    }
  }

  void updateSearchResults(List<StoreSummaryResponseModel> results) {
    _searchResults = results;
    notifyListeners();
  }

  void updateSelectedStore(StoreSummaryResponseModel? store) {
    _selectedStore = store;
    notifyListeners();
  }

  void selectStoreById(String storeId) {
    if (_mapStores.isEmpty) {
      _pendingStoreId = storeId;
      return;
    }
    _selectStoreById(storeId);
  }

  void _selectStoreById(String storeId) {
    final StoreResponseModel? match = _mapStores
        .cast<StoreResponseModel?>()
        .firstWhere((store) => store?.storeId == storeId, orElse: () => null);

    if (match != null) {
      updateSelectedStore(
        StoreSummaryResponseModel(
          storeId: match.storeId,
          name: match.name,
          latitude: match.latitude,
          longitude: match.longitude,
        ),
      );
    }
  }

  void resetMapController() {
    if (mapController.isCompleted) return;
    mapController.completeError(
      StateError('MapController was reset unexpectedly'),
    );
  }
}
