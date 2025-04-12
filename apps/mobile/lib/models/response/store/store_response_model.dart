class StoreResponseModel {
  final String storeID;
  final String name;
  final double latitude;
  final double longitude;
  final List<String>? tags;

  StoreResponseModel({
    required this.storeID,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.tags,
  });

  factory StoreResponseModel.fromJson(Map<String, dynamic> json) {
    return StoreResponseModel(
      storeID: json['storeID'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }
}
