import 'package:flutter/material.dart';
import 'package:caffeing/provider/bottom_navigation_provider.dart';
import 'package:caffeing/utils/permission_utils.dart';
import 'package:caffeing/view/screens/auth_screen/auth_screen.dart';
import 'package:caffeing/view/screens/home_screen/home_screen.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:caffeing/view_model/navigation_bar/navigation_bar_view_model.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  @override
  _AuthWrapperState createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  late Future<void> _navigationBarFuture;
  @override
  void initState() {
    super.initState();
    _requestPermissionsOnce();
    final navigationBarViewModel = Provider.of<NavigationBarViewModel>(
      context,
      listen: false,
    );
    _navigationBarFuture = navigationBarViewModel.navigationBar();
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
          final bottomNavigationProvider = BottomNavigationProvider();

          return FutureBuilder<void>(
            future: _navigationBarFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              return HomeScreen(
                bottomNavigationProvider: bottomNavigationProvider,
              );
            },
          );
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
