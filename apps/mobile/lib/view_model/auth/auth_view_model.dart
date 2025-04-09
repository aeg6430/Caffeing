import 'dart:async';
import 'package:flutter/material.dart';
import 'package:Kafein/data/network/network_utils.dart';
import 'package:Kafein/models/request/user/user_request_model.dart';
import 'package:Kafein/models/response/user/user_response_model.dart';
import 'package:Kafein/repository/auth/auth_repository.dart';
import 'package:Kafein/utils/token_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum LoginStatus {
  idle,
  loading,
  success,
  passwordMismatch,
  userNotFound,
  authorized,
  unauthorized,
  error,
}

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

  late StreamController<LoginStatus> _loginStatusController;
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

  Future<void> loginUser(String userId, String password) async {
    _updateLoginStatus(LoginStatus.loading);
    final isNetworkAvailable = await _checkNetworkConnectivity();
    if (!isNetworkAvailable) return;

    try {
      final userModel = UserRequestModel(userId: userId, password: password);
      final response = await _performLogin(userModel);
      _handleLoginResponse(response);
    } catch (error) {
      _handleLoginError(error.toString());
    }
  }

  Future<UserResponseModel?> _performLogin(UserRequestModel user) async {
    final isNetworkAvailable = await _checkNetworkConnectivity();
    if (!isNetworkAvailable) return null;

    return await authRepository.loginUser(user);
  }

  void _handleLoginResponse(UserResponseModel? response) {
    if (response == null) {
      _updateLoginStatus(LoginStatus.error);
      return;
    }

    if (response.isSuccess) {
      _setCurrentUser(response.user!);
      _updateLoginStatus(LoginStatus.authorized);
    } else {
      _handleLoginError(response.message);
    }
  }

  Future<void> _setCurrentUser(User user) async {
    _currentUserID = user.userId;
    _currentUserName = user.userName;
    _currentToken = user.token;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('token', user.token);
  }

  void _handleLoginError(String? message) {
    switch (message) {
      case "Incorrect password":
        _updateLoginStatus(LoginStatus.passwordMismatch);
        break;
      case "User not found":
        _updateLoginStatus(LoginStatus.userNotFound);
        break;
      default:
        _updateLoginStatus(LoginStatus.error);
    }
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
}
