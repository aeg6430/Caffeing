import 'package:caffeing/repository/favorite/store/favorite_store_repository.dart';
import 'package:caffeing/repository/keyword/keyword_repository.dart';
import 'package:caffeing/repository/search/search_repository.dart';
import 'package:caffeing/repository/store/store_repository.dart';
import 'package:caffeing/view_model/favorite/store/favorite_store_view_model.dart';
import 'package:caffeing/view_model/keyword/keyword_view_model.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/repository/auth/auth_repository.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';
import 'package:caffeing/view_model/navigation_bar/navigation_bar_view_model.dart';

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
        ChangeNotifierProvider<SearchViewModel>(
          create:
              (context) => SearchViewModel(
                searchRepository: SearchRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<KeywordViewModel>(
          create:
              (context) => KeywordViewModel(
                keywordRepository: KeywordRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<StoreViewModel>(
          create:
              (context) => StoreViewModel(
                storeRepository: StoreRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<FavoriteStoreViewModel>(
          create:
              (context) => FavoriteStoreViewModel(
                favoriteStoreRepository: FavoriteStoreRepository(
                  apiService: ApiService(),
                ),
              ),
        ),
      ],
      child: child,
    );
  }
}
