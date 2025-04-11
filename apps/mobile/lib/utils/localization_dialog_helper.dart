import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/view/components/dialog_components.dart';

class LocalizationDialogHelper {
  static Future<void> show(BuildContext context) async {
    Locale selectedLocale = LocaleProvider.of(context, listen: false).locale;
    String selectedLanguage = _getLanguageLabel(context, selectedLocale);

    await showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return DialogUtils.showCustomDialog(
              context: dialogContext,
              widgetHeight: 500,
              widgetWidth: 320,
              title: S.of(context).selectLanguage,
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Row(
                    children: [
                      Radio<String>(
                        value: S.of(context).chineseTraditional,
                        groupValue: selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;
                            selectedLocale = Locale('zh');
                          });
                        },
                      ),
                      Text(S.of(context).chineseTraditional),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: S.of(context).english,
                        groupValue: selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;
                            selectedLocale = Locale('en');
                          });
                        },
                      ),
                      Text(S.of(context).english),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: S.of(context).japanese,
                        groupValue: selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;
                            selectedLocale = Locale('ja');
                          });
                        },
                      ),
                      Text(S.of(context).japanese),
                    ],
                  ),
                  Row(
                    children: [
                      Radio<String>(
                        value: S.of(context).korean,
                        groupValue: selectedLanguage,
                        onChanged: (String? value) {
                          setState(() {
                            selectedLanguage = value!;
                            selectedLocale = Locale('ko');
                          });
                        },
                      ),
                      Text(S.of(context).korean),
                    ],
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).cancel),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    LocaleProvider.of(
                      context,
                      listen: false,
                    ).updateLocale(selectedLocale);
                    Navigator.pop(context);
                  },
                  child: Text(S.of(context).confirm),
                ),
              ],
            );
          },
        );
      },
    );
  }

  static String _getLanguageLabel(BuildContext context, Locale locale) {
    if (locale.languageCode == 'zh') {
      return S.of(context).chineseTraditional;
    } else if (locale.languageCode == 'ja') {
      return S.of(context).japanese;
    } else if (locale.languageCode == 'kr') {
      return S.of(context).korean;
    }
    return S.of(context).english;
  }
}
