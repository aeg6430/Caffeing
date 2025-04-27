import 'package:caffeing/view/screens/favorite/store/favorite_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/provider/bottom_navigation_provider.dart';
import 'package:caffeing/view/bottom_navigation_bar.dart';
import 'package:caffeing/view/screens/map_screen/map_screen.dart';
import 'package:caffeing/view/screens/settings_screen/settings_screen.dart';

class HomeScreen extends StatefulWidget {
  final int initialIndex;

  const HomeScreen({
    this.initialIndex = 0,
    required BottomNavigationProvider bottomNavigationProvider,
  });

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  late BottomNavigationProvider _bottomNavigationProvider;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _bottomNavigationProvider = BottomNavigationProvider();
  }

  @override
  Widget build(BuildContext context) {
    final screens = [MapScreen(), FavoriteStoreScreen(), SettingsScreen()];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: screens),
      bottomNavigationBar: CustomBottomNavigationBar(
        onTabSelected: (index) {
          setState(() {
            _currentIndex = index;
            _bottomNavigationProvider.currentIndex = index;
          });
        },
        currentIndex: _currentIndex,
        bottomNavigationProvider: _bottomNavigationProvider,
      ),
    );
  }
}
