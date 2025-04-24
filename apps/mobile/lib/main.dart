import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:caffeing/data/local/data_handler.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/localization/AppLocalizations.dart';
import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/provider/pageProvider.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:caffeing/routes/routes.dart';
import 'package:caffeing/utils/auth_wrapper.dart';
import 'package:caffeing/utils/env.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DataHandler.createFolderOnInstall();
  await Env.load();
  await Firebase.initializeApp();
  final savedLocale = await AppLocalizations.loadSavedLocale();

  runApp(
    ChangeNotifierProvider<LocaleProvider>(
      create: (_) => LocaleProvider(savedLocale),
      child: ChangeNotifierProvider(
        create: (_) => AppThemeNotifier(),
        child: App(),
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
              onGenerateRoute: Routes.generateRoute,
              home: PageProvider.buildProviders(
                context: context,
                child: AuthWrapper(),
              ),
            );
          },
        );
      },
    );
  }
}
