import 'dart:ui';
import 'package:feedback/feedback.dart';

class CustomFeedbackLocalizationsDelegate
    extends GlobalFeedbackLocalizationsDelegate {
  @override
  Future<FeedbackLocalizations> load(Locale locale) async {
    return Future.value(
      supportedLocales[locale] ?? CustomFeedbackLocalizations(),
    );
  }
}

class CustomFeedbackLocalizations implements FeedbackLocalizations {
  @override
  String get submitButtonText => "Submit";

  @override
  String get draw => "Draw";

  @override
  String get feedbackDescriptionText => "What's wrong?";

  @override
  String get navigate => "Use App";
}
