import 'package:caffeing/models/request/search/search_request_model.dart';
import 'package:caffeing/models/response/search/search_response_model.dart';
import 'package:caffeing/models/response/store/store_summary_response_model.dart';
import 'package:caffeing/repository/search/search_repository.dart';
import 'package:caffeing/view_model/search/search_result.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/data/network/network_utils.dart';

enum SearchStatus {
  idle,
  dataAvailable,
  dataUnavailable,
  loading,
  error,
  tokenInvalid,
}

class SearchViewModel extends ChangeNotifier {
  final SearchRepository searchRepository;

  bool _isInternetConnected = false;
  bool _isServerReachable = false;
  bool get isServerReachable => _isServerReachable;
  bool get isInternetConnected => _isInternetConnected;

  SearchStatus _status = SearchStatus.idle;
  SearchStatus get status => _status;

  SearchResponseModel? _data;
  SearchResponseModel? get data => _data;

  List<StoreSummaryResponseModel> _searchResults = [];
  List<StoreSummaryResponseModel> get searchResults => _searchResults;

  SearchViewModel({required this.searchRepository});

  Future<SearchResult> search(SearchRequestModel searchRequest) async {
    try {
      _status = SearchStatus.loading;
      notifyListeners();

      _isInternetConnected = await NetworkUtils.isInternetConnected();
      _isServerReachable = await NetworkUtils.isBackendServerReachable();

      if (_isInternetConnected && _isServerReachable) {
        final searchResult = await searchRepository.search(searchRequest);
        if (searchResult != null) {
          _status = SearchStatus.dataAvailable;
          _data = searchResult;
          _searchResults = searchResult.stores ?? [];
          return SearchResult(search: searchResult);
        } else {
          _status = SearchStatus.dataUnavailable;
          _searchResults = [];
        }
      }
    } catch (error) {
      debugPrint('Error during searching: $error');
      _status = SearchStatus.error;
      _searchResults = [];
      return SearchResult();
    } finally {
      notifyListeners();
    }
    return SearchResult();
  }

  void clearSearchResults() {
    _searchResults = [];
    notifyListeners();
  }
}
