import 'package:caffeing/models/response/keyword/keyword_response_model.dart';
import 'package:caffeing/repository/keyword/keyword_repository.dart';
import 'package:flutter/material.dart';
import 'package:caffeing/data/network/network_utils.dart';

enum KeywordStatus {
  idle,
  dataAvailable,
  dataUnavailable,
  loading,
  error,
  tokenInvalid,
}

class KeywordViewModel extends ChangeNotifier {
  final KeywordRepository keywordRepository;

  bool _isInternetConnected = false;
  bool _isServerReachable = false;
  bool get isServerReachable => _isServerReachable;
  bool get isInternetConnected => _isInternetConnected;

  KeywordViewModel({required this.keywordRepository});

  KeywordStatus _status = KeywordStatus.idle;
  KeywordStatus get status => _status;

  List<KeywordResponseModel>? _keywords;
  List<KeywordResponseModel>? _keywordOptions;

  List<KeywordResponseModel> get keywords => _keywords ?? [];
  List<KeywordResponseModel> get keywordOptions => _keywordOptions ?? [];

  Future<void> getKeywords() async {
    try {
      _status = KeywordStatus.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _isInternetConnected = await NetworkUtils.isInternetConnected();
      _isServerReachable = await NetworkUtils.isBackendServerReachable();

      if (_isInternetConnected && _isServerReachable) {
        final result = await keywordRepository.getKeywords();

        if (result != null && result.isNotEmpty) {
          _keywords = result;
          _status = KeywordStatus.dataAvailable;
          notifyListeners();
        } else {
          _status = KeywordStatus.dataUnavailable;
          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Error during fetching keyword: $error');
      _status = KeywordStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }

  Future<void> getKeywordsOptions() async {
    try {
      _status = KeywordStatus.loading;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });

      _isInternetConnected = await NetworkUtils.isInternetConnected();
      _isServerReachable = await NetworkUtils.isBackendServerReachable();

      if (_isInternetConnected && _isServerReachable) {
        final result = await keywordRepository.getKeywordsOptions();

        if (result != null && result.isNotEmpty) {
          _keywordOptions = result;
          _status = KeywordStatus.dataAvailable;
          notifyListeners();
        } else {
          _status = KeywordStatus.dataUnavailable;
          notifyListeners();
        }
      }
    } catch (error) {
      debugPrint('Error during fetching keyword options: $error');
      _status = KeywordStatus.error;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        notifyListeners();
      });
    }
  }
}
