import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:caffeing/utils/localization_dialog_helper.dart';
import 'package:caffeing/utils/version_updater_utils.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context);
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Scaffold(
          appBar: AppBar(title: Center(child: Text(S.of(context).settings))),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.getHorizontalPadding(context, 0.01),
            ),
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        'Hi, ${authViewModel.currentUserName ?? S.of(context).guest}',
                        style: const TextStyle(fontSize: 25),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      VersionUpdater.checkUpdate(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FaIcon(FontAwesomeIcons.circleArrowUp),
                        ),
                        Text(S.of(context).checkUpdate),
                      ],
                    ),
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () {
                      LocalizationDialogHelper.show(context);
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: Icon(Icons.translate),
                        ),
                        Text("Language"),
                      ],
                    ),
                  ),
                  const Divider(),
                  Consumer<AppThemeNotifier>(
                    builder: (context, themeNotifier, _) {
                      final isDark =
                          themeNotifier.currentThemeMode == ThemeMode.dark;
                      return InkWell(
                        onTap: () {
                          themeNotifier.updateTheme(
                            isDark ? ThemeColor.Light : ThemeColor.Dark,
                          );
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child:
                                  isDark
                                      ? Icon(Icons.light_mode)
                                      : Icon(Icons.dark_mode),
                            ),
                            isDark
                                ? Text(S.of(context).lightMode)
                                : Text(S.of(context).darkMode),
                          ],
                        ),
                      );
                    },
                  ),
                  const Divider(),
                  InkWell(
                    onTap: () async {
                      await authViewModel.logoutUser();
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.only(right: 8),
                          child: FaIcon(FontAwesomeIcons.rightFromBracket),
                        ),
                        Text(S.of(context).logout),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
