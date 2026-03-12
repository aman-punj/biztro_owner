import 'package:get/get.dart';

enum AuthStage { login, forgotPassword, register, otpVerification }

class AuthController extends GetxController {
  final currentStage = AuthStage.login.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;

  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final fullName = ''.obs;
  final mobile = ''.obs;
  final otp = List<String>.filled(4, '').obs;

  String get stageTitle {
    switch (currentStage.value) {
      case AuthStage.login:
        return 'Sign in to your account';
      case AuthStage.forgotPassword:
        return 'Forgot Password';
      case AuthStage.register:
        return 'Sign up & Join Biztro';
      case AuthStage.otpVerification:
        return 'OTP Verification';
    }
  }

  String get stageSubtitle {
    switch (currentStage.value) {
      case AuthStage.login:
        return 'Enter your credentials to access your account.';
      case AuthStage.forgotPassword:
        return 'Enter your registered email to reset your password.';
      case AuthStage.register:
        return 'Get your business journey started with Biztro.';
      case AuthStage.otpVerification:
        return 'We sent a 4-digit code to your registered mobile number.';
    }
  }

  void setStage(AuthStage stage) => currentStage.value = stage;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void onEmailChanged(String value) => email.value = value;

  void onPasswordChanged(String value) => password.value = value;

  void onConfirmPasswordChanged(String value) => confirmPassword.value = value;

  void onFullNameChanged(String value) => fullName.value = value;

  void onMobileChanged(String value) => mobile.value = value;

  void onOtpChanged(int index, String value) {
    if (index < 0 || index >= otp.length) return;
    otp[index] = value;
  }

  void onSubmit() {
    // UI only for now. API integration will be added later.
  }
}
