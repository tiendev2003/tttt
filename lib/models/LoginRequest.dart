class LoginRequest {
  String userID;
  String password;

  LoginRequest({
    required this.userID,
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'userID': userID,
      'password': password,
    };
  }
}
