class KeywordResponseModel {
  final String keywordId;
  final String keywordName;
  final List<String> keywordType;
  KeywordResponseModel({
    required this.keywordId,
    required this.keywordName,
    required this.keywordType,
  });

  factory KeywordResponseModel.fromJson(Map<String, dynamic> json) {
    return KeywordResponseModel(
      keywordId: json['keywordId'],
      keywordName: json['keywordName'],
      keywordType: List<String>.from(json['keywordType']),
    );
  }
}
