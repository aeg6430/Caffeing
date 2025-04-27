import 'package:flutter/material.dart';
import 'package:caffeing/provider/bottom_navigation_provider.dart';
import 'package:caffeing/view/screens/auth_screen/auth_screen.dart';
import 'package:caffeing/view/screens/home_screen/home_screen.dart';
import 'package:caffeing/view/screens/settings_screen/settings_screen.dart';

class Routes {
  static const String auth = '/auth';
  static const String home = '/home';
  static const String profile = '/profile';

  static Route<dynamic> generateRoute(
    RouteSettings settings, [
    BottomNavigationProvider? bottomNavigationProvider,
  ]) {
    switch (settings.name) {
      case auth:
        return MaterialPageRoute(builder: (_) => AuthScreen());
      case home:
        return MaterialPageRoute(
          builder:
              (_) => HomeScreen(
                bottomNavigationProvider:
                    bottomNavigationProvider ?? BottomNavigationProvider(),
              ),
        );
      case profile:
        return MaterialPageRoute(builder: (_) => SettingsScreen());

      default:
        return MaterialPageRoute(
          builder:
              (_) => Scaffold(
                body: Center(
                  child: Text('No route defined for ${settings.name}'),
                ),
              ),
        );
    }
  }
}
