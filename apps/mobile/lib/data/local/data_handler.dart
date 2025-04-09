import 'dart:io';
import 'package:flutter/widgets.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DataHandler {
  static Future<String> _getFolderPath() async {
    final packageInfo = await PackageInfo.fromPlatform();
    final documentsDirectory = await getExternalStorageDirectory();
    return '${documentsDirectory!.path}/${packageInfo.packageName}';
  }

  static Future<String> _getFilePath(String fileName) async {
    final folderPath = await _getFolderPath();

    return '$folderPath/$fileName';
  }

  static const String folderCreatedKey = 'folderCreated';

  static Future<void> createFolderOnInstall() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool folderCreated = prefs.getBool(folderCreatedKey) ?? false;

    if (!folderCreated) {
      await _createFolder();
      prefs.setBool(folderCreatedKey, true);
    }
  }

  static Future<void> _createFolder() async {
    try {
      final folderPath = await _getFolderPath();
      final appDirectory = Directory(folderPath);

      if (!appDirectory.existsSync()) {
        await appDirectory.create(recursive: true);
      }
    } catch (e) {
      debugPrint('Error creating folder: $e');
    }
  }

  static Future<void> _createFile(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (!file.existsSync()) {
        await file.create();
      }
    } catch (e) {
      debugPrint('Error creating file: $e');
    }
  }

  static Future<void> _writeData(String fileName, String data) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      await file.writeAsString(data);
    } catch (e) {
      debugPrint('Error writing data: $e');
    }
  }

  static Future<String?> _readData(String fileName) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (file.existsSync()) {
        return await file.readAsString();
      }
    } catch (e) {
      debugPrint('Error reading data: $e');
    }

    return null;
  }

  static Future<void> _editData(String fileName, String newData) async {
    try {
      final filePath = await _getFilePath(fileName);
      final file = File(filePath);

      if (file.existsSync()) {
        await file.writeAsString(newData);
      }
    } catch (e) {
      debugPrint('Error editing data: $e');
    }
  }
}
