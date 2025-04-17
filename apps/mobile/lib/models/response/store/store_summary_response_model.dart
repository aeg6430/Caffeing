class StoreSummaryResponseModel {
  final String storeId;
  final String name;
  final double latitude;
  final double longitude;

  StoreSummaryResponseModel({
    required this.storeId,
    required this.name,
    required this.latitude,
    required this.longitude,
  });

  factory StoreSummaryResponseModel.fromJson(Map<String, dynamic> json) {
    return StoreSummaryResponseModel(
      storeId: json['storeId'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
    );
  }
}
