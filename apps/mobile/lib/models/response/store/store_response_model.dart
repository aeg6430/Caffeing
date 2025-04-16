class StoreResponseModel {
  final String storeId;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? contactNumber;
  final String? businessHours;

  StoreResponseModel({
    required this.storeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.contactNumber,
    this.businessHours,
  });

  factory StoreResponseModel.fromJson(Map<String, dynamic> json) {
    return StoreResponseModel(
      storeId: json['storeId'],
      name: json['name'],
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      address: json['address'],
      contactNumber: json['contactNumber'],
      businessHours: json['businessHours'],
    );
  }
}
