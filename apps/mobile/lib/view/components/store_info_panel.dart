import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/models/request/favorite/store/favorite_store_request_model.dart';
import 'package:caffeing/view_model/favorite/store/favorite_store_view_model.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StoreInfoPanel extends StatefulWidget {
  const StoreInfoPanel({super.key});

  @override
  State<StoreInfoPanel> createState() => _StoreInfoPanelState();
}

class _StoreInfoPanelState extends State<StoreInfoPanel> {
  bool _isLoadingFavorite = false;

  Future<void> _loadFavoriteStatus() async {
    if (_isLoadingFavorite) return;
    _isLoadingFavorite = true;
    final favoriteVM = context.read<FavoriteStoreViewModel>();
    await favoriteVM.getFavoriteStores();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadFavoriteStatus();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<StoreViewModel, FavoriteStoreViewModel>(
      builder: (context, storeViewModel, favoriteVM, _) {
        final store = storeViewModel.storeByRequestData;

        if (storeViewModel.status == StoreStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (store == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No store selected."),
          );
        }

        final isFavorite = favoriteVM.storeList.any(
          (s) => s.storeId == store.storeId,
        );

        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Optimistic UI update for the heart icon
                    IconButton(
                      icon: Icon(
                        isFavorite ? Icons.favorite : Icons.favorite_border,
                        color: isFavorite ? Colors.red : Colors.grey,
                      ),
                      onPressed: () async {
                        // Optimistically change the favorite status in UI immediately
                        final request = FavoriteStoreRequestModel(
                          storeId: store.storeId,
                        );
                        bool wasFavorite = isFavorite; // Save current state
                        try {
                          // Temporarily update the favorite list UI
                          if (wasFavorite) {
                            favoriteVM.remove(request);
                          } else {
                            favoriteVM.add(request);
                          }

                          // Perform the API call in the background
                          if (wasFavorite) {
                            await favoriteVM.remove(request);
                          } else {
                            await favoriteVM.add(request);
                          }
                        } catch (e) {
                          debugPrint('Error toggling favorite: $e');
                          // Optional: Revert the UI if the API call fails
                          if (wasFavorite) {
                            favoriteVM.add(request);
                          } else {
                            favoriteVM.remove(request);
                          }
                        } finally {
                          // Always reload the favorite status after action
                          await _loadFavoriteStatus();
                        }
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  store.address ?? S.of(context).unavailable,
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    store.businessHours ?? S.of(context).unavailable,
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        store.keywords.map((keyword) {
                          return Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(keyword.keywordName),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
