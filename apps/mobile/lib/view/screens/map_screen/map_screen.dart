import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:Kafein/l10n/generated/l10n.dart';
import 'package:Kafein/provider/localeProvider.dart';
import 'package:Kafein/res/style/style.dart';
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
          appBar: AppBar(title: Center(child: Text(S.of(context).map))),
          body: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppStyles.getHorizontalPadding(context, 0.01),
            ),
            child: ListTile(
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [Center(child: Text("MAP HERE"))],
              ),
            ),
          ),
        );
      },
    );
  }
}
