import 'package:app_links/app_links.dart';
import 'package:caffeing/view_model/map/map_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DeepLinkHandler {
  static final _appLinks = AppLinks();
  static late GlobalKey<NavigatorState> _navigatorKey;

  static void initialize(GlobalKey<NavigatorState> navigatorKey) {
    _navigatorKey = navigatorKey;

    _appLinks.getInitialLink().then(_handleUri);
    _appLinks.uriLinkStream.listen(_handleUri);
  }

  static void _handleUri(Uri? uri) {
    if (uri == null) return;

    if (uri.host == 'caffeing.com' &&
        uri.pathSegments.length >= 2 &&
        uri.pathSegments[0] == 'store') {
      final storeId = uri.pathSegments[1];

      final context = _navigatorKey.currentContext;
      if (context != null) {
        final mapVM = Provider.of<MapViewModel>(context, listen: false);
        mapVM.selectStoreById(storeId);
      }
    }
  }
}
