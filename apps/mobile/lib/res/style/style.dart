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
      primary: Color(0xFFF5AF4E),
      secondary: Color(0xFFFBC076),
      surface: Color(0xFFFFFFFF),
      error: Colors.red,
      onPrimary: Color(0xFF000000),
      onSecondary: Color(0xFF000000),
      onSurface: Color(0xFF000000),
      onError: Colors.white,
    );

    return ThemeData(
      brightness: Brightness.light,
      primaryColor: customColorScheme.primary,
      dividerColor: Color(0xFFDDD1C4),
      scaffoldBackgroundColor: Color(0xFFFFFBFA),
      appBarTheme: AppBarTheme(
        backgroundColor: customColorScheme.primary,
        foregroundColor: customColorScheme.onPrimary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: customColorScheme.primary,
        unselectedItemColor: Color(0xFF717171),
        backgroundColor: Color(0xFFFFFFFF),
      ),
      colorScheme: customColorScheme,
    );
  }

  static ThemeData getDarkTheme(BuildContext context) {
    final darkColorScheme = const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xFFF5AF4E),
      secondary: Color(0xFFFBC076),
      surface: Color(0xFF121212),
      error: Colors.red,
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onSurface: Color(0xFFFFFFFF),
      onError: Color(0xFF000000),
    );

    return ThemeData(
      brightness: Brightness.dark,
      primaryColor: darkColorScheme.primary,
      dividerColor: Color(0xFF504B44),
      scaffoldBackgroundColor: darkColorScheme.surface,
      appBarTheme: AppBarTheme(
        backgroundColor: darkColorScheme.primary,
        foregroundColor: darkColorScheme.onPrimary,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        selectedItemColor: darkColorScheme.primary,
        unselectedItemColor: Color(0xFF8B8B8B),
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
}
