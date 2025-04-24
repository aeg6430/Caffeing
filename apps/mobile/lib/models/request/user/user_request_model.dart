class UserRequestModel {
  final String idToken;

  UserRequestModel({required this.idToken});
  Map<String, dynamic> toJson() {
    return {'IdToken': idToken};
  }
}
