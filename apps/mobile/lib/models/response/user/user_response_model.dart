class UserResponseModel {
  final String userId;
  final String name;
  final String email;
  final String role;
  final String token;

  UserResponseModel({
    required this.userId,
    required this.name,
    required this.email,
    required this.role,
    required this.token,
  });

  factory UserResponseModel.fromJson(Map<String, dynamic> json) {
    return UserResponseModel(
      userId: json['userId'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }
}
