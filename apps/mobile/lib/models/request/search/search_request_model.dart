class SearchRequestModel {
  final String query;
  final List<String> keywordIds;

  SearchRequestModel({required this.query, required this.keywordIds});
  Map<String, dynamic> toJson() {
    return {'query': query, 'keywordIds': keywordIds};
  }
}
