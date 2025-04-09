import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:Kafein/data/network/network_utils.dart';
import 'package:Kafein/models/request/app_update/app_update_request_model.dart';
import 'package:Kafein/models/request/user/user_request_model.dart';
import 'package:Kafein/models/response/user/user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String? get _apiUrl => NetworkUtils.baseApiUrl;
  String? get _updateServerUrl => NetworkUtils.updateServerUrl;
  static String? _token;

  Future<dynamic> getAppUpdateToken() async {
    try {
      final response = await http.get(
        Uri.parse('$_updateServerUrl/app-update/get-token'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      } else {
        debugPrint('Request failed with status code: ${response.statusCode}');
        debugPrint('Response: ${response.body.trim()}');
        return {"error": "Request failed"};
      }
    } catch (error) {
      debugPrint('Error during API request: $error');
      return {"error": "Error during API request"};
    }
  }

  Future<dynamic> checkAppVersion(AppUpdateRequestModel appUpdate) async {
    try {
      _token = await loadToken();
      final response = await http.get(
        Uri.parse(
          '$_updateServerUrl/app-update/check-version?version=${appUpdate.appVersion}',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final dynamic jsonResponse = json.decode(response.body);
        return jsonResponse;
      } else if (response.statusCode == 401) {
        return {"error": "Unauthorized"};
      } else {
        debugPrint('Request failed with status code: ${response.statusCode}');
        debugPrint('Response: ${response.body.trim()}');
        return {"error": "Request failed"};
      }
    } catch (error) {
      debugPrint('Error during API request: $error');
      return {"error": "Error during API request"};
    }
  }

  static Future<String?> loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('token');
  }

  Future<UserResponseModel?> loginUser(UserRequestModel user) async {
    try {
      final response = await http.post(
        Uri.parse('$_apiUrl/user/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        return UserResponseModel.fromJson(jsonResponse);
      }
    } catch (error) {
      debugPrint('Error during login: $error');
      return null;
    }
  }
}
