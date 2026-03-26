import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeadAnalyticsSection extends GetView<DashboardController> {
  const LeadAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Business Lead Analytics',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimaryLight,
          ),
        ),
        SizedBox(height: 12.h),
        // Legend
        Obx(
          () {
            // Force read of legendCategories for GetX reactivity
            final categories = controller.legendCategories.toList();
            return Wrap(
              spacing: 10.w,
              runSpacing: 6.h,
              children: categories.map((cat) {
                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 10.w,
                      height: 10.w,
                      decoration: BoxDecoration(
                        color: cat.color,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      cat.label,
                      style: TextStyle(
                        fontSize: 9.sp,
                        color: AppColors.textSecondaryLight,
                      ),
                    ),
                  ],
                );
              }).toList(),
            );
          },
        ),
        SizedBox(height: 14.h),
        // Bar chart
        SizedBox(
          height: 180.h,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: 500.w,
              child: Obx(
                () {
                  // Explicitly read barGroups for GetX
                  final groups = controller.barGroups.toList();
                  return BarChart(
                    BarChartData(
                      barGroups: groups,
                      borderData: FlBorderData(show: false),
                      gridData: FlGridData(
                        show: true,
                        drawVerticalLine: false,
                        horizontalInterval: 1,
                        getDrawingHorizontalLine:
                            (_) => FlLine(
                              color: AppColors.borderLight,
                              strokeWidth: 0.8,
                            ),
                      ),
                      titlesData: FlTitlesData(
                        leftTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: (value, meta) {
                              final labels = controller.xLabels;
                              final index = value.toInt();
                              if (index < 0 || index >= labels.length) {
                                return const SizedBox.shrink();
                              }
                              return Padding(
                                padding: EdgeInsets.only(top: 6.h),
                                child: Text(
                                  labels[index],
                                  style: TextStyle(
                                    fontSize: 9.sp,
                                    color: AppColors.textSecondaryLight,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      groupsSpace: 16.w,
                      barTouchData: BarTouchData(
                        touchTooltipData: BarTouchTooltipData(
                          getTooltipColor: (_) => AppColors.primaryDark,
                          tooltipMargin: 0,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ],
    );
  }
}
