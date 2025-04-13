import 'package:caffeing/models/request/search/search_request_model.dart';
import 'package:caffeing/models/response/store/store_response_model.dart';
import 'package:caffeing/view/components/dialog_components.dart';
import 'package:caffeing/view/components/search_suggestions_list.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final SearchViewModel searchViewModel;
  final Function(StoreResponseModel) onSelected;

  const SearchBarWidget({
    Key? key,
    required this.searchViewModel,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<StoreResponseModel> _searchResults = [];
  bool _showSuggestions = false;
  bool _isLoading = false;

  Future<void> _onQueryChanged(String query) async {
    if (query.isEmpty) {
      setState(() {
        _searchResults = [];
        _showSuggestions = false;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _showSuggestions = true;
    });

    try {
      final request = SearchRequestModel(query: query, keywordIds: []);
      final result = await widget.searchViewModel.search(request);
      setState(() {
        _searchResults = result.search?.stores ?? [];
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _onStoreSelected(StoreResponseModel store) {
    widget.onSelected(store);
    _controller.clear();
    setState(() {
      _searchResults = [];
      _showSuggestions = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width * 0.95,
            child: SearchBar(
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              controller: _controller,
              hintText: 'Search for a store',
              onChanged: _onQueryChanged,
              leading: IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogUtils.showCustomDialog(
                        context: context,
                        widgetHeight: MediaQuery.sizeOf(context).height * 0.45,
                        widgetWidth: MediaQuery.sizeOf(context).width * 0.9,
                        title: 'Filter Options',
                        content: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CheckboxListTile(
                              title: Text('Filter by Category'),
                              value: true,
                              onChanged: (bool? value) {},
                            ),
                          ],
                        ),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Close'),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: Text('Apply'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              trailing: [
                if (_controller.text.isNotEmpty)
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _controller.clear();
                      setState(() {
                        _searchResults = [];
                        _showSuggestions = false;
                      });
                    },
                  ),
              ],
            ),
          ),
        ),
        if (_showSuggestions)
          SearchSuggestionList(
            isLoading: _isLoading,
            searchResults: _searchResults,
            onStoreSelected: _onStoreSelected,
          ),
      ],
    );
  }
}
