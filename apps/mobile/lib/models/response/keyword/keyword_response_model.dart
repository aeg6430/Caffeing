class KeywordResponseModel {
  final String keywordID;
  final String keywordName;

  KeywordResponseModel({required this.keywordID, required this.keywordName});

  factory KeywordResponseModel.fromJson(Map<String, dynamic> json) {
    return KeywordResponseModel(
      keywordID: json['keywordID'],
      keywordName: json['keywordName'],
    );
  }
}
