import 'package:flutter/widgets.dart';
import 'package:caffeing/localization/app_localizations.dart';
import 'package:provider/provider.dart';

class LocaleProvider extends ChangeNotifier {
  Locale _locale;

  LocaleProvider(this._locale);

  Locale get locale => _locale;

  void updateLocale(Locale newLocale) {
    if (_locale != newLocale) {
      _locale = newLocale;
      notifyListeners(); // Notify all listeners about the locale change
      AppLocalizations.save(newLocale); // Save the new locale
    }
  }

  static LocaleProvider of(BuildContext context, {bool listen = false}) {
    return Provider.of<LocaleProvider>(context, listen: listen);
  }
}
