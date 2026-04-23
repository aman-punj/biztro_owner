import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';

class OtpStageView extends StatefulWidget {
  const OtpStageView({super.key});

  @override
  State<OtpStageView> createState() => _OtpStageViewState();
}

class _OtpStageViewState extends State<OtpStageView> {
  late final TextEditingController _pinController;

  PinTheme get _pinTheme => PinTheme(
        width: 55.w,
        height: 55.h,
        textStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppTokens.textPrimary,
        ),
        decoration: BoxDecoration(
          color: AppTokens.white,
          border: Border.all(color: AppTokens.border),
          borderRadius: BorderRadius.circular(12.r),
        ),
      );

  @override
  void initState() {
    super.initState();
    _pinController = TextEditingController();
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  void _onOtpChanged(String value) {
    final controller = Get.find<AuthController>();
    final digits = List<String>.generate(
      4,
      (index) => index < value.length ? value[index] : '',
    );
    controller.otp.assignAll(digits);
  }

  void _onCompleted(String value) {
    _onOtpChanged(value);
    Get.find<AuthController>().onSubmit();
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Column(
      children: [
        Pinput(
          length: 4,
          controller: _pinController,
          autofillHints: const [AutofillHints.oneTimeCode],
          androidSmsAutofillMethod: AndroidSmsAutofillMethod.smsUserConsentApi,
          listenForMultipleSmsOnAndroid: true,
          defaultPinTheme: _pinTheme,
          focusedPinTheme: _pinTheme.copyWith(
            decoration: _pinTheme.decoration?.copyWith(
              border: Border.all(color: AppTokens.brandPrimary, width: 1.5),
            ),
          ),
          submittedPinTheme: _pinTheme.copyWith(
            decoration: _pinTheme.decoration?.copyWith(
              color: AppTokens.screenBackground,
            ),
          ),
          onChanged: _onOtpChanged,
          onCompleted: _onCompleted,
        ),
        SizedBox(height: AppDimensions.sectionSpacing),
        Obx(
          () => PrimaryButton(
            label: 'Verify & Proceed',
            showArrow: true,
            isLoading: controller.isSubmitting.value,
            onPressed: controller.onSubmit,
          ),
        ),
        SizedBox(height: 8.h),
        Obx(
          () => controller.infoMessage.value.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  controller.infoMessage.value,
                  style: TextStyle(
                    color: AppTokens.success,
                    fontSize: 11.sp,
                  ),
                ),
        ),
        Obx(
          () => controller.formError.value.isEmpty
              ? const SizedBox.shrink()
              : Text(
                  controller.formError.value,
                  style: TextStyle(
                    fontSize: 11.sp,
                    color: AppTokens.error,
                  ),
                ),
        ),
        SizedBox(height: 12.h),
        Text(
          'Didn\'t receive the verification code ?',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        SizedBox(height: 2.h),
        GestureDetector(
          onTap: controller.resendOtp,
          child: Text(
            'Resend Now',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppTokens.brandPrimary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
