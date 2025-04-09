import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenUtils {
  static const String _userIDKey = 'userID';
  static const String _userNameKey = 'userName';
  static const String _authTokenKey = 'authToken';

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> setAuthToken(
    String userID,
    String userName,
    String authToken,
  ) async {
    await _secureStorage.write(key: _userIDKey, value: userID);
    await _secureStorage.write(key: _userNameKey, value: userName);
    await _secureStorage.write(key: _authTokenKey, value: authToken);
  }

  static Future<String?> getUserID() async {
    return await _secureStorage.read(key: _userIDKey);
  }

  static Future<String?> getUserName() async {
    return await _secureStorage.read(key: _userNameKey);
  }

  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _authTokenKey);
  }

  static Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: _userIDKey);
    await _secureStorage.delete(key: _userNameKey);
    await _secureStorage.delete(key: _authTokenKey);
  }
}
