import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/locale_provider.dart';
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
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.getHorizontalPadding(context, 0.05),
            ),
            child: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 5, bottom: 5),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Hi, ${authViewModel.currentUserName ?? S.of(context).guest}',
                      style: TextStyle(
                        fontSize: 25,
                        color:
                            Theme.of(context).brightness == Brightness.dark
                                ? Colors.white70
                                : Colors.black87,
                      ),
                    ),
                  ),
                ),
                Wrap(
                  direction: Axis.vertical,
                  spacing: MediaQuery.of(context).size.height * 0.01,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        S.of(context).settings,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        VersionUpdater.checkUpdate(context);
                      },
                      child: Expanded(
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
                    ),
                    InkWell(
                      onTap: () {
                        LocalizationDialogHelper.show(context);
                      },
                      child: Expanded(
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
                    ),
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
                          child: Expanded(
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
                          ),
                        );
                      },
                    ),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(top: 16, bottom: 8),
                      child: Text(
                        S.of(context).supportTitle,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color:
                              Theme.of(context).brightness == Brightness.dark
                                  ? Colors.white70
                                  : Colors.black87,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FaIcon(FontAwesomeIcons.envelope),
                            ),
                            Text(S.of(context).supportSendFeedback),
                          ],
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Padding(
                            padding: EdgeInsets.only(right: 8),
                            child: FaIcon(FontAwesomeIcons.bug),
                          ),
                          Text(S.of(context).supportBugReport),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () async {},
                      child: Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(right: 8),
                              child: FaIcon(FontAwesomeIcons.comment),
                            ),
                            Text(S.of(context).supportContactUs),
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    InkWell(
                      onTap: () async {
                        await authViewModel.logoutUser();
                      },
                      child: Expanded(
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
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
