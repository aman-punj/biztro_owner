class SignupRequest {
  const SignupRequest({
    required this.outletName,
    required this.email,
    required this.mobile,
    required this.password,
    this.confirmPassword,
    this.authorize = false,
  });

  final String outletName;
  final String email;
  final String mobile;
  final String password;
  final String? confirmPassword;
  final bool authorize;

  Map<String, dynamic> toJson() => {
        'OutletName': outletName,
        'Email': email,
        'Mobile': mobile,
        'Password': password,
        'ConfirmPassword': confirmPassword,
        'Authorize': authorize,
      }..removeWhere((_, value) => value == null);
}
