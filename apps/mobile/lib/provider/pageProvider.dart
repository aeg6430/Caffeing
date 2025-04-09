import 'package:flutter/widgets.dart';
import 'package:Kafein/data/network/api_service.dart';
import 'package:Kafein/repository/auth/auth_repository.dart';
import 'package:Kafein/view_model/auth/auth_view_model.dart';
import 'package:Kafein/view_model/navigation_bar/navigation_bar_view_model.dart';

import 'package:provider/provider.dart';

class PageProvider {
  static buildProviders({
    required BuildContext context,
    required Widget child,
  }) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          lazy: false,
          create:
              (context) => AuthViewModel(
                authRepository: AuthRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<NavigationBarViewModel>(
          create: (context) => NavigationBarViewModel(),
        ),
      ],
      child: child,
    );
  }
}
