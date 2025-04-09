class AppUpdateTokenResponseModel {
  final String? appUpdateToken;

  AppUpdateTokenResponseModel({
    required this.appUpdateToken,
  });

  factory AppUpdateTokenResponseModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateTokenResponseModel(
      appUpdateToken: json['personalAccessToken'] as String?,
    );
  }
}
