class StoreRequestModel {
  final String storeId;

  StoreRequestModel({required this.storeId});
  Map<String, dynamic> toJson() {
    return {'StoreId': storeId};
  }
}
