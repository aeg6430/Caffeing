import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class LauncherUtils {
  static Future<void> openMap({
    required BuildContext context,
    String? query,
    double? latitude,
    double? longitude,
  }) async {
    final encodedQuery = Uri.encodeComponent(query ?? '$latitude,$longitude');
    final googleMapsUrl = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$encodedQuery',
    );
    final appleMapsUrl = Uri.parse('http://maps.apple.com/?q=$encodedQuery');

    try {
      if (Platform.isIOS) {
        final canGoogleMaps = await canLaunchUrl(googleMapsUrl);
        final canAppleMaps = await canLaunchUrl(appleMapsUrl);

        if (canGoogleMaps && canAppleMaps) {
          _showChoiceDialog(
            context: context,
            title: 'Open with',
            choices: [
              LauncherChoiceItem(
                tooltip: 'Apple Maps',
                icon: Image.network(
                  'assets/third_party_icons/apple_map_icon.svg',
                  width: 48,
                  height: 48,
                ),
                onTap:
                    () => launchUrl(
                      appleMapsUrl,
                      mode: LaunchMode.externalApplication,
                    ),
              ),
              LauncherChoiceItem(
                tooltip: 'Google Maps',
                icon: SvgPicture.asset(
                  'assets/third_party_icons/google_map_icon.svg',
                  width: 48,
                  height: 48,
                ),
                onTap:
                    () => launchUrl(
                      googleMapsUrl,
                      mode: LaunchMode.externalApplication,
                    ),
              ),
            ],
          );
          return;
        } else if (canGoogleMaps) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
          return;
        } else if (canAppleMaps) {
          await launchUrl(appleMapsUrl, mode: LaunchMode.externalApplication);
          return;
        }
      } else if (Platform.isAndroid) {
        final canGoogleMaps = await canLaunchUrl(googleMapsUrl);

        if (canGoogleMaps) {
          await launchUrl(googleMapsUrl, mode: LaunchMode.externalApplication);
          return;
        } else {
          final playStoreUrl = Uri.parse(
            'https://play.google.com/store/apps/details?id=com.google.android.apps.maps',
          );
          await launchUrl(playStoreUrl, mode: LaunchMode.externalApplication);
          return;
        }
      }

      final appStoreUrl =
          Platform.isIOS
              ? Uri.parse('https://apps.apple.com/app/google-maps/id585027354')
              : Uri.parse(
                'https://play.google.com/store/apps/details?id=com.google.android.apps.maps',
              );

      await launchUrl(appStoreUrl, mode: LaunchMode.externalApplication);
    } catch (e) {
      debugPrint('Error launching map: $e');
    }
  }

  static void _showChoiceDialog({
    required BuildContext context,
    required String title,
    required List<LauncherChoiceItem> choices,
  }) {
    showDialog(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: Text(title),
            content: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:
                  choices.map((choice) {
                    return IconButton(
                      iconSize: 48,
                      tooltip: choice.tooltip,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        choice.onTap();
                      },
                      icon: choice.icon,
                    );
                  }).toList(),
            ),
          ),
    );
  }

  static Future<void> openShare({
    required BuildContext context,
    String? content,
  }) async {
    try {
      final appStoreUrl =
          Platform.isIOS
              ? 'app store link for ios'
              : 'app store like for android';
      final parameter = [
        'See what I got on Caffeing!',
        content ?? '',
        '',
        'Download now:',
        appStoreUrl,
      ].join('\n');
      SharePlus.instance.share(ShareParams(text: parameter));
    } catch (e) {
      debugPrint('Error sharing: $e');
    }
  }

  static Future<void> openEmail({required BuildContext context}) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'caffeingapp@gmail.com',
    );

    try {
      final launched = await launchUrl(
        emailLaunchUri,
        mode: LaunchMode.externalApplication,
      );

      if (!launched) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not launch email app.')));
      }
    } catch (e) {
      debugPrint('Error opening email: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    }
  }

  static Future<void> openThreads({required BuildContext context}) async {
    const username = 'caffe.ing';
    final appUrl = Uri.parse('https://threads.com/@$username');

    try {
      final launchedApp = await launchUrl(
        appUrl,
        mode: LaunchMode.externalApplication,
      );
    } catch (e) {
      debugPrint('Error opening Threads: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    }
  }

  static Future<void> openOfficialSite({required BuildContext context}) async {
    final uri = Uri.parse("https://caffeing.com/suggest");
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open the link.')));
      }
    } catch (e) {
      debugPrint('Error opening URL: $e');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Something went wrong.')));
    }
  }
}

class LauncherChoiceItem {
  final String tooltip;
  final Widget icon;
  final VoidCallback onTap;

  LauncherChoiceItem({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });
}
