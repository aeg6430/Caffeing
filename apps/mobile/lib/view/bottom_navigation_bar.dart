import 'package:flutter/material.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/bottom_navigation_provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final ValueChanged<int> onTabSelected;
  final int currentIndex;
  final BottomNavigationProvider bottomNavigationProvider;

  const CustomBottomNavigationBar({
    required this.onTabSelected,
    required this.currentIndex,
    required this.bottomNavigationProvider,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: bottomNavigationProvider.currentIndex,
      onTap: (index) {
        onTabSelected(index);
      },
      selectedItemColor:
          Theme.of(context).brightness == Brightness.dark
              ? Colors.white
              : Colors.black,
      items: [
        BottomNavigationBarItem(
          label: S.of(context).map,
          icon: Icon(
            currentIndex == 0 ? Icons.map : Icons.map_outlined,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          label: S.of(context).favorites,
          icon: Icon(
            currentIndex == 1 ? Icons.favorite : Icons.favorite_border,
            size: 30.0,
          ),
        ),
        BottomNavigationBarItem(
          label: S.of(context).settings,
          icon: Icon(
            currentIndex == 2 ? Icons.settings : Icons.settings_outlined,
            size: 30.0,
          ),
        ),
      ],
    );
  }
}
