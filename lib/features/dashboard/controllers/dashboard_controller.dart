import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/network/api_client.dart';
import 'package:bizrato_owner/core/storage/auth_storage.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/utils/formatters.dart';
import 'package:bizrato_owner/features/onboarding/data/repositories/onboarding_repository.dart';
import 'package:bizrato_owner/routes/app_routes.dart';
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
  DashboardController({
    required this.apiClient,
    required this.authStorage,
    required this.onboardingRepository,
  });

  final ApiClient apiClient;
  final AuthStorage authStorage;
  final OnboardingRepository onboardingRepository; 

  final isLoading = true.obs;
  final hasError = false.obs;
  final errorMessage = ''.obs;

  final businessName = 'Business'.obs;
  final businessType = ''.obs;
  final totalClickCount = '0'.obs;
  final viewCount = '0'.obs;
  final likeCount = '0'.obs;
  final businessStep = 3.obs;
  final profileCompletionPercent = 0.60.obs;
  final profileCompletionLabel = '60%'.obs;

  final insightStats = <BusinessInsightStat>[].obs;

// --- NEW: Added for the Chart UI in the image ---
  final barGroups = <BarChartGroupData>[].obs;
  final lineSpots = <FlSpot>[].obs; // For the trend line overlay
  final xLabels = <String>[].obs; // Labels like 'Books', 'Clothing'

  final legendCategories = <LeadAnalyticsCategory>[
    const LeadAnalyticsCategory(label: 'Books', color: AppTokens.brandAccent),
    const LeadAnalyticsCategory(
        label: 'Clothing', color: AppTokens.brandPrimary),
    const LeadAnalyticsCategory(
        label: 'Electronics', color: AppTokens.brandPrimaryDark),
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

  bool get shouldShowProfileCompletion => businessStep.value < 5;

  String get profileCompletionSubtitle {
    switch (businessStep.value) {
      case 3:
        return 'Complete Trusted Shield verification';
      case 4:
        return 'Add Photos to Boost Visibility';
      default:
        return 'Complete your business profile';
    }
  }

  void openProfileCompletion() {
    if (!shouldShowProfileCompletion) {
      return;
    }

    switch (businessStep.value) {
      case 3:
        Get.toNamed(AppRoutes.trustedShield);
        break;
      case 4:
        Get.toNamed(AppRoutes.editTimingPayment);
        break;
      default:
        Get.toNamed(AppRoutes.onboarding);
        break;
    }
  }

  @override
  void onInit() {
    super.onInit();
    _loadDashboard();
  }

  Future<void> _loadDashboard() async {
    isLoading.value = true;
    hasError.value = false;
    try {
      final merchantId = authStorage.merchantId;
      if (merchantId == null || merchantId == 0) {
        throw Exception('Merchant ID is not available');
      }

      await _loadBusinessProfile(merchantId);

      final response = await apiClient.get(
        '/api/dashboard/dashboardstats',
        queryParameters: {'merchantId': merchantId},
      );

      if (!response.success) {
        hasError.value = true;
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load dashboard data.';
        return;
      }

      if (response.data is Map<String, dynamic>) {
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
        hasError.value = true;
        errorMessage.value = response.message.isNotEmpty
            ? response.message
            : 'Failed to load dashboard data.';
        return;
      }

// 2. Load Chart Data (Matching the Image)
      _prepareChartData();
    } catch (e) {
      hasError.value = true;
      errorMessage.value = errorMessage.value.isNotEmpty
          ? errorMessage.value
          : 'Failed to load dashboard data.';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadBusinessProfile(int merchantId) async {
    final response = await onboardingRepository.getBusinessDetails(merchantId);
    final result = response.data?.result;
    if (!response.success || result == null) {
      return;
    }

    if (result.businessName.trim().isNotEmpty) {
      businessName.value = result.businessName.trim();
    }

    businessStep.value = result.businessStep;
    _applyProfileCompletion(result.businessStep);

    final parts = <String>[
      if (result.displayName.trim().isNotEmpty) result.displayName.trim(),
      // if (result.businessEmailId.trim().isNotEmpty) result.businessEmailId.trim(),
    ];
    businessType.value = parts.join(' • ');
  }

  void _applyProfileCompletion(int step) {
    final normalizedStep = step.clamp(0, 5);
    final percent = (normalizedStep * 0.20).clamp(0.0, 1.0);
    profileCompletionPercent.value = percent;
    profileCompletionLabel.value = '${(percent * 100).round()}%';
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

  @override
  Future<void> refresh() => _loadDashboard();
}
