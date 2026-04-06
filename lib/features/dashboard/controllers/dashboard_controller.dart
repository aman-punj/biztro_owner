import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/utils/formatters.dart';
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

class DashboardStatsModel {
  final int viewCount;
  final int whatsAppCount;
  final int contactCount;
  final int enquiryCount;
  final int totalClickCount;
  final int likeCount;
  final int shareCount;

  const DashboardStatsModel({
    required this.viewCount,
    required this.whatsAppCount,
    required this.contactCount,
    required this.enquiryCount,
    required this.totalClickCount,
    required this.likeCount,
    required this.shareCount,
  });

  factory DashboardStatsModel.fromJson(Map<String, dynamic> json) {
    return DashboardStatsModel(
      viewCount: AppFormatters.parseCount(json['ViewCount']),
      whatsAppCount: AppFormatters.parseCount(json['WhatsAppCount']),
      contactCount: AppFormatters.parseCount(json['ContactCount']),
      enquiryCount: AppFormatters.parseCount(json['EnquiryCount']),
      totalClickCount: AppFormatters.parseCount(json['TotalClickCount']),
      likeCount: AppFormatters.parseCount(json['LikeCount']),
      shareCount: AppFormatters.parseCount(json['ShareCount']),
    );
  }
}

class DashboardController extends GetxController {
  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

// Business info
  final businessName = 'Haldiram Restaurant'.obs;
  final businessType = 'Dine-In Delhi, 10:00'.obs;
  final totalClickCount = '0'.obs;
  final viewCount = '0'.obs;
  final likeCount = '0'.obs;
  final profileCompletionPercent = 0.60.obs;
  final profileCompletionLabel = '60%'.obs;

  final insightStats = <BusinessInsightStat>[].obs;

// --- NEW: Added for the Chart UI in the image ---
  final barGroups = <BarChartGroupData>[].obs;
  final lineSpots = <FlSpot>[].obs; // For the trend line overlay
  final xLabels = <String>[].obs; // Labels like 'Books', 'Clothing'

  final legendCategories = <LeadAnalyticsCategory>[
    const LeadAnalyticsCategory(label: 'Books', color: AppTokens.brandAccent),
    const LeadAnalyticsCategory(label: 'Clothing', color: AppTokens.brandPrimary),
    const LeadAnalyticsCategory(label: 'Electronics', color: AppTokens.brandPrimaryDark),
    const LeadAnalyticsCategory(label: 'Garden', color: AppTokens.info),
    const LeadAnalyticsCategory(label: 'Sorts', color: AppTokens.online),
    const LeadAnalyticsCategory(label: 'Fashion', color: AppTokens.star),
  ].obs;

  final quickActions = <Map<String, String>>[
    {
      'label': 'Business\nDetails',
      'icon': AppAssets.quickActionBusinessDetails
    },
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

      final merchantId = Get.find<AuthStorage>().merchantId;
      if (merchantId == null || merchantId == 0) {
        throw Exception('Merchant ID is not available');
      }

      final response = await Get.find<ApiClient>().get(
        '/api/dashboard/dashboardstats',
        queryParameters: {'merchantId': merchantId},
      );

      if (response.success && response.data is Map<String, dynamic>) {
        final payload = response.data as Map<String, dynamic>;
        final result = payload['Result'];
        if (result is Map<String, dynamic>) {
          final stats = DashboardStatsModel.fromJson(result);
          totalClickCount.value = stats.totalClickCount.toString();
          viewCount.value = stats.viewCount.toString();
          likeCount.value = stats.likeCount.toString();

          insightStats.assignAll([
            BusinessInsightStat(
              label: 'Business Leads',
              value: AppFormatters.formatCount(stats.enquiryCount),
              iconPath: AppAssets.statHotLeads,
              iconBg: AppTokens.insightIconBlue,
            ),
            BusinessInsightStat(
              label: 'Total Clicks',
              value: AppFormatters.formatCount(stats.totalClickCount),
              iconPath: AppAssets.statTotalLeads,
              iconBg: AppTokens.insightIconPeach,
            ),
            BusinessInsightStat(
              label: 'Add Calls',
              value: AppFormatters.formatCount(stats.contactCount),
              iconPath: AppAssets.statAddCode,
              iconBg: AppTokens.insightIconLavender,
            ),
            BusinessInsightStat(
              label: 'Total Views',
              value: AppFormatters.formatCount(stats.viewCount),
              iconPath: AppAssets.statTotalViews,
              iconBg: AppTokens.insightIconMint,
            ),
          ]);
        }
      } else {
        throw Exception(response.message);
      }

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
