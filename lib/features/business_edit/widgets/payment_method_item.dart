import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_checkbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentMethodItem extends StatelessWidget {
  const PaymentMethodItem({
    required this.label,
    required this.isSelected,
    required this.onChanged,
    super.key,
  });

  final String label;
  final bool isSelected;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onChanged(!isSelected),
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 12.h),
        child: Row(
          children: [
            AppCheckbox(
              isSelected: isSelected,
              size: 20.w,
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
