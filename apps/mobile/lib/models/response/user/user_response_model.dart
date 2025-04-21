class User {
  final String id;
  final String name;
  final String email;
  final String role;
  final String token;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
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
