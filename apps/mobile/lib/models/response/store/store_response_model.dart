import 'package:caffeing/models/response/keyword/keyword_response_model.dart';

class StoreResponseModel {
  final String storeId;
  final String name;
  final double latitude;
  final double longitude;
  final String? address;
  final String? contactNumber;
  final String? businessHours;
  final List<KeywordResponseModel> keywords;
  StoreResponseModel({
    required this.storeId,
    required this.name,
    required this.latitude,
    required this.longitude,
    this.address,
    this.contactNumber,
    this.businessHours,
    required this.keywords,
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
      keywords:
          (json['keywords'] as List<dynamic>)
              .map((k) => KeywordResponseModel.fromJson(k))
              .toList(),
    );
  }
}
