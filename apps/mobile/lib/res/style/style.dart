import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum ThemeColor { Light, Dark }

class AppThemeNotifier extends ChangeNotifier {
  ThemeMode _currentThemeMode = ThemeMode.system;

  ThemeMode get currentThemeMode => _currentThemeMode;

  AppThemeNotifier() {
    _loadTheme();
  }

  void updateTheme(ThemeColor newTheme) async {
    _currentThemeMode =
        newTheme == ThemeColor.Dark ? ThemeMode.dark : ThemeMode.light;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('theme', newTheme.toString().split('.').last);

    notifyListeners();
  }

  Future<void> _loadTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');

    if (savedTheme != null) {
      final theme = ThemeColor.values.firstWhere(
        (e) => e.toString() == 'ThemeColor.$savedTheme',
        orElse: () => ThemeColor.Light,
      );

      _currentThemeMode =
          theme == ThemeColor.Dark ? ThemeMode.dark : ThemeMode.light;

      notifyListeners();
    }
  }
}

class AppStyles {
  static ThemeData getTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.light,
      primarySwatch: Colors.grey,
      primaryColor: Colors.black,
      dividerColor: Colors.black12,
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    return ThemeData(
      brightness: Brightness.dark,
      primarySwatch: Colors.grey,
      primaryColor: Colors.white,
      dividerColor: Colors.white54,
    );
  }

  static double getHorizontalPadding(BuildContext context, double factor) {
    double screenWidth = MediaQuery.of(context).size.width;
    return screenWidth * factor;
  }

  static Future<ThemeColor> getSavedTheme() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString('theme');

    return savedTheme != null
        ? ThemeColor.values.firstWhere(
          (e) => e.toString() == 'ThemeColor.$savedTheme',
          orElse: () => ThemeColor.Light,
        )
        : ThemeColor.Light;
  }

  static ThemeColor _getSavedThemeSync() {
    return ThemeColor.Light;
  }

  static ButtonStyle outlinedButtonStyle({
    double? elevation,
    double? width,
    double? height,
    double? fontSize,
    Color? backgroundColor,
    Color? foregroundColor,
    BorderRadius? borderRadius,
  }) {
    return OutlinedButton.styleFrom(
      elevation: elevation,
      minimumSize: Size(width ?? 88, height ?? 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: borderRadius ?? BorderRadius.circular(4),
      ),
      side: const BorderSide(color: Colors.white),
      backgroundColor: backgroundColor ?? Colors.orange,
      foregroundColor: foregroundColor ?? Colors.white,
      textStyle: TextStyle(fontSize: fontSize ?? 16),
    );
  }
}
