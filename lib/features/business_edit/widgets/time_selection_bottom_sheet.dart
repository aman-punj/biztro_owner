import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/features/business_edit/data/models/time_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimeSelectionBottomSheet extends StatelessWidget {
  const TimeSelectionBottomSheet({
    required this.title,
    required this.timeList,
    required this.selectedTimeId,
    required this.onSelected,
    super.key,
  });

  final String title;
  final List<TimeModel> timeList;
  final int? selectedTimeId;
  final ValueChanged<TimeModel> onSelected;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: FractionallySizedBox(
        heightFactor: 0.75,
        child: Container(
          padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 20.h),
          decoration: BoxDecoration(
            color: AppTokens.cardBackground,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 42.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: AppTokens.border,
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                  color: AppTokens.textPrimary,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.separated(
                  itemCount: timeList.length,
                  separatorBuilder: (_, __) => Divider(
                    height: 1.h,
                    color: AppTokens.border,
                  ),
                  itemBuilder: (context, index) {
                    final time = timeList[index];
                    final isSelected = time.id == selectedTimeId;

                    return ListTile(
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 0.w,
                        vertical: 2.h,
                      ),
                      title: Text(
                        time.value,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w500,
                          color: isSelected
                              ? AppTokens.brandPrimary
                              : AppTokens.textPrimary,
                        ),
                      ),
                      trailing: Icon(
                        isSelected
                            ? Icons.radio_button_checked
                            : Icons.radio_button_off,
                        size: 18.sp,
                        color: isSelected
                            ? AppTokens.brandPrimary
                            : AppTokens.textSecondary,
                      ),
                      onTap: () => onSelected(time),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
