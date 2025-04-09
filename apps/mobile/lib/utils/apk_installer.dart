import 'package:flutter/services.dart';

class ApkInstaller {
  static const MethodChannel _channel = MethodChannel('apk_installer');

  Future<void> installAPK(String filePath) async {
    try {
      final result =
          await _channel.invokeMethod('installAPK', {'filePath': filePath});
      print(result);
    } catch (e) {
      print("Error installing APK: $e");
    }
  }
}
