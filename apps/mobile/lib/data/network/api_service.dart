import 'dart:convert';
import 'package:caffeing/models/request/favorite/store/favorite_store_request_model.dart';
import 'package:caffeing/models/request/search/search_request_model.dart';
import 'package:caffeing/models/request/store/store_request_model.dart';
import 'package:caffeing/models/request/user/user_request_model.dart';
import 'package:caffeing/models/response/keyword/keyword_response_model.dart';
import 'package:caffeing/models/response/search/search_response_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:caffeing/data/network/network_utils.dart';
import 'package:caffeing/models/response/user/user_response_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  String? get _apiUrl => NetworkUtils.baseApiUrl;
  static String? _token;

  static Future<String?> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token == null) return null;

    return token.replaceAll('"', '');
  }

  Future<UserResponseModel?> loginWithFirebaseToken(String idToken) async {
    try {
      final request = new UserRequestModel(idToken: idToken);
      final response = await http.post(
        Uri.parse('$_apiUrl/auth/login'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },

        body: jsonEncode(request),
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        return UserResponseModel.fromJson(jsonResponse);
      }
    } catch (error) {
      debugPrint('Error during Firebase login: $error');
    }
    return null;
  }

  Future<SearchResponseModel?> search(SearchRequestModel search) async {
    try {
      final uri = Uri.parse(
        '$_apiUrl/search?query=${Uri.encodeComponent(search.query ?? '')}'
        '${(search.keywordIds ?? []).map((id) => '&keywordIds=${Uri.encodeComponent(id)}').join()}',
      );
      final token = await loadToken();
      final response = await http.get(
        uri,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        return SearchResponseModel.fromJson(jsonResponse);
      }
    } catch (error) {
      debugPrint('Error during searching: $error');
      return null;
    }
  }

  Future<List<KeywordResponseModel>?> keywords() async {
    try {
      final token = await loadToken();
      final response = await http.get(
        Uri.parse('$_apiUrl/keywords'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;

        return jsonResponse
            .map((item) => KeywordResponseModel.fromJson(item))
            .toList();
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('Error during fetching keywords: $error');
      return null;
    }
  }

  Future<List<KeywordResponseModel>?> keywordsOptions() async {
    try {
      final token = await loadToken();
      final response = await http.get(
        Uri.parse('$_apiUrl/keywords/options'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body) as List<dynamic>;

        return jsonResponse
            .map((item) => KeywordResponseModel.fromJson(item))
            .toList();
      } else {
        return null;
      }
    } catch (error) {
      debugPrint('Error during fetching keywords options: $error');
      return null;
    }
  }

  Future<List<StoreResponseModel>> getAllStore() async {
    try {
      final token = await loadToken();
      final response = await http.get(
        Uri.parse('$_apiUrl/stores'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body) as List;
        return jsonResponse
            .map((store) => StoreResponseModel.fromJson(store))
            .toList();
      }
      return [];
    } catch (error) {
      debugPrint('Error during get store: $error');
      return [];
    }
  }

  Future<StoreResponseModel?> getStoreByRequest(StoreRequestModel store) async {
    try {
      final token = await loadToken();
      final response = await http.get(
        Uri.parse('$_apiUrl/stores/search?storeid=${store.storeId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body);
        return StoreResponseModel.fromJson(jsonResponse);
      }
    } catch (error) {
      debugPrint('Error during get store: $error');
      return null;
    }
  }

  Future<List<StoreResponseModel>> getFavoriteStores() async {
    try {
      final token = await loadToken();
      final response = await http.get(
        Uri.parse('$_apiUrl/favorites/stores'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200 || response.statusCode == 401) {
        final jsonResponse = json.decode(response.body) as List;
        return jsonResponse
            .map((store) => StoreResponseModel.fromJson(store))
            .toList();
      }
      return [];
    } catch (error) {
      debugPrint('Error during get favorite stores: $error');
      return [];
    }
  }

  Future addFavoriteStore(FavoriteStoreRequestModel request) async {
    try {
      final token = await loadToken();
      final response = await http.post(
        Uri.parse('$_apiUrl/favorites/stores?storeId=${request.storeId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      }
    } catch (error) {
      debugPrint('Error during add favorite store: $error');
      return null;
    }
  }

  Future removeFavoriteStore(FavoriteStoreRequestModel request) async {
    try {
      final token = await loadToken();
      final response = await http.delete(
        Uri.parse('$_apiUrl/favorites/stores?storeId=${request.storeId}'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        return null;
      } else if (response.statusCode == 401) {
        throw Exception('Unauthorized');
      }
    } catch (error) {
      debugPrint('Error during remove favorite store: $error');
      return null;
    }
  }
}
