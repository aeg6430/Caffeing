class AppUpdateResponseModel {
  final bool? isUpdateAvailable;
  final String? latestVersion;
  final String? downloadLink;

  AppUpdateResponseModel({
    required this.isUpdateAvailable,
    required this.latestVersion,
    required this.downloadLink,
  });

  factory AppUpdateResponseModel.fromJson(Map<String, dynamic> json) {
    return AppUpdateResponseModel(
      isUpdateAvailable: json['isUpdateAvailable'] as bool?,
      latestVersion: json['latestVersion'] as String?,
      downloadLink: json['downloadLink'] as String?,
    );
  }
}
