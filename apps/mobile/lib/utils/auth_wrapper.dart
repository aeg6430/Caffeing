import 'package:caffeing/view/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/utils/permission_utils.dart';
import 'package:caffeing/view/screens/auth_screen/auth_screen.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
    _requestPermissionsOnce();
  }

  void _requestPermissionsOnce() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      PermissionUtils.requestMultiplePermissions(context, [
        Permission.requestInstallPackages,
        Permission.unknown,
        Permission.notification,
        Permission.storage,
      ]);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.loginStatus == LoginStatus.authorized) {
          return HomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
