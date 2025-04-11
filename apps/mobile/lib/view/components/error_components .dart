import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:caffeing/res/style/style.dart';

class ErrorComponents extends StatelessWidget {
  final IconData icon;
  final String message;

  ErrorComponents({required this.icon, required this.message});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: SizedBox(
          height: MediaQuery.of(context).size.height * 0.8,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FaIcon(icon, size: 50, color: Colors.red.shade400),
              SizedBox(height: 12),
              Text(message),
            ],
          ),
        ),
      ),
    );
  }
}
