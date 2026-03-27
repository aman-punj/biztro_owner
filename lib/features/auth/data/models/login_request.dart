class LoginRequest {
  const LoginRequest({
    required this.mobile,
    required this.password,
  });

  final String mobile;
  final String password;

  Map<String, dynamic> toJson() => {
        'Mobile': mobile,
        'Password': password,
      };
}
