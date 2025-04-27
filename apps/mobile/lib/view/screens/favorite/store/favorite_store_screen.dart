import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/models/request/favorite/store/favorite_store_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/provider/locale_provider.dart';
import 'package:caffeing/view_model/favorite/store/favorite_store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class FavoriteStoreScreen extends StatefulWidget {
  @override
  _FavoriteStoreScreenState createState() => _FavoriteStoreScreenState();
}

class _FavoriteStoreScreenState extends State<FavoriteStoreScreen> {
  late FavoriteStoreViewModel favoriteStoreViewModel;

  @override
  void initState() {
    super.initState();
    favoriteStoreViewModel = Provider.of<FavoriteStoreViewModel>(
      context,
      listen: false,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      favoriteStoreViewModel.getFavoriteStores();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<LocaleProvider>(
      builder: (context, localeProvider, _) {
        return Consumer<FavoriteStoreViewModel>(
          builder: (context, favoriteStoreVM, _) {
            return Scaffold(body: SafeArea(child: _buildBody(favoriteStoreVM)));
          },
        );
      },
    );
  }

  Widget _buildBody(FavoriteStoreViewModel viewModel) {
    switch (viewModel.status) {
      case FavoriteStoreStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case FavoriteStoreStatus.dataAvailable:
        if (viewModel.storeList.isEmpty) {
          return const Center(child: Text('No favorite stores found.'));
        }
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: viewModel.storeList.length,
          itemBuilder: (context, index) {
            final store = viewModel.storeList[index];
            return Card(
              color:
                  Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[850]
                      : Theme.of(context).cardColor,
              margin: const EdgeInsets.only(bottom: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0.5,
              child: ListTile(
                title: Text(store.name),
                subtitle: Text(store.address ?? ''),
                trailing: _buildTrailing(viewModel, store),
                onTap: () {},
              ),
            );
          },
        );
      case FavoriteStoreStatus.dataUnavailable:
        return const Center(child: Text('No favorite stores found.'));
      case FavoriteStoreStatus.error:
        return const Center(
          child: Text('Something went wrong. Please try again.'),
        );
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildTrailing(
    FavoriteStoreViewModel viewModel,
    StoreResponseModel store,
  ) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) {
        if (value == 'share') {
        } else if (value == 'delete') {
          var request = FavoriteStoreRequestModel(storeId: store.storeId);
          viewModel.remove(request);
        }
      },
      itemBuilder: (BuildContext context) {
        return [
          PopupMenuItem<String>(
            value: 'share',
            child: Row(
              children: [
                Icon(Icons.ios_share, size: 20.0),
                SizedBox(width: 8.0),
                Text(S.of(context).share),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'delete',
            child: Row(
              children: [
                Icon(Icons.delete, size: 20.0),
                SizedBox(width: 8.0),
                Text(S.of(context).remove),
              ],
            ),
          ),
        ];
      },
    );
  }
}
