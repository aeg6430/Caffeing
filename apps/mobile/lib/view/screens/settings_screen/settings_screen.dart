import 'package:caffeing/utils/launcher_utils.dart';
import 'package:caffeing/view/components/settings_section.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:feedback_github/feedback_github.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/locale_provider.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:caffeing/utils/localization_dialog_helper.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:uuid/uuid.dart';

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
                      text: S.of(context).supportRecommendCafe,
                      icon: Icons.thumb_up_alt_outlined,
                      onTap: () async {
                        LauncherUtils.openOfficialSite(context: context);
                      },
                    ),
                    SettingsSection(
                      text: S.of(context).supportBugReport,
                      icon: Icons.bug_report_outlined,
                      onTap: () async {
                        final guid = Uuid().v4();
                        final imageRef = FirebaseStorage.instance.ref(
                          "feedback_images/screenshot_$guid.jpg",
                        );
                        final config = await getGithubConfig();
                        BetterFeedback.of(context).showAndUploadToGitHub(
                          repoUrl: config['repo'] ?? "",
                          gitHubToken: config['token'] ?? "",
                          allowEmptyText: false,
                          labels: ['bug'],
                          packageInfo: true,
                          deviceInfo: true,
                          imageRef: imageRef,
                          onError: (error) {
                            print("failed :/ $error");
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(S.of(context).bugReportFailed),
                              ),
                            );
                          },
                        );
                      },
                    ),
                    Text(
                      S.of(context).bugReportLimit,
                      style: TextStyle(fontSize: 14, color: Colors.grey),
                      softWrap: true,
                      overflow: TextOverflow.visible,
                    ),
                    SettingsSection(
                      text: S.of(context).supportContactUs,
                      icon: Icons.email_outlined,
                      onTap: () async {
                        LauncherUtils.openEmail(context: context);
                      },
                    ),
                    SettingsSection(
                      text: "Threads",
                      icon: FontAwesomeIcons.threads,
                      onTap: () async {
                        LauncherUtils.openThreads(context: context);
                      },
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

  Future<Map<String, String>> getGithubConfig() async {
    try {
      final HttpsCallable callable = FirebaseFunctions.instance.httpsCallable(
        'getGithubConfig',
      );
      final response = await callable.call();
      final token = response.data['token'] ?? '';
      final repo = response.data['repo'] ?? '';
      return {'token': response.data['token'], 'repo': response.data['repo']};
    } catch (e) {
      debugPrint('Error fetching GitHub config: $e');
      return {};
    }
  }
}
