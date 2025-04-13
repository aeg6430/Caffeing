class KeywordResponseModel {
  final String keywordID;
  final String keywordName;
  final List<int> keywordType;
  KeywordResponseModel({
    required this.keywordID,
    required this.keywordName,
    required this.keywordType,
  });

  factory KeywordResponseModel.fromJson(Map<String, dynamic> json) {
    return KeywordResponseModel(
      keywordID: json['keywordID'],
      keywordName: json['keywordName'],
      keywordType: List<int>.from(json['keywordType']),
    );
  }
}
