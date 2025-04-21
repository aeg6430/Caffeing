import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenUtils {
  static const String _firebaseUserIDKey = 'firebaseUserID';
  static const String _firebaseUserNameKey = 'firebaseUserName';
  static const String _firebaseAuthTokenKey = 'firebaseAuthToken';

  static final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  static Future<void> setAuthToken(
    String userID,
    String userName,
    String authToken,
  ) async {
    await _secureStorage.write(key: _firebaseUserIDKey, value: userID);
    await _secureStorage.write(key: _firebaseUserNameKey, value: userName);
    await _secureStorage.write(key: _firebaseAuthTokenKey, value: authToken);
  }

  static Future<String?> getUserID() async {
    return await _secureStorage.read(key: _firebaseUserIDKey);
  }

  static Future<String?> getUserName() async {
    return await _secureStorage.read(key: _firebaseUserNameKey);
  }

  static Future<String?> getAuthToken() async {
    return await _secureStorage.read(key: _firebaseAuthTokenKey);
  }

  static Future<void> deleteAuthToken() async {
    await _secureStorage.delete(key: _firebaseUserIDKey);
    await _secureStorage.delete(key: _firebaseUserNameKey);
    await _secureStorage.delete(key: _firebaseAuthTokenKey);
  }
}
