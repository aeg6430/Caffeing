import 'package:caffeing/provider/page_provider.dart';
import 'package:caffeing/utils/custom_feedback_localizations.dart';
import 'package:feedback/feedback.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/localization/app_localizations.dart';
import 'package:caffeing/provider/locale_provider.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:caffeing/utils/auth_wrapper.dart';
import 'package:caffeing/utils/env.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.load();
  await Firebase.initializeApp();
  final savedLocale = await AppLocalizations.loadSavedLocale();

  runApp(
    BetterFeedback(
      theme: FeedbackThemeData(sheetIsDraggable: false),
      localizationsDelegates: [CustomFeedbackLocalizationsDelegate()],
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<LocaleProvider>(
            create: (_) => LocaleProvider(savedLocale),
          ),
          ChangeNotifierProvider(create: (_) => AppThemeNotifier()),
        ],
        child: PageProvider.buildProviders(child: App()),
      ),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        final locale = localeProvider.locale;

        return Consumer<AppThemeNotifier>(
          builder: (context, themeNotifier, _) {
            return MaterialApp(
              debugShowCheckedModeBanner: false,
              locale: locale,
              localizationsDelegates: [
                S.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
              ],
              supportedLocales: S.delegate.supportedLocales,
              theme: AppStyles.getTheme(context),
              darkTheme: AppStyles.getDarkTheme(context),
              themeMode: themeNotifier.currentThemeMode,
              home: AuthWrapper(),
            );
          },
        );
      },
    );
  }
}
