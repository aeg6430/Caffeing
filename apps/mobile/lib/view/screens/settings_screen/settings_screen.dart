import 'package:caffeing/view/components/settings_section.dart';
import 'package:flutter/material.dart';
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
                    SettingsSection(
                      text: S.of(context).checkUpdate,
                      icon: Icons.arrow_circle_down_outlined,
                      onTap: () {
                        VersionUpdater.checkUpdate(context);
                      },
                    ),
                    SettingsSection(
                      text: "Language",
                      icon: Icons.translate,
                      onTap: () {
                        LocalizationDialogHelper.show(context);
                      },
                    ),
                    Consumer<AppThemeNotifier>(
                      builder: (context, themeNotifier, _) {
                        final isDark =
                            themeNotifier.currentThemeMode == ThemeMode.dark;
                        return SettingsSection(
                          text:
                              isDark
                                  ? S.of(context).lightMode
                                  : S.of(context).darkMode,
                          icon:
                              isDark
                                  ? Icons.light_mode_outlined
                                  : Icons.dark_mode_outlined,
                          onTap: () {
                            themeNotifier.updateTheme(
                              isDark ? ThemeColor.Light : ThemeColor.Dark,
                            );
                          },
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
                    SettingsSection(
                      text: S.of(context).supportSendFeedback,
                      icon: Icons.thumb_up_alt_outlined,
                      onTap: () async {},
                    ),
                    SettingsSection(
                      text: S.of(context).supportBugReport,
                      icon: Icons.bug_report_outlined,
                      onTap: () async {},
                    ),
                    SettingsSection(
                      text: S.of(context).supportContactUs,
                      icon: Icons.email_outlined,
                      onTap: () async {},
                    ),
                    Divider(),
                    SettingsSection(
                      text: S.of(context).logout,
                      icon: Icons.logout,
                      onTap: () async {
                        await authViewModel.logoutUser();
                      },
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
