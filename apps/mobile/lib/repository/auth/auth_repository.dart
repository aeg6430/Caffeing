import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/response/user/user_response_model.dart';
import 'package:caffeing/utils/token_utils.dart';
import 'package:flutter/material.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<UserResponseModel?> loginWithFirebaseToken(String idToken) async {
    try {
      // Call the API service to login with the Firebase idToken
      final UserResponseModel? response = await apiService
          .loginWithFirebaseToken(idToken);

      if (response?.user != null) {
        await TokenUtils.setAuthToken(
          response!.user!.id,
          response.user!.name,
          response.user!.token,
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
