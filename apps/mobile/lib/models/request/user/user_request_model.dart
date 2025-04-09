class UserRequestModel {
  final String userId;
  final String password;

  UserRequestModel({
    required this.userId,
    required this.password,
  });
  Map<String, dynamic> toJson() {
    return {
      'UserId': userId,
      'Password': password,
    };
  }
}
