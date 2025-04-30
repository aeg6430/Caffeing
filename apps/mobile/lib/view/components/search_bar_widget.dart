import 'package:caffeing/l10n/generated/l10n.dart';
import 'package:caffeing/models/request/search/search_request_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:caffeing/view/components/dialog_components.dart';
import 'package:caffeing/view/components/search_suggestions_list.dart';
import 'package:caffeing/view_model/keyword/keyword_view_model.dart';
import 'package:caffeing/view_model/search/search_view_model.dart';
import 'package:flutter/material.dart';

class SearchBarWidget extends StatefulWidget {
  final SearchViewModel searchViewModel;
  final KeywordViewModel keywordViewModel;
  final Function(StoreSummaryResponseModel) onSelected;

  const SearchBarWidget({
    Key? key,
    required this.searchViewModel,
    required this.keywordViewModel,
    required this.onSelected,
  }) : super(key: key);

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> _selectedKeywords = [];

  List<StoreSummaryResponseModel> _searchResults = [];
  bool _showSuggestions = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    widget.keywordViewModel.getKeywordsOptions();
  }

  Future<void> _onQueryChanged(String query) async {
    final hasQuery = query.isNotEmpty;
    final hasKeywords = _selectedKeywords.isNotEmpty;

    if (!hasQuery && !hasKeywords) {
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
      final request = SearchRequestModel(
        query: query,
        keywordIds: _selectedKeywords,
      );
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

  void _onStoreSelected(StoreSummaryResponseModel store) {
    widget.onSelected(store);
    _controller.clear();
    setState(() {
      _searchResults = [];
      _showSuggestions = false;
    });
  }

  void _showFilterDialog() async {
    await widget.keywordViewModel.getKeywordsOptions();

    if (widget.keywordViewModel.keywordOptions.isNotEmpty) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          List<String> tempSelected = List.from(_selectedKeywords);

          return DialogUtils.showCustomDialog(
            context: context,
            widgetHeight: MediaQuery.sizeOf(context).height * 0.45,
            widgetWidth: MediaQuery.sizeOf(context).width,
            content: StatefulBuilder(
              builder: (context, setStateDialog) {
                return SingleChildScrollView(
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children:
                        widget.keywordViewModel.keywordOptions.map((keyword) {
                          final isSelected = tempSelected.contains(
                            keyword.keywordId,
                          );
                          return FilterChip(
                            showCheckmark: false,
                            label: Text(
                              keyword.keywordName,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                color:
                                    isSelected
                                        ? Theme.of(context).colorScheme.primary
                                        : Theme.of(
                                          context,
                                        ).colorScheme.secondary,
                              ),
                            ),
                            selected: isSelected,
                            onSelected: (bool selected) {
                              setStateDialog(() {
                                if (selected) {
                                  tempSelected.add(keyword.keywordId);
                                } else {
                                  tempSelected.remove(keyword.keywordId);
                                }
                              });
                            },
                            selectedColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.white
                                    : Theme.of(context).colorScheme.primary
                                        .withValues(alpha: 0.2),
                            backgroundColor:
                                Theme.of(context).brightness == Brightness.dark
                                    ? Colors.grey.withValues(alpha: 0.3)
                                    : Colors.grey.shade200,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                              side: BorderSide(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primary.withValues(alpha: 0),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                );
              },
            ),
            actions: [
              OutlinedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: OutlinedButton.styleFrom(
                  foregroundColor:
                      Theme.of(context).brightness == Brightness.dark
                          ? Theme.of(context).colorScheme.onSurface
                          : Theme.of(context).colorScheme.primary,
                  side: BorderSide(
                    color:
                        Theme.of(context).brightness == Brightness.dark
                            ? Theme.of(context).colorScheme.outline
                            : Theme.of(context).colorScheme.primary,
                  ),
                ),
                child: Text(S.of(context).cancel),
              ),
              const SizedBox(width: 12),
              FilledButton(
                onPressed: () {
                  setState(() {
                    _selectedKeywords.clear();
                    _selectedKeywords.addAll(tempSelected);
                  });
                  _onQueryChanged(_controller.text);
                  Navigator.of(context).pop();
                },
                child: Text(S.of(context).confirm),
              ),
            ],
          );
        },
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No filter options available")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
            width: MediaQuery.sizeOf(context).width,
            child: SearchBar(
              elevation: WidgetStateProperty.all(0),
              shape: WidgetStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
              ),
              backgroundColor: WidgetStateProperty.all(
                Theme.of(context).colorScheme.surfaceContainerHighest,
              ),
              controller: _controller,
              hintText: S.of(context).search,
              onChanged: _onQueryChanged,
              leading: IconButton(
                icon: Icon(Icons.filter_alt_outlined),
                onPressed: _showFilterDialog,
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
