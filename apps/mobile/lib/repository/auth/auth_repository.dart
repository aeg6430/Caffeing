import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/response/user/user_response_model.dart';
import 'package:caffeing/utils/token_utils.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<UserResponseModel?> loginWithFirebaseToken(String idToken) async {
    try {
      final UserResponseModel? response = await apiService
          .loginWithFirebaseToken(idToken);

      if (response != null) {
        await TokenUtils.setAuthToken(
          response.userId,
          response.name,
          response.token,
        );
      }
      return response;
    } catch (e) {
      debugPrint('Error during Firebase login: $e');
      return null;
    }
  }

  Future<void> logoutUser() async {
    try {
      await TokenUtils.deleteAuthToken();
    } catch (e) {
      debugPrint('Error during logout: $e');
    }
  }
}
