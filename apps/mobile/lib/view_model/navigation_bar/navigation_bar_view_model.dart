import 'package:flutter/material.dart';
import 'package:caffeing/models/response/navigation_bar/navigation_bar_response_model.dart';
import 'package:caffeing/view_model/navigation_bar/navigation_bar_result.dart';

enum NavigationBarStatus {
  idle,
  dataAvailable,
  noDataAvailable,
  loading,
  error,
  tokenInvalid,
}

class NavigationBarViewModel extends ChangeNotifier {
  NavigationBarStatus _status = NavigationBarStatus.idle;
  NavigationBarStatus get status => _status;

  List<NavigationBarResponseModel> _data = [];
  List<NavigationBarResponseModel> get data => _data;

  Future<NavigationBarResult> navigationBar() async {
    try {
      _status = NavigationBarStatus.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      if (navigationBar != null) {
      } else {
        _status = NavigationBarStatus.tokenInvalid;
      }
    } catch (error) {
      debugPrint('Error during navigation bar: $error');
      _status = NavigationBarStatus.error;
      return NavigationBarResult();
    } finally {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
    return NavigationBarResult();
  }
}
