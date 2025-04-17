import 'package:flutter/material.dart';
import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/provider/bottomNavigationProvider.dart';

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
          Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
      unselectedItemColor:
          Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
      backgroundColor:
          Theme.of(context).bottomNavigationBarTheme.backgroundColor,
      items: [
        BottomNavigationBarItem(
          label: S.of(context).map,
          icon: Icon(size: 30.0, Icons.map),
        ),
        BottomNavigationBarItem(
          label: S.of(context).settings,
          icon: Icon(size: 30.0, Icons.settings),
        ),
      ],
    );
  }
}
