import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;
import 'package:Kafein/utils/env.dart';

class NetworkUtils {
  static String? get baseApiUrl => "${Env.apiUrl}/api";
  static String? get _testApiUrl => "${baseApiUrl}/connections/test";
  static String? get updateServerUrl => "${Env.updateServerUrl}/api";

  static Future<bool> isInternetConnected() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  static Future<bool> isBackendServerReachable() async {
    try {
      final response = await http.get(Uri.parse(_testApiUrl!));
      if (response.statusCode == 200) {
        debugPrint('Server is reachable');
        return true;
      } else {
        debugPrint('Server responded with status code: ${response.statusCode}');
        debugPrint('Response body: ${response.body}');
        return false;
      }
    } catch (error) {
      debugPrint('Error checking server reachability: $error');
      return false;
    }
  }

  static void showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_LONG,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
    );
  }

  static void showNetworkStatusToast(
    bool isInternetConnected,
    bool isServerReachable,
  ) {
    if (!isInternetConnected) {
      showToast('請檢查網路連線狀況');
    } else if (!isServerReachable) {
      showToast('無法連線至伺服器');
    }
  }
}
