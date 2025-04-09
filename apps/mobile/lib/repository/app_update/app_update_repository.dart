import 'package:Kafein/data/network/api_service.dart';
import 'package:Kafein/models/request/app_update/app_update_request_model.dart';

class AppUpdateRepository {
  final ApiService apiService;

  AppUpdateRepository({required this.apiService});

  Future<dynamic> getAppUpdateToken() async {
    return await apiService.getAppUpdateToken();
  }

  Future<dynamic> checkUpdate(AppUpdateRequestModel appUpdate) async {
    return await apiService.checkAppVersion(appUpdate);
  }
}
