import 'package:get/get.dart';

import '../../../routes/app_routes.dart' show AppRoutes;

enum AuthStage { login, forgotPassword, register, otpVerification }

class AuthController extends GetxController {
  final currentStage = AuthStage.login.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final rememberMe = false.obs;

  final email = ''.obs;
  final password = ''.obs;
  final confirmPassword = ''.obs;
  final businessName = ''.obs;
  final mobile = ''.obs;
  final otp = List<String>.filled(4, '').obs;

  String get stageTitle {
    switch (currentStage.value) {
      case AuthStage.login:
        return 'Sign in to your\nAccount';
      case AuthStage.forgotPassword:
        return 'Forgot\nPassword';
      case AuthStage.register:
        return 'Sign up & Join\nBizrato';
      case AuthStage.otpVerification:
        return 'OTP\nVerification';
    }
  }

  String get stageSubtitle {
    switch (currentStage.value) {
      case AuthStage.login:
        return 'Enter your email/mobile and password to access your business dashboard';
      case AuthStage.forgotPassword:
        return 'Enter your registered email/mobile no. for retrieve password.';
      case AuthStage.register:
        return 'Start your business journey Today';
      case AuthStage.otpVerification:
        return 'We have sent a 4 digit verification code to\n+917104891234';
    }
  }

  void setStage(AuthStage stage) => currentStage.value = stage;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;
  }

  void toggleRememberMe() => rememberMe.value = !rememberMe.value;

  void onEmailChanged(String value) => email.value = value;

  void onPasswordChanged(String value) => password.value = value;

  void onConfirmPasswordChanged(String value) => confirmPassword.value = value;

  void onBusinessNameChanged(String value) => businessName.value = value;

  void onMobileChanged(String value) => mobile.value = value;

  void onOtpChanged(int index, String value) {
    if (index < 0 || index >= otp.length) return;
    otp[index] = value;
  }

  void onSubmit() {
    Get.offNamed(AppRoutes.dashboard);
  }
}
