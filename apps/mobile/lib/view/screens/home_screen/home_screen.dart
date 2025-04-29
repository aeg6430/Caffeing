import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/view/screens/favorite/store/favorite_store_screen.dart';
import 'package:caffeing/view/screens/map_screen/map_screen.dart';
import 'package:caffeing/view/screens/settings_screen/settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent_bottom_nav_bar_v2.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PersistentTabController _controller = PersistentTabController(
    initialIndex: 0,
  );

  List<PersistentTabConfig> _tabs(BuildContext context) => [
    PersistentTabConfig(
      screen: MapScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.map),
        title: S.of(context).map,
        activeForegroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: FavoriteStoreScreen(controller: _controller),
      item: ItemConfig(
        icon: const Icon(Icons.favorite),
        title: S.of(context).favorites,
        activeForegroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
    PersistentTabConfig(
      screen: SettingsScreen(),
      item: ItemConfig(
        icon: const Icon(Icons.settings),
        title: S.of(context).settings,
        activeForegroundColor:
            Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : Colors.black,
        inactiveForegroundColor: Colors.grey,
      ),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PersistentTabView(
      tabs: _tabs(context),
      controller: _controller,
      navBarBuilder:
          (navBarConfig) => Style1BottomNavBar(
            navBarConfig: navBarConfig,
            navBarDecoration: NavBarDecoration(color: Colors.transparent),
          ),
      navBarOverlap: NavBarOverlap.full(),
    );
  }
}
