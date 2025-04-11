import 'package:caffeing/data/network/api_service.dart';
import 'package:caffeing/models/request/user/user_request_model.dart';
import 'package:caffeing/models/response/user/user_response_model.dart';
import 'package:caffeing/utils/token_utils.dart';

class AuthRepository {
  final ApiService apiService;

  AuthRepository({required this.apiService});

  Future<UserResponseModel?> loginUser(UserRequestModel user) async {
    final UserResponseModel? response = await apiService.loginUser(user);
    if (response!.user != null) {
      await TokenUtils.setAuthToken(
        response.user!.userId,
        response.user!.userName,
        response.user!.token,
      );
    }
    return response;
  }

  Future<UserResponseModel?> logoutUser() async {
    await TokenUtils.deleteAuthToken();
  }
}
