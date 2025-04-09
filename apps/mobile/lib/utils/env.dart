class Env {
  static late String _apiUrl;
  static late String _updateServerUrl;

  static Future<void> load() async {
    _apiUrl = const String.fromEnvironment('API_URL', defaultValue: '');
    _updateServerUrl =
        const String.fromEnvironment('UPDATE_SERVER_URL', defaultValue: '');
  }

  static String get apiUrl => _apiUrl;
  static String get updateServerUrl => _updateServerUrl;
}
