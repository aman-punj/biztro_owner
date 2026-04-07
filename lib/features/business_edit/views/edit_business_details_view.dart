import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_business_details_controller.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/onboarding/widgets/widgets.dart';
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
  bool _isAddingCustomKeyword = false;

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
    final previousCount = controller.customKeywords.length;
    final value = _customKeywordController.text;
    controller.addCustomKeyword(value);
    if (controller.customKeywords.length != previousCount) {
      _customKeywordController.clear();
      setState(() {
        _isAddingCustomKeyword = false;
      });
    }
  }

  void _showCustomKeywordInput() {
    setState(() {
      _isAddingCustomKeyword = true;
    });
  }

  void _hideCustomKeywordInput() {
    _customKeywordController.clear();
    setState(() {
      _isAddingCustomKeyword = false;
    });
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
    return AppPageShell(
      title: 'Business Details',
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
                BusinessEditHeader(
                  businessName: controller.businessName,
                  subtitle: 'Smart Keywords Selection',
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
                          title: 'e.g. Sweets, Restaurant...',
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
                  SafeArea(child: Obx(
                        () => PrimaryButton(
                      label: 'SAVE & CONTINUE',
                      isLoading: controller.isSaving.value,
                      onPressed: controller.saveAndUpdate,
                    ),
                  )),
                ],
              ),
            );
          },
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
                            horizontal: 16.w,
                            vertical: 4.h,
                          ),
                          title: Text(
                            result.displayName,
                            style: TextStyle(fontSize: 12.sp, color: AppTokens.textPrimary),
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
                  color: AppTokens.brandPrimary,
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
                },
              ),
              ScrollableOptionList(
                maxHeight: 220,
                title: 'SUGGESTED KEYWORDS',
                titleIconPath: AppAssets.sparkleIcon,
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
              ScrollableOptionList(
                maxHeight: 220,
                title: 'SERVICES BASED',
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ADD YOUR OWN',
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: AppTokens.textSecondary,
                    ),
                  ),
                  SizedBox(height: 12.h),
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
                  if (_isAddingCustomKeyword && controller.canAddMoreKeywords)
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
                  if (controller.canAddMoreKeywords)
                    Padding(
                      padding: EdgeInsets.only(top: 8.h),
                      child: OutlinedButton(
                        onPressed: _isAddingCustomKeyword
                            ? _hideCustomKeywordInput
                            : _showCustomKeywordInput,
                        style: OutlinedButton.styleFrom(
                          fixedSize: Size(double.maxFinite, 52.h),
                          side: BorderSide(
                            color: AppTokens.brandPrimary,
                            width: 1.5,
                          ),
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
                              _isAddingCustomKeyword
                                  ? Icons.close
                                  : Icons.add_circle_outline,
                              size: 20.sp,
                              color: AppTokens.brandPrimary,
                            ),
                            SizedBox(width: 8.w),
                            Text(
                              _isAddingCustomKeyword
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
                    )
                  else
                    Center(
                      child: Text(
                        'Max 5 keywords reached',
                        style: TextStyle(
                          fontSize: 11.sp,
                          color: AppTokens.error,
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
