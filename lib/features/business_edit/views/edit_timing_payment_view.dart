import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/widgets/app_checkbox.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_timing_payment_controller.dart';
import 'package:bizrato_owner/features/business_edit/data/models/time_model.dart';
import 'package:bizrato_owner/features/business_edit/data/models/week_model.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditTimingPaymentView extends GetView<EditTimingPaymentController> {
  const EditTimingPaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return AppPageShell(
      title: 'Timing & Payment',
      child: Obx(
        () {
          if (controller.isLoadingPage.value) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      _buildBusinessHoursSection(context),
                      _buildPaymentMethodsSection(),
                    ],
                  ),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 16.h),
                  child: PrimaryButton(
                    label: 'SAVE & CONTINUE',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveAndUpdate,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBusinessHoursSection(BuildContext context) {
    return OnboardingSectionCard(
      title: 'Business Hours',
      child: Obx(
        () => Column(
          children: [
            _buildDisplayOptionTile(
              label: 'Display Hours of Operation',
              isSelected: controller.isDisplayHours.value,
              onTap: () => controller.toggleDisplayHours(true),
            ),
            SizedBox(height: 10.h),
            _buildDisplayOptionTile(
              label: 'Do Not Display Hours',
              isSelected: !controller.isDisplayHours.value,
              onTap: () => controller.toggleDisplayHours(false),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(14.w),
              decoration: BoxDecoration(
                color: AppTokens.white,
                borderRadius: BorderRadius.circular(16.r),
                border: Border.all(color: AppTokens.border),
              ),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: controller.copyMondayToAllDays,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.copy,
                            size: 14.sp,
                            color: AppTokens.brandPrimary,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'Copy Monday to all days',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: AppTokens.brandPrimary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10.h),
                  ...controller.weekList.map(
                    (week) => _buildDayRow(
                      context: context,
                      week: week,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDisplayOptionTile({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: isSelected ? AppTokens.selectionBackground : AppTokens.surface,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(
            color: isSelected ? AppTokens.brandPrimary : AppTokens.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              size: 18.sp,
              color:
                  isSelected ? AppTokens.brandPrimary : AppTokens.textSecondary,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                label,
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDayRow({
    required BuildContext context,
    required WeekModel week,
  }) {
    return BusinessHourDayRow(
      dayName: week.name,
      openTime: controller.getFromTimeLabel(week.id),
      closeTime: controller.getToTimeLabel(week.id),
      onOpenTimePressed: () => _openTimeBottomSheet(
        context: context,
        week: week,
        isFromTime: true,
      ),
      onCloseTimePressed: () => _openTimeBottomSheet(
        context: context,
        week: week,
        isFromTime: false,
      ),
    );
  }

  Widget _buildPaymentMethodsSection() {
    return OnboardingSectionCard(
      title: 'Payment Methods',
      titleIcon: Obx(
        () => Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Checkbox(
              value: controller.areAllPaymentsSelected,
              onChanged: (value) =>
                  controller.toggleAllPayments(value ?? false),
            ),
            Text(
              'Select All',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTokens.textPrimary,
              ),
            ),
          ],
        ),
      ),
      child: Obx(
        () {
          final paymentItems = controller.paymentList.toList(growable: false);

          return Container(
            width: double.infinity,
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppTokens.white,
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(color: AppTokens.border),
            ),
            child: GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: paymentItems.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.w,
                mainAxisSpacing: 10.h,
                mainAxisExtent: 56.h,
              ),
              itemBuilder: (_, index) {
                final payment = paymentItems[index];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(10.r),
                    onTap: () => controller.togglePayment(payment.id),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 10.w),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: payment.isSelected
                              ? AppTokens.brandPrimary
                              : AppTokens.border,
                        ),
                        color: payment.isSelected
                            ? AppTokens.selectionBackground
                            : AppTokens.cardBackground,
                      ),
                      child: Row(
                        children: [
                          AppCheckbox(
                            isSelected: payment.isSelected,
                            size: 18.w,
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              payment.name,
                              maxLines: 2,
                              overflow: TextOverflow.visible,
                              style: TextStyle(
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                                color: AppTokens.textPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }

  Future<void> _openTimeBottomSheet({
    required BuildContext context,
    required WeekModel week,
    required bool isFromTime,
  }) async {
    final dayTiming = controller.dayTimings
        .firstWhereOrNull((item) => item.weekId == week.id);
    final selectedTimeId =
        isFromTime ? dayTiming?.fromTimeId : dayTiming?.toTimeId;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return TimeSelectionBottomSheet(
          title: '${week.name} ${isFromTime ? 'Opening' : 'Closing'} Time',
          timeList: controller.timeList,
          selectedTimeId: selectedTimeId,
          onSelected: (TimeModel selectedTime) {
            if (isFromTime) {
              controller.updateFromTime(week.id, selectedTime.id);
            } else {
              controller.updateToTime(week.id, selectedTime.id);
            }
            Get.back<void>();
          },
        );
      },
    );
  }
}
