import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/theme/dimensions.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class OtpStageView extends StatefulWidget {
  const OtpStageView({super.key});

  @override
  State<OtpStageView> createState() => _OtpStageViewState();
}

class _OtpStageViewState extends State<OtpStageView> {
  late final List<FocusNode> _focusNodes;
  late final List<TextEditingController> _controllers;

  @override
  void initState() {
    super.initState();
    _focusNodes = List.generate(4, (_) => FocusNode());
    _controllers = List.generate(4, (_) => TextEditingController());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        _focusNodes.first.requestFocus();
      }
    });
  }

  @override
  void dispose() {
    for (final node in _focusNodes) {
      node.dispose();
    }
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onDigitChanged(int index, String value) {
    final controller = Get.find<AuthController>();
    controller.onOtpChanged(index, value);

    if (value.isNotEmpty && index < _focusNodes.length - 1) {
      _focusNodes[index + 1].requestFocus();
    }

    if (value.isEmpty && index > 0) {
      _focusNodes[index - 1].requestFocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            4,
            (index) => SizedBox(
              width: 55.w,
              child: AppTextField(
                controller: _controllers[index],
                focusNode: _focusNodes[index],
                textInputAction:
                    index == _focusNodes.length - 1 ? TextInputAction.done : TextInputAction.next,
                onSubmitted: (_) {
                  if (index < _focusNodes.length - 1) {
                    _focusNodes[index + 1].requestFocus();
                  } else {
                    controller.onSubmit();
                  }
                },
                hint: '',
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                maxLength: 1,
                height: 55.h,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) => _onDigitChanged(index, value),
              ),
            ),
          ),
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
                    color: Colors.green,
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
                    color: Colors.redAccent,
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
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                ),
          ),
        ),
      ],
    );
  }
}
