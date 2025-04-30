import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  final String text;
  final IconData icon;
  final VoidCallback onTap;

  const SettingsSection({
    required this.text,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Padding(padding: const EdgeInsets.only(right: 8), child: Icon(icon)),
          Text(text),
        ],
      ),
    );
  }
}
