import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';

class SearchResponseModel {
  final List<StoreSummaryResponseModel> stores;
  final bool isMatched;
  final int totalStoresCount;
  final int pageNumber;
  final int pageSize;

  SearchResponseModel({
    required this.stores,
    required this.isMatched,
    required this.totalStoresCount,
    required this.pageNumber,
    required this.pageSize,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) {
    return SearchResponseModel(
      stores:
          (json['stores'] as List)
              .map((store) => StoreSummaryResponseModel.fromJson(store))
              .toList(),
      isMatched: json['isMatched'],
      totalStoresCount: json['totalStoresCount'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
    );
  }
}
