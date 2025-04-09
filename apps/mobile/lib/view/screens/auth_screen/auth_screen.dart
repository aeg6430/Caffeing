import 'package:flutter/material.dart';
import 'package:Kafein/models/request/user/user_request_model.dart';
import 'package:Kafein/res/style/style.dart';
import 'package:Kafein/view_model/auth/auth_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final TextEditingController _idController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _idController.text = prefs.getString('userId') ?? '';
      _passwordController.text = prefs.getString('password') ?? '';
      _rememberMe = prefs.getBool('rememberMe') ?? false;
    });
  }

  Future<void> _saveLoginInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    if (_rememberMe) {
      prefs.setString('userId', _idController.text);
      prefs.setString('password', _passwordController.text);
      prefs.setBool('rememberMe', _rememberMe);
    } else {
      prefs.remove('userId');
      prefs.remove('password');
      prefs.remove('rememberMe');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<LoginStatus>(
        stream: Provider.of<AuthViewModel>(context).loginStatusStream,
        builder: (context, snapshot) {
          return _buildLoginForm(context, Provider.of<AuthViewModel>(context));
        },
      ),
    );
  }

  Widget _buildLoginForm(BuildContext context, AuthViewModel authViewModel) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: AppStyles.getHorizontalPadding(context, 0.1),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(vertical: 25),
            child: Image.asset(
              'assets/image/logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _idController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusColor: AppStyles.getTheme(context).focusColor,
              labelText: '輸入使用者名稱',
            ),
            keyboardType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請輸入使用者名稱';
              } else if (authViewModel.loginStatus ==
                  LoginStatus.userNotFound) {
                return '使用者名稱不存在';
              }
              return null;
            },
          ),
          const SizedBox(height: 10),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordController,
            decoration: InputDecoration(
              border: const OutlineInputBorder(),
              focusColor: AppStyles.getTheme(context).focusColor,
              labelText: '輸入密碼',
            ),
            keyboardType: TextInputType.text,
            obscureText: true,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '請輸入密碼';
              } else if (authViewModel.loginStatus ==
                  LoginStatus.passwordMismatch) {
                return '密碼錯誤';
              }
              return null;
            },
          ),
          Row(
            children: [
              Checkbox(
                value: _rememberMe,
                onChanged: (bool? value) {
                  setState(() {
                    _rememberMe = value ?? false;
                  });
                },
              ),
              Text('記住登入資訊'),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () async {
              final userModel = UserRequestModel(
                userId: _idController.text,
                password: _passwordController.text,
              );
              await authViewModel.loginUser(
                userModel.userId,
                userModel.password,
              );
              await _saveLoginInfo();
            },
            child: const Text('登入'),
          ),
        ],
      ),
    );
  }
}
