import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Kafein/view/components/dialog_components.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionUtils {
  static bool isDialogOpen = false;

  static Future<bool> requestPermission(
    BuildContext context,
    Permission permission,
  ) async {
    var status = await permission.status;
    if (status.isPermanentlyDenied || status.isDenied) {
      var result = await permission.request();
      if (result == PermissionStatus.granted) {
        return true;
      } else {
        _showPermissionDeniedDialog(context, [permission]);
        return false;
      }
    } else {
      return status.isGranted;
    }
  }

  static Future<bool> requestMultiplePermissions(
    BuildContext context,
    List<Permission> permissions,
  ) async {
    Map<Permission, PermissionStatus> statusMap = await permissions.request();
    if (statusMap.values.every((status) => status.isGranted)) {
      return true;
    } else {
      List<Permission> deniedPermissions = _getDeniedPermissions(
        permissions,
        statusMap,
      );
      _showPermissionDeniedDialog(context, deniedPermissions);
      return false;
    }
  }

  static List<Permission> _getDeniedPermissions(
    List<Permission> permissions,
    Map<Permission, PermissionStatus> statusMap,
  ) {
    return permissions.where((permission) {
      return statusMap[permission]?.isDenied ?? false;
    }).toList();
  }

  static void _showPermissionDeniedDialog(
    BuildContext context,
    List<Permission> deniedPermissions,
  ) {
    if (!isDialogOpen) {
      isDialogOpen = true;
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return DialogUtils.showCustomDialog(
            context: dialogContext,
            widgetHeight: 200,
            widgetWidth: 200,
            icon: FaIcon(FontAwesomeIcons.key),
            title: '需獲取以下權限：',
            content: Text('${_getPermissionNames(deniedPermissions)}'),
            contentTextAlign: TextAlign.center,
            actions: [
              ElevatedButton(
                onPressed:
                    () => {Navigator.pop(dialogContext), isDialogOpen = false},
                child: Text('Cancel'),
              ),
              SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(dialogContext);
                  Future.delayed(const Duration(milliseconds: 500), () async {
                    await openAppSettings();
                    isDialogOpen = false;
                  });
                },
                child: Text('Confirm'),
              ),
            ],
          );
        },
      );
    }
  }

  static String _getPermissionNames(List<Permission> permissions) {
    List<String> names = permissions.map(_getPermissionName).toList();
    return names.join(", ");
  }

  static String _getPermissionName(Permission permission) {
    String permissionName = permission.toString();
    int dotIndex = permissionName.lastIndexOf('.');
    return permissionName.substring(dotIndex + 1);
  }
}
