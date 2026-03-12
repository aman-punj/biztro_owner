import 'package:biztro_owner/features/auth/controllers/auth_controller.dart';
import 'package:biztro_owner/features/auth/widgets/forgot_password_stage_view.dart';
import 'package:biztro_owner/features/auth/widgets/login_stage_view.dart';
import 'package:biztro_owner/features/auth/widgets/otp_stage_view.dart';
import 'package:biztro_owner/features/auth/widgets/register_stage_view.dart';
import 'package:flutter/widgets.dart';

class AuthStageContent extends StatelessWidget {
  const AuthStageContent({required this.stage, super.key});

  final AuthStage stage;

  @override
  Widget build(BuildContext context) {
    switch (stage) {
      case AuthStage.login:
        return const LoginStageView();
      case AuthStage.forgotPassword:
        return const ForgotPasswordStageView();
      case AuthStage.register:
        return const RegisterStageView();
      case AuthStage.otpVerification:
        return const OtpStageView();
    }
  }
}
