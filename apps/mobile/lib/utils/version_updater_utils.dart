import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/app_update/app_update_request_model.dart';
import 'package:caffeing/repository/app_update/app_update_repository.dart';
import 'package:caffeing/utils/apk_installer.dart';
import 'package:caffeing/view/components/dialog_components.dart';
import 'package:caffeing/view_model/app_update/app_update_view_model.dart';

class VersionUpdater {
  static late AppUpdateViewModel appUpdateViewModel;
  static late PackageInfo packageInfo;
  static bool _initialized = false;

  static Future<void> init() async {
    if (!_initialized) {
      _initialized = true;
    }

    packageInfo = await PackageInfo.fromPlatform();

    appUpdateViewModel = AppUpdateViewModel(
      appUpdateRepository: AppUpdateRepository(apiService: ApiService()),
    );
  }

  Future<void> checkAndIncrementAppVersion() async {
    WidgetsFlutterBinding.ensureInitialized();

    String version = packageInfo.version;
    await appUpdateViewModel.appUpdate(
      AppUpdateRequestModel(appVersion: version),
    );
  }

  static Future<void> checkUpdate(BuildContext context) async {
    final updater = VersionUpdater();
    await updater._checkUpdate(context);
  }

  Future<void> _checkUpdate(BuildContext context) async {
    await init();
    await checkAndIncrementAppVersion();
    if (appUpdateViewModel.status == AppUpdateStatus.fileAvailable) {
      await _showUpdateDialog(context);
    } else if (appUpdateViewModel.status == AppUpdateStatus.fileUnavailable) {
      await _showUpdateToast(context);
    }
  }

  Future<void> _showUpdateDialog(BuildContext context) async {
    try {
      String? appUpdateToken = appUpdateViewModel.token?.appUpdateToken;
      String? latestVersion = appUpdateViewModel.data?.latestVersion;
      String? downloadUrl = appUpdateViewModel.data?.downloadLink;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogUtils.showCustomDialog(
            context: dialogContext,
            widgetHeight: 200,
            widgetWidth: 200,
            icon: FaIcon(FontAwesomeIcons.rocket),
            title: '發現新版本',
            content: Text(
              "目前版本：${packageInfo.version}\r\n更新版本：${latestVersion}",
            ),
            contentTextAlign: TextAlign.center,
            actions: [
              ElevatedButton(
                onPressed: () => {Navigator.pop(dialogContext)},
                child: Text('稍後'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed:
                    () => {
                      Navigator.pop(dialogContext),
                      _downloadUpdate(appUpdateToken!, downloadUrl!, context),
                    },
                child: Text('現在更新'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      debugPrint('Error when show dialog: $e');
    }
  }

  Future<void> _showUpdateToast(BuildContext context) async {
    try {
      Fluttertoast.showToast(
        msg: "已經是最新版本： ${packageInfo.version}",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
      );
    } catch (e) {
      debugPrint('Error when show toast: $e');
    }
  }

  Future<void> _downloadUpdate(
    String appUpdateToken,
    String downloadUrl,
    BuildContext context,
  ) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext loadingContext) {
        return DialogUtils.showCustomDialog(
          context: loadingContext,
          widgetHeight: 200,
          widgetWidth: 200,
          icon: FaIcon(FontAwesomeIcons.hourglassHalf),
          title: '更新中.....',
          content: LinearProgressIndicator(),
          contentTextAlign: TextAlign.center,
        );
      },
    );

    try {
      final response = await http.get(
        Uri.parse(downloadUrl),
        headers: {'Authorization': 'Bearer $appUpdateToken'},
      );

      if (response.statusCode == 200) {
        final directory = await getApplicationDocumentsDirectory();
        String fileName = 'downloaded_file.apk';
        String savePath = '${directory.path}/${fileName}';

        File file = File(savePath);
        await file.writeAsBytes(response.bodyBytes);

        print("Saved at: $savePath");

        if (Platform.isAndroid) {
          installAPK(savePath);
        }
      }
    } catch (e) {
      debugPrint('Error downloading update: $e');
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext loadingContext) {
          return DialogUtils.showCustomDialog(
            context: loadingContext,
            widgetHeight: 200,
            widgetWidth: 200,
            icon: FaIcon(FontAwesomeIcons.rocket),

            title: '錯誤',
            content: Text("更新失敗"),
            contentTextAlign: TextAlign.center,
          );
        },
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  Future<void> installAPK(String savePath) async {
    try {
      final installer = ApkInstaller();
      installer.installAPK(savePath);
      print("APK installed successfully");
    } catch (e) {
      print("Error installing APK: $e");
    }
  }
}
