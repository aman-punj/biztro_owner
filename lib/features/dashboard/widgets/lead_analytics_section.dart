import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/features/dashboard/controllers/dashboard_controller.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class LeadAnalyticsSection extends GetView<DashboardController> {
  const LeadAnalyticsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppTokens.border.withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Business Lead Analytics',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: AppTokens.textPrimary,
            ),
          ),
          SizedBox(height: 16.h),
          _buildLegend(),
          SizedBox(height: 24.h),
          SizedBox(
            height: 220.h,
            child: Obx(() {
              if (controller.barGroups.isEmpty) return const SizedBox.shrink();

              return Stack(
                children: [
                  // 1. The Bar Chart (Bottom Layer)
                  BarChart(_mainBarData()),
                  // 2. The Line Chart (Top Layer for the grey connecting line)
                  LineChart(_trendLineData()),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  // --- Legend Builder ---
  Widget _buildLegend() {
    return Obx(() => Wrap(
      spacing: 12.w,
      runSpacing: 8.h,
      children: controller.legendCategories.map((cat) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 24.w,
              height: 10.h,
              decoration: BoxDecoration(
                color: cat.color,
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              cat.label,
              style: TextStyle(
                  fontSize: 11.sp, color: AppTokens.textPrimary.withValues(alpha: 0.87)),
            ),
          ],
        );
      }).toList(),
    ));
  }

  // --- Bar Chart Configuration ---
  BarChartData _mainBarData() {
    return BarChartData(
      maxY: 50,
      barGroups: controller.barGroups,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 10,
        getDrawingHorizontalLine: (value) => FlLine(
          color: AppTokens.textSecondary.withValues(alpha: 0.15),
          strokeWidth: 1,
        ),
        getDrawingVerticalLine: (value) => FlLine(
          color: AppTokens.textSecondary.withValues(alpha: 0.15),
          strokeWidth: 1,
        ),
      ),
      titlesData: FlTitlesData(
        rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28.w,
            interval: 10,
            getTitlesWidget: (value, meta) => SideTitleWidget(
              // axisSide: meta.axisSide,
              meta: meta,
              child: Text(value.toInt().toString(),
                  style: TextStyle(color: AppTokens.textSecondary, fontSize: 10.sp)),
            ),
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 50.h,
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              if (index < 0 || index >= controller.xLabels.length) return const SizedBox();
              return SideTitleWidget(
                // axisSide: meta.axisSide,
                meta: meta,
                space: 12.h,
                child: Transform.rotate(
                  angle: -0.7, // Slanted labels
                  child: Text(
                    controller.xLabels[index],
                    style: TextStyle(color: AppTokens.textSecondary, fontSize: 10.sp),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // --- Line Chart Configuration (The Trend Line) ---
  LineChartData _trendLineData() {
    return LineChartData(
      maxY: 50,
      lineBarsData: [
        LineChartBarData(
          // Ensure your controller provides points matching the bar heights
          spots: controller.lineSpots,
          isCurved: false,
          color: AppTokens.textSecondary.withValues(alpha: 0.5),
          barWidth: 1,
          isStrokeCapRound: true,
          dotData: const FlDotData(show: false), // Hide dots to keep it clean
        ),
      ],
      // Disable titles and grid for the line layer to avoid doubling them up
      titlesData: const FlTitlesData(show: false),
      gridData: const FlGridData(show: false),
      borderData: FlBorderData(show: false),
    );
  }
}