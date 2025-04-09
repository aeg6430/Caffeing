import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:Kafein/res/style/style.dart';

class DataLoadingComponents extends StatefulWidget {
  @override
  _DataLoadingComponentsState createState() => _DataLoadingComponentsState();
}

class _DataLoadingComponentsState extends State<DataLoadingComponents> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingFour(
        color: AppStyles.getTheme(context).primaryColor,
        size: 50.0,
      ),
    );
  }
}
