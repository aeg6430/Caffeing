import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLocalizations {
  final Locale locale;
  Map<String, String>? _localizedStrings;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  // Load the saved locale from SharedPreferences
  static Future<Locale> loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final savedLocale =
        prefs.getString('selectedLocale') ??
        'en'; // Default to 'en' if not found
    final parts = savedLocale.split('_');
    return Locale(
      parts[0],
      parts.length > 1 ? parts[1] : '',
    ); // Return the Locale
  }

  // Save the selected locale to SharedPreferences
  static Future<void> save(Locale locale) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('selectedLocale', locale.toString());
  }

  // Load localized strings based on the current locale
  Future<void> load() async {
    String jsonString = await rootBundle.loadString(
      'lib/l10n/${locale.languageCode}.json',
    );
    Map<String, dynamic> jsonMap = json.decode(jsonString);

    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
  }

  // Translate the given key
  String translate(String key) {
    // First try to get it from the current language, then fall back to English if not found
    return _localizedStrings?[key] ?? key;
  }

  // Accessor method to get the AppLocalizations instance
  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'zh'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    AppLocalizations localizations = AppLocalizations(locale);
    await localizations.load();
    return localizations;
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
