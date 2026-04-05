import 'package:bizrato_owner/core/theme/colors.dart';
import 'package:bizrato_owner/core/widgets/app_text_field.dart';
import 'package:bizrato_owner/core/widgets/edit_page_app_bar.dart';
import 'package:bizrato_owner/core/widgets/primary_button.dart';
import 'package:bizrato_owner/core/widgets/scrollable_option_item.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_business_details_controller.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/onboarding/widgets/onboarding_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

class EditBusinessDetailsView extends StatefulWidget {
  const EditBusinessDetailsView({super.key});

  @override
  State<EditBusinessDetailsView> createState() =>
      _EditBusinessDetailsViewState();
}

class _EditBusinessDetailsViewState extends State<EditBusinessDetailsView> {
  final EditBusinessDetailsController controller =
      Get.find<EditBusinessDetailsController>();
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
    final value = _customKeywordController.text;
    controller.addCustomKeyword(value);
    _customKeywordController.clear();
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
    return Scaffold(
      appBar: const EditPageAppBar(title: 'Business Details'),
      body: SafeArea(
        child: Obx(
          () {
            if (controller.isLoadingPage.value) {
              return const Center(child: CircularProgressIndicator());
            }

            return SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.08),
                      borderRadius: BorderRadius.circular(12.r),
                      border: Border.all(
                        color: AppColors.primary.withOpacity(0.2),
                      ),
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                          child: Icon(
                            Icons.storefront,
                            color: AppColors.primary,
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Column(
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
                              'Smart Keywords Selection',
                              style: TextStyle(
                                fontSize: 10.sp,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16.h),
                  OnboardingSectionCard(
                    title: 'CATEGORY SEARCH',
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AppTextField(
                            controller: _searchController,
                            hint: 'e.g. Sweets, Restaurant...',
                            readOnly: controller.isCategoryRestored.value,
                            prefixIcon: Icon(
                              Icons.search,
                              size: 20.sp,
                              color: AppColors.textSecondaryLight,
                            ),
                            suffixIcon: controller.isCategoryRestored.value
                                ? IconButton(
                                    onPressed: controller.clearRestoredCategory,
                                    icon: Icon(
                                      Icons.close,
                                      size: 18.sp,
                                      color: AppColors.textSecondaryLight,
                                    ),
                                  )
                                : controller.isSearching.value
                                    ? SizedBox(
                                        width: 18.w,
                                        height: 18.w,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2,
                                        ),
                                      )
                                    : const SizedBox.shrink(),
                          ),
                          AnimatedSwitcher(
                            duration: const Duration(milliseconds: 250),
                            switchInCurve: Curves.easeOut,
                            switchOutCurve: Curves.easeIn,
                            transitionBuilder: (child, animation) =>
                                FadeTransition(
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
                      isLoading: controller.isSaving.value,
                      onPressed: controller.saveAndUpdate,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
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
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.borderLight),
        boxShadow: [
          BoxShadow(
            color: AppColors.textSecondaryLight.withOpacity(0.1),
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
                  color: AppColors.primary,
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
                          color: AppColors.textSecondaryLight,
                        ),
                      ),
                    )
                  : ListView.separated(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: controller.searchResults.length,
                      separatorBuilder: (_, __) =>
                          Divider(color: AppColors.borderLight),
                      itemBuilder: (context, index) {
                        final result = controller.searchResults[index];
                        return ListTile(
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
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
      title: 'SUGGESTED KEYWORDS',
      child: Obx(
        () {
          if (controller.isLoadingKeywords.value) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () {
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
                              color: AppColors.primary,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'Restoring your previous selections...',
                            style: TextStyle(
                              fontSize: 11.sp,
                              color: AppColors.textSecondaryLight,
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
              Text(
                'QUALITY SPECIALITIES',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(height: 12.h),
              ScrollableOptionList(
                maxHeight: 220,
                items: controller.qualityKeywords
                    .map(
                      (k) => ScrollableOptionItem(
                        id: k.keywordId,
                        label: k.keyword,
                      ),
                    )
                    .toList(),
                selectedIds: controller.selectedKeywordIds.toSet(),
                onTap: (item) => controller.toggleKeyword(item.id),
              ),
              SizedBox(height: 12.h),
              Text(
                'SERVICES OFFERED',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(height: 12.h),
              ScrollableOptionList(
                maxHeight: 220,
                items: controller.serviceKeywords
                    .map(
                      (k) => ScrollableOptionItem(
                        id: k.keywordId,
                        label: k.keyword,
                      ),
                    )
                    .toList(),
                selectedIds: controller.selectedKeywordIds.toSet(),
                onTap: (item) => controller.toggleKeyword(item.id),
              ),
              SizedBox(height: 12.h),
              Text(
                'ADD YOUR OWN',
                style: TextStyle(
                  fontSize: 10.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondaryLight,
                ),
              ),
              SizedBox(height: 8.h),
              Column(
                children: [
                  ...controller.customKeywords.map(
                    (keyword) => Padding(
                      padding: EdgeInsets.only(bottom: 8.h),
                      child: AppTextField(
                        hint: 'Keyword',
                        initialValue: keyword,
                        readOnly: true,
                        suffixIcon: IconButton(
                          icon: Icon(
                            Icons.delete_outline,
                            color: AppColors.error.withOpacity(0.5),
                            size: 20.sp,
                          ),
                          onPressed: () =>
                              controller.removeCustomKeyword(keyword),
                        ),
                      ),
                    ),
                  ),
                  if (controller.canAddMoreKeywords) ...[
                    AppTextField(
                      hint: 'Enter keyword...',
                      controller: _customKeywordController,
                      onSubmitted: (_) => _addCustomKeywordFromField(),
                      suffixIcon: IconButton(
                        onPressed: _addCustomKeywordFromField,
                        icon: Icon(
                          Icons.add_circle_outline,
                          size: 20.sp,
                          color: AppColors.primary,
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
                          color: AppColors.error,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}
