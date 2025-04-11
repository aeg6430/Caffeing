import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/localeProvider.dart';
import 'package:caffeing/res/style/style.dart';
import 'package:caffeing/view/components/bottom_sheet.dart';
import 'package:caffeing/view/components/custom_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Scaffold(
          body: Stack(
            children: [
              Center(
                child: Image.network(
                  'https://fakeimg.pl/600x600/?text=Hello',
                  fit: BoxFit.fill,
                ),
              ),
              DraggableScrollableSheet(
                initialChildSize: 0.25,
                minChildSize: 0.1,
                maxChildSize: 0.8,
                builder: (
                  BuildContext context,
                  ScrollController scrollController,
                ) {
                  return CustomBottomSheet(scrollController: scrollController);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}
