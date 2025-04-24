import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:caffeing/data/network/network_utils.dart';
import 'package:caffeing/models/response/user/user_response_model.dart';
import 'package:caffeing/repository/auth/auth_repository.dart';
import 'package:caffeing/utils/token_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus { idle, loading, success, authorized, unauthorized, error }

class AuthViewModel extends ChangeNotifier {
  final AuthRepository authRepository;

  AuthViewModel({required this.authRepository}) {
    _loginStatusController = StreamController<LoginStatus>.broadcast();
    _loginStatus = LoginStatus.idle;
    _loginStatusController.add(_loginStatus);
    _initializeAuth();
  }

  String? _currentUserID;
  String? _currentUserName;
  String? _currentToken;
  late LoginStatus _loginStatus;

  String? get currentUserID => _currentUserID;
  String? get currentUserName => _currentUserName;
  String? get currentToken => _currentToken;
  LoginStatus get loginStatus => _loginStatus;

  late final StreamController<LoginStatus> _loginStatusController;
  Stream<LoginStatus> get loginStatusStream => _loginStatusController.stream;

  Future<void> _initializeAuth() async {
    final storedUserID = await TokenUtils.getUserID();
    final storedUserName = await TokenUtils.getUserName();
    final storedToken = await TokenUtils.getAuthToken();

    if (storedToken != null) {
      _currentUserID = storedUserID;
      _currentUserName = storedUserName;
      await _attemptAutoLogin(storedToken);
    }
  }

  Future<void> _attemptAutoLogin(String token) async {
    try {
      _currentToken = token;
      _loginStatus = LoginStatus.authorized;
      notifyListeners();
      debugPrint('Auto-login successful');
    } catch (error) {
      debugPrint('Error during auto login: $error');
      _loginStatus = LoginStatus.error;
    }
  }

  void _updateLoginStatus(LoginStatus status) {
    _loginStatus = status;
    notifyListeners();
  }

  Future<bool> _checkNetworkConnectivity() async {
    final isInternetConnected = await NetworkUtils.isInternetConnected();
    final isServerReachable = await NetworkUtils.isBackendServerReachable();

    if (!isInternetConnected || !isServerReachable) {
      _updateLoginStatus(LoginStatus.error);
      NetworkUtils.showNetworkStatusToast(
        isInternetConnected,
        isServerReachable,
      );
      return false;
    }
    return true;
  }

  Future<void> logoutUser() async {
    try {
      await authRepository.logoutUser();
      _currentToken = null;
      _currentUserName = null;
      _currentUserID = null;
      _updateLoginStatus(LoginStatus.idle);
    } catch (error) {
      debugPrint('Error during logout: $error');
    }
  }

  Future<void> loginWithGoogle() async {
    _updateLoginStatus(LoginStatus.loading);

    final isNetworkAvailable = await _checkNetworkConnectivity();
    if (!isNetworkAvailable) return;

    try {
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
      if (googleUser == null) {
        _updateLoginStatus(LoginStatus.idle);
        return;
      }

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final credential = fb.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final fb.UserCredential userCredential = await fb.FirebaseAuth.instance
          .signInWithCredential(credential);
      final fb.User? user = userCredential.user;

      if (user != null) {
        final idToken = await user.getIdToken();
        if (idToken?.isNotEmpty ?? false) {
          await _exchangeTokenWithBackend(idToken!);
        }
      } else {
        _updateLoginStatus(LoginStatus.error);
      }
    } catch (e) {
      debugPrint('Google Sign-In failed: $e');
      _updateLoginStatus(LoginStatus.error);
    }
  }

  Future<void> _exchangeTokenWithBackend(String idToken) async {
    try {
      final response = await authRepository.loginWithFirebaseToken(idToken);
      if (response != null) {
        await _setCurrentUser(response);
        _updateLoginStatus(LoginStatus.authorized);
      } else {
        _updateLoginStatus(LoginStatus.unauthorized);
      }
    } catch (e) {
      debugPrint('Token exchange failed: $e');
      _updateLoginStatus(LoginStatus.error);
    }
  }

  Future<void> _setCurrentUser(UserResponseModel user) async {
    _currentUserID = user.userId;
    _currentUserName = user.name;
    _currentToken = user.token;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.token);
  }
}
