import 'package:caffeing/repository/favorite/store/favorite_store_repository.dart';
import 'package:caffeing/repository/keyword/keyword_repository.dart';
import 'package:caffeing/repository/search/search_repository.dart';
import 'package:caffeing/repository/store/store_repository.dart';
import 'package:caffeing/view_model/favorite/store/favorite_store_view_model.dart';
import 'package:caffeing/view_model/keyword/keyword_view_model.dart';
import 'package:caffeing/view_model/map/map_view_model.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:caffeing/view_model/store/selected_store_view_model.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/widgets.dart';
import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/repository/auth/auth_repository.dart';
import 'package:caffeing/view_model/auth/auth_view_model.dart';

import 'package:provider/provider.dart';

class PageProvider {
  static Widget buildProviders({required Widget child}) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(
          lazy: false,
          create:
              (_) => AuthViewModel(
                authRepository: AuthRepository(apiService: ApiService()),
              ),
        ),

        ChangeNotifierProvider<SearchViewModel>(
          create:
              (_) => SearchViewModel(
                searchRepository: SearchRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<KeywordViewModel>(
          create:
              (_) => KeywordViewModel(
                keywordRepository: KeywordRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<StoreViewModel>(
          create:
              (_) => StoreViewModel(
                storeRepository: StoreRepository(apiService: ApiService()),
              ),
        ),
        ChangeNotifierProvider<FavoriteStoreViewModel>(
          create:
              (_) => FavoriteStoreViewModel(
                favoriteStoreRepository: FavoriteStoreRepository(
                  apiService: ApiService(),
                ),
              ),
        ),
        ChangeNotifierProvider<MapViewModel>(create: (_) => MapViewModel()),
        ChangeNotifierProvider<SelectedStoreViewModel>(
          create: (_) => SelectedStoreViewModel(),
        ),
      ],
      child: child,
    );
  }
}
