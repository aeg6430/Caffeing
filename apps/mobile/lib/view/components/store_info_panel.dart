import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/view_model/store/store_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

class StoreInfoPanel extends StatelessWidget {
  const StoreInfoPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<StoreViewModel>(
      builder: (context, storeViewModel, _) {
        final store = storeViewModel.data;

        if (storeViewModel.status == StoreStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (store == null) {
          return const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No store selected."),
          );
        }
        return SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${store.name}",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "${store.address ?? S.of(context).unavailable}",
                  style: const TextStyle(fontSize: 16),
                ),
                SizedBox(height: 8),
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
                    softWrap: true,
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(8),
                  /*decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey), 
                    borderRadius: BorderRadius.circular(8),
                  ),*/
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
