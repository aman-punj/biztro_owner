import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BusinessInsightStat {
  final String label;
  final String value;
  final String iconPath;
  final Color iconBg;

  const BusinessInsightStat({
    required this.label,
    required this.value,
    required this.iconPath,
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

  final insightStats = <BusinessInsightStat>[].obs;

// --- NEW: Added for the Chart UI in the image ---
  final barGroups = <BarChartGroupData>[].obs;
  final lineSpots = <FlSpot>[].obs; // For the trend line overlay
  final xLabels = <String>[].obs; // Labels like 'Books', 'Clothing'

  final legendCategories = <LeadAnalyticsCategory>[
    // Chart palette — intentional, not theme colors
    const LeadAnalyticsCategory(label: 'Books', color: Color(0xFFFF6B35)),
    const LeadAnalyticsCategory(label: 'Clothing', color: Color(0xFF2196F3)),
    const LeadAnalyticsCategory(label: 'Electronics', color: Color(0xFF0D47A1)),
    const LeadAnalyticsCategory(label: 'Garden', color: Color(0xFF90CAF9)),
    const LeadAnalyticsCategory(label: 'Sorts', color: Color(0xFFC2185B)),
    const LeadAnalyticsCategory(label: 'Fashion', color: Color(0xFF00BCD4)),
  ].obs;

  final quickActions = <Map<String, String>>[

    {'label': 'Business\nDetails', 'icon': AppAssets.quickActionBusinessDetails},

    {'label': 'Timing &\nDetails', 'icon': AppAssets.quickActionTimingDetails},

    {'label': 'Location\nInfo', 'icon': AppAssets.quickActionLocationInfo},

    {'label': 'Social\nLinks', 'icon': AppAssets.quickActionSocialLinks},

  ].obs;



  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      await Future<void>.delayed(const Duration(milliseconds: 1200));

// 1. Load Insights
      insightStats.assignAll([
        const BusinessInsightStat(
          label: 'Business Leads',
          value: '31K',
          iconPath: AppAssets.statHotLeads,
          iconBg: AppColors.insightIconBlue,
        ),
        const BusinessInsightStat(
          label: 'Total Clicks',
          value: '59K',
          iconPath: AppAssets.statTotalLeads,
          iconBg: AppColors.insightIconPeach,
        ),
        const BusinessInsightStat(
          label: 'Add Calls',
          value: '24K',
          iconPath: AppAssets.statAddCode,
          iconBg: AppColors.insightIconLavender,
        ),
        const BusinessInsightStat(
          label: 'Total Views',
          value: '258K',
          iconPath: AppAssets.statTotalViews,
          iconBg: AppColors.insightIconMint,
        ),
      ]);

// 2. Load Chart Data (Matching the Image)
      _prepareChartData();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = 'Failed to load dashboard data.';
    } finally {
      isLoading.value = false;
    }
  }

  void _prepareChartData() {
// Values matching the heights in your image roughly
    final values = [42.0, 21.0, 35.0, 15.0, 37.0, 24.0];
    final List<BarChartGroupData> groups = [];
    final List<FlSpot> spots = [];
    final List<String> labels = [];

    for (int i = 0; i < legendCategories.length; i++) {
      final category = legendCategories[i];
      final val = values[i];

// Add to Bar Groups
      groups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: val,
              color: category.color,
              width: 22, // Thick bars like the image
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(4),
                topRight: Radius.circular(4),
              ),
            ),
          ],
        ),
      );

// Add to Line Spots (The line connects the top center of each bar)
      spots.add(FlSpot(i.toDouble(), val));

// Add to X Labels
      labels.add(category.label);
    }

    lineSpots.assignAll(spots);
    xLabels.assignAll(labels);
    barGroups.assignAll(groups);
  }

  Future<void> refresh() => _loadDashboard();
}
