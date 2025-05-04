import 'package:caffeing/view/screens/home_screen/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/view/screens/auth_screen/auth_screen.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';

class AuthWrapper extends StatefulWidget {
  const AuthWrapper({super.key});

  @override
  State<AuthWrapper> createState() => _AuthWrapperState();
}

class _AuthWrapperState extends State<AuthWrapper> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthViewModel>(
      builder: (context, authViewModel, _) {
        if (authViewModel.loginStatus == LoginStatus.authorized) {
          return HomeScreen();
        } else {
          return AuthScreen();
        }
      },
    );
  }
}
