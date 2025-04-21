import 'package:flutter/material.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
  }

  Future<void> _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberUser', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.black87,
      body: StreamBuilder<LoginStatus>(
        stream: Provider.of<AuthViewModel>(context).loginStatusStream,
        builder: (context, snapshot) {
          return _buildLoginForm(context, Provider.of<AuthViewModel>(context));
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthViewModel authViewModel) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            'assets/image/logo.png',
            width: MediaQuery.of(context).size.width * 0.6,
          ),
          SizedBox(height: MediaQuery.of(context).size.height * 0.1),
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () async {
                await authViewModel.loginWithGoogle();
                await _saveLoginInfo();
              },
              child: Image.asset(
                'assets/google_signin/light.png',
                width: MediaQuery.of(context).size.width * 0.5,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
