import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SearchSuggestionList extends StatelessWidget {
  final bool isLoading;
  final List<StoreResponseModel> searchResults;
  final void Function(StoreResponseModel) onStoreSelected;

  const SearchSuggestionList({
    Key? key,
    required this.isLoading,
    required this.searchResults,
    required this.onStoreSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.sizeOf(context).width * 0.95,
      child: Container(
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(6),
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        width: MediaQuery.sizeOf(context).width * 0.95,
        child:
            isLoading
                ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Center(child: LinearProgressIndicator()),
                )
                : searchResults.isEmpty
                ? Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(S.of(context).noResultsFound),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  itemCount: searchResults.length,
                  itemBuilder: (context, index) {
                    final store = searchResults[index];
                    return ListTile(
                      title: Text(store.name ?? 'Unnamed Store'),
                      onTap: () => onStoreSelected(store),
                    );
                  },
                ),
      ),
    );
  }
}
