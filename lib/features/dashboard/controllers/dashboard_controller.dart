import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInsightStat {
  final String label;
  final String value;
  final IconData icon;
  final Color iconBg;

  const BusinessInsightStat({
    required this.label,
    required this.value,
    required this.icon,
    required this.iconBg,
  });
}

class LeadAnalyticsCategory {
  final String label;
  final Color color;

  const LeadAnalyticsCategory({required this.label, required this.color});
}

class DashboardController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  // Business info
  final businessName = 'Haldiram Restaurant'.obs;
  final businessType = 'Dine-In Delhi, 10:00'.obs;
  final businessRating = '4.5'.obs;
  final businessReviews = '8.6k'.obs;
  final businessFollowers = '2.1M'.obs;
  final profileCompletionPercent = 0.60.obs;
  final profileCompletionLabel = '60%'.obs;

  // Quick actions
  final quickActions = <Map<String, dynamic>>[
    {'label': 'Business\nDetails', 'icon': Icons.store_outlined},
    {'label': 'Timing &\nDetails', 'icon': Icons.access_time_outlined},
    {'label': 'Location\nInfo', 'icon': Icons.location_on_outlined},
    {'label': 'Social\nLinks', 'icon': Icons.share_outlined},
  ].obs;

  // Business Insights
  final insightStats = <BusinessInsightStat>[].obs;

  // Lead Analytics bar chart data
  final barGroups = <BarChartGroupData>[].obs;
  final legendCategories = <LeadAnalyticsCategory>[
    LeadAnalyticsCategory(label: 'Books', color: const Color(0xFFFF6B35)),
    LeadAnalyticsCategory(label: 'Clothing', color: const Color(0xFF4361EE)),
    LeadAnalyticsCategory(label: 'Electronics', color: const Color(0xFF3AB795)),
    LeadAnalyticsCategory(label: 'Garden', color: const Color(0xFFE63946)),
    LeadAnalyticsCategory(label: 'Sorts', color: const Color(0xFFFBB13C)),
    LeadAnalyticsCategory(label: 'Fashion', color: const Color(0xFF9B5DE5)),
  ].obs;

  final xLabels = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      // Simulate API delay
      await Future<void>.delayed(const Duration(milliseconds: 1200));

      insightStats.assignAll([
        const BusinessInsightStat(
          label: 'Total Leads',
          value: '31K',
          icon: Icons.person_outline,
          iconBg: Color(0xFFEAF0FF),
        ),
        const BusinessInsightStat(
          label: 'Hot Leads',
          value: '59K',
          icon: Icons.local_fire_department_outlined,
          iconBg: Color(0xFFFFF3E0),
        ),
        const BusinessInsightStat(
          label: 'Add Code',
          value: '24K',
          icon: Icons.phone_outlined,
          iconBg: Color(0xFFE8F5E9),
        ),
        const BusinessInsightStat(
          label: 'Total Views',
          value: '258K',
          icon: Icons.visibility_outlined,
          iconBg: Color(0xFFF3E5F5),
        ),
      ]);

      barGroups.assignAll(_buildBarGroups());
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data. Please try again.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() => _loadDashboard();

  List<BarChartGroupData> _buildBarGroups() {
    // Data for each category per day [Books, Clothing, Electronics, Garden, Sorts, Fashion]
    const data = [
      [3.0, 5.0, 2.0, 4.0, 1.5, 3.5],
      [4.0, 3.0, 5.0, 2.5, 3.0, 4.5],
      [2.5, 4.5, 3.5, 5.0, 2.0, 3.0],
      [5.0, 2.0, 4.0, 3.0, 4.5, 2.5],
      [3.5, 5.0, 2.5, 4.0, 3.0, 5.0],
      [4.5, 3.5, 5.0, 2.0, 4.0, 3.5],
      [2.0, 4.0, 3.0, 5.0, 2.5, 4.0],
    ];

    final colors = legendCategories.map((c) => c.color).toList();

    return List.generate(7, (dayIndex) {
      return BarChartGroupData(
        x: dayIndex,
        groupVertically: false,
        barRods: List.generate(6, (catIndex) {
          return BarChartRodData(
            toY: data[dayIndex][catIndex],
            color: colors[catIndex],
            width: 6,
            borderRadius: BorderRadius.circular(3),
          );
        }),
        barsSpace: 2,
      );
    });
  }
}
