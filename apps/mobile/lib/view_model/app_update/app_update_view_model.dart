import 'package:flutter/material.dart';
import 'package:Kafein/data/network/network_utils.dart';
import 'package:Kafein/models/request/app_update/app_update_request_model.dart';
import 'package:Kafein/models/response/app_update/app_update_response_model.dart';
import 'package:Kafein/models/response/app_update/app_update_token_response.dart';
import 'package:Kafein/repository/app_update/app_update_repository.dart';

enum AppUpdateStatus {
  idle,
  fileAvailable,
  fileUnavailable,
  loading,
  error,
  tokenInvalid,
}

class AppUpdateViewModel extends ChangeNotifier {
  final AppUpdateRepository appUpdateRepository;

  bool _isInternetConnected = false;
  bool _isServerReachable = false;
  bool get isServerReachable => _isServerReachable;
  bool get isInternetConnected => _isInternetConnected;

  AppUpdateViewModel({required this.appUpdateRepository});

  AppUpdateStatus _status = AppUpdateStatus.idle;
  AppUpdateStatus get status => _status;

  AppUpdateTokenResponseModel? _appUpdateToken;
  AppUpdateTokenResponseModel? get token => _appUpdateToken;
  AppUpdateResponseModel? _data;
  AppUpdateResponseModel? get data => _data;

  Future<void> appUpdate(AppUpdateRequestModel appUpdate) async {
    try {
      _status = AppUpdateStatus.loading;
      notifyListeners();

      _isInternetConnected = await NetworkUtils.isInternetConnected();
      _isServerReachable = await NetworkUtils.isBackendServerReachable();

      if (_isInternetConnected && _isServerReachable) {
        final appUpdateToken = await appUpdateRepository.getAppUpdateToken();

        final updateInfo = await appUpdateRepository.checkUpdate(appUpdate);
        debugPrint("updateInfo ${updateInfo}");

        if (appUpdateToken != null && updateInfo != null) {
          final AppUpdateTokenResponseModel token =
              AppUpdateTokenResponseModel.fromJson(
                appUpdateToken as Map<String, dynamic>,
              );
          final AppUpdateResponseModel appUpdate =
              AppUpdateResponseModel.fromJson(
                updateInfo as Map<String, dynamic>,
              );
          if (appUpdate.isUpdateAvailable == true) {
            _status = AppUpdateStatus.fileAvailable;
            _appUpdateToken = token;
            _data = appUpdate;
          } else {
            _status = AppUpdateStatus.fileUnavailable;
          }
        }
      }
    } catch (error) {
      debugPrint('Error during app update: $error');
      _status = AppUpdateStatus.error;
    } finally {
      notifyListeners();
    }
  }
}
