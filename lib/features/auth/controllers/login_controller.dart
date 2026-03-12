import 'package:get/get.dart';
import 'package:flutter/material.dart';

class LoginController extends GetxController {
  final RxBool isPasswordHidden = true.obs;
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void togglePasswordVisibility() {
    isPasswordHidden.value = !isPasswordHidden.value;
  }

  void onForgotPasswordTap() {}

  void onSignInTap() {}

  void onRegisterTap() {}

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
