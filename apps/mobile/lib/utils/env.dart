class Env {
  static late String _api_endpoint;

  static Future<void> load() async {
    _api_endpoint = const String.fromEnvironment(
      'APP_API_ENDPOINT',
      defaultValue: '',
    );
  }

  static String get apiEndpoint => _api_endpoint;
}
