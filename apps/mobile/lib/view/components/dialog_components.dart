import 'package:flutter/material.dart';
import 'package:caffeing/res/style/style.dart';

class DialogUtils {
  static Widget showCustomDialog({
    required BuildContext context,
    required double widgetHeight,
    required double widgetWidth,
    Widget? icon,
    String? title,
    Widget? content,
    TextAlign contentTextAlign = TextAlign.center,
    List<Widget>? actions,
  }) {
    return Dialog(
      insetAnimationDuration: const Duration(milliseconds: 500),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: widgetHeight,
          maxWidth: widgetWidth,
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (icon != null) ...[icon, const SizedBox(height: 10)],
              if (title != null)
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                  textAlign: TextAlign.center,
                ),
              if (content != null) ...[
                const SizedBox(height: 15),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: content,
                  ),
                ),
              ],
              if (actions != null && actions.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: actions,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  static void disposeDialog(BuildContext context) {
    Navigator.pop(context);
  }
}
