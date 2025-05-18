import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/utils/launcher_utils.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool _agreedToPrivacy = false;

  @override
  void initState() {
    super.initState();
    _loadLoginInfo();
  }

  Future<void> _loadLoginInfo() async {
    await SharedPreferences.getInstance();
  }

  Future<void> _saveLoginInfo() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('rememberUser', true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
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
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/image/logo.png',
              width: MediaQuery.of(context).size.width * 0.6,
              fit: BoxFit.contain,
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.08),
            Container(
              width: MediaQuery.of(context).size.width * 0.6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  GoogleSignInButton(
                    agreedToPrivacy: _agreedToPrivacy,
                    onSuccess: () async {
                      await authViewModel.loginWithGoogle();
                      await _saveLoginInfo();
                    },
                  ),
                  SizedBox(height: 12),
                  PrivacyAgreementCheckbox(
                    value: _agreedToPrivacy,
                    onChanged: (value) {
                      setState(() {
                        _agreedToPrivacy = value ?? false;
                      });
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class GoogleSignInButton extends StatelessWidget {
  final bool agreedToPrivacy;
  final VoidCallback onSuccess;

  const GoogleSignInButton({
    required this.agreedToPrivacy,
    required this.onSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap:
            agreedToPrivacy
                ? onSuccess
                : () {
                  final isDarkMode =
                      Theme.of(context).brightness == Brightness.dark;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        S.of(context).privacyPolicyRequired,
                        style: TextStyle(color: Colors.white),
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                },
        child: SizedBox(
          width: double.infinity,
          height: 48,
          child: SvgPicture.asset(
            'assets/google_signin/light.svg',
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}

class PrivacyAgreementCheckbox extends StatelessWidget {
  final bool value;
  final ValueChanged<bool?> onChanged;

  const PrivacyAgreementCheckbox({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: Colors.white,
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.all(Colors.white),
          checkColor: WidgetStateProperty.all(Colors.black),
        ),
      ),
      child: CheckboxListTile(
        value: value,
        onChanged: onChanged,
        contentPadding: EdgeInsets.zero,
        controlAffinity: ListTileControlAffinity.leading,
        title: GestureDetector(
          onTap: () => LauncherUtils.openAppPrivacy(context: context),
          child: Text(
            S.of(context).privacyPolicyAgreement,
            style: TextStyle(color: Colors.blue),
          ),
        ),
      ),
    );
  }
}
