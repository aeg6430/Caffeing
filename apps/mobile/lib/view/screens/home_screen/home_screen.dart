import 'package:caffeing/view/screens/favorite/store/favorite_store_screen.dart';
import 'package:caffeing/view/screens/map_screen/map_screen.dart';
import 'package:caffeing/view/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );
  List<PersistentTabConfig> _tabs() => [
    PersistentTabConfig(
      screen: MapScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.map),
        title: "Map",
        activeForegroundColor: Colors.blue,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: FavoriteStoreScreen(controller: _controller),
      item: ItemConfig(
        icon: const Icon(Icons.favorite),
        title: "Favorites",
        activeForegroundColor: Colors.red,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: SettingsScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        title: "Settings",
        activeForegroundColor: Colors.green,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) => PersistentTabView(
    tabs: _tabs(),
    controller: _controller,
    navBarBuilder:
        (navBarConfig) => Style1BottomNavBar(
          navBarConfig: navBarConfig,
          navBarDecoration: NavBarDecoration(color: Colors.transparent),
        ),
    navBarHeight: 60,
    navBarOverlap: NavBarOverlap.full(),
  );
}
