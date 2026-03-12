import 'package:get/get.dart';

enum AuthStage { login, forgotPassword, register }

class AuthController extends GetxController {
  final currentStage = AuthStage.login.obs;
  final isPasswordHidden = true.obs;

  final email = ''.obs;
  final password = ''.obs;

  void setStage(AuthStage stage) => currentStage.value = stage;

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void onEmailChanged(String value) => email.value = value;

  void onPasswordChanged(String value) => password.value = value;

  void onSubmit() {
    // UI only; API integration will be added later.
  }
}
