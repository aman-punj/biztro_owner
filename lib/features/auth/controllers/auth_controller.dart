import 'package:bizrato_owner/core/app_toast/app_toast_service.dart';
import 'package:bizrato_owner/core/app_toast/app_toast_service_extension.dart';
import 'package:bizrato_owner/core/network/app_response.dart';
import 'package:bizrato_owner/core/services/notification_service.dart';
import 'package:bizrato_owner/features/auth/data/auth_repository.dart';
import 'package:bizrato_owner/features/auth/data/models/login_request.dart';
import 'package:bizrato_owner/features/auth/data/models/otp_verification_request.dart';
import 'package:bizrato_owner/features/auth/data/models/signup_request.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
import 'package:get/get.dart';

enum AuthStage { login, forgotPassword, register, otpVerification }

class AuthController extends GetxController {
  AuthController({required this.authRepository});

  final AuthRepository authRepository;

  final currentStage = AuthStage.login.obs;
  final isPasswordHidden = true.obs;
  final isConfirmPasswordHidden = true.obs;
  final rememberMe = false.obs;

  final email = ''.obs;
  final password = ''.obs;
  final businessName = ''.obs;
  final confirmPassword = ''.obs;
  final mobile = ''.obs;
  final otp = List<String>.filled(4, '').obs;

  final isSubmitting = false.obs;
  final formError = ''.obs;
  final infoMessage = ''.obs;
  final otpMobileNumber = ''.obs;
  final pendingSignupRequest = Rxn<SignupRequest>();

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
        final masked = otpMobileNumber.value.isNotEmpty
            ? '+91${otpMobileNumber.value}'
            : _sanitizeMobile(mobile.value).isNotEmpty
                ? '+91${_sanitizeMobile(mobile.value)}'
                : 'your registered mobile';
        return 'We have sent a 4 digit verification code to\n$masked';
    }
  }

  void setStage(AuthStage stage) {
    currentStage.value = stage;
    _clearError();
    _clearInfo();
    otp.assignAll(List<String>.filled(4, ''));
  }

  void togglePasswordVisibility() => isPasswordHidden.value = !isPasswordHidden.value;

  void toggleConfirmPasswordVisibility() =>
      isConfirmPasswordHidden.value = !isConfirmPasswordHidden.value;

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

  Future<void> onSubmit() async {
    isSubmitting.value =true;
    _clearError();
    _clearInfo();
    switch (currentStage.value) {
      case AuthStage.login:
        await _handleLogin();
        break;
      case AuthStage.register:
        await _handleRegister();
        break;
      case AuthStage.otpVerification:
        await _handleOtpVerification();
        break;
      case AuthStage.forgotPassword:
        _setError('Forgot password flow is not yet connected.');
        break;
    }
    isSubmitting.value =false;
  }

  Future<void> resendOtp() async {
    _clearError();
    _clearInfo();
    final request = pendingSignupRequest.value;
    if (request == null) {
      _setError('Please complete the signup first to receive an OTP.');
      return;
    }

    final success = await _perform(() async => await _sendSignupOtp(request));
    if (!success) return;
    _setInfo('OTP resent to +91${request.mobile}');
  }

  Future<void> _handleLogin() async {
    final mobileValue = _sanitizeMobile(email.value);
    if (!_isValidMobile(mobileValue)) {
      _setError('Please enter a valid 10-digit mobile number.');
      return;
    }

    final passwordValue = password.value.trim();
    if (passwordValue.isEmpty) {
      _setError('Password cannot be empty.');
      return;
    }

    final response = await authRepository.login(
      LoginRequest(mobile: mobileValue, password: passwordValue),
    );

    if (!response.success) {
      _setError(response.message);
      return;
    }

    final user = response.data;
    if (user == null) {
      _setError('Login succeeded but user data is unavailable.');
      return;
    }

    Get.find<NotificationService>().uploadToken();

    if (user.businessProfileStep >= 3) {
      Get.offAllNamed(AppRoutes.dashboard);
      return;
    }

    Get.offNamed(
      AppRoutes.onboarding,
      arguments: {
        'businessName': user.outletName,
        'User': user.toJson(),
      },
    );
  }

  Future<void> _handleRegister() async {
    final name = businessName.value.trim();
    if (name.isEmpty) {
      _setError('Business name is required.');
      return;
    }

    final emailValue = email.value.trim();
    if (!_isValidEmail(emailValue)) {
      _setError('Please enter a valid email address.');
      return;
    }

    final mobileValue = otpMobileNumber.value.isNotEmpty
        ? otpMobileNumber.value
        : _sanitizeMobile(mobile.value);
    if (!_isValidMobile(mobileValue)) {
      _setError('Please provide a valid 10-digit mobile number.');
      return;
    }

    final passwordValue = password.value.trim();
    final confirmValue = confirmPassword.value.trim();
    if (!_isValidPassword(passwordValue)) {
      _setError('Password must be between 6 and 20 characters.');
      return;
    }

    if (passwordValue != confirmValue) {
      _setError('Password and confirm password does not match.');
      return;
    }

    final request = SignupRequest(
      outletName: name,
      email: emailValue,
      mobile: mobileValue,
      password: passwordValue,
      confirmPassword: confirmValue,
      authorize: true,
    );

    final success = await _perform(() async => await _sendSignupOtp(request));
    if (!success) return;

    pendingSignupRequest.value = request;
    otpMobileNumber.value = request.mobile;
    setStage(AuthStage.otpVerification);
  }

  Future<AppResponse<dynamic>> _sendSignupOtp(SignupRequest request) =>
      authRepository.signup(request);

  Future<void> _handleOtpVerification() async {
    final otpCode = otp.join().trim();
    if (otpCode.length != 4) {
      _setError('Enter a 4-digit OTP.');
      return;
    }

    final mobileValue = _sanitizeMobile(mobile.value);
    if (!_isValidMobile(mobileValue)) {
      _setError('Invalid mobile number provided for verification.');
      return;
    }

    final success = await _perform(() async => await authRepository.verifyOtp(
          OtpVerificationRequest(mobile: mobileValue, otp: otpCode),
        ));

    if (!success) return;
    setStage(AuthStage.login);
    _setInfo('Verification completed. Please sign in to continue.');
  }

  Future<bool> _perform(
    Future<AppResponse<dynamic>> Function() action,
  ) async {
    isSubmitting.value = true;
    try {
      final response = await action();
      if (!response.success) {
        _setError(response.message);
        return false;
      }
      return true;
    } catch (_) {
      _setError('Something went wrong. Please try again.');
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  bool _isValidMobile(String value) => RegExp(r'^[6-9]\d{9}$').hasMatch(value);

  String _sanitizeMobile(String value) => value.replaceAll(RegExp(r'[^0-9]'), '');

  bool _isValidEmail(String value) {
    final trimmed = value.trim();
    if (trimmed.isEmpty) return false;
    return RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(trimmed);
  }

  bool _isValidPassword(String value) => value.length >= 6 && value.length <= 20;

  void _setError(String message) {
    infoMessage.value = '';
    formError.value = message;
    Get.find<AppToastService>().error(message);
  }

  void _setInfo(String message) {
    formError.value = '';
    infoMessage.value = message;
  }

  void _clearError() {
    formError.value = '';
  }

  void _clearInfo() {
    infoMessage.value = '';
  }
}
