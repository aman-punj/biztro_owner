class OtpVerificationRequest {
  const OtpVerificationRequest({
    required this.mobile,
    required this.otp,
  });

  final String mobile;
  final String otp;

  Map<String, dynamic> toJson() => {
        'Mobile': mobile,
        'Otp': otp,
      };
}
