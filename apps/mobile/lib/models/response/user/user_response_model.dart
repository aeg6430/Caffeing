class User {
  final String userId;
  final String userName;
  final String token;

  User({
    required this.userId,
    required this.userName,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['userId'],
      userName: json['userName'],
      token: json['token'],
    );
  }
}

class UserResponseModel {
  final bool isSuccess;
  final String? message;
  final User? user;

  UserResponseModel({
    required this.isSuccess,
    required this.message,
    required this.user,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      isSuccess: json['isSuccess'],
      message: json['message'],
      user: json['user'] != null ? User.fromJson(json['user']) : null,
    );
  }
}
