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
    final customColorScheme = const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xFF795548),
      secondary: Color(0xFFA1887F),
      surface: Color(0xFFFFFBFA),
      onSurface: Colors.black,
      onError: Colors.white,
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.black,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: customColorScheme.primary,
      dividerColor: Colors.brown.shade100,
      scaffoldBackgroundColor: Colors.grey.shade50,
      appBarTheme: AppBarTheme(
        backgroundColor: customColorScheme.primary,
        foregroundColor: customColorScheme.onPrimary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: customColorScheme.primary,
        unselectedItemColor: Colors.grey.shade600,
        backgroundColor: customColorScheme.surface,
      ),
      colorScheme: customColorScheme,
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    final darkColorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFF5D4037),
      secondary: Color(0xFFA1887F),
      surface: Color(0xFF121212),
      background: Color(0xFF1E1E1E),
      error: Colors.red,
      onPrimary: Colors.white,
      onSecondary: Colors.white,
      onSurface: Colors.white,
      onBackground: Colors.white,
      onError: Colors.black,
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkColorScheme.primary,
      dividerColor: Colors.grey.shade700,
      scaffoldBackgroundColor: darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: Colors.grey.shade400,
        backgroundColor: darkColorScheme.surface,
      ),
      colorScheme: darkColorScheme,
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
      side: BorderSide(color: foregroundColor ?? Colors.white),
      backgroundColor: backgroundColor,
      foregroundColor: foregroundColor,
      textStyle: TextStyle(fontSize: fontSize ?? 16),
    );
  }
}
