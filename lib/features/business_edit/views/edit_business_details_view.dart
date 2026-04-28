import 'package:bizrato_owner/core/theme/theme.dart';
import 'package:bizrato_owner/core/constants/app_assets.dart';
import 'package:bizrato_owner/core/widgets/widgets.dart';
import 'package:bizrato_owner/features/business_edit/controllers/edit_business_details_controller.dart';
import 'package:bizrato_owner/features/business_edit/widgets/widgets.dart';
import 'package:bizrato_owner/features/onboarding/data/models/search_result_model.dart';
import 'package:bizrato_owner/features/business_edit/widgets/business_category_search_field.dart';
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

    _searchListener = () {
      controller.onSearchChanged(_searchController.text);
    };

    _searchController.addListener(_searchListener);

    _searchQueryWorker = ever<String>(
      controller.searchQuery,
      _updateSearchText,
    );
  }

  void _updateSearchText(String value) {
    if (_searchController.text == value) return;

    _searchController.removeListener(_searchListener);

    _searchController.text = value;
    _searchController.selection =
        TextSelection.collapsed(offset: value.length);

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
      child: Obx(() {
        if (controller.isLoadingPage.value) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 16.h,
          ),
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
                      BusinessCategorySearchField(
                        controller: _searchController,
                        isCategoryRestored:
                            controller.isCategoryRestored.value,
                        isSearching: controller.isSearching.value,
                        onClearRestoredCategory:
                            controller.clearRestoredCategory,
                        results: _buildSearchResults(),
                      ),
                    ],
                  ),
                ),
              ),

              Obx(
                    () => AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  child: controller.hasSelectedCategory
                      ? _buildKeywordSection()
                      : const SizedBox.shrink(),
                ),
              ),

              SafeArea(
                child: Obx(
                      () => PrimaryButton(
                    label: 'SAVE & CONTINUE',
                    isLoading: controller.isSaving.value,
                    onPressed: controller.saveAndUpdate,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildSearchResults() {
    final hasResults = controller.searchResults.isNotEmpty;
    final isSearching = controller.isSearching.value;

    if (!hasResults && !isSearching) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: EdgeInsets.only(top: 8.h),
      padding: EdgeInsets.zero, // removes top blank gap
      decoration: BoxDecoration(
        color: AppTokens.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppTokens.border,
        ),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: isSearching
            ? SizedBox(
          height: 50.h,
          child: Center(
            child: SizedBox(
              height: 18.w,
              width: 18.w,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                color: AppTokens.brandPrimary,
              ),
            ),
          ),
        )
            : ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 150.h,
          ),
          child: controller.searchResults.isEmpty
              ? Padding(
            padding: EdgeInsets.symmetric(
              vertical: 12.h,
            ),
            child: Text(
              'No categories found',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.sp,
                color: AppTokens.textSecondary,
              ),
            ),
          )
              : MediaQuery.removePadding(
            context: context,
            removeTop: true,
            removeBottom: true,
            child: ListView.separated(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: controller.searchResults.length,
              separatorBuilder: (_, __) => Divider(
                height: 1,
                thickness: .6,
                color: AppTokens.border,
              ),
              itemBuilder: (context, index) {
                final result =
                controller.searchResults[index];

                return Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () =>
                        _handleCategoryTap(result),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 14.w,
                        vertical: 10.h,
                      ),
                      child: Text(
                        result.displayName,
                        maxLines: 2,
                        overflow:
                        TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11.4.sp,
                          height: 1.08,
                          fontWeight:
                          FontWeight.w500,
                          color:
                          AppTokens.textPrimary,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeywordSection() {
    return OnboardingSectionCard(
      child: Obx(
            () {
          if (controller.isLoadingKeywords.value) {
            return SizedBox(
              height: 120.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppTokens.brandPrimary,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                selectedIds:
                controller.selectedKeywordIds.toSet(),
                onTap: (item) =>
                    controller.toggleKeyword(item.id),
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
                selectedIds:
                controller.selectedKeywordIds.toSet(),
                onTap: (item) =>
                    controller.toggleKeyword(item.id),
              ),

              SizedBox(height: 12.h),

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
                  onDelete: () =>
                      controller.removeCustomKeyword(keyword),
                  onSave: (value) =>
                      controller.updateCustomKeyword(
                        oldValue: keyword,
                        newValue: value,
                      ),
                ),
              ),

              if (_isAddingCustomKeyword &&
                  controller.canAddMoreKeywords)
                KeywordInputRow(
                  controller: _customKeywordController,
                  hint: 'Enter keyword...',
                  actionIcon: Icons.check,
                  actionBackgroundColor:
                  AppTokens.brandPrimary.withValues(
                    alpha: .12,
                  ),
                  actionIconColor:
                  AppTokens.brandPrimary,
                  onSubmitted: (_) =>
                      _addCustomKeywordFromField(),
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
                      fixedSize: Size(
                        double.maxFinite,
                        52.h,
                      ),
                    ),
                    child: Text(
                      _isAddingCustomKeyword
                          ? 'Cancel'
                          : 'Add Another Keyword',
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}
