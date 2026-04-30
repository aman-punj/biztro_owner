import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/theme/app_tokens.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/keyword_input_widget.dart';
import 'package:bizrato_owner/core/widgets/multi_select_bottom_sheet_field.dart';
import 'package:bizrato_owner/core/widgets/onboarding_section_card.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/scrollable_option_item.dart';
import 'package:bizrato_owner/features/auth/widgets/auth_footer_text.dart';
import 'package:bizrato_owner/features/onboarding/controllers/onboarding_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class BusinessInformationStage extends StatefulWidget {
  const BusinessInformationStage({super.key});

  @override
  State<BusinessInformationStage> createState() =>
      _BusinessInformationStageState();
}

class _BusinessInformationStageState extends State<BusinessInformationStage> {
  final OnboardingController controller = Get.find<OnboardingController>();
  late final TextEditingController _searchController;
  late final TextEditingController _customKeywordController;
  late final VoidCallback _searchListener;
  Worker? _searchQueryWorker;

  @override
  void initState() {
    super.initState();
    _searchController =
        TextEditingController(text: controller.searchQuery.value);
    _customKeywordController = TextEditingController();
    _searchListener = () => controller.onSearchChanged(_searchController.text);
    _searchController.addListener(_searchListener);
    _searchQueryWorker = ever<String>(
      controller.searchQuery,
      _updateSearchText,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.initPageData(_extractBusinessName());
    });
  }

  String? _extractBusinessName() {
    final args = Get.arguments;
    if (args is Map<String, dynamic>) {
      final direct = args['businessName']?.toString();
      final userPayload = args['User'] ?? args['user'];
      final merchantId = userPayload is Map<String, dynamic>
          ? userPayload['MerchantId']?.toString()
          : null;

      controller.setMerchantId(merchantId ?? '');
      if (direct != null && direct.isNotEmpty) return direct;

      if (userPayload is Map<String, dynamic>) {
        final outlet = userPayload['OutletName']?.toString();

        if (outlet != null && outlet.isNotEmpty) return outlet;
      }
      return null;
    }
    if (args is String) return args;
    return null;
  }

  void _updateSearchText(String value) {
    if (_searchController.text == value) {
      return;
    }
    _searchController.removeListener(_searchListener);
    _searchController.text = value;
    _searchController.selection = TextSelection.collapsed(offset: value.length);
    _searchController.addListener(_searchListener);
  }

  void _handleCategoryTap(SearchResultModel result) {
    controller.onCategorySelected(result);
    _updateSearchText(result.displayName);
    FocusScope.of(context).unfocus();
  }

  void _addCustomKeywordFromField() {
    final previousCount = controller.customKeywords.length;
    final value = _customKeywordController.text;
    controller.addCustomKeyword(value);
    if (controller.customKeywords.length != previousCount) {
      _customKeywordController.clear();
      controller.hideCustomKeywordInput();
    }
  }

  @override
  void dispose() {
    _searchQueryWorker?.dispose();
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    _customKeywordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 14.h),
        OnboardingSectionCard(
          title: 'BUSINESS PROFILE',
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: AppTokens.screenBackground,
              borderRadius: BorderRadius.circular(12.r),
              border: Border.all(color: AppTokens.border),
            ),
            child: Row(
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: AppTokens.textSecondary.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Icon(Icons.storefront,
                      color: AppTokens.textSecondary, size: 20.sp),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(
                        () => Text(
                          controller.businessName.value.isNotEmpty
                              ? controller.businessName.value
                              : 'Business Name',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Text(
                        'Id Verification Pending',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        OnboardingSectionCard(
          title: 'SEARCH YOUR BUSINESS CATEGORY',
          child: Obx(
            () => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AppTextField(
                  controller: _searchController,
                  title: 'Enter your category name',
                  hintText: 'e.g. Sweets, Restaurant...',
                  readOnly: controller.isCategoryRestored.value,
                  prefixIcon: Icon(
                    Icons.search,
                    size: 20.sp,
                    color: AppTokens.textSecondary,
                  ),
                  suffixIcon: controller.isCategoryRestored.value
                      ? IconButton(
                          onPressed: controller.clearRestoredCategory,
                          icon: Icon(
                            Icons.close,
                            size: 18.sp,
                            color: AppTokens.textSecondary,
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 250),
                  switchInCurve: Curves.easeOut,
                  switchOutCurve: Curves.easeIn,
                  transitionBuilder: (child, animation) => FadeTransition(
                    opacity: animation,
                    child: child,
                  ),
                  child: _buildSearchResults(),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: child,
            ),
            child: controller.hasSelectedCategory
                ? _buildKeywordSection()
                : const SizedBox.shrink(),
          ),
        ),
        SizedBox(height: 16.h),
        Obx(
          () => PrimaryButton(
            label: 'SAVE & CONTINUE',
            isLoading:
                controller.isSearching.value || controller.isSaving.value,
            onPressed: controller.saveAndContinue,
          ),
        ),
        SizedBox(height: 16.h),
        const AuthFooterText(),
        SizedBox(height: 10.h),
      ],
    );
  }

  Widget _buildSearchResults() {
    final bool hasResults = controller.searchResults.isNotEmpty;
    final bool isSearching = controller.isSearching.value;
    final bool shouldShow = hasResults || isSearching;

    if (!shouldShow) {
      return const SizedBox.shrink();
    }

    return Container(
      key: const ValueKey('search-results'),
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.symmetric(vertical: 12.h),
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppTokens.border),
        boxShadow: [
          BoxShadow(
            color: AppTokens.textSecondary.withValues(alpha: 0.1),
            blurRadius: 10,
          ),
        ],
      ),
      child: Column(
        children: [
          if (isSearching)
            SizedBox(
              height: 60.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTokens.brandPrimary,
                  strokeWidth: 2,
                ),
              ),
            )
          else
            ConstrainedBox(
              constraints: BoxConstraints(maxHeight: 220.h),
              child: controller.searchResults.isEmpty
                  ? Padding(
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      child: Text(
                        'No categories found for "${controller.searchQuery.value}".',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12.sp,
                          color: AppTokens.textSecondary,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppTokens.border),
                      itemBuilder: (context, index) {
                        final result = controller.searchResults[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 4.h),
                          title: Text(
                            result.displayName,
                            style: TextStyle(fontSize: 12.sp),
                          ),
                          onTap: () => _handleCategoryTap(result),
                        );
                      },
                    ),
            ),
        ],
      ),
    );
  }

  Widget _buildKeywordSection() {
    return OnboardingSectionCard(
      key: const ValueKey('keywords-section'),
      child: Obx(
        () {
          if (controller.isLoadingKeywords.value) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                    strokeWidth: 2, color: AppTokens.brandPrimary),
              ),
            );
          }

          final allKeywordOptions = [
            ...controller.qualityKeywords.map((k) => MultiSelectOption(id: k.keywordId, label: k.keyword)),
            ...controller.serviceKeywords.map((k) => MultiSelectOption(id: k.keywordId, label: k.keyword)),
          ];

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(() {
                if (controller.isRestoringKeywords.value) {
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 12.h),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 14.w,
                          height: 14.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: AppTokens.brandPrimary,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Restoring your previous selections...',
                          style: TextStyle(
                            fontSize: 11.sp,
                            color: AppTokens.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  );
                }
                return const SizedBox.shrink();
              }),
              MultiSelectBottomSheetField(
                title: 'Select business keywords',
                options: allKeywordOptions,
                selectedIds: controller.selectedKeywordIds,
                onSelectionChanged: (ids) => controller.setSelectedKeywords(ids),
                limit: 5,
              ),
              SizedBox(height: 12.h),
              Text(
                'ADD YOUR OWN',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppTokens.textSecondary,
                ),
              ),
              SizedBox(height: 8.h),
              Obx(() => Column(
                children: [
                  ...controller.customKeywords.map(
                    (keyword) => EditableKeywordRow(
                      value: keyword,
                      onDelete: () => controller.removeCustomKeyword(keyword),
                      onSave: (value) => controller.updateCustomKeyword(
                        oldValue: keyword,
                        newValue: value,
                      ),
                    ),
                  ),
                  if (controller.isAddingCustomKeyword.value && controller.canAddMoreKeywords)
                    KeywordInputRow(
                      controller: _customKeywordController,
                      isReadOnly: false,
                      hint: 'Enter keyword...',
                      maxLines: 3,
                      actionIcon: Icons.check,
                      actionBackgroundColor:
                          AppTokens.brandPrimary.withValues(alpha: 0.12),
                      actionIconColor: AppTokens.brandPrimary,
                      onSubmitted: (_) => _addCustomKeywordFromField(),
                      onAction: _addCustomKeywordFromField,
                    ),
                  if (controller.canAddMoreKeywords) ...[
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: OutlinedButton(
                        onPressed: controller.isAddingCustomKeyword.value
                            ? controller.hideCustomKeywordInput
                            : controller.showCustomKeywordInput,
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 52.h),
                          side: BorderSide(
                              color: AppTokens.brandPrimary, width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          backgroundColor:
                              AppTokens.brandPrimary.withValues(alpha: 0.05),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              controller.isAddingCustomKeyword.value
                                  ? Icons.close
                                  : Icons.add_circle_outline,
                              size: 20.sp,
                              color: AppTokens.brandPrimary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              controller.isAddingCustomKeyword.value
                                  ? 'Cancel'
                                  : 'Add Another Keyword',
                              style: TextStyle(
                                color: AppTokens.brandPrimary,
                                fontWeight: FontWeight.bold,
                                fontSize: 14.sp,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ] else
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: Text(
                        'Max 5 keywords reached',
                        style: TextStyle(
                          fontSize: 10.sp,
                          color: AppTokens.error,
                        ),
                      ),
                    ),
                ],
              )),
            ],
          );
        },
      ),
    );
  }
}
